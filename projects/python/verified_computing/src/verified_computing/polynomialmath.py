"""Defines a Polynomial class and functions for operating on polynomials

Standard basic operations such as addition, subtraction, and multiplication
are supported along with non-standard operations such as integer
exponentiation, composition, approximate multiplication, approximate
integer exponentiation, and approximate composition.  The approximate
operations are performed by truncating the result and keeping track of
the remainder polynomial.  Operations for bounding polynomials using
interval arithmetic and for keeping track of the bounds of remainders in
approximate computations on polynomials are provided.
"""


import numpy as np

from verified_computing import intvmath


__author__ = "Mauro J. Sanchirico III"
__copyright__ = "Copyright 2021 Mauro J. Sanchirico III"
__credits__ = ["Mauro J. Sanchirico III", "Xun Jiao", "C. Nataraj"]
__license__ = "GPL"
__version__ = "0.1"
__maintainer__ = "Mauro J. Sanchirico III"
__email__ = "msanchi1@villanova.edu"
__status__ = "Prototype"


class Polynomial:
    """Defines a polynomial as a vector of coefficients

    Coefficient vectors are stored in descending order without skipping
    any coefficients.  There is an exponent vector stored with the
    coefficient vector however it is only stored for convienience when
    performing evaluations and other operations which require indexing
    the coefficients.

    Attributes:
        coef_vector (np.ndarray) : Vector of coefficients in descending order
        exp_vector (np.ndarray) : Vector of exponents for convienience
    """

    def __init__(self, coef_vector: np.ndarray = np.array([0])) -> None:
        """Initializes a polynomial

        A polynomial is defined by a vector of coefficients.  A vector of
        exponents is precomputed and stored for convienience.

        The vector of coefficients must be provided in descending order
        with no values skipped.  A vector of exponents is stored with the
        coefficient vector for convienience.

        Args:
            coef_vector (np.ndarray) : The vector of coefficients in
                descending order with no values skipped

        Returns:
            None
        """
        self.n_coefs = coef_vector.shape[0]
        self.coef_vector = coef_vector
        self.exp_vector = np.arange(self.n_coefs - 1, -1, step=-1)

    def _get_str_representation_for_no_coefs(self) -> str:
        """Gets a string for an empty polynomial

        Returns:
            poly_str (str) : The string representing the empty polynomial
        """
        poly_str = ""
        return poly_str

    def _get_str_representation_for_one_coef(self) -> str:
        """Gets a string for a single constant coefficient polynomial

        Returns:
            poly_str (str) : The single coefficient polynomial as a string
        """
        poly_str = "{}".format(self.coef_vector[0])
        return poly_str

    def _get_str_representation_for_multi_coef(self, indvar: str = "x") -> str:
        """Gets a string representation for a multi-coefficient polynomial

        Args:
            indvar (str) : The independent variable as a string

        Returns:
            poly_str (str) : The polynomial string
        """
        poly_str = ""
        nonzero_previous_coefs = False

        # If there are many coefficients, loop through the terms
        for idx, (coef, exponent) in enumerate(
            zip(self.coef_vector, self.exp_vector)
        ):

            # Get the sign string
            if coef < 0:
                if idx > 0 and nonzero_previous_coefs:
                    sign_str = "- "
                else:
                    sign_str = "-"
                nonzero_previous_coefs = True
            elif coef > 0:
                if idx > 0 and nonzero_previous_coefs:
                    sign_str = "+ "
                else:
                    sign_str = ""
                nonzero_previous_coefs = True
            else:
                sign_str = ""

            # Get a string for the coefficient and the multiplication sign
            if abs(coef) == 1 or abs(coef) == 0:
                coef_str = ""
                mult_str = ""
            else:
                coef_str = "{}".format(abs(coef))
                mult_str = "*"

            # Construct the term string based on the sign, multiplication and
            # coefficient strings
            if abs(coef) == 0:
                term_str = ""
            else:
                if exponent == 0:
                    term_str = " {}{}".format(sign_str, abs(coef))
                elif exponent == 1:
                    term_str = " {}{}{}{}".format(
                        sign_str, coef_str, mult_str, indvar
                    )
                else:
                    term_str = " {}{}{}{}^{}".format(
                        sign_str, coef_str, mult_str, indvar, exponent
                    )

            poly_str = poly_str + term_str

        return poly_str

    def tostr(self, indvar: str = "x") -> str:
        """Converts a polynomial to a string

        Args:
            indvar (str = 'x') : Independent variable to use in the string

        Returns:
            poly_str (str) : The polynomial as a string
        """
        if self.n_coefs == 0:
            poly_str = self._get_str_representation_for_no_coefs()
        elif self.n_coefs == 1:
            poly_str = self._get_str_representation_for_one_coef()
        else:
            poly_str = self._get_str_representation_for_multi_coef(indvar)

        return poly_str

    def print(self) -> None:
        """Prints a polynomial"""
        print(self.tostr())

    def copy(self) -> "Polynomial":
        """Returns a copy of the Polynomial using different memory

        Returns:
            polynomial_copy (Polynomial) : The copy of the polynomial
        """
        polynomial_copy = Polynomial()
        polynomial_copy.n_coefs = self.n_coefs
        polynomial_copy.coef_vector = self.coef_vector.copy()
        polynomial_copy.exp_vector = self.exp_vector.copy()
        return polynomial_copy

    def __add__(polynomial_a, polynomial_b):
        """Overloads the addition operator for two polynomials

        Args:
            polynomial_a (Polynomial) : The first polynomial
            polynomial_b (Polynomial) : The second polynomial

        Returns:
            polynomial_result (Polynomial): The addition of the first and second
                polynomial
        """
        polynomial_result = add_polynomials(polynomial_a, polynomial_b)
        return polynomial_result

    def __sub__(polynomial_a, polynomial_b):
        """Overloads the subtraction operator for two polynomials

        Args:
            polynomial_a (Polynomial) : The first polynomial
            polynomial_b (Polynomial) : The second polynomial

        Returns:
            polynomial_result (Polynomial) : The difference
                polynomial_a - polynomial_b
        """
        polynomial_result = subtract_polynomials(polynomial_a, polynomial_b)
        return polynomial_result

    def __mul__(polynomial_a, polynomial_b):
        """Overloads the multiplication operator for two polynomials

        Args:
            polynomial_a (Polynomial) : The first polynomial
            polynomial_b (Polynomial) : The second polynomial

        Returns:
            polynomial_result (Polynomial) : The multiplication of the
                two polynomials
        """
        polynomial_result = multiply_polynomials(polynomial_a, polynomial_b)
        return polynomial_result

    def evaluate(self, x_input: np.float64):
        """Evaluates a polynomial

        Args:
            x_input (np.float64) : The input to be evaluated

        Returns:
            y_output (np.float64) : The output result
        """
        y_output = np.polyval(self.coef_vector, x_input)
        return y_output

    def bound(self, interval: intvmath.Interval):
        """Computes the bounds for the polynomial over the given interval

        Note that when using the basic bounding function the bounds will usually
        be overestimated.  For a tight bound, it is recomended to use the
        bound_with_subdomains function.

        Args:
            interval (Interval) : The interval over which the bound is desired

        Returns:
            interval_result (Interval) : The bounds of the polynomial
        """
        interval_result = intvmath.Interval(0, 0)
        for (coef, exponent) in zip(
            self.coef_vector[:-1], self.exp_vector[:-1]
        ):
            interval_exp = intvmath.pown_interval(interval, exponent)
            term_interval = intvmath.multiply_interval_by_scalar(
                coef, interval_exp
            )
            interval_result = interval_result + term_interval
        interval_result = intvmath.add_scalar_to_interval(
            self.coef_vector[-1], interval_result
        )
        return interval_result

    def bound_with_subdomains(
        self, interval: intvmath.Interval, n_subdomains: np.int = 16
    ):
        """Use subdomains to get a tight bound on the polynomial

        Args:
            interval (Interval) : The interval over which the bound is desired
            subdomains (np.int) : The number of subdomains to use

        Returns:
            interval_result (Interval) : The bounds of the polynomial
        """
        subintervals = interval.subdivide(n_subdomains)
        subinterval_ranges = []

        # Evaluate the polynomial on each subdomain
        for subinterval in subintervals:
            subinterval_range = self.bound(subinterval)
            subinterval_ranges.append(subinterval_range)

        # The resulting interval is bounded by the minimum of the minimum
        # bound of each subdomain and the maximum of the maximum bound of
        # each subdomain
        interval_result = intvmath.bound_intervals(subinterval_ranges)

        return interval_result


def add_polynomials(
    polynomial_a: Polynomial, polynomial_b: Polynomial
) -> Polynomial:
    """Adds two polynomials

    Args:
        polynomial_a (Polynomial) : The first polynomial
        polynomial_b (Polynomial) : The second polynomial

    Returns:
        polynomial_result (Polynomial) : The addition of the two polynomials
    """
    if polynomial_a.n_coefs > polynomial_b.n_coefs:
        n_extra_coefs = polynomial_a.n_coefs - polynomial_b.n_coefs
        polynomial_b_extra_coefs = np.zeros(n_extra_coefs)
        polynomial_b_concat_coef_vector = np.hstack(
            [polynomial_b_extra_coefs, polynomial_b.coef_vector]
        )
        polynomial_result_coefs = (
            polynomial_a.coef_vector + polynomial_b_concat_coef_vector
        )

    elif polynomial_a.n_coefs < polynomial_b.n_coefs:
        n_extra_coefs = polynomial_b.n_coefs - polynomial_a.n_coefs
        polynomial_a_extra_coefs = np.zeros(n_extra_coefs)
        polynomial_a_concat_coef_vector = np.hstack(
            [polynomial_a_extra_coefs, polynomial_a.coef_vector]
        )
        polynomial_result_coefs = (
            polynomial_a_concat_coef_vector + polynomial_b.coef_vector
        )

    else:
        polynomial_result_coefs = (
            polynomial_a.coef_vector + polynomial_b.coef_vector
        )

    polynomial_result = Polynomial(polynomial_result_coefs)

    return polynomial_result


def subtract_polynomials(
    polynomial_a: Polynomial, polynomial_b: Polynomial
) -> Polynomial:
    """Subtracts two polynomials

    Args:
        polynomial_a (Polynomial) : The first polynomial
        polynomial_b (Polynomial) : The second polynomial

    Returns:
        polynomial_result (Polynomial) : The subtraction of
            polynomial b from polynomial a
    """
    negative_unity_polynomial = Polynomial(np.array([-1]))
    polynomial_b_times_negative_unity = multiply_polynomials(
        negative_unity_polynomial, polynomial_b
    )
    polynomial_result = add_polynomials(
        polynomial_a, polynomial_b_times_negative_unity
    )
    return polynomial_result


def multiply_polynomials(
    polynomial_a: Polynomial, polynomial_b: Polynomial
) -> Polynomial:
    """Subtracts two polynomials

    Args:
        polynomial_a (Polynomial): The first polynomial
        polynomial_b (Polynomial): The second polynomial

    Returns:
        polynomial_result (Polynomial): The product of the two polynomials
    """
    polynomial_result_coefs = np.convolve(
        polynomial_a.coef_vector, polynomial_b.coef_vector
    )
    polynomial_result = Polynomial(polynomial_result_coefs)
    return polynomial_result


def multiply_polynomials_approx(
    polynomial_a: Polynomial, polynomial_b: Polynomial
) -> tuple:
    """Multiplies two polynomials while preserving the order of polynomial_a

    Multiplies polynomial_a with polynomial_b and then truncates the result
    to be the same order as polynomial_a.  The polynomial part of the result
    that is truncated is returned along with the approximate truncated result.

    The return tuple is of the form:
    (polynomial_approx_result, polynomial_remainder).

    Args:
        polynomial_a (Polynomial) : The first polynomial
        polynomial_b (Polynomial) : The second polynomial

    Returns:
        (polynomial_result, polynomial_remainder) (tuple) : The result
            sepparated into approximate and remainder terms
    """
    n_terms = polynomial_a.n_coefs
    exact_result = polynomial_a * polynomial_b
    polynomial_result_coefs = exact_result.coef_vector[-n_terms:]
    polynomial_remainder_coefs = exact_result.coef_vector[:-n_terms]
    zero_vector = np.zeros(polynomial_result_coefs.shape[0])
    polynomial_remainder_coefs = np.hstack(
        (polynomial_remainder_coefs, zero_vector)
    )
    polynomial_result = Polynomial(polynomial_result_coefs)
    polynomial_remainder = Polynomial(polynomial_remainder_coefs)
    return (polynomial_result, polynomial_remainder)


def multiply_polynomials_approx_and_bound(
    polynomial_a: Polynomial,
    polynomial_b: Polynomial,
    interval: intvmath.Interval,
    n_subdomains: np.int = 16,
) -> tuple:
    """Multiplies two polynomials approximately and bounds the remainder

    Multiplies polynomial_a with polynomial_b and then truncates the result
    to be the same order as polynomial_a.  The remainder term is bounded
    using the given number of subdomains.

    The return tuple is of the form:
    (polynomial_result, polynomial remainder, bounds)

    Args:
        polynomial_a (Polynomial) : The first polynomial
        polynomial_b (Polynomial) : The second polynomial
        interval (Interval) : The interval over which the bound is desired
        subdomains (np.int) : The number of subdomains to use

    Returns:
        (polynomial_result,
         polynomial_remainder,
         bounds) (tuple) : The result sepparated into approximate and
             remainder terms with a bound computed for the remainder term
    """
    polynomial_result, polynomial_remainder = multiply_polynomials_approx(
        polynomial_a, polynomial_b
    )
    bounds = polynomial_remainder.bound_with_subdomains(interval, n_subdomains)
    return (polynomial_result, polynomial_remainder, bounds)


def add_scalar_to_polynomial(
    scalar: np.float64, polynomial_a: Polynomial
) -> Polynomial:
    """Multiplies a polynomial by a scalar

    Args:
        scalar (np.float64) : The scalar to add to the polynomial
        polynomial_a (Polynomial) : The polynomial to be added to

    Returns:
        polynomial_result (Polynomial) : The polynomial added to the scalar
    """
    polynomial_result = polynomial_a.copy()
    polynomial_result.coef_vector[-1] += scalar
    return polynomial_result


def multiply_polynomial_by_scalar(
    scalar: np.float64, polynomial_a: Polynomial
) -> Polynomial:
    """Multiplies a polynomial by a scalar

    Args:
        scalar (np.float64) : The scalar to multiply the polynomial by
        polynomial_a (Polynomial) : The polynomial to be multiplied

    Returns:
        polynomial_result (Polynomial) : The polynomial multiplied by the scalar
    """
    polynomial_result = polynomial_a.copy()
    polynomial_result.coef_vector = polynomial_result.coef_vector * scalar
    return polynomial_result


def pown_polynomial(
    polynomial_a: Polynomial, integer_exponent: np.int
) -> Polynomial:
    """Raise a polynomial to a positive or zero integer power

    Args:
        polynomial (Polynomial) : The polynomial to raise to a power
        integer_exponent (np.int) : The positive or zero integer exponent

    Returns:
        polynomial_result (Polynomial) : The polynomial raised to the nth power
    """
    if integer_exponent == 0:
        polynomial_result = Polynomial(np.array([1]))
        return polynomial_result

    polynomial_result = polynomial_a
    for _ in range(0, integer_exponent - 1):
        polynomial_result = polynomial_result * polynomial_a
    return polynomial_result


def compose_polynomials(
    outer_polynomial_f: Polynomial, inner_polynomial_g: Polynomial
) -> Polynomial:
    """Composes polynomials f and g to compute h(x) = f(g(x))

    Args:
        outer_polynomial_f (Polynomial) : The outer polynomial to compose
        inner_polynomial_g (Polynomial) : The inner polynomial to compose

    Returns:
        polynomial_result (Polynomial) : The result of the composition
    """
    polynomial_result = Polynomial(np.array([0]))
    for _, (coef, exponent) in enumerate(
        zip(outer_polynomial_f.coef_vector, outer_polynomial_f.exp_vector)
    ):
        g_exp = pown_polynomial(inner_polynomial_g, exponent)
        g_term = multiply_polynomial_by_scalar(coef, g_exp)
        polynomial_result = polynomial_result + g_term
    return polynomial_result
