#!/usr/bin/env python
from numpy.testing import assert_array_almost_equal,run_module_suite
#
import pylineclip as plc


def test_lineclip():
    """
    make box with corners LL/UR (1,3) (4,5)
    and line segment with ends (0,0) (4,6)
    """
    #%% LOWER to UPPER test
    x1, y1, x2, y2 = plc.cohensutherland(1,  5, 4, 3,
                                     0,  0, 4, 6)

    assert_array_almost_equal([x1,y1,x2,y2],[2, 3, 3.3333333333333,5])
    #%% no intersection test
    x1,y1,x2,y2 = plc.cohensutherland(1,5,  4,3,
                                  0,0.1,0,0.1)
    assert x1==y1==x2==y2==None
    #%% left to right test
    x1,y1,x2,y2 = plc.cohensutherland(1,5,4,3,
                                  0,4,5,4)
    assert_array_almost_equal([x1,y1,x2,y2],[1, 4, 4, 4])



if __name__ == '__main__':
    run_module_suite()
