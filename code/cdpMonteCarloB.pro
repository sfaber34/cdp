pro cdpMonteCarloB

  dtClock=2.5e-7 ;time for 1 clock cycle [s]
  
  saEX=8d-3 ;estimate from lance 2012 [m]
  saEZ=5d-4
  saQX=1.5d-4
  saQZ=8d-5
  
  conc=80d ;per cm3
  
  
  simDist=1d ;simulation distance [m]
  as=100d ;airspeed [m s-1]
  
  reqTime=simDist/as
  
  conc=conc*((saEX*saEZ*simDist)*1d6)
  
  
  timeStep=dindgen((reqTime/dtClock),start=!values.D_nan,increment=0)
  nDropsInSaE=indgen((reqTime/dtClock),start=0,increment=0)
  nDropsInSaQ=indgen((reqTime/dtClock),start=0,increment=0)
  
  
  ;------Create sample area-----
  
  saEcircX=dindgen(2000,start=0,increment=saEZ/1999.)
  saECircTop=(((.5*saEZ)^2.-(saEcircX-(.5*saEZ))^2.)^(1./2.))+(.5*saEZ)
  saECircBottom=-1.*(((.5*saEZ)^2.-(saEcircX-(.5*saEZ))^2.)^(1./2.))+(.5*saEZ)
  
  saQcircX=dindgen(200,start=.5*saEZ-.5*saQZ,increment=saQZ/199.)
  saQCircTop=(((.5*saQZ)^2.-(saQcircX-(2.5d-4))^2.)^(1./2.))+(.5*saEZ)
  saQCircBottom=-1.*(((.5*saQZ)^2.-(saQcircX-(2.5d-4))^2.)^(1./2.))+(.5*saEZ)
  
  rand=randomu(!null,3,conc,/double)
  nCoords=n1(rand[0,*])
  
  dropX=reform(rand[0,*]*saEX,nCoords)
  dropY=reform(rand[1,*]*simDist,nCoords)
  dropZ=reform(rand[2,*]*saEZ,nCoords)
  
  ;p1=scatterplot3d(dropY,dropX,dropZ,dimensions=[1600,1200])
  ;p2=plot3d(dindgen(n1(saEcircX),increment=0,start=(.5*saEZ)),saEcircX,saECircTop,/overplot)
  
  
  p1=plot([0,1],[0,1],dimensions=[900,900],margin=50,/device,/nodata)
  p1.xrange=[0,simDist]
  p1.yrange=[0,saEZ]
  
  psaETop=plot(saEcircX,saECircTop,/device,/overplot)
  psaeBottom=plot(saEcircX,saECircBottom,/device,/overplot)
  
  x=plot([saQcircX[0],saQcircX[0]],[0,5d-4],/overplot)
  x=plot([max(saQcircX),max(saQcircX)],[0,5d-4],/overplot)
  x.xrange=[0,5d-4]
  
  psaQTop=plot(saQcircX,saQCircTop,/device,/overplot)
  psaQBottom=plot(saQcircX,saQCircBottom,/device,/overplot)
  
  s2=scatterplot(dropY,dropZ,symbol='.',sym_size=3,sym_transparency=60,sym_filled=1,title='X/Z',/overplot)

  t=0
  i=0
  nt=0
  validDrop=0
  fu = Obj_New('IDLanROI', saEcircX, saECircTop)
  fuB = Obj_New('IDLanROI', saEcircX, saECircBottom)
  fuC = Obj_New('IDLanROI', saQcircX, saQCircTop)
  fuD = Obj_New('IDLanROI', saQcircX, saQCircBottom)
  
  while validDrop[0] gt -1 do begin
    isInSaE=[]
    isInSaQ=[]
    
    ;dtFilter=where(dropY-saEZ gt 0)
    ;dt=max([min(abs(dropY-max(saEcircX))/as),min(abs(dropY-max(saQcircX))/as),dtClock])
    dt=dtclock
    
    ;cgcleanup
    ;p1=plot([0,1],[0,1],dimensions=[1200,800],margin=50,/device,/nodata)
    ;s2=scatterplot(dropY,dropZ,symbol='.',sym_size=3,sym_transparency=60,sym_filled=1,title='X/Z',/overplot)
    
    if n(where(dropY lt saEZ*1.00001 and dropY gt 0)) gt 0 then begin
      ;s2=scatterplot(dropY,dropZ,symbol='.',sym_size=3,sym_transparency=60,sym_color='red',sym_filled=1,title='X/Z',/overplot)
      if n(where(dropZ gt .5*saEZ) gt 0) then begin         
        isinsaETop=where(fu->ContainsPoints(dropY,dropZ) eq 1,/null)        
      endif
      if n(where(dropZ lt .5*saEZ) gt 0) then begin         
        isinsaEBottom=where(fuB->ContainsPoints(dropY,dropZ) eq 1,/null)
      endif
        
        
        if n(where(dropX gt .5*saEX-.5*saQX and dropX lt .5*saEX+.5*saQX)) gt 0 then begin
          if n(where(dropZ gt .5*saEZ) gt 0) then begin
            isinsaQTop=where(fuC->ContainsPoints(dropY,dropZ) eq 1,/null)
          endif
          if n(where(dropZ lt .5*saEZ) gt 0) then begin
            isinsaQBottom=where(fuD->ContainsPoints(dropY,dropZ) eq 1,/null)
          endif
          isInSaQ=[isinsaQTop,isinsaQBottom]
        endif
          if isa(isInSaQ) eq 0 then isInSaE=[isinsaETop,isinsaEBottom] else isInSaE=[isinsaETop,isinsaEBottom]-isInSaQ
    endif
    
    
    
    
    
      
      
      nDropsInSaE[i]=n1(isInSaE)
      nDropsInSaQ[i]=n1(isInSaQ)

   
    ;if isInSaE[0] gt 0 then s3=scatterplot(dropY[isInSaE],dropZ[isInSaE],symbol='.',sym_size=5,sym_transparency=30,sym_color='red',sym_filled=1,title='X/Z',/overplot)
    if(nt gt 50.) then begin
      print,ceil((t/reqTime)*100d)
      nt=0d
    endif
    validDrop=where(dropY gt 0)
    
    dropY=dropY[validDrop]-as*dt
    dropX=dropX[validDrop]
    dropZ=dropZ[validDrop]
    timeStep[i]=t        
    t=t+dt
    i++
    nt++

  endwhile
  
  coincSaE=where(nDropsInSaE ge 2)
  Obj_Destroy, fu
  Obj_Destroy, fuB
  Obj_Destroy, fuC
  Obj_Destroy, fuD
  stop
end