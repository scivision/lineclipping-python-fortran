#!/usr/bin/env julia
#=
 The MIT License (MIT)
 Copyright (c) 2018 Michael Hirsch, Ph.D.
=#
using Base.Test

function cohensutherland(xmin, ymax, xmax, ymin, x1, y1, x2, y2)
    #=
    Clips a line to a rectangular area.

    This implements the Cohen-Sutherland line clipping algorithm.  xmin,
    ymax, xmax and ymin denote the clipping area, into which the line
    defined by x1, y1 (start point) and x2, y2 (end point) will be
    clipped.

    If the line intersects with the rectangular clipping area,
    a tuple of the clipped line points will be returned in the form (cx1, cy1, cx2, cy2).
    =#
    INSIDE,LEFT, RIGHT, LOWER, UPPER = 0,1, 2, 4, 8

    function _getclip(xa, ya)
        p = INSIDE  #default is inside

        # consider x
        if xa < xmin
            p |= LEFT
        elseif xa > xmax
            p |= RIGHT
        end

        # consider y
        if ya < ymin
            p |= LOWER # bitwise OR
        elseif ya > ymax
            p |= UPPER #bitwise OR
        end

        return p
     end

# check for trivially outside lines
    k1 = _getclip(x1, y1)
    k2 = _getclip(x2, y2)

#%% examine non-trivially outside points
    #bitwise OR |
    while (k1 | k2) != 0 # if both points are inside box (0000) , ACCEPT trivial whole line in box

        # if line trivially outside window, REJECT
        if (k1 & k2) != 0 #bitwise AND &
            return nothing
        end

        # non-trivial case, at least one point outside window

        # this is NOT a bitwise or
        if k1 != 0
            opt = k1
        elseif k2 != 0
            opt = k2
        else
            jl_error("unexpected k1,k2  $k1  $k2")
        end

        if (opt & UPPER) != 0 #these are bitwise ANDS
            x = x1 + (x2 - x1) * (ymax - y1) / (y2 - y1)
            y = ymax
        elseif (opt & LOWER) != 0
            x = x1 + (x2 - x1) * (ymin - y1) / (y2 - y1)
            y = ymin
        elseif (opt & RIGHT) != 0
            y = y1 + (y2 - y1) * (xmax - x1) / (x2 - x1)
            x = xmax
        elseif (opt & LEFT) != 0
            y = y1 + (y2 - y1) * (xmin - x1) / (x2 - x1)
            x = xmin
        else
            jl_error("Undefined clipping state")
        end

        if opt == k1
            x1, y1 = x, y
            k1 = _getclip(x1, y1)
            #println("checking k1: $x , $y   $k1")
        elseif opt == k2
            x2, y2 = x, y
            k2 = _getclip(x2, y2)
            #println("checking 2: $x , $y   $k2")
        end

    end

    return x1, y1, x2, y2
end


if PROGRAM_FILE == splitdir(@__FILE__)[end]
    xmin, ymax, xmax, ymin, x1, y1, x2, y2 = 1,  5, 4, 3, 0,  0, 4, 6

    x1, y1, x2, y2 = cohensutherland(xmin, ymax, xmax, ymin, x1, y1, x2, y2)

    @test x1≈2
    @test y1≈3
    @test x2≈3.3333333
    @test y2≈5

    println("x1,y2,x2,y2 $x1 $y1 $x2 $y2")
end
