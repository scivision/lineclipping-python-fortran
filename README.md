# Line clipping

[![Actions Status](https://github.com/scivision/lineclipping-python-fortran/workflows/ci_python/badge.svg)](https://github.com/scivision/lineclipping-python-fortran/actions)


[![PyPi versions](https://img.shields.io/pypi/pyversions/pylineclip.svg)](https://pypi.python.org/pypi/pylineclip)
[![PyPi Download stats](http://pepy.tech/badge/pylineclip)](http://pepy.tech/project/pylineclip)

`lineclipping.f90` Cohen-Sutherland line clipping algorithm for
massively parallel coarray modern Fortran. Input scalars or arrays,
output intersections or `NaN` if no intersection.

`lineClipping.py` Cohen-Sutherland line clipping algorithm for Python.
Input scalars, output intersection length, or `None` if no intersection.

Julia line clipping is at https://github.com/scivision/lineclipping-julia

## Install

To install the latest release:

```sh
pip install pylineclip
```

### Fortran

If you want to use the Fortran Cohen-Sutherland line clipping modules
directly (optional):

```sh
meson build

meson test -C build
```

## Usage

The main difference with textbook implementations is that I return a
sentinel value (NaN, None, nothing) if there's no intersection of line
with box.

### Python

```python
import pylineclip.lineclipping as lc

x3,y3,x4,y4 = lc.cohensutherland((xmin, ymax, xmax, ymin, x1, y1, x2, y2)
```

If no intersection, `(None, None, None, None)` is returned.

### Fortran

lineclipping.f90 has two subroutines.
Pick Ccohensutherland if you're calling from C/C++/Python, which cannot tolerate assummed-shape arrays.
It's a slim wrapper to cohensutherland which is elemental (can handle scalar or any rank array).

Fortran programs will simply use

```fortran
use lineclipping
call cohensutherland(xmin,ymax,xmax,ymin,x1,y1,x2,y2)
```

The arguments are:

```sh
INPUTS
------
xmin,ymax,xmax,ymin:  upper left and lower right corners of box (pixel coordinates)

INOUT
-----
x1,y1,x2,y2:
in - endpoints of line
out - intersection points with box. If no intersection, all NaN
```
