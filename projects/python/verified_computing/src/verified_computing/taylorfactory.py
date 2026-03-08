"""Defines a factory for generating Taylor models

Taylor models are defined in taylorm.py.  This factory includes functions
for generating traditional Taylor models wherein the polynomials employed
use the Taylor series coefficients.  This factory also includes functions
for generating improved Taylor models wherein the the AMIE polynomials
are used.

Taylor models are efficient to use but can take some time to compute.
To help with this, saving and loading Taylor models is supported.

AMIE polynomials are defined here:
https://arxiv.org/abs/2007.06226
"""

import numpy as np

from datetime import datetime
from scipy.optimize import minimize
from scipy.optimize import Bounds

from prism.prism_math.activation_coefs import (
    get_alpha_coefs,
    compute_eta_error_tanh_approx_large_tau,
    compute_eta_error_tanh,
    compute_eta_error_relu_approx_large_sigma,
    compute_eta_error_relu,
    compute_eta_error_taylor_tanh,
)
from prism.prism_math.polynomials import convert_sparse_to_dense_polynomial

from verified_computing import taylorm


##
# Utility functions
#
def get_dated_filename(filename):

    # datetime object containing current date and time
    now = datetime.now()
    dt_str = now.strftime("%Y-%m-%d_%H-%M-%S-%f")
    filename = filename + "_" + dt_str + ".pickle"
    return filename


def get_taylor_model(
    function_type: str = "tanh",
    big_m: int = 20,
    v_max: np.float64 = 2.0,
    dps: int = 60,
    silent: bool = False,
    n_brute_points: int = 200,
    tol_final: np.float64 = 1e-4,
):
    """Builds a Taylor model

    Args:
        function_type (str) : Defines the type of function;
            currently "tanh", "tanh_taylor", and "relu" are
            supported.
        big_m (int) : Defines the "big m" term at the top of
            the summation
        v_max (np.float64) : The maximum domain of validity;
            note this only applies to Taylor models constructed
            with AMIE polynomials
        dps (int) : Digits of precision for multi-precision math
        silent (bool) : Set to True to suppress printed output
        n_brute_points (int) : Number of points to use in brute
            force optimization steps
        tol_final (np.float64) : Tolerance to use in the optimizer
            end game

    Returns:
        taylor_model (TaylorModel) : The Taylor model
    """

    # Get the coefficients
    if not silent:
        print("Computing polynomial coefficients...")

    _, exponents, coefs_float64 = get_alpha_coefs(
        function_type=function_type,
        big_m=big_m,
        v_max=v_max,
        dps=dps,
        save=False,
        silent=silent,
    )

    dense_coefs = convert_sparse_to_dense_polynomial(
        coefs_float64, np.array(exponents)
    )

    if not silent:
        print("Computing bounds...")

    # Get the bounds
    min_bound = 0
    max_bound = 0

    if function_type == "tanh":
        min_bound, max_bound = compute_bounds_tanh(
            big_m, v_max, n_brute_points, tol_final
        )
    elif function_type == "tanh_taylor":
        min_bound, max_bound = compute_bounds_tanh_taylor(big_m, v_max)
    elif function_type == "relu":
        min_bound, max_bound = compute_bounds_relu(
            big_m, v_max, n_brute_points, tol_final
        )

    taylor_model = taylorm.TaylorModel(dense_coefs, min_bound, max_bound)

    return taylor_model


def compute_bounds_tanh(
    big_m: int, v_max: np.float64, n_brute_points: int, tol_final=np.float64
):
    """Computes range bounds on the error in the tanh AMIE polynomials

    Note that this algorithm fully exploits the analytical errors
    uniquely provided by the AMIE polynomials.

    Args:
        big_m (int) : Defines the "big m" term at the top of
            the summation
        v_max (np.float64) : The maximum domain of validity
        dps (int) : Digits of precision for multi-precision math
        n_brute_points (int) : Number of points to use in brute
            force optimization steps
        tol_final (np.float64) : Tolerance to use in the optimizer
            end game

    Returns:
        (min_bound, max_bound) (np.float64, np.float64) : The minimum
            and maximum error bounds
    """

    # Evaluate the approximate error to help the optimization
    v = np.linspace(-v_max, v_max, n_brute_points)
    eta = compute_eta_error_tanh_approx_large_tau(v, big_m, v_max)

    # Brute force to get approx. local min.
    min_idx = np.argmin(eta)
    v_where_eta_is_minimum = v[min_idx]

    # Exploit the known periodicity of the error function
    # to get tight bounds for optimization
    tau = np.math.factorial(2 * big_m + 3) ** (1 / (2 * big_m + 3)) / v_max
    period = 2 * np.pi / tau

    opt_bound_min = v_where_eta_is_minimum - period / 2
    opt_bound_max = v_where_eta_is_minimum + period / 2

    # Finish with Nelder-Mead on the exact error
    result = minimize(
        compute_eta_error_tanh,
        v_where_eta_is_minimum,
        args=(big_m, v_max),
        bounds=Bounds(opt_bound_min, opt_bound_max),
        method="trust-constr",
        tol=tol_final,
    )
    found_minimum = result.fun

    # Add the tolerance of the optimizer to the uncertainty
    min_bound = found_minimum - tol_final

    # Brute force to get approx. local max.
    max_idx = np.argmax(eta)
    v_where_eta_is_maximum = v[max_idx]

    # Exploit the known periodicity of the error function
    # to get tight bounds for optimization
    opt_bound_min = v_where_eta_is_maximum - period / 2
    opt_bound_max = v_where_eta_is_maximum + period / 2

    # Finish with Nelder-Mead on the exact error
    # Take the negative of the objective function to maximize it
    negative_fn = lambda x: -compute_eta_error_tanh(x, big_m, v_max)

    result = minimize(
        negative_fn,
        v_where_eta_is_maximum,
        bounds=Bounds(opt_bound_min, opt_bound_max),
        method="trust-constr",
        tol=tol_final,
    )

    # Take the negative of the result since we negated the objective
    found_maximum = -result.fun

    # Add the tolerance of the optimizer to the uncertainty
    max_bound = found_maximum + tol_final

    return (min_bound, max_bound)


def compute_bounds_tanh_taylor(big_m: int, v_max: np.float64):
    """Computes range bounds on the error in the tanh Taylor polynomials

    Args:
        big_m (int) : Defines the "big m" term at the top of
            the summation
        v_max (np.float64) : The maximum domain of validity

    Returns:
        (min_bound, max_bound) (np.float64, np.float64) : The minimum
            and maximum error bounds
    """
    bound1 = compute_eta_error_taylor_tanh(np.array([-v_max]), big_m)
    bound2 = compute_eta_error_taylor_tanh(np.array([v_max]), big_m)

    if bound1 < bound2:
        lower_bound = bound1
        upper_bound = bound2
    else:
        lower_bound = bound2
        upper_bound = bound1

    return (lower_bound, upper_bound)


def compute_bounds_relu(
    big_m: int, v_max: np.float64, n_brute_points: int, tol_final=np.float64
):
    """Computes range bounds on the error in the relu AMIE polynomials

    Note that this algorithm fully exploits the analytical errors
    uniquely provided by the AMIE polynomials.  In the case of ReLU,
    the minimum value of the error will occur at 0.  The maximum value
    occurs at the peaks to the left and right of zero and must be
    solved for numerically.

    Args:
        big_m (int) : Defines the "big m" term at the top of
            the summation
        v_max (np.float64) : The maximum domain of validity
        dps (int) : Digits of precision for multi-precision math
        n_brute_points (int) : Number of points to use in brute
            force optimization steps
        tol_final (np.float64) : Tolerance to use in the optimizer
            end game

    Returns:
        (min_bound, max_bound) (np.float64, np.float64) : The minimum
            and maximum error bounds
    """
    # Evaluate the approximate error to help the optimization
    v = np.linspace(-v_max, v_max, n_brute_points)
    eta = compute_eta_error_relu_approx_large_sigma(v, big_m, v_max)

    # Exploit the known minimum at 0 to avoid optimizing
    min_bound = compute_eta_error_relu(
        np.array(
            [
                0.0,
            ]
        ),
        big_m,
        v_max,
    )

    # Brute force to get approx. local max.
    max_idx = np.argmax(eta)
    v_where_eta_is_maximum = v[max_idx]

    # Exploit the known periodicity of the error function
    # to get tight bounds for optimization
    sigma = np.math.factorial(2 * big_m + 2) ** (1 / (2 * big_m + 2)) / v_max
    period = 2 * np.pi / sigma
    opt_bound_min = v_where_eta_is_maximum - period / 2
    opt_bound_max = v_where_eta_is_maximum + period / 2

    # Finish with Nelder-Mead on the exact error
    # Take the negative of the objective function to maximize it
    negative_fn = lambda x: -compute_eta_error_relu(x, big_m, v_max)

    result = minimize(
        negative_fn,
        v_where_eta_is_maximum,
        bounds=Bounds(opt_bound_min, opt_bound_max),
        method="trust-constr",
        tol=tol_final,
    )

    # Take the negative of the result since we negated the objective
    found_maximum = -result.fun

    # Add the tolerance of the optimizer to the uncertainty
    max_bound = found_maximum + tol_final

    return (min_bound, max_bound)
