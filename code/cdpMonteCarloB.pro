function cdpMonteCarloB,conc=conc
  tic
  dtClock=2.5e-7 ;time for 1 clock cycle [s]
  
  saEX=8d-3 ;estimate from lance 2012 [m]
  saEZ=5d-4
  saQX=1.5d-4
  saQZ=8d-5
  
  saQZU=.5*saQZ
  saQZL=.5*saQZ-saQZ
  saQXU=.5*saEX+.5*saQX
  saQXL=.5*saEX-.5*saQX
  saQYU=.5*saEZ+.5*saQZ
  saQYL=.5*saEZ-.5*saQZ
  
  saEZU=.5*saEZ
  saEZL=.5*saEZ-saEZ
  
  ;if isa(conc) eq 0 then conc=400d ;per cm3
  concCm=conc
  
  simDist=10d ;simulation distance [m]
  as=100d ;airspeed [m s-1]
  
  reqTime=simDist/as
  
  conc=conc*((saEX*saEZ*simDist)*1d6)
  
  timeStep=dindgen((reqTime/dtClock),start=!values.D_nan,increment=0)
  nDropsInSaE=indgen((reqTime/dtClock),start=0,increment=0)
  nDropsInSaQ=indgen((reqTime/dtClock),start=0,increment=0)
  
  
  ;------Create sample area-----
  
  saEcircX=dindgen(2000,start=0,increment=saEZ/1999.)
  saECircTop=(((.5*saEZ)^2.-(saEcircX-(.5*saEZ))^2.)^(1./2.))
  saECircBottom=-1.*(((.5*saEZ)^2.-(saEcircX-(.5*saEZ))^2.)^(1./2.))
  
  saQcircX=dindgen(200,start=saQYL,increment=saQZ/199.)
  saQCircTop=(((.5*saQZ)^2.-(saQcircX-(2.5d-4))^2.)^(1./2.))
  saQCircBottom=-1.*(((.5*saQZ)^2.-(saQcircX-(2.5d-4))^2.)^(1./2.))
  
  rand=randomu(!null,3,conc,/double)
  nCoords=n1(rand[0,*])
  
  dropX=reform(rand[0,*]*saEX,nCoords)
  dropY=reform(rand[1,*]*simDist,nCoords)
  dropZ=reform(rand[2,*]*saEZ-(.5)*saEZ,nCoords)
  
  ;p1=scatterplot3d(dropY,dropX,dropZ,dimensions=[1600,1200])
  ;p2=plot3d(dindgen(n1(saEcircX),increment=0,start=(.5*saEZ)),saEcircX,saECircTop,/overplot)
  
  ;------keep these------
  ;p1=plot([0,1],[0,1],dimensions=[990,990],margin=50,/device,/nodata)
;  p1.xrange=[0,simDist]
;  p1.yrange=[0,saEZ]
 
;  psaETop=plot(saEcircX,saECircTop,/device,/overplot)
;  psaeBottom=plot(saEcircX,saECircBottom,/device,/overplot)
;  
;  
;  psaQTop=plot(saQcircX,saQCircTop,/device,/overplot)
;  psaQBottom=plot(saQcircX,saQCircBottom,/device,/overplot)

  t=0
  i=0
  nt=0
  validDrop=0

  
  while validDrop[0] gt -1 do begin
    isInSaE=[]
    isInSaQ=[]
    
    plotDropsInds=where(dropY lt saEZ)
    plotDropY=dropY[plotDropsInds]
    plotDropZ=dropZ[plotDropsInds]
    
    ;dtFilter=where(dropY-saEZ gt 0)
    ;dt=max([min(abs(dropY-max(saEcircX))/as),min(abs(dropY-max(saQcircX))/as),dtClock])
    dt=dtclock
    
    ;cgcleanup
    
    
    possInE=where(dropY lt saEZ and dropY gt 0 and dropZ gt saEZL and dropZ lt saEZU)
    if possInE[0] gt 0 then begin
      saECircEq=(((.5*saEZ)^2.-(dropY[possInE]-(.5*saEZ))^2.)^(1./2.))
      
      diffs=saECircEq - abs(dropZ[possInE])
      isInSaE=possInE[where(diffs gt 0,/null)]
    endif  
    
    possInQ=where(dropY lt saQYU and dropY gt saQYL and dropZ gt saQZL and dropZ lt saQZU and dropX gt saQXL and dropX lt saQXU)
    if possInQ[0] gt 0 then begin
      saQCircEq=((.5*saQZ)^2.-(dropY[possInQ]-(2.5d-4))^2.)^(1./2.)

      diffs=saQCircEq - abs(dropZ[possInQ])
      isInSaQ=possInQ[where(diffs gt 0,/null)]
    endif
    
      
      nDropsInSaE[i]=n1(isInSaE)
      nDropsInSaQ[i]=n1(isInSaQ)

   
    ;s3=scatterplot(dropY[isInSaE],dropZ[isInSaE],symbol='.',sym_size=5,sym_transparency=30,sym_color='red',sym_filled=1,title='X/Z',/overplot)
;    if(nt gt 800.) then begin
;      print,ceil((t/reqTime)*100d)
;      nt=0d
;    endif
    validDrop=where(dropY gt 0)
    
    dropY=dropY[validDrop]-as*dt
    dropX=dropX[validDrop]
    dropZ=dropZ[validDrop]
    timeStep[i]=t        
    t=t+dt
    i++
    nt++

  endwhile
  
  coincSaQ=n(where(nDropsInSaQ gt 1))
  coincSaE=n(where(nDropsInSaE gt 1))
  coincBoth=n(where(nDropsInSaE gt 0 and nDropsInSaQ gt 0))
   
   t=timestamp()
   ts=strsplit(t,'T',/extract)
   ts=ts[1]
   tsb=strmid(ts,0,8)
   
  savename=strcompress('saves/'+string(concCm)+'-'+tsb+'.sav')
  endtime=toc()
  print,string(concCm)+'-->'+string(endtime)
  ;save,filename=savename,coincSaQ,coincSaE,coincBoth,nDropsInSaE,nDropsInSaQ,timeStep,concCm,endtime
  return,[conccm,coincSaQ,coincSaE,coincBoth,endtime]
end


pro loopCarlo
  ;conc=[10,10,10,10,25,25,25,25,50,50,50,50,75,75,75,75,100,100,100,100,150,150,150,150,200,200,200,200,300,300,300,300,400,400,400,400,500,500,500,500,600,600,600,600,700,700,700,700,800,800,800,800,900,900,900,900,1000,1000,1000,1000]
  conc=[10,25,50,75,100,150,200,300,400,500,600,700]
  conccm=[]
  coincSaQ=[]
  coincSaE=[]
  coincBoth=[]
  endtime=[]
  for i=0,n(conc) do begin
    ret=cdpMonteCarloB(conc=conc[i])
    
    conccm=[conccm,ret[0]]
    coincSaQ=[coincSaQ,ret[1]]
    coincSaE=[coincSaE,ret[2]]
    coincBoth=[coincBoth,ret[3]]
    endtime=[endtime,ret[4]]
  endfor
    save,filename='saves/mulTestB.sav',conccm,coincSaQ,coincSaE,coincBoth,endtime
end