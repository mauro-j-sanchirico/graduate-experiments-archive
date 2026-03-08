"""Module for perfoming simple verified interval arithmetic

Simplified formal interval arithmetic is defined in the IEEE standard for
Interval Arithmetic (Simplified), IEEE-17881.  This module and its functions
define a further subset of even that simplification.  The primary functions
implemented are addition, subtraction, and multiplication.  The rationale
behind this is that even highly nonlinear functions can be, when handled
correctly, turned into polynomial approximations with formal error bounds.
As such, a sequence of additions, subtractions, and multiplications can
approximate any function on a closed interval with precisely defined error
tolerances.

The Interval class implements basic interval math functions by overloading
python math operators.  The class is supported by a set of general interval
math functions defined independently.  These functions cover operations which
are not covered by the standard math operators, such as raising and interval
to an integer power, which is not the same as multiplying the interval by
itself.
"""

import numpy as np


__author__ = "Mauro J. Sanchirico III"
__copyright__ = "Copyright 2021 Mauro J. Sanchirico III"
__credits__ = ["Mauro J. Sanchirico III", "Xun Jiao", "C. Nataraj"]
__license__ = "GPL"
__version__ = "0.1"
__maintainer__ = "Mauro J. Sanchirico III"
__email__ = "msanchi1@villanova.edu"
__status__ = "Prototype"


class IntervalColumnVector:
    """Defines a column vector of intervals for manipulation

    Attributes:
        elems (list) : List of intervals (Interval)
    """

    def __init__(self, elems: list):
        """Initializes a column vector of intervals

        Args:
            elems (list) : The list of intervals to
                form the column vector, all of type Interval

        Returns:
            None
        """
        self.elems = elems

    def tostr(self) -> str:
        """Converts an interval column vector to a string

        Returns:
            interval_str (str): The interval column vector as a string
        """
        interval_vector_str = "[\n"

        for element in self.elems:
            interval_str = element.tostr()
            interval_vector_str += "  {}\n".format(interval_str)

        interval_vector_str += "]"
        return interval_vector_str

    def print(self) -> None:
        """Prints an interval"""
        print(self.tostr())

    def copy(self) -> "IntervalColumnVector":
        """Returns a copy of the Interval using different memory

        Returns:
            interval_vector_copy (Interval) : The copy of the interval
        """
        interval_list = []

        for element in self.elems:
            interval_list.append(element.copy())

        interval_vector_copy = IntervalColumnVector(interval_list)

        return interval_vector_copy

    def __add__(
        interval_vector_a, interval_vector_b
    ) -> "IntervalColumnVector":
        """Overloads the addition operator for interval column vectors

        Args:
            interval_vector_a (IntervalColumnVector) :
                The first interval vector
            interval_vector_b (IntervalColumnVector) :
                The second interval vector

        Returns:
            interval_vector_result (IntervalColumnVector) :
                The addition of the two interval vector operands
        """
        interval_vector_result = add_interval_column_vectors(
            interval_vector_a, interval_vector_b
        )
        return interval_vector_result

    def __sub__(
        interval_vector_a, interval_vector_b
    ) -> "IntervalColumnVector":
        """Overloads the subtraction operator for interval column vectors

        Args:
            interval_vector_a (IntervalColumnVector) :
                The first interval vector
            interval_vector_b (IntervalColumnVector) :
                The second interval vector

        Returns:
            interval_vector_result (IntervalColumnVector) :
                The subtraction of the two interval vector operands
        """
        interval_vector_result = subtract_interval_column_vectors(
            interval_vector_a, interval_vector_b
        )
        return interval_vector_result

    def __mul__(interval_vector_a, interval_vector_b):
        """Overloads the multiplication operator for interval column vectors

        Args:
            interval_vector_a (IntervalColumnVector) :
                The first interval vector
            interval_vector_b (IntervalColumnVector) :
                The second interval vector

        Returns:
            interval_vector_result (IntervalColumnVector) :
                The subtraction of the two interval operands
        """
        interval_vector_result = multiply_interval_column_vectors(
            interval_vector_a, interval_vector_b
        )
        return interval_vector_result


def add_interval_column_vectors(
    interval_vector_a: IntervalColumnVector,
    interval_vector_b: IntervalColumnVector,
) -> IntervalColumnVector:
    """Adds two interval column vectors via interval arithmetic

    Does not perform any checking to make sure the two vectors are
    the same lenght.  Look before you leap!

    Args:
        interval_vector_a (IntervalColumnVector) : The first interval vector
        interval_vector_b (IntervalColumnVector) : The second interval vector

    Returns:
        interval_vector_result (IntervalColumnVector) :
            The addition of the two interval vector operands
    """
    elem_r_list = []
    for (elem_a, elem_b) in zip(
        interval_vector_a.elems, interval_vector_b.elems
    ):
        elem_r = elem_a + elem_b
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def add_scalar_to_interval_column_vector(
    scalar: np.float64, interval_vector: IntervalColumnVector
) -> IntervalColumnVector:
    """Add a scalar to an interval column vector

    Args:
        scalar (np.float64) : The scalar to add to the interval
        interval_vector (IntervalColumnVector) : The interval column vector

    Returns:
        interval_result (IntervalColumnVector) : The result of adding the
            scalar and the interval
    """
    elem_r_list = []
    for elem in interval_vector.elems:
        elem_r = add_scalar_to_interval(scalar, elem)
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def add_real_vector_to_interval_column_vector(
    vector: np.ndarray, interval_vector: IntervalColumnVector
) -> IntervalColumnVector:
    """Adds an interval column vector to a real vector

    Args:
        vector (np.ndarray) : The vector of real numbers
        interval_vector (IntervalColumnVector) : The interval vector

    Returns:
        interval_result (IntervalColumnVector) : The result of the
            addition
    """
    elem_r_list = []
    for (scalar, interval) in zip(vector, interval_vector.elems):
        elem_r = add_scalar_to_interval(scalar, interval)
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def subtract_interval_column_vectors(
    interval_vector_a: IntervalColumnVector,
    interval_vector_b: IntervalColumnVector,
) -> IntervalColumnVector:
    """Subtracts two interval column vectors

    Does not perform any checking to make sure the two vectors are
    the same lenght.  Look before you leap!

    Args:
        interval_vector_a (IntervalColumnVector) : The first interval vector
        interval_vector_b (IntervalColumnVector) : The second interval vector

    Returns:
        interval_vector_result (IntervalColumnVector) : The subtraction of
            the two interval operands
    """
    elem_r_list = []
    for (elem_a, elem_b) in zip(
        interval_vector_a.elems, interval_vector_b.elems
    ):
        elem_r = elem_a - elem_b
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def subtract_scalar_from_interval_column_vector(
    interval_vector: IntervalColumnVector, scalar: np.float64
) -> IntervalColumnVector:
    """Subtracts a scalar from an interval column vector

    Args:
        interval_vector (IntervalColumnVector) : The interval vector
        scalar (np.float64) : The scalar to subtract from the interval vector

    Returns:
        interval_vector_result (Interval) : The result of the subtraction
    """
    elem_r_list = []
    for elem in interval_vector.elems:
        elem_r = subtract_scalar_from_interval(elem, scalar)
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def subtract_interval_column_vector_from_scalar(
    scalar: np.float64, interval_vector: IntervalColumnVector
) -> IntervalColumnVector:
    """Subtracts a scalar from an interval

    Args:
        scalar (np.float64) : The scalar to subtract from the interval
        interval_vector (IntervalColumnVector) : The interval vector

    Returns:
        interval_vector_result (Interval) : The result of the subtraction
    """
    elem_r_list = []
    for elem in interval_vector.elems:
        elem_r = subtract_interval_from_scalar(scalar, elem)
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def multiply_interval_column_vectors(
    interval_vector_a: IntervalColumnVector,
    interval_vector_b: IntervalColumnVector,
) -> IntervalColumnVector:
    """Multiplies two interval vectors via interval arithmetic

    Multiplication is performed elementwise; i.e. the dot product of
    the interval column vectors is taken.

    Does not perform any checking to make sure the two vectors are
    the same lenght.  Look before you leap!

    Args:
        interval_vector_a (IntervalColumnVector) : The first interval vector
        interval_vector_b (IntervalColumnVector) : The second interval vector

    Returns:
        interval_vector_result (IntervalColumnVector) :
            The product of the two interval vector operands
    """
    elem_r_list = []
    for (elem_a, elem_b) in zip(
        interval_vector_a.elems, interval_vector_b.elems
    ):
        elem_r = elem_a * elem_b
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def multiply_interval_column_vector_by_scalar(
    scalar: np.float64, interval_vector: IntervalColumnVector
) -> IntervalColumnVector:
    """Multiplies an interval column vector by a scalar

    Args:
        scalar (np.float64) : The scalar to multiply the interval vector by
        interval (IntervalColumnVector) : The interval vector to be multiplied

    Returns:
        interval_result (IntervalColumnVector) : The interval vector
            multiplied by the scalar
    """
    elem_r_list = []
    for elem in interval_vector.elems:
        elem_r = multiply_interval_by_scalar(scalar, elem)
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def multiply_interval_column_vector_by_real_vector(
    vector: np.ndarray, interval_vector: IntervalColumnVector
) -> IntervalColumnVector:
    """Multiplies an interval column vector by a real vector

    Args:
        vector (np.ndarray) : The vector of real numbers
        interval_vector (IntervalColumnVector) : The interval vector

    Returns:
        interval_result (IntervalColumnVector) : The result of the
            multiplication
    """
    elem_r_list = []
    for (scalar, interval) in zip(vector, interval_vector.elems):
        elem_r = multiply_interval_by_scalar(scalar, interval)
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


def sum_interval_column_vector(
    interval_vector: IntervalColumnVector,
) -> IntervalColumnVector:
    """Computes the sum of the interval column vector

    Args:
        interval_vector (np.ndarray) : The interval vector

    Returns:
        interval_sum (Interval) : The resulting interval sum
    """
    interval_sum = Interval(0, 0)
    for elem in interval_vector.elems:
        interval_sum = interval_sum + elem
    return interval_sum


def left_multiply_interval_column_vector_by_matrix(
    matrix: np.ndarray, interval_vector: IntervalColumnVector
) -> IntervalColumnVector:
    """Left multiplies an interval vector by a matrix

    Does not perform any checking on the size of the matrix or vector.
    Look before you leap!

    Args:
        matrix (np.array) : The matrix multiplicand
        interval_vector (IntervalColumnVector) : The interval multiplicand

    Returns:
        interval_vector_result (IntervalColumnVector) : The result of the
            multiplication
    """
    interval_list = []
    for row_vector in matrix:
        dot_product_interval_vector = (
            multiply_interval_column_vector_by_real_vector(
                row_vector, interval_vector
            )
        )
        result_elem = sum_interval_column_vector(dot_product_interval_vector)
        interval_list.append(result_elem)
    interval_vector_result = IntervalColumnVector(interval_list)
    return interval_vector_result


def pown_interval_column_vector(
    interval_vector: IntervalColumnVector, integer_exponent: np.int
) -> IntervalColumnVector:
    """Raise an interval column vector to a positive integer power

    Iterates through the elements of the vector and raises each to
    the given integer power.

    Raises an interval column vector to an integer power, treating even
    and odd exponents sepparately to account for critical points in even
    exponents.

    Args:
        interval_vector (IntervalColumnVector) : The interval to raise
            to a power
        integer_exponent (np.int) : The positive integer exponent

    Returns:
        interval_vector_result (Interval) : The interval raised to the
            nth power
    """
    elem_r_list = []
    for elem in interval_vector.elems:
        elem_r = pown_interval(elem, integer_exponent)
        elem_r_list.append(elem_r)
    interval_vector_result = IntervalColumnVector(elem_r_list)
    return interval_vector_result


class Interval:
    """Defines an interval for performing formal interval arithmetic

    Note that an upper and lower bound of the interval are defined as class
    attributes.  Further note that no checking is performed to ensure that x2
    is greater than x1 even though this should always be true.  This is done
    for speed since these functions are intended to be used in speed critical
    code.  Look before you leap if you don't trust that x1 is less than x2!

    Attributes:
        x1 (np.int) : The lower bound of the interval
        x2 (np.int) : The upper bound of the interval
    """

    def __init__(self, x1: np.float64, x2: np.float64) -> None:
        """Initializes an interval

        An interval the set of all floating point numbers between two
        floating point numbers, x1 and x2, which define the lower
        and upper bound respectively.

        Args:
            x1 (np.float64) : The lower bound
            x2 (np.float64) : The upper bound

        Returns:
            None
        """
        self.x1 = x1
        self.x2 = x2

    def tostr(self) -> str:
        """Converts an interval to a string

        Returns:
            interval_str (str): The interval as a string
        """
        interval_str = "[{}, {}]".format(self.x1, self.x2)
        return interval_str

    def print(self) -> None:
        """Prints an interval"""
        print(self.tostr())

    def copy(self) -> "Interval":
        """Returns a copy of the Interval using different memory

        Returns:
            interval_copy (Interval) : The copy of the interval
        """
        interval_copy = Interval(0, 0)
        interval_copy.x1 = self.x1
        interval_copy.x2 = self.x2
        return interval_copy

    def __add__(interval_a, interval_b):
        """Adds two intervals via interval arithmetic

        Args:
            interval_a (Interval) : The first interval
            interval_b (Interval) : The second interval

        Returns:
            interval_result (Interval) : The addition of the two interval
                operands
        """
        interval_result = add_intervals(interval_a, interval_b)
        return interval_result

    def __sub__(interval_a, interval_b):
        """Overloads the subtraction operator for intervals

        Args:
            interval_a (Interval) : The first interval
            interval_b (Interval) : The second interval

        Returns:
            interval_result (Interval) : The subtraction of the two interval
                operands
        """
        interval_result = subtract_intervals(interval_a, interval_b)
        return interval_result

    def __mul__(interval_a, interval_b):
        """Overloads the multiplication operator for intervals

        Args:
            interval_a (Interval) : The first interval
            interval_b (Interval) : The second interval

        Returns:
            interval_result (Interval) : The product of the two interval
                operands
        """
        interval_result = multiply_intervals(interval_a, interval_b)
        return interval_result

    def subdivide(self, n_subdivisions: np.int):
        """Subdivides an interval into n equally spaced subdomains

        Args:
            n_subdivisions (np.int) : The number of subdomains desired

        Returns:
            subintervals_list (list) : List of intervals
        """
        bounds = np.linspace(self.x1, self.x2, n_subdivisions + 1)
        interval_list = []
        for idx in range(n_subdivisions):
            interval = Interval(bounds[idx], bounds[idx + 1])
            interval_list.append(interval)
        return interval_list


def add_intervals(interval_a: Interval, interval_b: Interval) -> Interval:
    """Adds two intervals via interval arithmetic

    Args:
        interval_a (Interval) : The first interval
        interval_b (Interval) : The second interval

    Returns:
        interval_result (Interval) : The addition of the two interval operands
    """
    interval_result = Interval(0.0, 0.0)
    interval_result.x1 = interval_a.x1 + interval_b.x1
    interval_result.x2 = interval_a.x2 + interval_b.x2
    return interval_result


def add_scalar_to_interval(scalar: np.float64, interval: Interval) -> Interval:
    """Add a scalar to an interval

    Args:
        scalar (np.float64) : The scalar to add to the interval
        interval (Interval) : The interval

    Returns:
        interval_result (Interval) : The result of adding the scalar and the
            interval
    """
    interval_result = Interval(0.0, 0.0)
    interval_from_scalar = Interval(scalar, scalar)
    interval_result = interval_from_scalar + interval
    return interval_result


def subtract_intervals(interval_a: Interval, interval_b: Interval) -> Interval:
    """Subtracts two intervals via interval arithmetic

    Args:
        interval_a (Interval) : The first interval
        interval_b (Interval) : The second interval

    Returns:
        interval_result (Interval) : The subtraction of the two interval
            operands
    """
    interval_result = Interval(0.0, 0.0)
    interval_result.x1 = interval_a.x1 - interval_b.x2
    interval_result.x2 = interval_a.x2 - interval_b.x1
    return interval_result


def subtract_scalar_from_interval(
    interval: Interval, scalar: np.float64
) -> Interval:
    """Subtracts a scalar from an interval

    Args:
        interval (Interval) : The interval
        scalar (np.float64) : The scalar to subtract from the interval

    Returns:
        interval_result (Interval) : The result of the subtraction
    """
    interval_result = Interval(0.0, 0.0)
    interval_result.x1 = interval.x1 - scalar
    interval_result.x2 = interval.x2 - scalar
    return interval_result


def subtract_interval_from_scalar(
    scalar: np.float64, interval: Interval
) -> Interval:
    """Subtracts a scalar from an interval

    Args:
        scalar (np.float64) : The scalar to subtract from the interval
        interval (Interval) : The interval

    Returns:
        interval_result (Interval) : The result of the subtraction
    """
    interval_result = Interval(0.0, 0.0)
    interval_result.x1 = scalar - interval.x2
    interval_result.x2 = scalar - interval.x1
    return interval_result


def multiply_intervals(interval_a: Interval, interval_b: Interval) -> Interval:
    """Multiplies two intervals via interval arithmetic

    Args:
        interval_a (Interval) : The first interval
        interval_b (Interval) : The second interval

    Returns:
        interval_result (Interval) : The product of the two interval operands
    """
    interval_result = Interval(0.0, 0.0)
    x1_result_candidate1 = interval_a.x1 * interval_b.x1
    x1_result_candidate2 = interval_a.x1 * interval_b.x2
    x1_result_candidate3 = interval_a.x2 * interval_b.x1
    x1_result_candidate4 = interval_a.x2 * interval_b.x2

    interval_result.x1 = min(
        x1_result_candidate1,
        x1_result_candidate2,
        x1_result_candidate3,
        x1_result_candidate4,
    )

    interval_result.x2 = max(
        x1_result_candidate1,
        x1_result_candidate2,
        x1_result_candidate3,
        x1_result_candidate4,
    )

    return interval_result


def multiply_interval_by_scalar(
    scalar: np.float64, interval: Interval
) -> Interval:
    """Multiplies an interval by a scalar

    Args:
        scalar (np.float64) : The scalar to multiply the interval by
        interval (Interval) : The interval to be multiplied

    Returns:
        interval_result (Interval) : The interval multiplied by the scalar
    """
    interval_result = Interval(0.0, 0.0)
    interval_from_scalar = Interval(scalar, scalar)

    interval_result = interval_from_scalar * interval

    return interval_result


def pown_even_interval(
    interval: Interval, integer_exponent_even: np.int
) -> Interval:
    """Raise an interval to an even positive integer power

    Raises an interval to an even integer power.  Does not perform any
    checking to make sure the power is actually even.  Look before you leap!
    Note that even integer powers of intervals have to be handled with care.
    A different algorithm must be used to perform even integer exponentiation
    vs. odd integer exponentiation.

    Args:
        interval (Interval) : The interval to raise to an even power
        integer_exponent_even (np.int) : The even positive integer exponent

    Returns:
        interval_result (Interval) : The interval raised to the even power
    """
    interval_result = Interval(0.0, 0.0)

    if interval.x1 < 0:
        if interval.x2 < 0:
            interval_result.x1 = interval.x2 ** integer_exponent_even
            interval_result.x2 = interval.x1 ** integer_exponent_even

        elif interval.x2 == 0:
            interval_result.x1 = 0
            interval_result.x2 = interval.x1 ** integer_exponent_even

        elif interval.x2 > 0:
            interval_result.x1 = 0
            interval_result.x2 = max(
                interval.x1 ** integer_exponent_even,
                interval.x2 ** integer_exponent_even,
            )

    elif interval.x1 == 0:
        if interval.x2 == 0:
            interval_result.x1 = 0
            interval_result.x2 = 0

        elif interval.x2 > 0:
            interval_result.x1 = 0
            interval_result.x2 = interval.x2 ** integer_exponent_even

    elif interval.x1 > 0:
        if interval.x2 > 0:
            interval_result.x1 = interval.x1 ** integer_exponent_even
            interval_result.x2 = interval.x2 ** integer_exponent_even

    return interval_result


def pown_odd_interval(
    interval: Interval, integer_exponent_odd: np.int
) -> Interval:
    """Raise an interval to an odd positive integer power

    Raises an interval to an odd integer power.  Does not perform any checking
    to make sure the power is actually odd.  Look before you leap!

    Args:
        interval (Interval) : The interval to raise to an odd power
        integer_exponent_odd (np.int) : The odd positive integer exponent

    Returns:
        interval_result (Interval) : The interval raised to the odd power
    """
    interval_result = Interval(0.0, 0.0)

    interval_result.x1 = interval.x1 ** integer_exponent_odd
    interval_result.x2 = interval.x2 ** integer_exponent_odd

    return interval_result


def pown_interval(interval: Interval, integer_exponent: np.int) -> Interval:
    """Raise an interval to a positive integer power

    Raises an interval to an integer power, treating even and odd
    exponents sepparately to account for critical points in even
    exponents.

    Args:
        interval (Interval) : The interval to raise to a power
        integer_exponent (np.int) : The positive integer exponent

    Returns:
        interval_result (Interval) : The interval raised to the nth power
    """
    interval_result = Interval(0.0, 0.0)

    integer_exponent_is_zero = integer_exponent == 0

    if integer_exponent_is_zero:
        interval_result = Interval(1, 1)
    else:
        integer_exponent_is_even = (integer_exponent % 2) == 0
        if integer_exponent_is_even:
            interval_result = pown_even_interval(interval, integer_exponent)
        else:
            interval_result = pown_odd_interval(interval, integer_exponent)

    return interval_result


def bound_intervals(interval_list: list) -> Interval:
    """Returns the bounds which include all intervals in the list

    The lower bound is the minimum low bound of all the intervals
    and the upper bound is the maximum high bound of all the intervals
    the result is a new interval with the given low bound and high
    bound.

    Args:
        interval_list (list) : List of intervals

    Returns:
        interval_result (Interval) : The bounding interval
    """
    min_x1 = np.inf
    max_x2 = -np.inf

    for interval in interval_list:
        if interval.x1 < min_x1:
            min_x1 = interval.x1
        if interval.x2 > max_x2:
            max_x2 = interval.x2

    interval_result = Interval(min_x1, max_x2)

    return interval_result
