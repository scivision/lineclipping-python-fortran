program test

    use, intrinsic:: ieee_arithmetic
    use lineclip,only: Ccohensutherland, cohensutherland
    use assert

    implicit none
    
    real(wp) :: L(8)[*]

    if(this_image()==1) then
      call test_lineclip()

      call test_array_lineclip()
    endif
    
    call coarray_lineclip(L)
!    if(this_image()==1)  print *,L

contains
  
subroutine test_array_lineclip()

    integer, parameter :: Np=2
    real(wp), dimension(Np) :: length, x1,x2,y1,y2
    real(wp),parameter :: xmin=1., ymax=5.,xmax=4., ymin=3.
    real(wp),parameter :: truelength(Np) =[2.40370083, 3.]

    x1=[0.,0.]
    y1=[0.,4.]
    x2=[4.,5.]
    y2=[6.,4.]

    
    call Ccohensutherland(xmin,ymax,xmax,ymin,Np,x1,y1,x2,y2)
    
    length = hypot((x2-x1), (y2-y1))
    call assert_isclose(length, truelength)
    
!-----------

    call cohensutherland(xmin,ymax,xmax,ymin,x1,y1,x2,y2)
    
    length = hypot((x2-x1), (y2-y1))
    call assert_isclose(length, truelength)

    
    print *, 'OK array_lineclip'
    

end subroutine test_array_lineclip

!--------------------

subroutine test_lineclip()

    real(wp), parameter :: xmin=1., ymax=5., xmax=4., ymin=3.
    real(wp) :: x1, y1, x2, y2  !not a parameter

!    make box with corners LL/UR (1,3) (4,5)
!    and line segment with ends (0,0) (4,6)

! LOWER to UPPER test   
    x1=0.; y1=0.; x2=4.; y2=6.

    call cohensutherland(xmin,ymax,xmax,ymin,x1,y1,x2,y2)
    
    call assert_isclose(x1, 2._wp)
    call assert_isclose(y1, 3._wp)
    call assert_isclose(x2, 3.3333333_wp)
    call assert_isclose(y2, 5._wp)
    
! no intersection test
    x1=0.;y1=0.1;x2=0.;y2=0.1
    
    call cohensutherland(xmin,ymax,xmax,ymin,x1,y1,x2,y2)
    if (.not.all(ieee_is_nan([x1,y1,x2,y2]))) error stop 'failed no intersection test'
    
    print *, 'OK lineclip'
    
end subroutine test_lineclip

!----------------------------

subroutine coarray_lineclip(length)

    integer, parameter :: Np=8
    real(wp), dimension(Np) :: x1,x2,y1,y2
    real(wp),parameter :: xmin=1., ymax=5.,xmax=4., ymin=3.
    real(wp) :: truelength(Np) =[2.40370083, 3.,0.,0.,0.,0.,2.,2.5]
    real(wp) :: nan
    integer :: Ni, im, s0,s1
    real(wp),intent(out) :: length(Np)[*]
    
    Ni = num_images()
    im=this_image()
    
    nan = ieee_value(1.,ieee_quiet_nan)
    truelength(3:6) = nan

    x1=[0.,0.,0.,0.,0.,0.,0.,0.]
    y1=[0.,4.,1.,1.5,2.,2.5,3.0,3.5]
    x2=[4.,5.,1.,1.5,2.,2.5,3.0,3.5]
    y2=[6.,4.,1.,1.5,2.,2.5,3.0,3.5]

!------ slice problem
    s0 = (im-1)*Np/Ni+1
    s1 = im*Np/Ni
    print '(A,I3,A,I3,A,I3)','Image',im,' solved over indices ',s0,':',s1
!------- solve problem
    call cohensutherland(xmin,ymax,xmax,ymin, &
                x1(s0:s1), y1(s0:s1), x2(s0:s1), y2(s0:s1))
                
    length(s0:s1)[1] = hypot(x2(s0:s1) - x1(s0:s1), y2(s0:s1) - y1(s0:s1))
!-------- finish up 
    sync all
 
    if (im==1) then
        call assert_isclose(length, truelength, equal_nan=.true.)
        print *, 'OK coarray_lineclip'
    endif
    

end subroutine coarray_lineclip

end program
