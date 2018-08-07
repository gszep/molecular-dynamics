      PROGRAM calculate_current
      implicit none

!!!! ifort -convert big_endian  script_water_analys.f90

      integer i,j,k

!   DCD VARIABLES
!
      integer ntraj,nions,mions,pions,ntraj2

      real*8 deltat,fact,pcurr,mcurr,curr,delta_z,halfbox,fact1,Volt
      real*4, allocatable :: zp0(:,:)
      real*8, allocatable :: box_z(:)
!
      character*11 suf2file,suf3file
      character*4  idxfile

!========1=========2=========3=========4=========5=========6=========7==

      suf2file= 'ns-ions.out'
      suf3file= 'ns-q.out'
      Volt=1.0

      fact1=1.6d0/10.**7/Volt
!      fact=1.0d0
      deltat=50.0d0

!  INPUT FILES
!  OUTPUT FILES
!
      open(100,file='input.idx',status='old',form='formatted')
      read(100,*) idxfile
      CALL getarg(1, idxfile)

      open(12,file=trim(idxfile)//suf2file,status='old',form='unformatted')
!      open(12,file='all.out',status='old',form='unformatted')
      open(20,file=trim(idxfile)//suf3file,status='unknown',form='formatted')

      read(12) ntraj,nions,pions,mions
      write(*,*) ntraj,nions,pions,mions

      allocate(zp0(4*ntraj,nions))
      allocate(box_z(4*ntraj))

!========1=========2=========3=========4=========5=========6=========7==

      do k=1,ntraj
         read(12) box_z(k),(zp0(k,j),j=1,nions)
      end do
!         read(12)
!      do k=ntraj+1,2*ntraj
!         read(12) box_z(k),(zp0(k,j),j=1,nions)
!      end do
!!!         read(12) ntraj2
!!!      do k=2*ntraj+1,2*ntraj+ntraj2
!!!         read(12) box_z(k),(zp0(k,j),j=1,nions)
!!!      end do

      write(*,*) 'File input read: ok'

      mcurr=0.0d0
      pcurr=0.0d0

      do k=1,ntraj-2
!!!      do k=1,2*ntraj+ntraj2-2

         halfbox=box_z(k)/2.0d0

         fact=fact1/(2*deltat)/box_z(k)

         do j=1,pions
            delta_z=(zp0(k+2,j)-zp0(k,j))
            if(delta_z.gt.halfbox)delta_z=delta_z-2.0d0*halfbox
            if(delta_z.lt.-halfbox)delta_z=delta_z+2.0d0*halfbox
            pcurr=pcurr+delta_z*fact
         end do

         do j=pions+1,nions
            delta_z=(zp0(k+2,j)-zp0(k,j))
            if(delta_z.gt.halfbox)delta_z=delta_z-2.0d0*halfbox
            if(delta_z.lt.-halfbox)delta_z=delta_z+2.0d0*halfbox
            mcurr=mcurr+delta_z*fact
         end do

         curr=pcurr-mcurr

         write(20,'(f8.2,2x,3(e15.9,2x))') k*deltat,curr*deltat,pcurr*deltat,mcurr*deltat

      end do


! here finishes the loop on the trajectory
!
      write(*,*) 'bye...'

!----------------- END OF EXECUTABLE STATEMENTS -----------------------*

      END
