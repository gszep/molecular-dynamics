      PROGRAM read_write_ions
      implicit none

      integer i,j,k,l

!   DCD VARIABLES
!
      character*4 ctype
      integer ntraj,tstart,tsave,tend,i5(5),i9(9),ntitle,natm,nfe
      real*8 delta
      character*80 title(10)
      real*4, allocatable :: xp0(:),yp0(:),zp0(:),wca(:)
      real*8 xsc(6)

!  PDB VARIABLES
!
      integer nwrite,n0,n1,n2

!    INPUT/OUTOUT
!
      character*6  suffile
      character*11 suf2file,suf3file,suf4file
      character*8  prefile
      character*4  idxfile

!========1=========2=========3=========4=========5=========6=========7==

      n0=15216
      n1=95
      n2=62
      nwrite=n1+n2

      suf2file='ns-prot.dcd'
      suf3file='ns-ions.out'
!
      open(100,file='input.idx',status='old',form='formatted')
      read(100,*) idxfile
      CALL getarg(1, idxfile)

      open(10,file=trim(idxfile)//suf2file,status='old',form='unformatted')
      open(12,file=trim(idxfile)//suf3file,status='unknown',form='unformatted')

      read(10) ctype,ntraj,tstart,tsave,tend,i5,delta,i9
      write(*,*) ctype,ntraj,tstart,tsave,tend,i5,delta,i9
      read(10) ntitle,(title(j),j=1,ntitle)
      read(10) natm

      write(*,*) natm,ntraj

      allocate(xp0(natm))
      allocate(yp0(natm))
      allocate(zp0(natm))

      write(12) ntraj,nwrite,n1,n2

!========1=========2=========3=========4=========5=========6=========7==


      TRAJ: do k=1,ntraj

!  Read the dcd file
!
      read(10) (xsc(i),i=1,6)
      read(10) (xp0(i),i=1,natm)
      read(10) (yp0(i),i=1,natm)
      read(10) (zp0(i),i=1,natm)

      write(12) xsc(6),(zp0(j),j=n0+1,n0+nwrite)
      print*, nwrite
      write(*,*) 'finished with frame',k

! here finishes the loop on the trajectory
!
      end do TRAJ

      write(*,*) 'bye...'

!----------------- END OF EXECUTABLE STATEMENTS -----------------------*

      END
