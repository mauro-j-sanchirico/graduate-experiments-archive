"""Defines a TaylorModel class and functions for operating on TaylorModels

Taylor models are a method whereby verified computing can be performed
on any functions having polynomial representations with known error
bounds.  Taylor Models represent functions as a polynomial part p
and as an error part e.  Standard operations such as addition,
subtraction, and multiplication of Taylor models can be defined by
performing addition, subtraction, and multiplication of the polynomial
and error parts.  The error parts are treated as formal intervals and
the polynomial parts are treated as coefficient vetors.  When operations
which increase the polynomial order of the result (e.g. multiplication)
are performed, the result is truncated and the remainder polynomial is
bounded and absorbed into the error part of the result according to the
rules of Taylor model arithmetic.

This module does not provide a means of obtaining Taylor model
coefficients.  Taylor model coefficients are usually obtained by
taking the Taylor series of an elementary function.  However, the Taylor
series need not be used exclusively and in the case where there are
better polynomial approximations with smaller errors that can still be
explicitly calculated or bounded (as the remainders from the Taylor
series can be bounded by the Lagrange remainder).  Operations such as
composition of Taylor models are also supported so that Taylor models
for non-elementary functions can be constructed from Taylor models for
elementary functions.
"""


import matplotlib
import matplotlib.pyplot as plt
import numpy as np

from verified_computing import intvmath
from verified_computing import polynomialmath


__author__ = "Mauro J. Sanchirico III"
__copyright__ = "Copyright 2021 Mauro J. Sanchirico III"
__credits__ = ["Mauro J. Sanchirico III", "Xun Jiao", "C. Nataraj"]
__license__ = "GPL"
__version__ = "0.1"
__maintainer__ = "Mauro J. Sanchirico III"
__email__ = "msanchi1@villanova.edu"
__status__ = "Prototype"


class TaylorModel:
    """Defines a Taylor Model for representing functions

    Taylor Models represent functions as a polynomial part p
    and as an error part e.  The polynomial part p is a vector
    of coefficients and the error part e is a formal interval.

    This class implements the polynomial part as a polynomial
    from the polynomialmath library and the error part as an
    interval from the intvmath library.

    Attributes:
        poly (Polynomial) : The polynomial part
        error (Interval) : The error part
    """

    def __init__(
        self,
        coef_vector: np.ndarray,
        min_error_bound: np.float64,
        max_error_bound: np.float64,
    ) -> None:
        """Initializes a Talyor model

        A Taylor model is defined by a polynomial part and an error interval.
        The polynomial part is defined by a vector of coefficients and the
        error part is defined by a minimum and maximum error.  The coefficient
        vector is used to initialize a polynomial from polynomialmath and the
        minimum and maximum errors are used to initialize an error interval.

        Note: the Taylor model accepts coefficient vectors in descending order
        without skipping any coefficients.  This is also the way the
        coefficients will be stored in memory.

        Args:
            coef_vector (np.ndarray) : The vector of polynomial coefficients
                in descending order without skipping any coefficients
            min_error_bound (np.float64) : The minimum error bound
            max_error_bound (np.float64) : The maximum error bound

        Returns:
            None
        """
        self.poly = polynomialmath.Polynomial(coef_vector)
        self.error = intvmath.Interval(min_error_bound, max_error_bound)

    def tostr(self, indvar: str = "x") -> str:
        """Converts a Taylor model to a string

        Args:
            indvar (str = 'x') : Independent variable to use in the string

        Returns:
            taylorm_str (str) : The polynomial as a string
        """
        poly_part_str = self.poly.tostr(indvar=indvar)
        error_part_str = self.error.tostr()
        taylorm_str = "{} + {}".format(poly_part_str, error_part_str)
        return taylorm_str

    def print(self) -> None:
        """Prints a polynomial"""
        print(self.tostr())

    def copy(self) -> "TaylorModel":
        """Returns a copy of the Taylor Model using different memory

        Returns:
            taylorm_copy (TaylorModel) : The copy of the Taylor Model
        """
        taylorm_copy = TaylorModel(np.array([]), 0, 0)
        taylorm_copy.poly = self.poly.copy()
        taylorm_copy.error = self.error.copy()
        return taylorm_copy

    def evaluate_high(self, x_input: np.ndarray) -> np.ndarray:
        """Evaluates the high bound of the Taylor model

        Args:
            x_input (np.ndarray) : The input to evaluate over

        Returns:
            y_high (np.ndarray) : The high bound for the evaluation
        """
        y_high = self.poly.evaluate(x_input) + self.error.x2
        return y_high

    def evaluate_low(
        self, x_input: np.ndarray, indvar: str = "x"
    ) -> np.ndarray:
        """Evaluates the high bound of the Taylor model

        Args:
            x_input (np.ndarray) : The input to evaluate over

        Returns:
            y_high (np.ndarray) : The high bound for the evaluation
        """
        y_low = self.poly.evaluate(x_input) + self.error.x1
        return y_low

    def plot(
        self,
        x_min: np.float64,
        x_max: np.float64,
        n_points: int = 50,
        indvar: str = "x",
        figsize: tuple = (8, 6),
        ax=None,
    ) -> "matplotlib.axes._subplots.AxesSubplot":
        """Plots a Taylor model

        Returns the plot axes so new plots can be added.  For example:
        ax = t1.plot(-outer_bound, outer_bound, n_points=100)
        x = np.linspace(-outer_bound, outer_bound, 50)
        ax.plot(x, np.sin(x), color='limegreen')

        Args:
            x_min (np.float64) : The minimum of the domain to plot
            x_max (np.float64) : The maximum of the domain to plot
            n_points (int) : The number of points to plot
            indvar (str) : The independent variable
            figsize (tuple) : The size of the figure

        Returns:
           ax (matplotlib.axes._subplots.AxesSubplot) : The plot axes
        """

        x_input = np.linspace(x_min, x_max, n_points)
        y_low = self.evaluate_low(x_input)
        y_high = self.evaluate_high(x_input)

        if ax is None:
            _, ax = plt.subplots(1, 1, sharex=True, figsize=figsize)

        ax.plot()
        ax.plot(x_input, y_low, color="k")
        ax.plot(x_input, y_high, color="k")
        ax.fill_between(x_input, y_low, y_high, color="k", alpha=0.5)
        ax.set_title("T({})".format(indvar))
        ax.set_xlabel("{}".format(indvar))
        ax.grid()
        print(type(ax))

        return ax

    def __add__(taylor_a, taylor_b) -> "TaylorModel":
        """Overloads the addition operator for two Taylor models

        Args:
            taylor_a (TaylorModel) : The first Taylor model
            taylor_b (TaylorModel) : The second Taylor model

        Returns:
            taylor_result (TaylorModel): The addition of the first and second
                Taylor model
        """
        taylor_result = add_taylor_models(taylor_a, taylor_b)
        return taylor_result

    def __sub__(taylor_a, taylor_b) -> "TaylorModel":
        """Overloads the subtraction operator for two Taylor models

        Args:
            taylor_a (TaylorModel) : The first Taylor model
            taylor_b (TaylorModel) : The second Taylor model

        Returns:
            taylor_result (TaylorModel) : The difference
                taylor_a - taylor_b
        """
        taylor_result = subtract_taylor_models(taylor_a, taylor_b)
        return taylor_result

    def bound(
        self, x_min: np.float64, x_max: np.float64, n_subdomains: np.int = 16
    ) -> intvmath.Interval:
        """Bounds a Taylor model over the given domain

        Determines the range of the Taylor model as an interval over the
        given domain [x_min, x_max].  Can divide the domain into subdomains
        to make the range estimate more accurate.

        Args:
            x_min (np.float64) : The lower bound of the domain
            x_max (np.float64) : The upper bound of the domain
            n_subdomains (np.int64) : The number of subdomains to use

        Returns:
            interval_range (Interval) : The range of the Taylor model
                as an interval.
        """
        domain = intvmath.Interval(x_min, x_max)
        poly_bound = self.poly.bound_with_subdomains(domain, n_subdomains)
        interval_range = poly_bound + self.error
        return interval_range

    def bound_interval_vector(
        self,
        interval_vector: intvmath.IntervalColumnVector,
        n_subdomains: np.int = 16,
    ) -> intvmath.IntervalColumnVector:
        """Bounds a Taylor model over the given batch of domains

        Determines the range of the Taylor model as an interval over
        the list of domains elementwise.  Can divide each domain into
        subdomains to make the range estimate more accurate.

        Args:
            interval_vector (intvmath.IntervalColumnVector) :
                The vector of interval domains

        Returns:
            interval_vector_result (intvmath.IntervalColumnVector) :
                The vector of interval ranges
        """
        interval_list_result = []
        for interval in interval_vector.elems:
            bounds = self.bound(interval.x1, interval.x2, n_subdomains)
            interval_list_result.append(bounds)
        interval_vector_result = intvmath.IntervalColumnVector(
            interval_list_result
        )
        return interval_vector_result


def add_taylor_models(
    taylor_a: TaylorModel, taylor_b: TaylorModel
) -> TaylorModel:
    """Adds two Taylor models

    Args:
        taylor_a (TaylorModel) : The first Taylor model
        taylor_b (TaylorModel) : The second Taylor model

    Returns:
        taylor_result (TaylorModel) : The addition of the two Taylor models
    """
    poly_result = taylor_a.poly + taylor_b.poly
    error_result = taylor_a.error + taylor_b.error
    taylor_result = TaylorModel(
        poly_result.coef_vector, error_result.x1, error_result.x2
    )
    return taylor_result


def subtract_taylor_models(
    taylor_a: TaylorModel, taylor_b: TaylorModel
) -> TaylorModel:
    """Subtracts two Taylor models

    Args:
        taylor_a (TaylorModel) : The first Taylor model
        taylor_b (TaylorModel) : The second Taylor model

    Returns:
        taylor_result (TaylorModel) : The subtraction of Taylor model b
            from Taylor model a
    """
    poly_result = taylor_a.poly - taylor_b.poly
    error_result = taylor_a.error - taylor_b.error
    taylor_result = TaylorModel(
        poly_result.coef_vector, error_result.x1, error_result.x2
    )
    return taylor_result


def multiply_taylor_models(
    taylor_1: TaylorModel,
    taylor_2: TaylorModel,
    x_min: np.float64,
    x_max: np.float64,
    n_subdomains: np.int = 16,
) -> TaylorModel:
    """Multiplies two Taylor models

    Assumes both Taylor models are of the same order.

    The formula for Taylor model multiplication of Taylor models
    T_1 = (P_1, I_1), T_2 = (P_2, I_2) where P_1 and P_2 are polynomials
    of order N approximating some functions f_1 and f_2 within intervals
    I_1 and I_2 respectively:

    T_1 * T_2 = (P_(1*2), I_(1*2))

    P_(1*2) is the polynomial P_1 * P_2 up to order N.

    I_(1*2) = B(P_e) + B(P_1) * I_2 + B(P_2) * I_1 + I_1 * I_2

    Args:
        taylor_1 (TaylorModel) : The first Taylor model
        taylor_2 (TaylorModel) : The second Taylor model
        x_min (np.float64) : The minimum bound of the interval
        x_max (np.float64) : The maximum bound of the interval
        subdomains (np.int) : The number of subdomains to use

    Returns:
        taylor_result (TaylorModel) : The multiplication of Taylor model a
            with Taylor model b
    """
    p_1_times_2, p_error = polynomialmath.multiply_polynomials_approx(
        taylor_1.poly, taylor_2.poly
    )

    interval = intvmath.Interval(x_min, x_max)

    bound_p_error = p_error.bound_with_subdomains(interval, n_subdomains)
    bound_p1 = taylor_1.poly.bound_with_subdomains(interval, n_subdomains)
    bound_p2 = taylor_2.poly.bound_with_subdomains(interval, n_subdomains)

    interval_1_times_2 = (
        bound_p_error
        + bound_p1 * taylor_2.error
        + bound_p2 * taylor_1.error
        + taylor_1.error * taylor_2.error
    )

    taylor_result = TaylorModel(
        p_1_times_2.coef_vector, interval_1_times_2.x1, interval_1_times_2.x2
    )

    return taylor_result


def add_scalar_to_taylor_model(
    scalar: np.float64, taylor_a: TaylorModel
) -> TaylorModel:
    """Multiplies a Taylor model by a scalar

    Args:
        scalar (np.float64) : The scalar to add to the polynomial
        taylor_a (TaylorModel) : The Taylor model to be added to

    Returns:
        taylor_result (TaylorModel) : The Taylor model added to the scalar
    """
    taylor_result = taylor_a.copy()
    taylor_result.poly.coef_vector[-1] += scalar
    return taylor_result


def multiply_taylor_model_by_scalar(
    scalar: np.float64, taylor_a: TaylorModel
) -> TaylorModel:
    """Multiplies a Taylor model by a scalar

    Args:
        scalar (np.float64) : The scalar to multiply the polynomial by
        taylor_a (Polynomial) : The Taylor model to be multiplied

    Returns:
        taylor_result (TaylorModel) : The Taylor model multiplied by the scalar
    """
    taylor_result = taylor_a.copy()
    taylor_result.poly.coef_vector = taylor_result.poly.coef_vector * scalar
    taylor_result.error = intvmath.multiply_interval_by_scalar(
        scalar, taylor_a.error
    )
    return taylor_result


def pown_taylor_model(
    taylor_a: TaylorModel,
    integer_exponent: np.int,
    x_min: np.float64,
    x_max: np.float64,
    n_subdomains: np.int = 16,
) -> TaylorModel:
    """Raise a Taylor model to a positive or zero integer power

    Args:
        taylor_a (Taylor Model) : The Taylor model to raise to a power
        integer_exponent (np.int) : The positive or zero integer exponent

    Returns:
        taylor_result (TaylorModel) : The TaylorModel raised to the nth power
    """
    if integer_exponent == 0:
        taylor_result = TaylorModel(np.array([1]), 0, 0)
        return taylor_result

    taylor_result = taylor_a.copy()
    for _ in range(0, integer_exponent - 1):
        taylor_result = multiply_taylor_models(
            taylor_result, taylor_a, x_min, x_max, n_subdomains
        )
    return taylor_result


def compose_taylor_models(
    outer_taylor_f: TaylorModel,
    inner_taylor_g: TaylorModel,
    x_min: np.float64,
    x_max: np.float64,
    n_subdomains: np.int = 16,
) -> TaylorModel:
    """Composes Taylor models Tf and Tg to compute Th(x) = Tf(Tg(x))

    Args:
        outer_taylor_f (TaylorModel) : The outer Taylor model to compose
        inner_taylor_g (TaylorModel) : The inner Taylor model to compose

    Returns:
        taylor_result (TaylorModel) : The result of the composition
    """
    taylor_result = TaylorModel(np.array([0]), 0, 0)
    for _, (coef, exponent) in enumerate(
        zip(outer_taylor_f.poly.coef_vector, outer_taylor_f.poly.exp_vector)
    ):
        g_exp = pown_taylor_model(
            inner_taylor_g, exponent, x_min, x_max, n_subdomains
        )
        g_term = multiply_taylor_model_by_scalar(coef, g_exp)
        taylor_result = taylor_result + g_term
    return taylor_result
