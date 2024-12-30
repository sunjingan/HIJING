      program test
      CHARACTER FRAME*8,PROJ*8,TARG*8,dum*32
      CHARACTER*200 FOUTNAME
      CHARACTER*200 EVENTID
      COMMON/HIPARNT/HIPR1(100),IHPR2(50),HINT1(100),IHNT2(50)
      SAVE  /HIPARNT/
      COMMON/HIMAIN1/NATT,EATT,JATT,NT,NP,N0,N01,N10,N11
      SAVE  /HIMAIN1/
      COMMON/HIMAIN2/KATT(130000,4),PATT(130000,4)
      SAVE  /HIMAIN2/
      COMMON/HIMAIN3/VATT(130000,4)
      SAVE  /HIMAIN3/
      COMMON/RANSEED/NSEED
      SAVE  /RANSEED/
C
C       
C....initialize HIJING for Au+Au collisions at c.m. energy of 200 GeV:
C      WRITE(*,*)  'random number seed'
      READ(*,*) NSEED
C      WRITE(*,*) 'frame(LAB,CMS), enegy-frame'
      READ(*,*) FRAME,EFRM
C      WRITE(*,*) 'Proj, Targ(A,P,PBAR)'
      READ(*,*) PROJ,TARG
C      WRITE(*,*)  'A,Z of proj; A,Z of targ'
      READ(*,*) IAP,IZP,IAT,IZT
C      WRITE(*,*) 'number of events'
      READ(*,*) N_EVENT
C      WRITE(*,*) 'Print warning messages (0,1)'
      READ(*,*) IHPR2(10)
C      WRITE(*,*) 'Keep information of decayed particles (0,1)'
      READ(*,*) IHPR2(21)
C
C
C*** initialize HIJING
      CALL HIJSET(EFRM,FRAME,PROJ,TARG,IAP,IZP,IAT,IZT)
C        WRITE(*,*) 'Sjet=', HINT1(11),'mb','Stot=',HINT1(13),'mb'
C
C....set BMIN=0 and BMAX=0.0 for central interaction
      BMIN=0
      BMAX=40
      NEVENT_EF =0 
C....generating N_EVENT events of central AA interaction:
      OPEN (unit=40, file= "output/info.dat", status='unknown')
      DO 200 IE=1,N_EVENT
         
         
         CALL HIJING(FRAME,BMIN,BMAX)
         
         IF (NATT .EQ. 0) GO TO 200         

         WRITE (EVENTID,'(I200)') NEVENT_EF
         FOUTNAME = 'output/final_'//trim(AdjustL(EVENTID))//'.dat'
         Ncharged = 0
         WRITE(*,*) FOUTNAME
         WRITE(*,*) IE,NATT,EATT,NEVENT_EF,IE
         OPEN (unit=30, file= FOUTNAME, status='unknown')
         DO 300 IP=1,NATT
            IF(KATT(IP,2).EQ.0 .OR. KATT(IP,2).EQ.10) GO TO 300
            IF (LUCHGE(KATT(IP,1)) .EQ. 0) GO TO 300
            Ncharged = Ncharged + 1
            WRITE(30,18) PATT(IP,1),PATT(IP,2),PATT(IP,3)
     &    ,PATT(IP,4), ULMASS(KATT(IP,1)),KATT(IP,1)
     &    ,LUCHGE(KATT(IP,1))/3.0

        
         



300      continue
      WRITE(40,*) NEVENT_EF,NT+NP,Ncharged
      NEVENT_EF = NEVENT_EF +1
      close(30)
200   continue
18    format(4(f21.8),1(f21.8),1(I8),1(f21.1))
      close(40)
      STOP

      END 

