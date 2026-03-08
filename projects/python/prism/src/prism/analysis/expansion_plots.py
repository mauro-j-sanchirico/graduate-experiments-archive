import matplotlib.pyplot as plt
import numpy as np

def plot_expansion_and_errors(
        name, v_max, v, y, y_true, error,
        error_predicted_analytical,
        error_predicted_approx,
        error_vs_error_predicted_analytical,
        error_vs_error_predicted_approx,
        v_smooth, y_smooth, y_true_smooth, error_smooth,
        error_predicted_analytical_smooth,
        error_predicted_approx_smooth,
        error_vs_error_predicted_analytical_smooth,
        error_vs_error_predicted_approx_smooth
):

    fig, axs = plt.subplots(3, 1, figsize=(8.5,9.0), constrained_layout=True)

    my_ms = 10
    my_mew = 1.2

    # Plot the function and the approximation
    axs[0].plot(
        v, y_true,
        lw=1, ls='none', color='black',
        marker='o', ms=my_ms,
        mfc='none', mec='black', mew=my_mew,
        label='$$\\varphi(v)$$')

    axs[0].plot(
        v_smooth, y_true_smooth,
        lw=1, ls='-', color='black',
        label=None)

    axs[0].plot(
        v, y,
        lw=1, ls='none',  color='black',
        marker='x', ms=my_ms,
        mfc='none', mec='black', mew=my_mew,
        label='$$\\varphi_a(v)$$')

    axs[0].plot(
        v_smooth, y_smooth,
        lw=1, ls='-',  color='black',
        label=None)

    axs[0].legend(
        bbox_to_anchor=(0.2, 1.05, 0.6, .102), loc=3,
        ncol=2, mode="expand", borderaxespad=0)

    axs[0].grid()

    # Plot lines to mark domain of convergence
    axs[0].vlines(
        [-v_max, v_max],
        axs[0].get_ylim()[0],
        axs[0].get_ylim()[1],
        lw=2, ls='--', color='black')

    # Plot the error formulas
    axs[1].plot(
        v, error,
        lw=1, ls='none',  color='black',
        marker='o', ms=my_ms,
        mfc='none', mec='black', mew=my_mew,
        label='$$E_M^{\{\\varphi\}}(v)$$')

    axs[1].plot(
        v_smooth, error_smooth,
        lw=1, ls='-', color='black',
        label=None)

    axs[1].plot(
        v, error_predicted_analytical,
        lw=1, ls='none',  color='black',
        marker='x', ms=my_ms,
        mfc='none', mec='black', mew=my_mew,
        label='$$H_M^{\{\\varphi\}}(v)$$')

    axs[1].plot(
        v_smooth, error_predicted_analytical_smooth,
        lw=1, ls='-', color='black',
        label=None)

    axs[1].plot(
        v, error_predicted_approx,
        lw=1, ls='none',  color='black',
        marker='+', ms=my_ms,
        mfc='none', mec='black', mew=my_mew,
        label='$$I_M^{\{\\varphi\}}(v)$$')

    axs[1].plot(
        v_smooth, error_predicted_approx_smooth,
        lw=1, ls='-', color='black',
        label=None)

    axs[1].legend(
        bbox_to_anchor=(0.07, 1.05, 0.86, .102), loc=3,
        ncol=3, mode="expand", borderaxespad=0)

    axs[1].grid()

    # Plot lines to mark domain of convergence
    axs[1].vlines(
        [-v_max, v_max],
        axs[1].get_ylim()[0],
        axs[1].get_ylim()[1],
        lw=2, ls='--', color='black')

    # Plot the error in the error formulas themselves
    axs[2].semilogy(
        v, np.abs(error_vs_error_predicted_analytical),
        lw=1, ls='none',  color='black',
        marker='x', ms=my_ms,
        mfc='none', mec='black', mew=my_mew,
        label='$$\\left|E_M^{\{\\varphi \}}(v) - H_M^{\{ \\varphi \}}(v)\\right|$$')

    #axs[2].semilogy(
    #    v_smooth, np.abs(error_vs_error_predicted_analytical_smooth),
    #    lw=1, ls='-', color='black',
    #    label=None)

    axs[2].semilogy(
        v, np.abs(error_vs_error_predicted_approx),
        lw=1, ls='none',  color='black',
        marker='+', ms=my_ms,
        mfc='none', mec='black', mew=my_mew,
        label='$$\\left|E_M^{ \{ \\varphi \}}(v) - I_M^{\{ \\varphi \}}(v)\\right|$$')

    #axs[2].semilogy(
    #    v_smooth, np.abs(error_vs_error_predicted_approx_smooth),
    #    lw=1, ls='-', color='black',
    #    label=None)

    axs[2].set_xlabel('$$v$$')
    axs[2].legend(
        bbox_to_anchor=(0.03, 1.05, 0.93, .102), loc=3,
        ncol=3, mode="expand", borderaxespad=0)
    axs[2].grid()

    axs[2].vlines(
        [-v_max, v_max],
        axs[2].get_ylim()[0],
        axs[2].get_ylim()[1],
        lw=2, ls='--', color='black')

    fig.savefig(name, format='png')