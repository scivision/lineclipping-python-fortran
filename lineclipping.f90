module lineclip

use, intrinsic:: iso_c_binding, only: c_int
use, intrinsic:: iso_fortran_env, only : stderr=>error_unit
use, intrinsic:: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
use assert, only: err,wp

implicit none

    integer,parameter :: inside=0,left=1,right=2,lower=4,upper=8
    private
    public:: wp,cohensutherland,Ccohensutherland

contains

subroutine Ccohensutherland(xmin,ymax,xmax,ymin,Np,x1,y1,x2,y2) bind(c)
! for C/C++/f2py that need constant length arrays
!
! INPUTS
! ------
! xmin,ymax,xmax,ymin:  upper left and lower right corners of box (pixel coordinates)
! Np: number of points in vectors (number of elementts)
! 
! INOUT
! -----
! x1,y1,x2,y2: 
! in - endpoints of line
! out - intersection points with box. If no intersection, all NaN
    
    integer(c_int), intent(in) :: Np
    real(wp),intent(in) :: xmin,ymax,xmax,ymin
    real(wp),intent(inout), dimension(Np):: x1,y1,x2,y2
  
    call cohensutherland(xmin, ymax, xmax,ymin,x1,y1,x2,y2)

end subroutine Ccohensutherland


elemental subroutine cohensutherland(xmin,ymax,xmax,ymin, &
                                x1, y1, x2, y2)
! INPUTS
! ------
! xmin,ymax,xmax,ymin:  upper left and lower right corners of box (pixel coordinates)
! 
! INOUT
! -----
! x1,y1,x2,y2: 
! in - endpoints of line
! out - intersection points with box. If no intersection, all NaN
    
real(wp), intent(in) :: xmin,ymax,xmax,ymin
real(wp), intent(out):: x1,y1,x2,y2
real(wp) :: nan

integer k1, k2, opt ! just plain integers
real(wp) :: x,y

nan = ieee_value(1.,ieee_quiet_nan)
y = nan
x = nan

! check for trivially outside lines
k1 = getclip(x1,y1,xmin,xmax,ymin,ymax)
k2 = getclip(x2,y2,xmin,xmax,ymin,ymax)


do while (ior(k1,k2) /= 0)

    !trivially outside window, Reject
    if (iand(k1,k2) /= 0) then
      x1=nan; y1=nan; x2=nan; y2=nan 
      return
    endif
    
    opt = merge(k1,k2,k1 > 0)
    if (iand(opt,UPPER) > 0) then
        x = x1 + (x2 - x1) * (ymax - y1) / (y2 - y1)
        y = ymax
    elseif (iand(opt,LOWER) > 0) then
        x = x1 + (x2 - x1) * (ymin - y1) / (y2 - y1)
        y = ymin
    elseif (iand(opt,RIGHT) > 0) then
        y = y1 + (y2 - y1) * (xmax - x1) / (x2 - x1)
        x = xmax
    elseif (iand(opt,LEFT) > 0) then
        y = y1 + (y2 - y1) * (xmin - x1) / (x2 - x1)
        x = xmin
    else
        call err('undefined clipping state')
    endif
    
    if (opt == k1) then ! not case select
        x1 = x; y1 = y
        k1 = getclip(x1,y1,xmin,xmax,ymin,ymax)
    elseif (opt == k2) then
        x2 = x; y2 = y
        k2 = getclip(x2,y2,xmin,xmax,ymin,ymax)
    endif

end do


end subroutine cohensutherland


elemental function getclip(xa,ya,xmin,xmax,ymin,ymax) result(p) ! bit patterns
real(wp), intent(in) :: xa,ya,xmin,xmax,ymin,ymax


integer p
p = inside ! default

!consider x
if (xa < xmin) then
  p = ior(p,left)
elseif (xa > xmax) then
  p = ior(p,right)
endif

!consider y
if (ya < ymin) then
  p = ior(p,lower)
elseif (ya > ymax) then
  p = ior(p,upper)
endif

end function getclip

end module lineclip
