pro cdpBase

  ;data=read_csv('data/CDP_20160519_203922Snip.csv')
  data=read_csv('data/CDP_20160519_203922.csv')

  test=data.(305)
  if test[0] gt 0. then headerTest=0 else headerTest=1
  
  nRows = n_elements(data.(0))
  runTime = dindgen(nRows, start=0, increment=1)
  pbp=make_array(256,nRows,/long)
  val=make_array(256,nRows)
  pbpACD=make_array(256,nRows)
  pbpACD[*,*]=!VALUES.F_NAN
  pbpD=make_array(256,nRows)
  pbpD[*,*]=!VALUES.F_NAN
  pbpBin=make_array(256,nRows)
  pbpBin[*,*]=!VALUES.F_NAN
  pbpTime=make_array(256,nRows)
  pbpTime[*,*]=!VALUES.F_NAN
  binD=make_array(27,nRows)
  binDEx=make_array(48,nRows)
  pbpDEx=make_array(48,nRows)
  ;pbpD=make_array(49,nRows)
  xBin=dindgen(27,start=0,increment=1)
  xBinEx=dindgen(50,start=0,increment=1)
  binDSum=dindgen(27,start=0,increment=0)
  binDExSum=dindgen(48,start=0,increment=0)
  pbpDExSum=dindgen(48,start=0,increment=0)
  date=[]
  hour=[]
  min=[]
  sec=[]
  x=[]
  adcReject=[]
  aveTransReject=[]
  dofReject=[]
  binsecsum=[]
  pbpSecSum=[]
  
;  original bins

  ;--use these---
  ;binDBounds=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  ;binADCBounds=[30,83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]
  
  ;binADCBounds=[30,91,111,159,190,215,243,254,272,301,355,382,488,636,751,846,959,1070,1297,1452,1665,1851,2016,2230,2513,2771,3003,3220,3424,3660,4095]
  
  ;binADCBounds=[30,64,89,115,147,168,188,220,262,308,356,407,461,583,707,829,983,1148,1324,1512,1697,1909,2131,2365,2610,2864,3097,3337,3583,3879,4096]
  
  
  
  binDBounds=[2,3,4,5,6,7,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  binADCBounds=[30,83,105,173,219,265,307,367,428,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]
  
  ;binADCBounds=[30,91,111,159,190,215,243,272,355,488,636,751,846,959,1070,1297,1452,1665,1851,2016,2230,2513,2771,3003,3220,3424,3660,4095]

  adcRejectCol=data.(18)
  aveTransRejectCol=data.(15)
  dofRejectCol=data.(12)

  pbp[0,*]=data.(49)
  for i=0,255 do begin
    x=data.(i+49)
    pbp[i,*]=x
  endfor

  ;ASSIGN BIN COUNTS
  for i=0,5 do begin
    binD[i,*]=data.(i+19)
  endfor
  binD[6,*]=data.(25)+data.(26)
  binD[7,*]=data.(27)+data.(28)
  binD[8,*]=data.(29)+data.(30)
  for i=9,26 do begin
    binD[i,*]=data.(i+22)
  endfor
  
  
  
;  for i=0,29 do begin
;    binD[i,*]=data.(i+19)
;  endfor
  
  
  

  for i=0,5 do begin
    binDEx[i,*]=binD[i,*]
  endfor
  
  k=6
  for i=6,47 do begin
    binDEx[i,*]=binD[k,*]
    if 2*(i/2) ne i then k++
  endfor
  
  
  lastStep=0
  for u=0,nRows-1 do begin
    step=fix((float(u))/nRows*100.)
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
    
    adcReject=[adcReject,adcRejectCol[u]]
    aveTransReject=[aveTransReject,aveTransRejectCol[u]]
    dofReject=[dofReject,dofRejectCol[u]]
    binsecsum=[binsecsum,total(binD[*,u])]
    

    pbpArr=[]

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

    endfor
  endfor


  lastStep=0
  for u=0,n_elements(pbpACD[0,*])-1 do begin
    
    step=fix((float(u))/nRows*100.)
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
        endif else begin
          pbpBin[i,u]=!values.F_INFINITY
          pbpD[i,u]=!values.F_INFINITY
        endelse
      endif
    endfor
    
    pbpSecSum=[pbpSecSum,max(where(pbpBin[*,u] gt 0.1))+1.]
    
  endfor
  
  
  
  for i=0,26 do begin
    binDSum[i]=total(binD[i,*])
  endfor
  
  for i=0,47 do begin
    binDExSum[i]=total(binDEx[i,*])
  endfor
  
  
  
  for i=0,5 do begin
    pbpDEx[i,*]=pbpD[i,*]
  endfor

  k=6
  for i=6,47 do begin
    pbpDEx[i,*]=pbpD[k,*]
    if 2*(i/2) ne i then k++
  endfor


  pbpDSum=histogram(pbpBin,min=1,max=27)

  for i=0,5 do begin
    pbpDExSum[i]=pbpDSum[i]
  endfor

  k=6
  for i=6,47 do begin
    pbpDExSum[i]=pbpDSum[k]
    if 2*(i/2) ne i then k++
  endfor


  if headerTest eq 1 then begin  
    runTime=runTime[0:nRows-2]
    date=date[1:nRows-1]
    hour=hour[1:nRows-1]
    min=min[1:nRows-1]
    sec=sec[1:nRows-1]

    binD=binD[*,1:nRows-1]
    binDEx=binDEx[*,1:nRows-1]
    binSecSum=binSecSum[1:nRows-1]

    pbp=pbp[*,1:nRows-1]
    pbpACD=pbpACD[*,1:nRows-1]
    pbpD=pbpD[*,1:nRows-1]
    pbpBin=pbpBin[*,1:nRows-1]
    pbpTime=pbpTime[*,1:nRows-1]
    pbpDEx=pbpDEx[*,1:nRows-1]
    pbpSecSum=pbpSecSum[1:nRows-1]


    
    adcReject=adcReject[1:nRows-1]
    aveTransReject=aveTransReject[1:nRows-1]
    dofReject=dofReject[1:nRows-1]
    
    
  endif  



  save,filename='cdpdata.sav',date,hour,min,sec,binD,binDSum,binDEx,binDExSum,adcReject,aveTransReject,dofReject,$
    runtime,binsecsum,pbpD,pbpBin,xBin,xBinEx,pbpSecSum,pbpDEx,pbpDSum,pbpDExSum,pbpACD,pbpTime,/verbose

end