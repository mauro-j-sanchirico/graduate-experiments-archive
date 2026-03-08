import numpy as np
from typing import Tuple


from signal_utilities import (
    concatenate_time_vectors,
    concatenate_signals,
    superimpose_vectors,
    superimpose_signals)

from visualization import plot_signal, show_signal_spectrogram


def generate_time_vector(
        length_sec: float,
        sample_rate_hz: float) -> np.ndarray:
    """Generates a uniformly spaced time vector"""
    time_step_sec = 1 / sample_rate_hz
    time_sec = np.arange(0, length_sec + time_step_sec, time_step_sec)
    return time_sec


def generate_chirp(
        center_frequency_hz: float,
        bandwidth_hz: float,
        chirp_length_sec: float,
        sample_rate_hz: float) -> Tuple[np.ndarray, np.ndarray]:
    """Generates a chirp with the given parameters"""
    time_sec = generate_time_vector(chirp_length_sec, sample_rate_hz)
    chirp_rate = bandwidth_hz / (2*chirp_length_sec)
    instantaneous_frequency_wrt_time_hz = (
        center_frequency_hz - bandwidth_hz / 2 + chirp_rate * time_sec)
    sin_arg = 2 * np.pi * instantaneous_frequency_wrt_time_hz * time_sec
    chirp_signal_volts = np.sin(sin_arg)
    return (time_sec, chirp_signal_volts)


def generate_pulse(
        frequency_hz: float,
        pulse_length_sec: float,
        sample_rate_hz: float) -> Tuple[np.ndarray, np.ndarray]:
    """Generates a pulse with the given parameters"""
    time_sec = generate_time_vector(pulse_length_sec, sample_rate_hz)
    pulse_signal_volts = np.sin(2 * np.pi * frequency_hz * time_sec)
    return (time_sec, pulse_signal_volts)
    

def generate_silence(
        silence_length_sec: float,
        sample_rate_hz: float) -> Tuple[np.ndarray, np.ndarray]:
    """Generates silence for the specified duration"""
    time_sec = generate_time_vector(silence_length_sec, sample_rate_hz)
    silence_signal_volts = np.zeros(np.shape(time_sec))
    return (time_sec, silence_signal_volts)


def delay_signal(
        delay_sec: float,
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        sample_rate_hz: float):
    """Returns a delayed copy of the signal"""
    (time_silence_sec, silence_signal_volts) = generate_silence(
        delay_sec, sample_rate_hz)
    (time_delayed_signal_sec, delayed_signal_volts) = concatenate_signals(
        time_silence_sec, silence_signal_volts,
        time_sec, signal_volts, sample_rate_hz)
    return (time_delayed_signal_sec, delayed_signal_volts)
    

def delay_and_sum_signals(
        delay_signal1_sec: float, delay_signal2_sec: float,
        time1_sec: np.ndarray, signal1_volts: np.ndarray,
        time2_sec: np.ndarray, signal2_volts: np.ndarray,
        sample_rate_hz: float) -> Tuple[np.ndarray, np.ndarray]:
    """Adds a delayed copy of signal 2 to signal 1"""
    (time_delayed_signal1_sec, delayed_signal1_volts) = delay_signal(
        delay_signal1_sec, time1_sec, signal1_volts, sample_rate_hz)
    (time_delayed_signal2_sec, delayed_signal2_volts) = delay_signal(
        delay_signal2_sec, time2_sec, signal2_volts, sample_rate_hz)
    (time_combined_sec, signals_combined_volts) = superimpose_signals(
        time_delayed_signal1_sec, delayed_signal1_volts,
        time_delayed_signal2_sec, delayed_signal2_volts)
    return (time_combined_sec, signals_combined_volts)


def delay_and_copy_signal(
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        repetition_interval_sec: float,
        n_reps: int, sample_rate_hz: float) -> Tuple[np.ndarray, np.ndarray]:
    """Generates a train of delayed copies of the same signal"""
    time_train_sec = time_sec
    train_signal_volts = signal_volts
    for idx in range(n_reps - 1):
        delay_sec = float(idx + 1) * repetition_interval_sec
        (time_train_sec, train_signal_volts) = delay_and_sum_signals(
            0.0, delay_sec,
            time_train_sec, train_signal_volts,
            time_sec, signal_volts,
            sample_rate_hz)
    return (time_train_sec, train_signal_volts)


def generate_chirp_train(
        center_frequency_hz: float,
        bandwidth_hz: float,
        chirp_length_sec: float,
        sample_rate_hz: float,
        repetition_interval_sec: float,
        n_reps: int) -> Tuple[np.ndarray, np.ndarray]:
    """"Generates a train of chirps with the given parameters"""
    (time_chirp_sec, chirp_signal_volts) = generate_chirp(
        center_frequency_hz, bandwidth_hz, chirp_length_sec, sample_rate_hz)
    (time_chirp_train_sec, chirp_train_signal_volts) = delay_and_copy_signal(
        time_chirp_sec, chirp_signal_volts, repetition_interval_sec, n_reps, sample_rate_hz)
    return (time_chirp_train_sec, chirp_train_signal_volts)

    
def generate_pulse_train(
        frequency_hz: float,
        pulse_length_sec: float,
        sample_rate_hz: float,
        repetition_interval_sec: float,
        n_reps: int) -> Tuple[np.ndarray, np.ndarray]:
    """Generates a train of pulses with the given parameters"""
    (time_pulse_sec, pulse_signal_volts) = generate_pulse(
        frequency_hz, pulse_length_sec, sample_rate_hz)
    (time_pulse_train_sec, pulse_train_signal_volts) = delay_and_copy_signal(
        time_pulse_sec, pulse_signal_volts, repetition_interval_sec, n_reps, sample_rate_hz)
    return (time_pulse_train_sec, pulse_train_signal_volts)


def visual_test_chirp_train():
    """Visually test the chirp train generator"""
    
    # Signal parameters
    center_frequency_hz = 10e6
    bandwidth_hz = 10e6
    length_sec = 10e-6
    n_reps = 4
    repetition_interval_sec = 0.5*length_sec

    # Sample rate is higher than needed to allow nonlinear operations
    upsample_factor = 5
    nyquist_rate_hz = 2 * (center_frequency_hz + bandwidth_hz)
    sample_rate_hz = upsample_factor * nyquist_rate_hz

    # For plotting
    fmin_hz = center_frequency_hz - bandwidth_hz
    fmax_hz = center_frequency_hz + bandwidth_hz

    # Test chirp train
    (time_sec, signal_volts) = generate_chirp_train(
        center_frequency_hz, bandwidth_hz, length_sec,
        sample_rate_hz, repetition_interval_sec, n_reps)
    
    fh_spec = show_signal_spectrogram(
        time_sec, signal_volts,
        sample_rate_hz, fmin_hz, fmax_hz,
        'Chirp Train Signal PSD')


def visual_test_pulse_train():
    """Visually test the chirp train generator"""
    
    # Signal parameters
    center_frequency_hz = 10e6
    length_sec = 10e-6
    n_reps = 4
    repetition_interval_sec = 1.5*length_sec

    # Sample rate is higher than needed to allow nonlinear operations
    upsample_factor = 5
    nyquist_rate_hz = 2 * center_frequency_hz
    sample_rate_hz = upsample_factor * nyquist_rate_hz

    # For plotting
    fmin_hz = 1.5 * center_frequency_hz
    fmax_hz = 0.5 * center_frequency_hz

    # Test pulse train
    (time_sec, signal_volts) = generate_pulse_train(
        center_frequency_hz, length_sec,
        sample_rate_hz, repetition_interval_sec, n_reps)
    
    fh_spec = show_signal_spectrogram(
        time_sec, signal_volts,
        sample_rate_hz, fmin_hz, fmax_hz,
        'Pulse Train Signal PSD')
    