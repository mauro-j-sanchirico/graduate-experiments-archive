import numpy as np

import matplotlib.pyplot as plt
from scipy import signal
from scipy.fft import fftshift
from typing import Tuple


from constants import c_speed_of_light_mps
from signal_utilities import normalize


def plot_signal(
        time_sec: np.ndarray, 
        signal_volts: np.ndarray,
        plot_x_label: str,
        plot_y_label: str,
        plot_title: str,
        suppress_show=False) -> "matplotlib.figure.Figure":
    """Plots a signal"""
    fh = plt.figure(figsize=(10, 3))
    time_usec = time_sec * 1e6
    plt.plot(time_usec, signal_volts, color='k')
    plt.title(plot_title)
    plt.xlabel(plot_x_label)
    plt.ylabel(plot_y_label)
    plt.grid()
    if suppress_show:
        plt.close()
    return fh


def plot_a_scope(
        time_sec: np.ndarray, 
        signal_volts: np.ndarray,
        template_length_sec: float,
        plot_x_label: str,
        plot_y_label: str,
        plot_title: str,
        suppress_show=False) -> "matplotlib.figure.Figure":
    """Plots a signal"""
    fh = plt.figure(figsize=(10, 3))
    range_km = (time_sec - template_length_sec) * c_speed_of_light_mps / 1e3
    a_scope_signal = 1 - normalize(signal_volts)
    plt.plot(range_km, a_scope_signal, color='k')
    plt.title(plot_title)
    plt.xlabel(plot_x_label)
    plt.ylabel(plot_y_label)
    plt.grid()
    if suppress_show:
        plt.close()
    return fh


def plot_detections(
        times_sec: np.ndarray, 
        values: np.ndarray,
        selected_times_sec: np.ndarray,
        selected_values: np.ndarray,
        plot_x_label: str,
        plot_y_label: str,
        plot_title: str,
        suppress_show=False) -> "matplotlib.figure.Figure":
    """Plots a signal and detections in the signal"""
    fh = plt.figure(figsize=(10, 3))
    plt.plot(times_sec, values, color='k')
    plt.scatter(
        selected_times_sec, selected_values, color='b', marker='o')
    plt.title(plot_title)
    plt.xlabel(plot_x_label)
    plt.ylabel(plot_y_label)
    plt.grid()
    if suppress_show:
        plt.close()
    return fh


def show_signal_spectrogram(
        time_sec: np.ndarray,
        signal_volts: np.ndarray,
        sample_rate_hz: np.ndarray,
        fmin_hz: float, fmax_hz: float,
        plot_title: str, suppress_show=False) -> "matplotlib.figure.Figure":
    """Shows a spectrogram of a signal"""
    f_hz, t_sec, sxx = signal.spectrogram(
        signal_volts, sample_rate_hz, return_onesided=True)
    f_mhz = f_hz / 1e6
    t_usec = t_sec * 1e6
    apply_custom_f_limit = (fmin_hz is not None and fmax_hz is not None)
    if apply_custom_f_limit:
        fmin_mhz = fmin_hz / 1e6
        fmax_mhz = fmax_hz / 1e6
    fh = plt.figure(figsize=(10,4))
    plt.pcolormesh(
        t_usec, fftshift(f_mhz), fftshift(sxx, axes=0),
        cmap='gray_r', shading='flat')
    plt.ylabel('Frequency (MHz)')
    if apply_custom_f_limit:
        plt.ylim((fmin_mhz, fmax_mhz))
    plt.xlabel('Time (us)')
    plt.title(plot_title)
    plt.grid()
    if suppress_show:
        plt.close()
    return fh