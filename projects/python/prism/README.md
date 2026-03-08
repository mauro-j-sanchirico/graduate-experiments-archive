# Prism AI

This package contains all algorithms and experiments for Prism AI.
The Prism AI project seeks to break basic neural network architectures
down into a universal basis wherein they can be compared and checked
for conformance with a specified network architecture in a manner
analagous to the way linear systems are verified: (1) stimulate the
network under test with a test signal; (2) replicate the network from
the response (3) verify that the replicated network conforms with the
specified network.  This package is broken up into subpacakges which
contain the fundamental components of the study.

## Installation (developers)

To install an editable version of this package, navigate to the package
root directory and run:

```console
python -m pip install --editable .
```

## Installation (Windows users)

To install this package on Windows run:

```console
py -m pip install --index-url https://test.pypi.org/simple/ --no-deps prism_mauro_j_sanchirico_iii
```

## Installation (Unix users)

To install this package on Unix run:

```console
python3 -m pip install --index-url https://test.pypi.org/simple/ --no-deps prism_mauro_j_sanchirico_iii
```

## Building packages for distribution (from Windows)

To build packages for distribution:

```console
py -m pip install --upgrade build
py -m build
```

To upload the distribution archives:

```console
py -m pip install --upgrade twine
py -m twine upload --repository testpypi dist/*
```

## Building packages for distribution (from Unix)

To build packages for distribution:

```console
python3 -m pip install --upgrade build
python3 -m build
```

To upload to the distribution archives:

```console
python3 -m pip install --upgrade twine
python3 -m twine upload --repository testpypi dist/*
```
