#!/usr/bin/env python
import numpy as np
from lineClipping import cohensutherland

"""
make box with corners LL/UR (1,3) (4,5)
and line segment with ends (0,0) (4,6)
"""
# %% LOWER to UPPER test
x1, y1, x2, y2 = cohensutherland(1,  5, 4, 3,
                                 0,  0, 4, 6)

np.testing.assert_array_almost_equal([x1, y1, x2, y2], [2, 3, 3.3333333333333, 5])
# %% no intersection test
x1, y1, x2, y2 = cohensutherland(1, 5,  4, 3,
                                 0, 0.1, 0, 0.1)

assert x1 is None and y1 is None and x2 is None and y2 is None
# %% left to right test
x1, y1, x2, y2 = cohensutherland(1, 5, 4, 3,
                                 0, 4, 5, 4)
np.testing.assert_array_almost_equal([x1, y1, x2, y2], [1, 4, 4, 4])
