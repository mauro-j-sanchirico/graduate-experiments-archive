import cupy as cp
import numpy as np


def polyval_gpu(p, e, x):
    """Evaluates a polynomial on the GPU

    Params:
    p - The coefficients of the polynomial, cupy vector
    e - The the exponents of the polynomial, cupy vector
    x - The independent variable, cupy vector

    Returns:
    result -- The evaluated polynomial
    """

    result = cp.zeros(cp.shape(x))

    for coef, exponent in zip(p, e):
        result = result + coef * x ** exponent

    return result


def polyval_cpu(p, e, x):
    """Evaluates a polynomial on the CPU

    Params:
    p - The coefficients of the polynomial, numpy vector
    e - The the exponents of the polynomial, numpy vector
    x - The independent variable, numpy vector

    Returns:
    result -- The evaluated polynomial
    """

    result = np.zeros(np.shape(x))

    for coef, exponent in zip(p, e):
        result = result + coef * x ** exponent

    return result


def convert_sparse_to_dense_polynomial(p, e):
    """Converts a polynomial from a sparse to a dense respresentation

    The dense polynomial representation returned is in descending order
    (coefficient cooresponding to largest exponent first) without skipping
    any coefficients.

    Params:
    p - The coefficients of the sparse polynomial, numpy vector
    e - The exponents of the sparse polynomial, numpy vector

    Returns:
    result -- The dense polynomial representation
    """
    max_exp = np.max(e)

    dense_coefs_list = []

    # Walk back from the maximum exponent one by one
    for idx in range(max_exp, -1, -1):
        dense_coef = p[e == idx]

        # If no exponent is found this coefficient is set to zero
        if dense_coef.shape[0] == 0:
            dense_coefs_list.append(0.0)
        else:
            dense_coefs_list.append(dense_coef[0])

    dense_coefs = np.array(dense_coefs_list)

    return dense_coefs
