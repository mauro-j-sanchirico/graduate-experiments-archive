# Verified Computing

This package provides tools and algorithms for verified computing in
Python inclduing:
* Interval arithmetic
* Polynomial operations, including rigorous range bounding
* Taylor modeling

## Installation (developers)

To install an editable version of this package, navigate to the package
root directory and run:

```console
python -m pip install --editable .
```

## Installation (Windows users)

To install this package on Windows run:

```console
py -m pip install --index-url https://test.pypi.org/simple/ --no-deps verified_computing_mauro_j_sanchirico_iii
```

## Installation (Unix users)

To install this package on Unix run:

```console
python3 -m pip install --index-url https://test.pypi.org/simple/ --no-deps verified_computing_mauro_j_sanchirico_iii
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
