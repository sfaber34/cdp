;function cdpMonteCarloC,conc=conc
pro cdpMonteCarloC,conc=conc
  tic
  
  

  ;----------------------Options----------------------------------
  ;saEX=8d-3 ;estimate from lance 2012 [m]
;  saEZ=5d-4
;  saQX=1.5d-4
;  saQZ=8d-5
  
  conc=100. ;concentration of drops [not truely concentration yet, more like number of drops intercepted]
  conc=conc*1d6
  
  rEx=2d-4 ; extended sample area radius
  yEx=8d-3 ;width of extended sample area
  rQ=4d-5
  yQ=4d-4
  
  as=100. ;true airspeed
  dist=10. ;simulation distance
  simTime=dist/as
  
  sweptArea=yEx*(2.*rEx)*dist
  numDrops=ceil(conc*sweptArea)
  
  dtClock=2.5e-7 ;time for 1 clock cycle [s]
  
  
  
  ;---------------------------------------------------------------
  
  tMeanEx=1./numDrops
  
  
  drops=make_array(6,numDrops) ;tArrEx,y,z,tInEx,tOutEx,tArrQ,tInQ,tOutQ
  dropTime=make_array(numDrops)
  
  tArrEx=(randomu(!null,numDrops))*simTime
  z=randomu(!null,numDrops)*2*rEx-rEx
  y=randomu(!null,numDrops)*yEx

  
;  for i=1,n(tIntArr) do begin
;    dropTime[i]=total(tIntArr[0:i])
;  endfor
;  dropTime[0]=tIntArr[0]
  
  
  drops[0,*]=tArrEx
  drops[1,*]=y
  drops[2,*]=z
  
  dropsTSort=sort(drops[0,*])
  drops=drops[*,dropsTSort]
  
  drops[5,*]=drops[0,*]+(rQ/as) ;qualified 'gate' arrival time
  outOfQBounds=where(abs(drops[2,*]) gt rQ or (drops[1,*] lt .5*yEx-.5*yQ or drops[1,*] gt .5*yEx+.5*yQ))
  drops[5,outOfQBounds]=!values.d_nan
  
  tInEx=(rEx-sqrt(rEx^2.-abs(z)^2.))/as
  tCrossEx=2.*(sqrt(rEx^2.-abs(z)^2.)/as)
  drops[3,*]=tInEx+drops[0,*] ;tInEx
  drops[4,*]=drops[3,*]+tCrossEx ;tOutEx
  
  ;-------Figure out to flag coinc------------
  
  
  coinc=[]
  for i=0,n(drops[3,*]) do begin
    for j=i+1,n(drops[3,*]) do begin
      if drops[3,j] lt drops[4,i] then coinc=[coinc,i] else break
    endfor
  endfor


 
  tsb=timestamp()
  ts=strsplit(tsb,'T',/extract)
  ts=ts[1]
  tsb=strmid(ts,0,8)

  savename=strcompress('saves/'+string(concCm)+'-'+tsb+'.sav')
  endtime=toc()
  print,string(concCm)+'-->'+string(endtime)
  ;save,filename=savename,coincSaQ,coincSaE,coincBoth,nDropsInSaE,nDropsInSaQ,timeStep,concCm,endtime
  ;return,[conccm,coincSaQ,coincSaE,coincBoth,endtime]
end


pro loopCarlo
  conca=[10,10,10,10,25,25,25,25,50,50,50,50,75,75,75,75,100,100,100,100,150,150,150,150,200,200,200,200,300,300,300,300,400,400,400,400,500,500,500,500,600,600,600,600,700,700,700,700,800,800,800,800,900,900,900,900,1000,1000,1000,1000]
  ;conc=[20,25,50,75,100,150,200,300,400,500,600,700]
  conca=indgen(30,start=1)*20.
  conc=[conca,conca,conca,conca,conca]
  conccm=[]
  coincSaQ=[]
  coincSaE=[]
  coincBoth=[]
  endtime=[]
  for i=0,n(conc) do begin
    ret=cdpMonteCarloB(conc=conc[i])
    print,'---------'+string(i/n1(conc)*100d)+'---------'
    conccm=[conccm,ret[0]]
    coincSaQ=[coincSaQ,ret[1]]
    coincSaE=[coincSaE,ret[2]]
    coincBoth=[coincBoth,ret[3]]
    endtime=[endtime,ret[4]]
    save,filename='saves/mulTestB.sav',conccm,coincSaQ,coincSaE,coincBoth,endtime
  endfor

end