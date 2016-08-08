pro cdpBase,file=file,filter=filter

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;
;
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


;----------------------------------------------------------------------VARIABLE INFO----------------------------------------------------------------------------------------------------
;
;
;----------PARTICLE VARIABLES----------
;binN - Bin 1-30 counts [#/bin]
;binNSum - Bin 1-30 counts summed over entire runtime [#]
;binNSecSum - Bin 1-30 counts summed for each interval [#/s]
;pbpN - bin segregated PBP counts [#/bin]
;pbpBin - PBP particle bin number [int]
;pbpD - PBP particle diameter [um]
;pbpACD - PBP voltage signal [V]
;pbpTime - PBP arival time [us]
;
;
;----------DIAGNOSTIC VARIABLES----------
;aveTrans - Average particle transit time (time qualifier signal shows qualified particles)  [us]
;dofRejCol - Number of rejected out of depth of field particles [#]
;adcOverflow - Number of oversize particles (sizer signal > max V) [#]
;
;
;----------PLOTTING VARIABLES----------
;date
;hour
;sec - Interval second
;min - Interval minute
;runtime - Second since file start (zero indexed)
;xBin - Array for histogram plotting particles by bin
;*****Variables with 'Ex' are 'non-Ex' variables shown above extrapolated for easier histogram plotting*****
;
;
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


  ;---------------------------------------------------------------------------------------------------------------------------------------------------
  ;--------------------------------------------------------------VARIABLE/ARRAY CREATION--------------------------------------------------------------
  ;---------------------------------------------------------------------------------------------------------------------------------------------------
  
  
  if n_elements(filter) gt 0 then doFilter=1 else doFilter=0
  if isa(file) eq 1 then begin
    data=read_csv(file)
    x=strsplit(file,/extract,'_')
    y=strsplit(x[2],/extract,'.')
    savename='saves/'+y[0]+'.sav'
  endif else begin
    data=read_csv('data/CDP_20160804_205948.csv')
  endelse
  
  
  
  nRows = n_elements(data.(0))
  
  if doFilter eq 1 then begin
    cgcleanup
    
    times=timePlot()
    t1=times.t1
    t2=times.t2
    
    rowCount=abs(t2-t1)
    for i=0, n_tags(data)-1 do begin
      var=data.(i)
      var=var[t1:t2-1]
      data.(i)=!VALUES.F_NAN
      data.(i)=var
    endfor    
    savename='cdpdatafilter.sav'
  endif else begin
    if isa(file) eq 0 then savename='cdpdata.sav'    
    rowCount=nRows
  endelse

  test=data.(305)
  if test[0] gt 0. then headerTest=0 else headerTest=1
  
  
  runTime = dindgen(rowCount, start=0, increment=1)
  pbp=make_array(256,rowCount,/long)
  val=make_array(256,rowCount)
  pbpACD=make_array(256,rowCount)
  pbpACD[*,*]=!VALUES.F_NAN
  pbpN=make_array(256,rowCount)*!VALUES.F_NAN
  pbpD=make_array(256,rowCount)*!VALUES.F_NAN
  pbpDEx=make_array(256,rowCount)
  pbpDEx[*,*]=!VALUES.F_NAN
  pbpBin=make_array(256,rowCount)
  pbpBin[*,*]=!VALUES.F_NAN
  pbpTime=make_array(256,rowCount)*!VALUES.F_NAN
  binN=make_array(27,rowCount)
  binNEx=make_array(48,rowCount)
  pbpNEx=binNEx
  xBin=dindgen(27,start=0,increment=1)
  xBinEdge=[indgen(6,start=3),indgen(21, start=10,increment=2)]
  xBinEx=dindgen(48,start=3,increment=1)
  binNSum=dindgen(27,start=0,increment=0)
  binNExSum=dindgen(48,start=0,increment=0)
  pbpNExSum=dindgen(48,start=0,increment=0)
  date=[]
  hour=[]
  min=[]
  sec=[]
  x=[]
  adcOverflow=[]
  aveTrans=[]
  dofRej=[]
  binNSecSum=[]
  pbpNSecSum=[]
  
  

  binDBounds=[2,3,4,5,6,7,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  binADCBounds=[30,83,105,173,219,265,307,367,428,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]
  binGeoMean=[2.5,3.5,4.5,5.5,6.5,7.5,9.,findgen(20,start=11,increment=2)]

  ;-----ADDITIONAL THRESHOLD VALUES-----
  ;binADCBounds=[30,91,111,159,190,215,243,272,355,488,636,751,846,959,1070,1297,1452,1665,1851,2016,2230,2513,2771,3003,3220,3424,3660,4095]
  ;binDBounds=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  ;binADCBounds=[30,83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]
  ;binADCBounds=[30,91,111,159,190,215,243,254,272,301,355,382,488,636,751,846,959,1070,1297,1452,1665,1851,2016,2230,2513,2771,3003,3220,3424,3660,4095]
  ;binADCBounds=[30,64,89,115,147,168,188,220,262,308,356,407,461,583,707,829,983,1148,1324,1512,1697,1909,2131,2365,2610,2864,3097,3337,3583,3879,4096]
  
  
  
  
  ;---------------------------------------------------------------------------------------------------------------------------------------------------
  ;-------------------------------------------------------------------CALCULATIONS--------------------------------------------------------------------
  ;---------------------------------------------------------------------------------------------------------------------------------------------------


  ;-----------------------------------------ASSIGN BIN COUNTS (REBINNED)-----------------------------------------
  
  
  for i=0,5 do begin
    d1=data.(i+19)
    binN[i,*]=d1[0:rowCount-1]
  endfor
  
  d2=data.(25)+data.(26)
  d3=data.(27)+data.(28)
  d4=data.(29)+data.(30)
  binN[6,*]=d2[0:rowCount-1]
  binN[7,*]=d3[0:rowCount-1]
  binN[8,*]=d4[0:rowCount-1]
  
  for i=9,26 do begin
    d5=data.(i+22)
    binN[i,*]=d5[0:rowCount-1]
  endfor
  
  
  for i=0,5 do begin
    binNEx[i,*]=binN[i,*]
  endfor
  
  k=6
  for i=6,47 do begin
    binNEx[i,*]=binN[k,*]
    if 2*(i/2) ne i then k++
  endfor
  
  if isa(file) then print,'-----'+file+'-----'
  ;-----------------------CALCULATE PBP SIZE/ARRIVAL TIME (REBINNED), TIME, REJECTED COUNTS-----------------------
  adcOverflowCol=data.(18)
  aveTransCol=data.(15)
  dofRejCol=data.(12)
  
  d1=data.(49)
  pbp[0,*]=d1[0:rowCount-1]
  for i=0,255 do begin
    x=data.(i+49)
    pbp[i,*]=x[0:rowCount-1]
  endfor
  
  lastStep=0
  for u=0,rowCount-1 do begin
    step=fix((float(u))/rowCount*100.)
    if step mod 10 eq 0 and step ne lastStep then begin
      print, strcompress('loop 1->'),strcompress(string(step)+'%')
      lastStep=step
    endif

    date=[date,data.field001[u]]
    
    hourX=strsplit(data.field002[u],':',/extract)
    hour=[hour,hourX[0]]
    
    minX=strsplit(data.field002[u],':',/extract)
    min=[min,minX[1]]
    
    secX=strsplit(data.field002[u],':',/extract)
    secXB=strsplit(secX[2],'.',/extract)
    sec=[sec,secXB[0]]
    
    adcOverflow=[adcOverflow,adcOverflowCol[u]]
    aveTrans=[aveTrans,aveTransCol[u]*(2.5d-3)]
    dofRej=[dofRej,dofRejCol[u]]
    binNSecSum=[binNSecSum,total(binN[*,u])]
    
    ;---CONVERT RAW PBP TO SIZER RESPONSE/ARRIVAL TIME---
    for i=0,255 do begin
      toDecTime=[]
      toDecD=[]
      calcTime=0

      val=binary(pbp[i,u])

      valTime=reverse(val[0:19])
      valD=reverse(val[20:31])
      
      if total(long(valD)) eq 0 then break

      for j=0,19 do begin
        toDecTime=[toDecTime,valTime[j]*2.^j]
      endfor

      for j=0,11 do begin
        toDecD=[toDecD,valD[j]*2.^j]
      endfor

      if total(toDecD) gt .000001 then begin
        pbpACD[i,u]=total(toDecD)
      endif     
      
      if total(toDecTime) gt .000001 then begin
        pbpTime[i,u]=total(toDecTime)
      endif 

    endfor
      if pbpACD[0,u] gt .000001 then pbpTime[0,u]=0.
  endfor
  
  

  ;---ASSIGN PBP SIZE VIA SIZER RESPONSE---
  lastStep=0
  for u=0,n_elements(pbpACD[0,*])-1 do begin
    
    step=fix((float(u))/rowCount*100.)
    if step mod 10 eq 0 and step ne lastStep then begin
      print, strcompress('loop 2->'),strcompress(string(step)+'%')
      lastStep=step
    endif
    
    for i=0,n_elements(pbpACD[*,0])-1 do begin
      if pbpACD[i,u] gt binADCBounds[0] then begin
        x=where(pbpACD[i,u] le binADCBounds)
        x=x[0]
        if x ne -1 then begin
            pbpBin[i,u]=x
            pbpD[i,u]=binDBounds[x]
          
          
          x=-1
        endif else begin
          pbpBin[i,u]=!values.F_NAN
          pbpD[i,u]=!values.F_NAN
        endelse
        if pbpACD[i,u] eq 4095 then begin
          pbpBin[i,u]=!values.F_infinity
          pbpD[i,u]=!values.F_infinity
        endif
      endif
      if pbpACD[i,u] lt binADCBounds[0] and pbpACD[i,u] gt 0. then begin
        pbpBin[i,u]=1
        pbpD[i,u]=binDBounds[1]
      endif
    endfor
    
    pbpNSecSum=[pbpNSecSum,max(where(pbpBin[*,u] gt 0.1))+1.]
    
  endfor
  
  
  ;-----------------------SUM BIN/PBP COUNTS-----------------------
  for i=0,26 do begin
    binNSum[i]=total(binN[i,*])
  endfor
  
  for i=0,47 do begin
    binNExSum[i]=total(binNEx[i,*])
  endfor
  

  for i=0,5 do begin
    pbpDEx[i,*]=pbpD[i,*]
  endfor

  k=6
  for i=6,47 do begin
    pbpDEx[i,*]=pbpD[k,*]
    if 2*(i/2) ne i then k++
  endfor


  pbpNSum=histogram(pbpBin,min=1,max=27)

  for i=0,5 do begin
    pbpNExSum[i]=pbpNSum[i]
  endfor

  k=6
  for i=6,47 do begin
    pbpNExSum[i]=pbpNSum[k]
    if 2*(i/2) ne i then k++
  endfor
 
  
  ;-------CALC A FEW STATS---------
  binNMedRedist=[]
  for i=0,n(binNSum) do begin
    if binNSum[i] gt 0 then binNMedRedist=[binNMedRedist,replicate(binGeoMean[i],binNSum[i])]
  endfor
  
  binNMed=med(binNMedRedist)
  binNMean=mean(binNMedRedist)
  binNQ1=q1(binNMedRedist)
  binNQ3=q3(binNMedRedist)
  binNMom=moment(binNMedRedist)
  binNVar=binNMom[1]
  binNSkew=binNMom[2]
  binNKurt=binNMom[3]


  ;-----------------------REMOVE INITIALIZATION COLUMN-----------------------
  if headerTest eq 1 then begin  
    runTime=runTime[0:rowCount-2]
    date=date[1:rowCount-1]
    hour=hour[1:rowCount-1]
    min=min[1:rowCount-1]
    sec=sec[1:rowCount-1]

    binN=binN[*,1:rowCount-1]
    binNEx=binNEx[*,1:rowCount-1]
    binNSecSum=binNSecSum[1:rowCount-1]

    pbp=pbp[*,1:rowCount-1]
    pbpACD=pbpACD[*,1:rowCount-1]
    pbpD=pbpD[*,1:rowCount-1]
    pbpN=pbpN[*,1:rowCount-1]
    pbpBin=pbpBin[*,1:rowCount-1]
    pbpTime=pbpTime[*,1:rowCount-1]
    pbpNEx=pbpNEx[*,1:rowCount-1]
    pbpNSecSum=pbpNSecSum[1:rowCount-1]

    adcOverflow=adcOverflow[1:rowCount-1]
    aveTrans=aveTrans[1:rowCount-1]
    dofRej=dofRej[1:rowCount-1]   
  endif  


  save,filename=savename,date,hour,min,sec,binN,binNSum,binNEx,binNExSum,adcOverflow,aveTrans,dofRej,$
    runtime,binNSecSum,pbpN,pbpBin,xBin,xBinEx,pbpNSecSum,pbpNEx,pbpNSum,pbpNExSum,pbpACD,pbpTime,$
    xBinEdge,binNMed,binNMean,binNQ1,binNQ3,binNVar,binNSkew,binNKurt
    
  if doFilter eq 0 then begin
    runTimeFilter=runTime
    binNSecSumFilter=binNSecSum
    
    save,filename='filterdata.sav',runTimeFilter,binNSecSumFilter
  endif

end


function timePlot
  restore,'filterdata.sav'
  p1=plot(runTimeFilter,binNSecSumFilter,dimensions=[1600,1200],margin=50,/device)
  
  stop
  
  t1=floor(p1.xrange[0])
  t2=floor(p1.xrange[1])
  p1.close
  
  return, {t1:t1,t2:t2}
end