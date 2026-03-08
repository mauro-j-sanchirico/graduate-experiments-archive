from datetime import datetime
import numpy as np
from sympy.ntheory.multinomial import multinomial_coefficients
from mpmath import mp, mpf
import pickle


##
# Utility Functions
#
def get_dated_filename(filename):
    # datetime object containing current date and time
    now = datetime.now()
    dt_str = now.strftime("%Y-%m-%d_%H-%M-%S-%f")
    filename = filename + '_' + dt_str + '.pickle'
    return filename


##
# Basic Multinomial Functions
#
def compute_multiexponent(x, kappa):
    """Computes the multiexponent x^kappa"""
    return np.prod(x ** kappa)


def compute_batch_multiexponent(x, kappa):
    """Computes multiexponent for an array
    
    Params:
    x -- (array of floats) rows are samples and columns are states
    kappa -- (tuple of ints) tuple of exponents
    
    Returns:
    y -- (array) x^k where k is a multiexponent
    """
    return np.prod(x ** kappa, axis=1)


def compute_batch_multinomial_sum(x, coefs):
    """Computes a batch multinomial sum over an array"""
    nrows, ncols = x.shape
    summation = np.zeros((nrows,))

    # Add a row for the input bias
    b = np.ones((nrows,1))
    x = np.hstack((x,b))

    for k, mc in coefs.items():
        summation = summation + mc*compute_batch_multiexponent(x, k)
    
    return summation


##
# Core Multinomial Table Builder
#
# This is the function that builds the core multinomial table
#
def build_multinomial_table(
        m_num_terms_min=0, m_num_terms_max=4,
        n_exponent_min=0, n_exponent_max=10,
        silent=False):
    """Builds a table of multinomial coefficients"""

    mc_table = {}

    m_num_terms_range = range(
        m_num_terms_min, m_num_terms_max + 1)

    n_exponent_range = range(
        n_exponent_min, n_exponent_max + 1)

    for m_num_terms in m_num_terms_range:

        if not silent:
            print('Processing tables for number of terms m = {}'.format(m_num_terms))

        for n_exponent in n_exponent_range:

            if not silent:
                print('Processing tables for exponent n = {}'.format(n_exponent))

            key_tuple = (m_num_terms, n_exponent)
            mc_table[key_tuple] = multinomial_coefficients(m_num_terms, n_exponent)
        
    return mc_table


##
# Multinomial Coefficients Class
#
# Utility class for creating, saving, and loading multinomial coefficient
# tables.
#
class MultinomialCoefs():
    def __init__(
            self,
            m_num_terms_min=0, m_num_terms_max=4,
            n_exponent_min=0, n_exponent_max=10,
            silent=False):

        self.m_num_terms_min = m_num_terms_min
        self.m_num_terms_max = m_num_terms_max
        self.n_exponent_min = n_exponent_min
        self.n_exponent_max = n_exponent_max

        self.mc_table = build_multinomial_table(
            m_num_terms_min=self.m_num_terms_min,
            m_num_terms_max=self.m_num_terms_max,
            n_exponent_min=self.n_exponent_min,
            n_exponent_max=self.n_exponent_max,
            silent=silent)

    def save(self, filename):
        filename = get_dated_filename(filename)
        with open(filename, 'wb') as fh:
            pickle.dump(self, fh)
        return filename

    @classmethod
    def load(cls, filename):
        with open(filename, 'rb') as f:
            return pickle.load(f)


##
# Get Multinomial Coefficients Function
#
# Wrapper to handle building multinomial coefficient tables and
# loading existing tables.
#
def get_multinomial_coefs(
        m_num_terms_min=0, m_num_terms_max=4,
        n_exponent_min=0, n_exponent_max=10,
        load_file=None, save=True, silent=False,
        save_str=''):
    """Generates or loads alpha coefs"""

    # If no file is provided, generate coefs
    if load_file == None:

        mc_obj = MultinomialCoefs(
            m_num_terms_min=m_num_terms_min,
            m_num_terms_max=m_num_terms_max,
            n_exponent_min=n_exponent_min,
            n_exponent_max=n_exponent_max,
            silent=silent)

        if save:
            mc_obj.save(
                'coefs/multinomial_coefs_{}'.format(save_str))

    # Otherwise load from file
    else:
        mc_obj = MultinomialCoefs.load(load_file)

    return mc_obj.mc_table


##
# Basic Tests
#
def simple_multinomial_tests():
    """Basic test of a multinomial expansion"""

    mc_table = get_multinomial_coefs(
        m_num_terms_min=0, m_num_terms_max=4,
        n_exponent_min=0, n_exponent_max=10,
        load_file=None, save=False, silent=True,
        save_str='test')

    # Straightforward expansion

    # m is the NUMBER OF TERMS INSIDE THE SUM... for a Psi-expansion
    # this is the number of network inputs + 1
    m = 3

    # n is the exponent... for a Psi expansion this is j = 2*m,
    # j = 2m + 1, or j = m, depending on the type of expansion
    n = 10

    mp.dps = 100

    # Compute a multinomial sum directly
    x = np.array([mpf(1), mpf(-2), mpf(-7)])

    result = np.sum(x) ** n

    print('Direct evalation:')
    print(result)

    # Multinomial expansion

    # Get a multinomial coefficient table
    mc = mc_table[(m, n)]

    summation = 0

    for kappa, coef in mc.items():
        term = coef * compute_multiexponent(x, kappa)
        summation += term

    print('Multinomial evaluation:')
    print(summation)

    delta = summation - result

    if delta == 0:
        print('Passed')
    else:
        print('Failed')
