import numpy as np
from typing import Tuple


def awgn(signal_volts: np.ndarray, snr_db: float) -> np.array:
    """Adds white gaussian noise to a signal
    
    Params:
    signal_volts -- The signal
    snr_db -- The desired SNR in 10*log10 DB
    
    Returns:
    signal_noise_volts -- the noisy signal
    """
    snr_linear = 10 ** (snr_db / 10)
    power_signal = np.var(signal_volts)
    power_noise = power_signal / snr_linear
    noise_volts = np.random.normal(0, np.sqrt(power_noise), signal_volts.shape)
    signal_noise_volts = signal_volts + noise_volts
    return signal_noise_volts


def normalize(x: np.array) -> np.ndarray:
    """Normalizes a signal between 0 and 1"""
    xmin = np.min(x)
    xmax = np.max(x)
    xnorm = (x - xmin) / (xmax - xmin)
    return xnorm


def remove_dc_offset(x: np.ndarray) -> np.ndarray:
    """Removes the bias of a signal"""
    y = x - np.mean(x)
    return y


def recenter_signal(x: np.ndarray) -> np.ndarray:
    """Normalizes and then removes DC offset"""
    xnorm = normalize(x)
    y = 2*remove_dc_offset(xnorm)
    return y


def concatenate_time_vectors(
        time1_sec: np.ndarray,
        time2_sec: np.ndarray,
        sample_rate_hz: float) -> np.ndarray:
    """Concatenates time1_sec after time2_sec
    
    Adjusts time2_sec to start at 0, then shifts time2_sec to begin at the first
    sample after the end of time1_sec.  Assumes both are uniformly spaced.
    """
    time_step_sec = 1.0 / sample_rate_hz
    time_offset_sec = time1_sec[-1] + time_step_sec
    time2_shifted_sec = time2_sec - time2_sec[0] + time_offset_sec
    time_sec = np.hstack((time1_sec, time2_shifted_sec))
    return time_sec


def concatenate_signals(
        time1_sec: np.ndarray, signal1_volts: np.ndarray,
        time2_sec: np.ndarray, signal2_volts: np.ndarray,
        sample_rate_hz: float) -> Tuple[np.ndarray, np.ndarray]:
    """Concatenates signal 2 after signal 1, adjusting the time stamps for signal 2
    
    Adjusts signal 2 to start at 0, then shifts signal 2 to begin at the first sample
    after the end of signal 1.  Assumes both signals are uniformly sampled.
    """
    time_sec = concatenate_time_vectors(time1_sec, time2_sec, sample_rate_hz)
    signal_volts = np.hstack((signal1_volts, signal2_volts))
    return (time_sec, signal_volts)


def superimpose_vectors(va: np.ndarray, vb: np.ndarray) -> np.ndarray:
    """Superimposes two vectors of unequal length
    
    Vectors are aligned at the start of each.
    """
    if len(va) < len(vb):
        vc = vb.copy()
        vc[:len(va)] += va
    else:
        vc = va.copy()
        vc[:len(vb)] += vb
    return vc


def superimpose_signals(
        time1_sec: np.ndarray, signal1_volts: np.ndarray,
        time2_sec: np.ndarray, signal2_volts: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Sums two signals of different lengths
    
    Signals are time aligned at the start of each.  Assumes both signals
    are uniformly sampled.
    """
    if len(time1_sec) > len(time2_sec):
        time_sec = time1_sec
    else:
        time_sec = time2_sec
        
    signal_volts = superimpose_vectors(signal1_volts, signal2_volts)
    
    return (time_sec, signal_volts)

