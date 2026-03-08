from constants import c_speed_of_light_mps
from signal_generators import (
    generate_chirp_train,
    generate_pulse_train,
    delay_and_copy_signal,
    generate_silence,
    concatenate_signals)
from visualization import plot_signal, show_signal_spectrogram


# TODO: provide a list of power ratios per target

def synthesize_range_sepparated_chirp_trains(
        sepparation_m: float = 20.0e3,
        n_targets: int = 3,
        center_frequency_hz: float = 10.0e6,
        bandwidth_hz: float = 10.0e6,
        chirp_length_sec: float = 10.0e-6,
        sample_rate_hz: float = 200.0e6,
        repetition_interval_sec: float = 5e-6,
        n_reps: int = 4,
        end_silence_sec: float = 10e-6):
    """Synthesizes target returns for range sepparated chirp excited targets"""
    delay_sec = sepparation_m / c_speed_of_light_mps
    (time_chirp_train_sec, chirp_train_signal_volts) = generate_chirp_train(
        center_frequency_hz, bandwidth_hz, chirp_length_sec,
        sample_rate_hz, repetition_interval_sec, n_reps)
    (time_sec, signal_volts) = delay_and_copy_signal(
        time_chirp_train_sec, chirp_train_signal_volts,
        delay_sec, n_targets, sample_rate_hz)
    (time_silence_sec, silence_signal_volts) = generate_silence(
        end_silence_sec, sample_rate_hz)
    (time_sec, signal_volts) = concatenate_signals(
        time_sec, signal_volts,
        time_silence_sec, silence_signal_volts, sample_rate_hz)
    return (time_sec, signal_volts)


def synthesize_range_sepparated_pulse_trains(
        sepparation_m: float = 20e3,
        n_targets: int = 3,
        frequency_hz: float = 10e6,
        pulse_length_sec: float = 5e-6,
        sample_rate_hz: float = 200e6,
        repetition_interval_sec: float = 10e-6,
        n_reps: int = 4,
        end_silence_sec: float = 10e-6):
    """Synthesizes target returns for range sepparated pulse excited targets"""
    delay_sec = sepparation_m / c_speed_of_light_mps
    (time_pulse_train_sec, pulse_train_signal_volts) = generate_pulse_train(
        frequency_hz, pulse_length_sec,
        sample_rate_hz, repetition_interval_sec, n_reps)
    (time_sec, signal_volts) = delay_and_copy_signal(
        time_pulse_train_sec, pulse_train_signal_volts,
        delay_sec, n_targets, sample_rate_hz)
    (time_silence_sec, silence_signal_volts) = generate_silence(
        end_silence_sec, sample_rate_hz)
    (time_sec, signal_volts) = concatenate_signals(
        time_sec, signal_volts,
        time_silence_sec, silence_signal_volts, sample_rate_hz)
    return (time_sec, signal_volts)


def visual_test_range_sepparated_chirp_trains():
    
    # Signal parameters
    center_frequency_hz = 10e6
    bandwidth_hz = 10e6
    n_reps = 4
    length_sec = 10e-6
    repetition_interval_sec = 0.5*length_sec

    # Sample higher than needed to allow nonlinear operations
    upsample_factor = 5
    nyquist_rate_hz = 2 * (center_frequency_hz + bandwidth_hz)
    sample_rate_hz = upsample_factor * nyquist_rate_hz

    # Target sepparation
    sepparation_m = 20e3
    n_targets = 3

    # For plotting
    fmin_hz = center_frequency_hz - bandwidth_hz
    fmax_hz = center_frequency_hz + bandwidth_hz

    # Range sepparated chirp trains
    (time_sec, signal_volts) = synthesize_range_sepparated_chirp_trains(
        sepparation_m, n_targets, center_frequency_hz, bandwidth_hz,
        length_sec, sample_rate_hz, repetition_interval_sec, n_reps)

    fh_plot = plot_signal(
        time_sec, signal_volts, 't (us)', '', 'Chirp Train Return Signals (volts)')

    fp_spec = show_signal_spectrogram(
        time_sec, signal_volts, sample_rate_hz,
        fmin_hz, fmax_hz, 'Chirp Train Return Signals PSD')
    

def visual_test_range_sepparated_pulse_trains():
    
    # Signal parameters
    center_frequency_hz = 10e6
    bandwidth_hz = 10e6
    n_reps = 4
    length_sec = 5e-6
    repetition_interval_sec = 2*length_sec

    # Sample higher than needed to allow nonlinear operations
    upsample_factor = 5
    nyquist_rate_hz = 2 * (center_frequency_hz + bandwidth_hz)
    sample_rate_hz = upsample_factor * nyquist_rate_hz

    # Target sepparation
    sepparation_m = 20e3
    n_targets = 3

    # For plotting
    fmin_hz = center_frequency_hz - bandwidth_hz
    fmax_hz = center_frequency_hz + bandwidth_hz


    # Range sepparated pulse trains
    (time_sec, signal_volts) = synthesize_range_sepparated_pulse_trains(
        sepparation_m, n_targets, center_frequency_hz, length_sec,
        sample_rate_hz, repetition_interval_sec, n_reps)

    fh_plot = plot_signal(
        time_sec, signal_volts, 't (us)', '', 'Pulse Train Return Signals (volts)')

    fp_spec = show_signal_spectrogram(
        time_sec, signal_volts, sample_rate_hz,  fmin_hz, fmax_hz, 'Pulse Train Return Signals PSD')
    