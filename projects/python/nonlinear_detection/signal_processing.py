import numpy as np
from typing import Tuple


from constants import c_speed_of_light_mps

from signal_utilities import (
    awgn,
    normalize,
    remove_dc_offset,
    recenter_signal)

from visualization import (
    plot_signal,
    plot_detections,
    show_signal_spectrogram,
    plot_a_scope)


def apply_square_law(x: np.ndarray):
    """Returns the normalized square of the input signal"""
    y = normalize(x ** 2)
    return y


def apply_abs_law(x: np.ndarray):
    """Returns the normalized absolute value of the input signal"""
    y = normalize(np.abs(x))
    return y


def apply_fspl_attenuation(
       time_sec: np.array,
       signal_volts: np.array,
       range_m: float,
       center_frequency_hz: float) -> np.ndarray:
    """Applies free space path loss to the signal.
    
    Uses a use defined center frequency to compute a single, constant
    attenuation for the entire provided signal.
    """
    fspl_ratio = ((4 * np.pi * range_m * center_frequency_hz) / c_speed_of_light_mps) ** 2
    output_signal = signal_volts / fspl_ratio
    return (time_sec, output_signal)


def generate_local_oscillator_signal(
        time_sec: np.ndarray,
        lo_frequency_hz: float,
        phase_noise_amount_std: float,
        lo_drift_swing_hz: float,
        lo_drift_frequency_hz: float) -> Tuple[np.ndarray, np.ndarray]:
    """Generates a local oscillator signal with phase noise and drift"""
    phase_noise = np.random.normal(0, phase_noise_amount_std, time_sec.shape)
    sin_arg = 2 * np.pi * lo_drift_frequency_hz * time_sec
    lo_drift = lo_drift_swing_hz / 2 * np.sin(sin_arg)
    lo_frequency_drifted_hz = lo_frequency_hz + lo_drift
    sin_arg = 2 * np.pi * lo_frequency_drifted_hz * time_sec
    lo_signal_volts = np.sin(sin_arg) + phase_noise
    return (time_sec, lo_signal_volts)


def apply_bandpass_filter(
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        center_frequency_hz: float,
        bandwidth_hz: float,
    ) -> Tuple[np.ndarray, np.ndarray]:
    """Applys a brickwall filter of the given bandwidth and center frequency
    
    Assumes a uniform sample rate.
    """
    cutoff_high_hz = center_frequency_hz + bandwidth_hz / 2
    cutoff_low_hz = center_frequency_hz - bandwidth_hz / 2
    # Note normalized sinc function is used here, and is also
    # convieniently the numpy default
    kernel_high = 2 * cutoff_high_hz * np.sinc(2 * cutoff_high_hz * time_sec)
    kernel_low = 2 * cutoff_low_hz * np.sinc(2 * cutoff_low_hz * time_sec)
    kernel = kernel_high + kernel_low
    dt = time_sec[1] - time_sec[0]
    filter_out_volts = np.convolve(kernel, signal_volts, mode='full') * dt
    return (time_sec, filter_out_volts[0:len(signal_volts)])
    
    
def nonlinear_diode(
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        q_over_kt_inverse_volts: float = 38.68,
        saturation_current_amps: float = 1e-12
    ) -> Tuple[np.ndarray, np.ndarray]:
    """Passes the signal through a nonlinear diode
    
    Assumes the output load resistance R = 1 such that VO = IO / R = IO
    """
    exp_arg = q_over_kt_inverse_volts * signal_volts + 1
    output_volts = saturation_current_amps * np.exp(exp_arg)
    return (time_sec, output_volts)


def downmix(
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        lo_frequency_hz: float,
        lo_drift_swing_hz: float,
        lo_drift_frequency_hz: float,
        filter_center_frequency_hz: float,
        filter_bandwidth_hz: float,
        q_over_kt_inverse_volts: float = 38.68,
        saturation_current_amps: float = 1e-12,
        phase_noise_amount_std: float = 0.001) -> Tuple[np.ndarray, np.ndarray]:
    """Models a nonlinear downmixer"""
    (_, lo_signal_volts) = generate_local_oscillator_signal(
        time_sec, lo_frequency_hz, phase_noise_amount_std,
        lo_drift_swing_hz, lo_drift_frequency_hz)
    
    signal_volts = normalize(signal_volts)
    lo_norm = normalize(lo_signal_volts)
    
    # Parameter to bring the signal to a resonale level for mixing
    # (about 100mV for a standard diode); not tunable or configurable.
    gain_correction_factor_ratio = 0.1
    
    signal_volts = gain_correction_factor_ratio * (signal_volts + lo_norm)
    
    (_, signal_volts) = nonlinear_diode(
        time_sec, signal_volts, 
        q_over_kt_inverse_volts,
        saturation_current_amps)
    
    # Remove the DC offset brough on by mixing and renormalize the signal
    signal_volts = recenter_signal(signal_volts)
    
    (_, signal_volts) = apply_bandpass_filter(
        time_sec,
        signal_volts,
        filter_center_frequency_hz,
        filter_bandwidth_hz)
    
    signal_volts = gain_correction_factor_ratio * recenter_signal(signal_volts)
    
    return (time_sec, signal_volts)


def amplify(
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        gain_db: float,
        saturation_parameter: float,
        input_snr_db: float) -> Tuple[np.ndarray, np.ndarray]:
    """Models a nonlinear amplifier with soft clipping
    
    The amplifier is modeled in a nonlinear stage, which introduces
    harmonic content due to saturation and a linear stage
    which amplified the signal.  The post gain and pregain are calculated
    such that the nonlinear stage of the model does not affect the peak
    to peak amplitude of the signal.
    
    The saturation parameter is a number between -1 and 1 where -1 and 1
    are fully saturated and 0 is bypasses the saturation model.  The fully
    saturated amplifier becomes a sign detector.  The negatively saturated
    amplifier becomes an opposite sign detector.
    """
    gain_linear = 10 ** (gain_db / 20)
    if saturation_parameter == 0.0:
        output_signal_volts = gain_linear * signal_volts
        
    else:
        pregain = np.arctanh(saturation_parameter)
        max_volts = np.max(signal_volts)
        min_volts = np.min(signal_volts)
        input_swing_volts = max_volts - min_volts
        output_extreme1 = np.tanh(pregain*max_volts)
        output_extreme2 = np.tanh(pregain*min_volts)
        output_max_volts = max((output_extreme1, output_extreme2))
        output_min_volts = min((output_extreme1, output_extreme2))
        output_swing_volts = output_max_volts - output_min_volts
        input_signal = pregain * signal_volts
        noisy_input_signal = awgn(input_signal, input_snr_db)
        output_gain_adjusted = gain_linear * (input_swing_volts / output_swing_volts)
        output_signal_volts =  output_gain_adjusted * np.tanh(noisy_input_signal)
        
    return (time_sec, output_signal_volts)


def apply_matched_filter(
        time_sec: np.ndarray, 
        signal_volts: np.ndarray,
        matched_filter_template: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Applies a matched fitler to search for the template in the signal"""
    length_diff = len(signal_volts) - len(matched_filter_template)
    zeros_array = np.zeros(length_diff)
    time_reversed_template = np.flip(matched_filter_template)
    matched_filter_template = np.hstack((time_reversed_template, zeros_array))
    filter_out = np.convolve(matched_filter_template, signal_volts, mode='full')
    return (time_sec, filter_out[0:len(signal_volts)])


def apply_simple_cell_averaging_cfar(
        time_sec: np.ndarray,
        signal: np.ndarray,
        cfar_n_skip_cells = 3,
        cfar_n_adjacent_cells = 3,
        cfar_n_background_cells = 3) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Applies simple cell averaging CFAR to each Cell Under Test (CUT)
    
    Returns a list of times at which detections occur.
    """
    cfar_ratios = np.array([])
    cfar_times_sec = np.array([])
    signal_values = np.array([])
    
    total_adjacent_cells = (
        cfar_n_skip_cells + cfar_n_adjacent_cells + cfar_n_background_cells)

    for idx, cut in enumerate(signal[total_adjacent_cells:-total_adjacent_cells]):
        cut_idx = idx + total_adjacent_cells
        
        left_background_start = idx
        left_skip_start = left_background_start + cfar_n_background_cells
        left_adjacent_start = left_skip_start + cfar_n_skip_cells
        
        left_background = signal[left_background_start:left_skip_start]
        left_skip = signal[left_skip_start:left_adjacent_start]
        left_adjacent = signal[left_adjacent_start:cut_idx]
        
        cut = signal[cut_idx]
        
        right_adjacent_start = cut_idx + 1
        right_skip_start = right_adjacent_start + cfar_n_adjacent_cells
        right_background_start = right_skip_start + cfar_n_skip_cells
        right_background_end = right_background_start + cfar_n_background_cells
        
        right_adjacent = signal[right_adjacent_start:right_skip_start]
        right_skip = signal[right_skip_start:right_background_start]
        right_background = signal[right_background_start:right_background_end]
        
        target_cells = np.hstack((left_adjacent, cut, right_adjacent))
        background_cells = np.hstack((left_background, right_background))
        
        target_mean = np.mean(target_cells)
        background_mean = np.mean(background_cells)
        
        cfar_ratio = target_mean / background_mean
        
        cfar_times_sec = np.append(cfar_times_sec, time_sec[cut_idx])
        cfar_ratios = np.append(cfar_ratios, cfar_ratio)
        signal_values = np.append(signal_values, signal[cut_idx])
    
    return (cfar_times_sec, cfar_ratios, signal_values)


def apply_cfar_thresholding(
        time_sec: np.ndarray,
        cfar_ratios: np.ndarray,
        signal_values: np.ndarray,
        cfar_threshold: float) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """Applies a threshold to the CFAR ratio to downselect detection candidates"""
    tentative_detections = cfar_ratios > cfar_threshold
    selected_times_sec = time_sec[tentative_detections]
    selected_cfar_ratios = cfar_ratios[tentative_detections]
    selected_signal_values = signal_values[tentative_detections]
    return (
        tentative_detections,
        selected_times_sec,
        selected_cfar_ratios,
        selected_signal_values)


def apply_clear_detection():
    pass
    # cfar
    # measurement

    
def apply_ci_detection():
    pass
    # ci
    # cfar
    # measurement

    
def apply_nci_detection(
        time_sec: np.ndarray,
        signal: np.ndarray,
        cfar_constant: float,
        cfar_n_skip_cells: int,
        cfar_n_adjacent_cells: int,
        cfar_n_background_cells: int,
        samples_per_range_bin: int,
        suppress_plots) -> np.array:
    """Applies a non-coherently integrated detection scheme"""
    
    signal = np.abs(signal)
    
    (cfar_times_sec, cfar_ratios, signal_values) = apply_simple_cell_averaging_cfar(
        time_sec, signal, cfar_n_skip_cells,
        cfar_n_adjacent_cells, cfar_n_background_cells)
    
    (
        tentative_detections,
        selected_times_sec,
        selected_cfar_ratios,
        selected_signal_values
    ) = apply_cfar_thresholding(
            cfar_times_sec, cfar_ratios, signal_values, cfar_constant)
    
    plot_detections(
        cfar_times_sec, signal_values,
        selected_times_sec, selected_signal_values,
        't (us)', '', 'Rectified Matched Filter Output and Tentative Detections',
        suppress_show=suppress_plots)
    
    plot_detections(
        cfar_times_sec, cfar_ratios,
        selected_times_sec, selected_cfar_ratios,
        't (us)', '', 'CFAR Ratio and Tentative Detections',
        suppress_show=suppress_plots)
    
    plot_detections(
        cfar_times_sec, tentative_detections,
        cfar_times_sec, tentative_detections,
        't (us)', '', 'Unbinned Tentative Detections',
        suppress_show=suppress_plots)
    
    print(samples_per_range_bin)
    
    # Compute number of detections per bin!!!
    
    #for idx, sample in enumerate(signal[samples_per_range_bin:]):
    #    cut_idx = idx + total_adjacent_cells
    
    # Non-coherently integrate cooresponding bins!!!
    
    detection_times_sec = selected_times_sec
    
    return detection_times_sec
    
    
def make_measurement(
        time_sec: np.ndarray,
        signal: np.ndarray,
        cfar_constant: float,
        cfar_n_skip_cells: int,
        cfar_n_adjacent_cells: int,
        cfar_n_background_cells: int,
        template_length_sec: float,
        samples_per_range_bin: int,
        suppress_plots) -> np.array:
    """Applies the chosen detection scheme to detect targets"""
    
    detection_times_sec = apply_nci_detection(
        time_sec, signal, cfar_constant,
        cfar_n_skip_cells, cfar_n_adjacent_cells,
        cfar_n_background_cells, samples_per_range_bin, suppress_plots)
    
    range_measurements_m = (
        c_speed_of_light_mps * (detection_times_sec - template_length_sec))
    
    return range_measurements_m


def rf_amplify_and_plot(
        time_sec,
        signal_volts,
        sample_rate_hz,
        scopes,
        fmin_rf_plot_hz,
        fmax_rf_plot_hz,
        rf_amp_gain_db,
        rf_amp_saturation_parameter,
        rf_amp_input_snr_db,
        suppress_plots) -> Tuple[np.ndarray, np.ndarray]:
    """Amplifies the RF signal and plots scopes of the output"""
    (_, signal_volts) = amplify(
        time_sec, signal_volts,
        rf_amp_gain_db, rf_amp_saturation_parameter,
        rf_amp_input_snr_db)
    
    post_amp_scope = plot_signal(
        time_sec, signal_volts,
        't (us)', '', 'Post RF Amp. Signal (volts)',
        suppress_show=suppress_plots)
    
    scopes['post_rf_amp_scope'] = post_amp_scope
    
    post_amp_spec = show_signal_spectrogram(
        time_sec, signal_volts,
        sample_rate_hz, fmin_rf_plot_hz, fmax_rf_plot_hz,
        'Post RF Amp. PSD', suppress_show=suppress_plots)
    
    scopes['post_rf_amp_spec'] = post_amp_spec
    
    return (time_sec, signal_volts)


def downmix_and_plot(
        time_sec,
        signal_volts,
        sample_rate_hz,
        scopes,
        fmin_if_plot_hz,
        fmax_if_plot_hz,
        lo_frequency_hz,
        lo_drift_swing_hz,
        lo_drift_frequency_hz,
        filter_center_frequency_hz,
        filter_bandwidth_hz,
        mixer_q_over_kt_inverse_volts,
        mixer_saturation_current_amps,
        lo_phase_noise_amount_std,
        suppress_plots) -> Tuple[np.ndarray, np.ndarray]:
    """Downmixes RF to IF and plots scopes of the output"""
    
    (_, signal_volts) = downmix(
        time_sec, signal_volts,
        lo_frequency_hz,
        lo_drift_swing_hz,
        lo_drift_frequency_hz,
        filter_center_frequency_hz,
        filter_bandwidth_hz,
        mixer_q_over_kt_inverse_volts,
        mixer_saturation_current_amps,
        lo_phase_noise_amount_std)
    
    scopes['post_rf_mixer_scope'] = plot_signal(
        time_sec, signal_volts,
        't (s)', '', 'Post RF Mixer Signal (volts)',
        suppress_show=suppress_plots)
    
    scopes['post_rf_mixer_spec'] = show_signal_spectrogram(
        time_sec, signal_volts,
        sample_rate_hz, fmin_if_plot_hz, fmax_if_plot_hz,
        'Post RF Mixer PSD', suppress_show=suppress_plots)

    return (time_sec, signal_volts)


def if_amplify_and_plot(
        time_sec,
        signal_volts,
        sample_rate_hz,
        scopes,
        fmin_if_plot_hz,
        fmax_if_plot_hz,
        if_amp_gain_db,
        if_amp_saturation_parameter,
        if_amp_input_snr_db,
        suppress_plots) -> Tuple[np.ndarray, np.ndarray]:
    """Applies IF amplification and plots scopes of the output"""
    (_, signal_volts) = amplify(
        time_sec, signal_volts,
        if_amp_gain_db, if_amp_saturation_parameter,
        if_amp_input_snr_db)
    
    post_amp_scope = plot_signal(
        time_sec, signal_volts,
        't (us)', '', 'Post IF Amp. Signal (volts)',
        suppress_show=suppress_plots)
    
    scopes['post_if_amp_scope'] = post_amp_scope
    
    post_amp_spec = show_signal_spectrogram(
        time_sec, signal_volts,
        sample_rate_hz, fmin_if_plot_hz, fmax_if_plot_hz,
        'Post IF Amp. PSD', suppress_show=suppress_plots)
    
    scopes['post_if_amp_spec'] = post_amp_spec
    
    return (time_sec, signal_volts)


def matched_filter_and_plot(
        time_sec,
        signal_volts,
        sample_rate_hz,
        scopes,
        fmin_if_plot_hz,
        fmax_if_plot_hz,
        matched_filter_template,
        template_length_sec,
        suppress_plots) -> Tuple[np.ndarray, np.ndarray]:
    """Applies a matched filter and plots the raw output and A-Scope"""
    
    (_, signal_volts) = apply_matched_filter(
        time_sec, signal_volts, matched_filter_template)
    
    mf_output_scope = plot_signal(
        time_sec, signal_volts,
        't (us)', '', 'Matched Filter Output Scope',
        suppress_show=suppress_plots)
    
    scopes['mf_output_scope'] = mf_output_scope
    
    a_scope_signal = apply_square_law(signal_volts)
    
    a_scope = plot_a_scope(
        time_sec, a_scope_signal, template_length_sec,
        'Range (km)', '', 'Raw A-Scope',
        suppress_show=suppress_plots)
    
    scopes['a_scope'] = a_scope
    
    return (time_sec, signal_volts)

    
def process_radar_receiver_chain(
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        sample_rate_hz: float,
        matched_filter_template: np.ndarray,
        template_length_sec: float,
        fmin_rf_plot_hz: float,
        fmax_rf_plot_hz: float,
        fmin_if_plot_hz: float,
        fmax_if_plot_hz: float,
        suppress_plots = False,
        rf_amp_saturation_parameter: float = 0.1,
        rf_amp_gain_db: float = 100.0,
        rf_amp_input_snr_db: float = 10,
        lo_frequency_hz: float = 5.0e6,
        filter_center_frequency_hz: float = 5.0e6,
        filter_bandwidth_hz: float = 5.0e6,
        mixer_q_over_kt_inverse_volts: float = 38.68,
        mixer_saturation_current_amps: float = 1e-12,
        lo_phase_noise_amount_std: float = 0.001,
        lo_drift_swing_hz: float = 0.0,
        lo_drift_frequency_hz: float = 0.0,
        if_amp_saturation_parameter: float = 0.1,
        if_amp_gain_db: float = 100.0,
        if_amp_input_snr_db: float = 10,
        cfar_constant: float = 4,
        cfar_n_skip_cells = 5,
        cfar_n_adjacent_cells = 3,
        cfar_n_background_cells = 25,
        samples_per_range_bin = 100
    ) -> Tuple[np.ndarray, dict]:
    """Processes a radar receiver chain"""
    
    scopes = {}
    
    (_, signal_volts) = rf_amplify_and_plot(
        time_sec, signal_volts, sample_rate_hz, scopes,
        fmin_rf_plot_hz, fmax_rf_plot_hz, rf_amp_gain_db,
        rf_amp_saturation_parameter, rf_amp_input_snr_db, suppress_plots)
    
    (_, signal_volts) = downmix_and_plot(
        time_sec, signal_volts, sample_rate_hz, scopes,
        fmin_if_plot_hz, fmax_if_plot_hz, lo_frequency_hz,
        lo_drift_swing_hz, lo_drift_frequency_hz,
        filter_center_frequency_hz, filter_bandwidth_hz,
        mixer_q_over_kt_inverse_volts, mixer_saturation_current_amps,
        lo_phase_noise_amount_std, suppress_plots)
    
    (_, signal_volts) = if_amplify_and_plot(
        time_sec, signal_volts, sample_rate_hz, scopes,
        fmin_if_plot_hz, fmax_if_plot_hz, if_amp_gain_db,
        if_amp_saturation_parameter, if_amp_input_snr_db, suppress_plots)
    
    (_, signal_volts) = matched_filter_and_plot(
        time_sec, signal_volts, sample_rate_hz,
        scopes, fmin_if_plot_hz, fmax_if_plot_hz,
        matched_filter_template, template_length_sec,
        suppress_plots)
    
    measurements = make_measurement(
        time_sec, signal_volts, cfar_constant,
        cfar_n_skip_cells, cfar_n_adjacent_cells,
        cfar_n_background_cells, template_length_sec,
        samples_per_range_bin, suppress_plots)
    
    return (measurements, scopes)
    