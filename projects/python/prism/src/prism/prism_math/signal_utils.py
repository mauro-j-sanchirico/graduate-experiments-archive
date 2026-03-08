import numpy as np
import matplotlib.pyplot as plt

def awgn(x, snr_db):
    """Adds white gaussian noise to a signal
    
    Params:
    x -- The signal
    snr_db -- The desired SNR in 10*log10 DB
    
    Returns:
    y -- the noisy signal
    """
    snr_linear = 10**(snr_db/10)
    power_signal = np.var(x)
    power_noise = power_signal / snr_linear
    noise = np.random.normal(0, np.sqrt(power_noise), x.shape)
    y = x + noise
    return y

def visual_test_awgn():
    t = np.arange(0, 2*np.pi, 0.01)
    x = np.sin(t)
    x_hat = awgn(x, -20)

    fig, axs = plt.subplots(1,1)
    axs.plot(t, x_hat)
    axs.plot(t, x)

