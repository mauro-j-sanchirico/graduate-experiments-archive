import cupy as cp
from datetime import datetime
import matplotlib.pyplot as plt
from mpmath import (
    bernoulli,
    betainc,
    cos,
    csch,
    exp,
    eulernum,
    factorial,
    hyp2f1,
    hyper,
    inf,
    j,
    quad,
    pi,
    polylog,
    re,
    si,
    sin,
    sech,
    mp,
)
import numpy as np
import pickle

from prism.prism_math.polynomials import polyval_cpu, polyval_gpu

##
# Utility functions
#
# These functions help compute intermediate results in the Alpha expansions.
# They compute fundamental mathemtatical results that are built off of
# mathematical primitives.
#


def compute_legendre_chi_mp(s, z):
    """Computes the Legendre Chi function in multi-precision

    Params:
    s -- The index of the polylogs
    z -- The argument

    Returns
    chi -- The value of the Legendre Chi function
    """
    chi = 1 / 2 * (polylog(s, z) - polylog(s, -z))
    return chi


def compute_inverse_tangent_integral_mp(s, z):
    """Computes the Inverse Tangent Integral in multi-precision

    Params:
    s -- The index of the polylogs
    z -- The argument

    Returns
    chi -- The value of the Legendre Chi function
    """
    ti = 1 / (2 * j) * (polylog(s, j * z) - polylog(s, -j * z))
    return ti


def compute_lambda_csch_mp(a, j_index, xi):
    """Computes the antiderivative of int xi^j * csch(a*xi) dxi in multi-precision

    This is an intermediate result in the expansion of the hyperbolic tangent
    that is provided for convienience only.  It is not the most efficient way to
    compute the expansion coefficients of the hyperbolic tangent.

    Params:
    a -- An arbitrary constant
    j_index -- The index to use
    xi -- The independent variable

    Returns
    result -- The value of the Lambda result
    """
    summation = 0
    for k in range(0, int(j_index + 1)):
        factorials = factorial(j_index) / factorial(j_index - k)
        xi_power = xi ** (j_index - k)
        a_power = a ** (-k - 1)
        chi_factor = compute_legendre_chi_mp(k + 1, exp(-a * xi))
        term = factorials * xi_power * a_power * chi_factor
        summation += term
    result = -2 * summation
    return result


def get_dated_filename(filename):

    # datetime object containing current date and time
    now = datetime.now()
    dt_str = now.strftime("%Y-%m-%d_%H-%M-%S-%f")
    filename = filename + "_" + dt_str + ".pickle"
    return filename


##
# Nth Coefficients Formulas
#
# These are n-th coefficient formulas for the alpha coefficient expansions.
#


def compute_nth_alpha_tanh_coef_mp(big_m, v_max, j_index):
    """Computes a coefficient of the hyperbolic tangent approximation

    Params:
    big_m -- The order of the expansion
    v_max -- The bound of validity
    j_index -- The exponent associated with this coefficient

    Returns:
    (alpha, j_index) -- The coefficient and its associated exponent
    """

    q = 2 * big_m + 3
    m = int((j_index - 1) / 2)
    tau = (factorial(q)) ** (1 / q) / v_max

    summation = 0
    for k in range(0, int(2 * m + 2)):
        chi_factor = compute_legendre_chi_mp(k + 1, exp(-pi * tau / 2))
        term = (
            2 ** k
            * tau ** (2 * m + 1 - k)
            * chi_factor
            / (pi ** k * factorial(2 * m + 1 - k))
        )
        summation += term

    term = (
        2 ** (2 * m + 1)
        * (4 ** (m + 1) - 1)
        * bernoulli(2 * m + 2)
        / ((m + 1) * factorial(2 * m + 1))
    )

    alpha = (-1) ** (m + 1) * 4 / pi * summation + term

    return (alpha, j_index)


def compute_nth_taylor_tanh_coef_mp(j_index):
    """Computes a coefficient of the hyperbolic tangent approximation

    Params:
    j_index -- The exponent associated with this coefficient

    Returns:
    (coef, j_index) -- The coefficient and its associated exponent
    """
    m = int((j_index + 1) / 2)
    coef = (
        2 ** (2 * m) * (2 ** (2 * m) - 1) * bernoulli(2 * m) / factorial(2 * m)
    )

    return (coef, j_index)


def compute_nth_alpha_sech_coef_mp(big_m, v_max, j_index):
    """Computes a coefficient of the hyperbolic secant approximation

    Params:
    big_m -- The order of the expansion
    v_max -- The bound of validity
    j_index -- The exponent associated with this coefficient

    Returns:
    (alpha, j_index) -- The coefficient and its associated exponent
    """

    q = 2 * big_m + 2
    m = int(j_index / 2)
    sigma = (factorial(q)) ** (1 / q) / v_max

    summation = 0
    for k in range(0, int(2 * m + 1)):
        ti_factor = compute_inverse_tangent_integral_mp(
            k + 1, exp(-pi * sigma / 2)
        )
        term = (
            2 ** k
            * sigma ** (2 * m - k)
            * ti_factor
            / (pi ** k * factorial(2 * m - k))
        )
        summation += term

    term = eulernum(2 * m) / factorial(2 * m)

    alpha = (-1) ** (m + 1) * 4 / pi * re(summation) + term

    return (alpha, j_index)


def compute_nth_alpha_sech2_coef_mp(big_m, v_max, j_index):
    """Computes a coefficient of the hyperbolic secant squared approximation

    Params:
    big_m -- The order of the expansion
    v_max -- The bound of validity
    j_index -- The exponent associated with this coefficient

    Returns:
    (alpha, j_index) -- The coefficient and its associated exponent
    """
    q = 2 * big_m + 2
    m = int(j_index / 2)
    sigma = (factorial(q)) ** (1 / q) / v_max

    summation = 0
    for k in range(0, int(2 * m + 2)):
        chi_factor = compute_legendre_chi_mp(k + 1, exp(-pi * sigma / 2))
        term = (
            2 ** k
            * sigma ** (2 * m - k + 1)
            * chi_factor
            / (pi ** k * factorial(2 * m - k + 1))
        )
        summation += term

    term = (
        2 ** (2 * m + 1)
        * (4 ** (m + 1) - 1)
        * bernoulli(2 * m + 2)
        / (factorial(2 * m) * (m + 1))
    )
    alpha = (-1) ** (m + 1) * 4 * (2 * m + 1) / pi * re(summation) + term

    return (alpha, j_index)


def compute_nth_alpha_relu_coef_mp(big_m, v_max, j_index):
    """Computes a coefficient of the hyperbolic tangent approximation"""
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max
    m_index = j_index / 2
    alpha = (
        (-1) ** (m_index + 1)
        * sigma ** (2 * m_index - 1)
        / (pi * factorial(2 * m_index) * (2 * m_index - 1))
    )
    return (alpha, j_index)


##
# Multi-precision formulas
#
# These are the multi-precision formulas for approximating the
# supported activation functions.
#

# ---------------------------------------------
# Hyperbolic tangent - multiprecision formulas
# ---------------------------------------------


def compute_alpha_tanh_coefs_mp(big_m, v_max, silent=False):
    """Computes coefficients for the hyperbolic tangent approximation

    Params:
    big_m -- The order of expansion
    v_max -- The maximum bound of validity
    silent -- Turns off output when set to true

    Returns:
    (coefs, exponents) -- The coefficients and the associated exponents
    """

    exponents = []
    coefs = []

    # Compute the odd part
    for m_index in range(0, big_m + 1):
        j_index = 2 * m_index + 1
        coef, exponent = compute_nth_alpha_tanh_coef_mp(
            big_m=big_m, v_max=v_max, j_index=j_index
        )
        coefs.append(coef)
        exponents.append(exponent)
        if not silent:
            print(
                "Generated tanh coef. {} for exponent {}".format(
                    coef, exponent
                )
            )

    return (coefs, exponents)


def compute_eta_error_tanh(v_values, big_m, v_max):
    """Computes the error for the alpha expansion of tanh

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_tanh -- The expansion error for each v in v_values
    """
    q = 2 * big_m + 3
    tau = (factorial(q)) ** (1 / q) / v_max

    eta_error_tanh = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand1 = (
            lambda xi: (xi * v) ** (2 * big_m + 3)
            * csch(pi / 2 * xi)
            * hyper([1], [big_m + 2, big_m + 5 / 2], -((xi * v) ** 2.0) / 4.0)
        )
        integral1 = quad(integrand1, [0, tau])

        integral2 = 2 * np.tanh(v) - j / pi * (
            betainc(1.0 / 2.0 + j * v / pi, 0, x1=0, x2=exp(pi * tau))
            - betainc(1.0 / 2.0 - j * v / pi, 0, x1=0, x2=exp(pi * tau))
        )

        eta_error_tanh[idx] = (-1) ** (big_m + 1) / factorial(
            2 * big_m + 3
        ) * integral1 + re(integral2)

    return eta_error_tanh


def compute_eta_error_tanh_analytic(v_values, big_m, v_max):
    """Employs a partially analytical formula for the tanh error

    This function is useful for checking intermediate results pertaining
    to the analysis of the error formulas for the tanh modified expansion.
    However, it is not the most efficient way to evaluate the error.

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_tanh -- The expansion error for each v in v_values
    """

    q = 2 * big_m + 3
    tau = (factorial(q)) ** (1 / q) / v_max

    eta_error_tanh = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand1 = (
            lambda xi: (xi * v) ** (2 * big_m + 3)
            * csch(pi / 2 * xi)
            * hyper([1], [big_m + 2, big_m + 5 / 2], -((xi * v) ** 2.0) / 4.0)
        )
        integral1 = quad(integrand1, [0, tau])

        U1 = (
            exp(-j * tau * v)
            / (v - j * pi / 2)
            * hyper([1, 1], [3 / 2 + j * v / pi], 1 / (1 - exp(pi * tau)))
        )

        U2 = (
            exp(j * tau * v)
            / (v + j * pi / 2)
            * hyper([1, 1], [3 / 2 - j * v / pi], 1 / (1 - exp(pi * tau)))
        )

        integral2 = exp(tau * pi / 2) / (exp(pi * tau) - 1) * (U1 + U2)

        eta_error_tanh[idx] = (-1) ** (big_m + 1) / factorial(
            2 * big_m + 3
        ) * integral1 + re(integral2)

    return eta_error_tanh


def compute_eta_error_tanh_approx_large_tau(v_values, big_m, v_max):
    """Employs a completely analytic approx formula for tanh expansion error

    This formula is valid within the region of convergence, |v| < V

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_tanh -- The approx. expansion error for each v in v_values
    """
    q = 2 * big_m + 3
    tau = (factorial(q)) ** (1 / q) / v_max

    eta_error_tanh = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integral2 = (
            4
            * exp(tau * pi / 2)
            / ((exp(pi * tau) - 1) * (4 * v ** 2 + pi ** 2))
            * (pi * sin(tau * v) + 2 * v * cos(tau * v))
        )

        eta_error_tanh[idx] = integral2

    return eta_error_tanh


# ----------------------------------------------------
# Hyperbolic tangent Taylor - multiprecision formulas
# ----------------------------------------------------


def compute_taylor_tanh_coefs_mp(big_m, silent=False):
    """Computes coefficients for the hyperbolic tangent Taylor series

    Params:
    big_m -- The order of expansion
    silent -- Turns off output when set to true

    Returns:
    (coefs, exponents) -- The coefficients and the associated exponents
    """

    exponents = []
    coefs = []

    # Compute the odd part
    for m_index in range(1, big_m + 1):
        j_index = 2 * m_index - 1
        coef, exponent = compute_nth_taylor_tanh_coef_mp(j_index=j_index)
        coefs.append(coef)
        exponents.append(exponent)
        if not silent:
            print(
                "Generated tanh Tayor coef. {} for exponent {}".format(
                    coef, exponent
                )
            )

    return (coefs, exponents)


def compute_eta_error_taylor_tanh(v_values, big_m):
    """Computes the error for the Taylor expansion of tanh

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion

    Returns:
    eta_error_taylor_tanh -- The expansion error for each v in v_values
    """
    eta_error_tanh = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand = (
            lambda xi: (xi * v) ** (2 * big_m + 1)
            * csch(pi / 2 * xi)
            * hyper([1], [big_m + 1, big_m + 3 / 2], -((xi * v) ** 2.0) / 4.0)
        )
        integral = quad(integrand, [0, inf])

        eta_error_tanh[idx] = (
            (-1) ** big_m / factorial(2 * big_m + 1) * integral
        )

    return eta_error_tanh


# ---------------------------------------------
# Hyperbolic secant - multiprecision formulas
# ---------------------------------------------


def compute_alpha_sech_coefs_mp(big_m, v_max, silent=False):
    """Computes coefficients for the hyperbolic secant approximation

    Params:
    big_m -- The order of expansion
    v_max -- The maximum bound of validity
    silent -- Turns off output when set to true

    Returns:
    (coefs, exponents) -- The coefficients and the associated exponents
    """

    exponents = []
    coefs = []

    # Compute the odd part
    for m_index in range(0, big_m + 1):
        j_index = 2 * m_index
        coef, exponent = compute_nth_alpha_sech_coef_mp(
            big_m=big_m, v_max=v_max, j_index=j_index
        )
        coefs.append(coef)
        exponents.append(exponent)
        if not silent:
            print(
                "Generated sech coef. {} for exponent {}".format(
                    coef, exponent
                )
            )

    return (coefs, exponents)


def compute_eta_error_sech(v_values, big_m, v_max):
    """Computes the error for the alpha expansion of sech

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_sech -- The expansion error for each v in v_values
    """
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_sech = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand1 = (
            lambda xi: xi ** (2 * big_m + 2)
            * sech(pi / 2 * xi)
            * hyper([1], [big_m + 2, big_m + 3 / 2], -((xi * v) ** 2.0) / 4.0)
        )
        integral1 = quad(integrand1, [0, sigma])

        integrand2 = lambda xi: sech(pi / 2 * xi) * cos(xi * v)
        integral2 = quad(integrand2, [sigma, inf])

        eta_error_sech[idx] = (-1) ** (big_m + 1) * v ** (
            2 * big_m + 2
        ) / factorial(q) * integral1 + re(integral2)

    return eta_error_sech


def compute_eta_error_sech_analytic(v_values, big_m, v_max):
    """Employs a partially analytical formula for the sech error

    This function is useful for checking intermediate results pertaining
    to the analysis of the error formulas for the sech modified expansion.
    However, it is not the most efficient way to evaluate the error.

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_sech -- The expansion error for each v in v_values
    """

    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_sech = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand1 = (
            lambda xi: xi ** (2 * big_m + 2)
            * sech(pi / 2 * xi)
            * hyper([1], [big_m + 2, big_m + 3 / 2], -((xi * v) ** 2.0) / 4.0)
        )
        integral1 = quad(integrand1, [0, sigma])

        U1 = (
            exp(j * sigma * v)
            / (pi / 2 - j * v)
            * hyper([1, 1], [3 / 2 - j * v / pi], 1 / (1 + exp(pi * sigma)))
        )

        U2 = (
            exp(-j * sigma * v)
            / (pi / 2 + j * v)
            * hyper([1, 1], [3 / 2 + j * v / pi], 1 / (1 + exp(pi * sigma)))
        )

        integral2 = exp(pi * sigma / 2) / (exp(pi * sigma) + 1) * (U1 + U2)

        term1 = (-1) ** (big_m + 1) * v ** q / factorial(q) * integral1

        eta_error_sech[idx] = term1 + re(integral2)

    return eta_error_sech


def compute_eta_error_sech_approx_large_sigma(v_values, big_m, v_max):
    """Employs a completely analytic approx formula for sech expansion error

    This formula is valid within the region of convergence, |v| < V

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_sech -- The approx. expansion error for each v in v_values
    """
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_sech = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integral2 = (
            4
            * exp(pi * sigma / 2)
            / ((exp(pi * sigma) + 1) * (4 * v ** 2 + pi ** 2))
            * (pi * cos(sigma * v) - 2 * v * sin(sigma * v))
        )

        eta_error_sech[idx] = integral2

    return eta_error_sech


# ------------------------------------------------
# Hyberbolic Secant Squared
# ------------------------------------------------


def compute_alpha_sech2_coefs_mp(big_m, v_max, silent=False):
    """Computes coefficients for the hyperbolic secant squared approximation

    Params:
    big_m -- The order of expansion
    v_max -- The maximum bound of validity
    silent -- Turns off output when set to true

    Returns:
    (coefs, exponents) -- The coefficients and the associated exponents
    """
    exponents = []
    coefs = []

    # Compute the odd part
    for m_index in range(0, big_m + 1):
        j_index = 2 * m_index
        coef, exponent = compute_nth_alpha_sech2_coef_mp(
            big_m=big_m, v_max=v_max, j_index=j_index
        )
        coefs.append(coef)
        exponents.append(exponent)
        if not silent:
            print(
                "Generated sech^2 coef. {} for exponent {}".format(
                    coef, exponent
                )
            )

    return (coefs, exponents)


def compute_eta_error_sech2(v_values, big_m, v_max):
    """Computes the error for the alpha expansion of sech squared

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_sech -- The expansion error for each v in v_values
    """
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_sech2 = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand1 = (
            lambda xi: xi ** (2 * big_m + 3)
            * csch(pi / 2 * xi)
            * hyper([1], [big_m + 2, big_m + 3 / 2], -((xi * v) ** 2.0) / 4.0)
        )
        integral1 = quad(integrand1, [0, sigma])

        integrand2 = lambda xi: xi * csch(pi / 2 * xi) * cos(xi * v)
        integral2 = quad(integrand2, [sigma, inf])

        eta_error_sech2[idx] = (-1) ** (big_m + 1) * v ** (
            2 * big_m + 2
        ) / factorial(q) * integral1 + re(integral2)

    return eta_error_sech2


def compute_eta_error_sech2_analytic(v_values, big_m, v_max):
    """Employs a partially analytical formula for the sech squared error

    This function is useful for checking intermediate results pertaining
    to the analysis of the error formulas for the sech modified expansion.
    However, it is not the most efficient way to evaluate the error.

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_sech -- The expansion error for each v in v_values
    """

    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_sech2 = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand1 = lambda xi: xi * csch(pi / 2 * xi) * cos(xi * v)
        integral1 = quad(integrand1, [sigma, inf])

        eta_error_sech2[idx] = integral1

    return eta_error_sech2


# TODO: Check and finish this function
def compute_eta_error_sech2_approx_large_sigma(v_values, big_m, v_max):
    """Employs a completely analytic approx formula for sech squared expansion error

    Note that classical closed forms (e.g. sine, cosine, exponential, etc.) proved
    difficult to extract for the sech squared.  For this reason we employ the
    hypergeometric form of these equations instead.  Note there is an equivalent
    expression in terms of the Hurwitz-Lerch Transcendent and the Euler Beta
    Function, however the Hurwitz-Lerch Transcendent is known to be buggy in python
    so we avoid it here.

    This formula is valid within the region of convergence, |v| < V

    Params:
    v_values -- The vector of values to compute the error over
    big_m -- The order of the expansion
    v_max -- The maximum bound of validity

    Returns:
    eta_error_sech -- The approx. expansion error for each v in v_values
    """
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_sech2 = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        a = 1
        b = 1 / 2 - j * v / pi
        c = 3 / 2 - j * v / pi
        z = exp(pi * sigma)
        exp_term = (
            exp(1 / 2 * (pi - 2 * j * v) * sigma) / (pi - 2 * j * v) ** 2
        )
        h2f1_term = hyp2f1(a, b, c, z)
        h3f2_term = hyper([1, b, b], [c, c], z)

        eta_error_sech2[idx] = 2 * sech(v) ** 2 + 4 * re(
            exp_term * ((pi - 2 * j * v) * sigma * h2f1_term - 2 * h3f2_term)
        )

    return eta_error_sech2


# ------------------------------------------------
# Rectified linear unit - multiprecision formulas
# ------------------------------------------------


def compute_alpha_relu_coefs_mp(big_m, v_max, silent=False):
    """Computes coefficients for the relu approximation

    Params:
    big_m -- The order of expansion
    v_max -- The maximum bound of validity
    silent -- Turns off output when set to true

    Returns:
    (coefs, exponents) -- The coefficients and the associated exponents
    """

    exponents = []
    coefs = []

    # Compute the even part
    for m_index in range(0, big_m + 1):
        j_index = 2 * m_index
        coef, exponent = compute_nth_alpha_relu_coef_mp(
            big_m=big_m, v_max=v_max, j_index=j_index
        )
        coefs.append(coef)
        exponents.append(exponent)
        if not silent:
            print(
                "Generated relu coef. {} for exponent {}".format(
                    coef, exponent
                )
            )

    # Append the odd part
    exponents.append(1)
    coefs.append(0.5)
    if not silent:
        print("Generated relu coef. {} for exponent {}".format(0.5, 1.0))

    return (coefs, exponents)


def compute_eta_error_relu(v_values, big_m, v_max):
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_relu = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        integrand1 = lambda xi: xi ** (2 * big_m) * hyper(
            [1], [big_m + 2, big_m + 3 / 2], -((xi * v) ** 2.0) / 4.0
        )
        integral1 = quad(integrand1, [0, sigma])

        integrand2 = lambda xi: cos(xi * v) / (xi ** 2)
        integral2 = quad(integrand2, [sigma, inf])

        eta_error_relu[idx] = (-1) ** big_m * v ** (2 * big_m + 2) / (
            pi * factorial(2 * big_m + 2)
        ) * integral1 - 1 / pi * re(integral2)

    return eta_error_relu


def compute_eta_error_relu_analytic(v_values, big_m, v_max):
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_relu = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]

        term1 = (
            (-1) ** big_m
            * sigma ** (2 * big_m + 1)
            * v ** (2 * big_m + 2)
            / (pi * factorial(2 * big_m + 2) * (2 * big_m + 1))
            * hyper(
                [1, big_m + 1 / 2],
                [big_m + 3 / 2, big_m + 3 / 2, big_m + 2],
                -((sigma * v) ** 2.0) / 4.0,
            )
        )

        term2 = (
            abs(v) / 2 - v * si(sigma * v) / pi - cos(sigma * v) / (sigma * pi)
        )

        eta_error_relu[idx] = term1 + term2

    return eta_error_relu


def compute_eta_error_relu_approx_large_sigma(v_values, big_m, v_max):
    q = 2 * big_m + 2
    sigma = (factorial(q)) ** (1 / q) / v_max

    eta_error_relu = np.zeros(v_values.shape)

    for idx in range(0, len(v_values)):
        v = v_values[idx]
        term2 = (
            abs(v) / 2 - v * si(sigma * v) / pi - cos(sigma * v) / (sigma * pi)
        )
        eta_error_relu[idx] = term2

    return eta_error_relu


##
# Alpha Coefficients Class
#
# Utility class for saving and loading the alpha coefficients.
#


class AlphaCoefs:
    def __init__(self, function_type, big_m, v_max, silent):

        if function_type == "tanh":
            coefs, exponents = compute_alpha_tanh_coefs_mp(
                big_m=big_m, v_max=v_max, silent=silent
            )
        elif function_type == "tanh_taylor":
            coefs, exponents = compute_taylor_tanh_coefs_mp(
                big_m=big_m, silent=silent
            )
        elif function_type == "sech":
            coefs, exponents = compute_alpha_sech_coefs_mp(
                big_m=big_m, v_max=v_max, silent=silent
            )
        elif function_type == "sech2":
            coefs, exponents = compute_alpha_sech2_coefs_mp(
                big_m=big_m, v_max=v_max, silent=silent
            )
        elif function_type == "relu":
            coefs, exponents = compute_alpha_relu_coefs_mp(
                big_m=big_m, v_max=v_max, silent=silent
            )
        else:
            coefs = None
            exponents = None

        self.coefs = coefs
        self.coefs_float64 = np.array(coefs, dtype=np.float64)
        self.exponents = exponents
        self.big_m = big_m
        self.v_max = v_max

    def save(self, filename):
        filename = get_dated_filename(filename)
        with open(filename, "wb") as fh:
            pickle.dump(self, fh)
        return filename

    @classmethod
    def load(cls, filename):
        with open(filename, "rb") as f:
            return pickle.load(f)


##
# Get Alpha Coefficients Function
#
# This is the main function that should be used to get the alpha coefficients
# for use in other algoriths.
#


def get_alpha_coefs(
    function_type="tanh",
    big_m=20,
    v_max=2,
    dps=60,
    load_file=None,
    save=True,
    silent=False,
    save_str="",
):
    """Generates or loads alpha coefs

    Params:
    function_type -- (str) The function type desired:
        'tanh', 'sech', 'sech2', 'relu', 'tanh_taylor'
    big_m -- (int) The order of the expansion
    v_max -- (float) The maxium bound of validity
    dps -- (int) The digits of precision
    load_file -- (str) The name of the file to load from
    save -- (bool) Set to true to save generated coefficients
    save_str -- (str) Descriptive string to form save file name

    (alpha_coefs, exponents, alpha_coefs_float64) -- The alpha coefs
    in multiprecision, their exponents, and the truncated float64
    versions of the alpha coefficients.
    """

    # If no file is provided, generate coefs
    if load_file == None:

        mp.dps = dps

        alpha_coefs_obj = AlphaCoefs(
            function_type=function_type,
            big_m=big_m,
            v_max=v_max,
            silent=silent,
        )

        if save:
            alpha_coefs_obj.save(
                "coefs/{}_{}_coefs".format(function_type, save_str)
            )

    # Otherwise load from file
    else:
        alpha_coefs_obj = AlphaCoefs.load(load_file)

    # The multiprecision coefficients
    alpha_coefs, exponents = alpha_coefs_obj.coefs, alpha_coefs_obj.exponents

    # The float64 coefficients
    alpha_coefs_float64 = alpha_coefs_obj.coefs_float64

    return (alpha_coefs, exponents, alpha_coefs_float64)


##
# Visual tests
#
# A series of visual test are provided to confirm that the functions for
# expansion and error prediction are working correctly.
#


def visual_test_alpha_coefs_tanh():
    """Generates and tests the alpha_coefs"""

    big_m = 10
    v_max = 2

    alpha_coefs, exponents, alpha_coefs_float64 = get_alpha_coefs(
        function_type="tanh",
        big_m=big_m,
        v_max=v_max,
        dps=64,
        load_file=None,
        save=False,
        silent=True,
    )

    x = np.arange(-2.1, 2.1, 0.05)
    y = polyval_cpu(alpha_coefs_float64, exponents, x)
    y_true = np.tanh(x)

    error = y_true - y
    error_predicted = compute_eta_error_tanh(x, big_m, v_max)
    error_predicted_analytical = compute_eta_error_tanh_analytic(
        x, big_m, v_max
    )
    error_predicted_approx = compute_eta_error_tanh_approx_large_tau(
        x, big_m, v_max
    )

    fig, axs = plt.subplots(3, 1, figsize=(9, 7))
    axs[0].plot(x, y_true, linewidth=8, color="navy")
    axs[0].plot(x, y, linewidth=2, color="limegreen")
    axs[0].set_xlabel("x")
    axs[0].set_ylabel("y")
    axs[0].set_title("Hyperbolic Tangent")
    axs[0].legend(("True", "Approx."))
    axs[1].plot(x, error, linewidth=8, color="navy")
    axs[1].plot(x, error_predicted_analytical, linewidth=4, color="red")
    axs[1].plot(x, error_predicted, linewidth=2, color="limegreen")
    axs[1].plot(x, error_predicted_approx, linewidth=0.5, color="black")
    axs[1].set_xlabel("x")
    axs[1].set_ylabel("Error")
    axs[1].legend(("True", "Predicted"))
    axs[2].stem(exponents, np.log10(np.abs(alpha_coefs_float64)))
    axs[2].set_xlabel("exponent")
    axs[2].set_ylabel("log10(abs(coef))")


def visual_test_taylor_coefs_tanh():
    """Generates and tests the alpha_coefs"""

    big_m = 10

    alpha_coefs, exponents, alpha_coefs_float64 = get_alpha_coefs(
        function_type="tanh_taylor",
        big_m=big_m,
        dps=64,
        load_file=None,
        save=False,
        silent=True,
    )

    x = np.arange(-np.pi / 2, np.pi / 2, 0.1)
    y = polyval_cpu(alpha_coefs_float64, exponents, x)
    y_true = np.tanh(x)

    error = y_true - y
    error_predicted = compute_eta_error_taylor_tanh(x, big_m)

    fig, axs = plt.subplots(3, 1, figsize=(9, 7))
    axs[0].plot(x, y_true, linewidth=8, color="navy")
    axs[0].plot(x, y, linewidth=2, color="limegreen")
    axs[0].set_xlabel("x")
    axs[0].set_ylabel("y")
    axs[0].set_title("Hyperbolic Tangent")
    axs[0].legend(("True", "Approx."))
    axs[1].plot(x, error, linewidth=8, color="navy")
    axs[1].plot(x, error_predicted, linewidth=2, color="limegreen")
    axs[1].set_xlabel("x")
    axs[1].set_ylabel("Error")
    axs[1].legend(("True", "Predicted"))
    axs[2].stem(exponents, np.log10(np.abs(alpha_coefs_float64)))
    axs[2].set_xlabel("exponent")
    axs[2].set_ylabel("log10(abs(coef))")


def visual_test_alpha_coefs_sech():
    """Generates and tests the alpha_coefs"""

    big_m = 10
    v_max = 2

    alpha_coefs, exponents, alpha_coefs_float64 = get_alpha_coefs(
        function_type="sech",
        big_m=big_m,
        v_max=v_max,
        dps=64,
        load_file=None,
        save=False,
        silent=True,
    )

    x = np.arange(-2.1, 2.1, 0.05)
    y = polyval_cpu(alpha_coefs_float64, exponents, x)
    y_true = 1 / np.cosh(x)

    error = y_true - y
    error_predicted = compute_eta_error_sech(x, big_m, v_max)
    error_predicted_analytical = compute_eta_error_sech_analytic(
        x, big_m, v_max
    )
    error_predicted_approx = compute_eta_error_sech_approx_large_sigma(
        x, big_m, v_max
    )

    fig, axs = plt.subplots(3, 1, figsize=(9, 7))
    axs[0].plot(x, y_true, linewidth=8, color="navy")
    axs[0].plot(x, y, linewidth=2, color="limegreen")
    axs[0].set_xlabel("x")
    axs[0].set_ylabel("y")
    axs[0].set_title("Hyperbolic Secant")
    axs[0].legend(("True", "Approx."))
    axs[1].plot(x, error, linewidth=8, color="navy")
    axs[1].plot(x, error_predicted_analytical, linewidth=4, color="red")
    axs[1].plot(x, error_predicted, linewidth=2, color="limegreen")
    axs[1].plot(x, error_predicted_approx, linewidth=0.5, color="black")
    axs[1].set_xlabel("x")
    axs[1].set_ylabel("Error")
    axs[1].legend(("True", "Predicted"))
    axs[2].stem(exponents, np.log10(np.abs(alpha_coefs_float64)))
    axs[2].set_xlabel("exponent")
    axs[2].set_ylabel("log10(abs(coef))")


def visual_test_alpha_coefs_sech2():
    """Generates and tests the alpha_coefs"""

    big_m = 10
    v_max = 2

    alpha_coefs, exponents, alpha_coefs_float64 = get_alpha_coefs(
        function_type="sech2",
        big_m=big_m,
        v_max=v_max,
        dps=64,
        load_file=None,
        save=False,
        silent=True,
    )

    x = np.arange(-2.1, 2.1, 0.05)
    y = polyval_cpu(alpha_coefs_float64, exponents, x)
    y_true = 1 / np.cosh(x) ** 2

    error = y_true - y
    error_predicted = compute_eta_error_sech2(x, big_m, v_max)
    error_predicted_analytical = compute_eta_error_sech2_analytic(
        x, big_m, v_max
    )
    error_predicted_approx = compute_eta_error_sech2_approx_large_sigma(
        x, big_m, v_max
    )

    fig, axs = plt.subplots(3, 1, figsize=(9, 7))
    axs[0].plot(x, y_true, linewidth=8, color="navy")
    axs[0].plot(x, y, linewidth=2, color="limegreen")
    axs[0].set_xlabel("x")
    axs[0].set_ylabel("y")
    axs[0].set_title("Hyperbolic Secant Squared")
    axs[0].legend(("True", "Approx."))
    axs[1].plot(x, error, linewidth=8, color="navy")
    axs[1].plot(x, error_predicted_analytical, linewidth=4, color="red")
    axs[1].plot(x, error_predicted, linewidth=2, color="limegreen")
    axs[1].plot(x, error_predicted_approx, linewidth=0.5, color="black")
    axs[1].set_xlabel("x")
    axs[1].set_ylabel("Error")
    axs[1].legend(("True", "Predicted"))
    axs[2].stem(exponents, np.log10(np.abs(alpha_coefs_float64)))
    axs[2].set_xlabel("exponent")
    axs[2].set_ylabel("log10(abs(coef))")


def visual_test_alpha_coefs_relu():
    """Generates and tests the alpha_coefs"""

    big_m = 10
    v_max = 2

    alpha_coefs, exponents, alpha_coefs_float64 = get_alpha_coefs(
        function_type="relu",
        big_m=big_m,
        v_max=v_max,
        dps=64,
        load_file=None,
        save=False,
        silent=True,
    )

    x = np.arange(-2.1, 2.1, 0.05)
    y = polyval_cpu(alpha_coefs_float64, exponents, x)
    y_true = 0.5 * (np.abs(x) + x)

    error = y_true - y
    error_predicted = compute_eta_error_relu(x, big_m, v_max)
    error_predicted_analytical = compute_eta_error_relu_analytic(
        x, big_m, v_max
    )
    error_predicted_approx = compute_eta_error_relu_approx_large_sigma(
        x, big_m, v_max
    )

    fig, axs = plt.subplots(3, 1, figsize=(9, 7))
    axs[0].plot(x, y_true, linewidth=8, color="navy")
    axs[0].plot(x, y, linewidth=2, color="limegreen")
    axs[0].set_xlabel("x")
    axs[0].set_ylabel("y")
    axs[0].set_title("ReLU")
    axs[0].legend(("True", "Approx."))
    axs[1].plot(x, error, linewidth=8, color="navy")
    axs[1].plot(x, error_predicted_analytical, linewidth=4, color="red")
    axs[1].plot(x, error_predicted, linewidth=2, color="limegreen")
    axs[1].plot(x, error_predicted_approx, linewidth=0.5, color="black")
    axs[1].set_xlabel("x")
    axs[1].set_ylabel("log10(abs(error))")
    axs[2].stem(exponents, np.log10(np.abs(alpha_coefs_float64)))
    axs[2].set_xlabel("exponent")
    axs[2].set_ylabel("log10(abs(coef))")
