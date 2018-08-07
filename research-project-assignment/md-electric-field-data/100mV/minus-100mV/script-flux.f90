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
      character*11 suf3file,suf4file
      character*11 suf2file
      character*8  prefile
      character*4  idxfile

!    translocation
!
      real*8 zmax,zmin,rest
      integer idx,pos1,pos2,diff,mtra_intra,mtra_extra,dentro,fuori
      integer ptra_intra,ptra_extra
      real*8 ave_mtra_intra,ave_mtra_extra,ave_ptra_intra,ave_ptra_extra
      integer*2, allocatable :: restime(:,:)

      logical inside,upper1,upper2,lower1,lower2

!========1=========2=========3=========4=========5=========6=========7==

      n0=15216
      n1=95
      n2=62
      nwrite=n1+n2

      zmax=10.0d0
      zmin=-10.0d0

      suf2file='ns-prot.dcd'
      suf3file='ns-ions.out'
!
      open(100,file='input.idx',status='old',form='formatted')
      read(100,*) idxfile
      CALL getarg(1, idxfile)

      open(10,file=trim(idxfile)//suf2file,status='old',form='unformatted')

      read(10) ctype,ntraj,tstart,tsave,tend,i5,delta,i9
      read(10) ntitle,(title(j),j=1,ntitle)
      read(10) natm

      write(*,*) ntraj,natm,n1,n2

!      ntraj=10000

      allocate(xp0(natm))
      allocate(yp0(natm))
      allocate(zp0(natm))
      allocate(restime(ntraj,nwrite))

      restime(1:ntraj,1:nwrite)=0


!========1=========2=========3=========4=========5=========6=========7==


      TRAJ: do k=1,ntraj

!  Read the dcd file
!
      read(10) (xsc(i),i=1,6)
      read(10) (xp0(i),i=1,natm)
      read(10) (yp0(i),i=1,natm)
      read(10) (zp0(i),i=1,natm)

      do i=n0+1,n0+nwrite

         idx=i-n0
         if(zp0(i).gt.zmax) restime(k,idx)=1
         if(zp0(i).lt.zmin) restime(k,idx)=-1

      end do

! here finishes the loop on the trajectory
!
      end do TRAJ


      close(10)
      write(*,*) 'Analysis on structures',ntraj


      mtra_intra=0
      mtra_extra=0
      ptra_intra=0
      ptra_extra=0
      ave_mtra_intra=0.0
      ave_mtra_extra=0.0
      ave_ptra_intra=0.0
      ave_ptra_extra=0.0

      do i=1,nwrite

         inside=.false.
         upper1=.false.
         lower1=.false.

         do k=2,ntraj

            pos1=abs(restime(k-1,i))
            pos2=abs(restime(k,i))
            diff=pos1-pos2

            if(diff.eq.1) then
              inside=.true.
              rest=0.0

              if(restime(k-1,i).gt.0) then
                  upper1=.true.
                  lower1=.false.
                  dentro=1
              else
                  lower1=.true.
                  upper1=.false.
                  dentro=-1
              end if
!              write(*,*) 'INSIDE',i,k,dentro

            end if

            if(inside .and. restime(k,i).eq.0) rest=rest+1.0

            if(diff.eq.-1) then
              inside=.false.

              if(restime(k,i).gt.0) then
                  upper2=.true.
                  lower2=.false.
                  fuori=1
              else
                  lower2=.true.
                  upper2=.false.
                  fuori=-1
              end if

              if(upper1.and.lower2) then
                  if(i.le.n1) then
                    mtra_extra=mtra_extra+1
                    write(20,*) i,rest
                    ave_mtra_extra=ave_mtra_extra+rest
                  else
                    ptra_extra=ptra_extra+1
                    write(22,*) i,rest
                    ave_ptra_extra=ave_ptra_extra+rest
                  end if
              end if
              if(lower1.and.upper2) then
                  if(i.le.n1) then
                    mtra_intra=mtra_intra+1
                    write(21,*) i,rest
                    ave_mtra_intra=ave_mtra_intra+rest
                  else
                    ptra_intra=ptra_intra+1
                    write(23,*) i,rest
                    ave_ptra_intra=ave_ptra_intra+rest
                  end if
              end if
              rest=0.0
!              write(*,*) 'OUTSIDE',i,k,fuori

            end if


         end do
      end do


      write(*,*) 'Cl ex-in Translocation:',ptra_extra,ptra_intra
      write(*,*) 'Cl ex-in Average time(ns):',ave_ptra_extra*5.0/ptra_extra/1000.,ave_ptra_intra*5.0/ptra_intra/1000.
      write(*,*) 'K ex-in Translocation:',mtra_extra,mtra_intra
      write(*,*) 'K ex-in Average time(ns):',ave_mtra_extra*5.0/mtra_extra/1000.,ave_mtra_intra*5.0/mtra_intra/1000.
      write(*,*) 'RATIO m/p:',real(mtra_extra+mtra_intra)/real(ptra_extra+ptra_intra)



      write(*,*) 'bye...'

!----------------- END OF EXECUTABLE STATEMENTS -----------------------*

      END
