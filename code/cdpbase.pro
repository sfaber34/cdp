pro cdpBase

  ;data=read_csv('data/CDP_20160519_203922F.csv')
  data=read_csv('data/CDP_20160519_203922.csv')


  nRows = n_elements(data.(0))
  runTime = dindgen(nRows, start=0, increment=1)
  pbp=make_array(256,nRows,/long)
  val=make_array(256,nRows)
  pbpACD=make_array(256,nRows)
  pbpD=make_array(256,nRows)
  pbpBin=make_array(256,nRows)
  pbpTime=make_array(256,nRows)
  binCounts=make_array(27,nRows)
  binSizeUp=make_array(49,nRows)
  date=[]
  hour=[]
  min=[]
  sec=[]
  x=[]
  rejectADC=[]
  aveTransReject=[]
  dofReject=[]
  binCountsSecSum=[]
  
;  original bins
;  binDBoundsB=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
;  binADCBoundsB=[30,83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]
  
  
  binDBounds=[2,3,4,5,6,7,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  binADCBounds=[30,83,105,173,219,265,307,367,428,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]


  ;firstTime=data.(49)
  firstTime=0.
  rejectADCCol=data.(18)
  aveTransRejectCol=data.(15)
  dofRejectCol=data.(12)

  pbp[0,*]=data.(49)
  for i=1,255 do begin
    x=data.(i+49)
    pbp[i,*]=x
  endfor

  ;ASSIGN BIN COUNTS
  for i=0,5 do begin
    binCounts[i,*]=data.(i+19)
  endfor
  binCounts[6,*]=data.(25)+data.(26)
  binCounts[7,*]=data.(27)+data.(28)
  binCounts[8,*]=data.(29)+data.(30)
  for i=9,26 do begin
    binCounts[i,*]=data.(i+22)
  endfor

  for i=0,5 do begin
    binSizeUp[i,*]=binCounts[i,*]
  endfor

  binSizeUp[6,*]=binCounts[6,*]
  binSizeUp[7,*]=binCounts[6,*]
  binSizeUp[8,*]=binCounts[7,*]
  binSizeUp[9,*]=binCounts[7,*]
  binSizeUp[10,*]=binCounts[8,*]
  binSizeUp[11,*]=binCounts[8,*]
  binSizeUp[12,*]=binCounts[9,*]
  binSizeUp[13,*]=binCounts[9,*]
  binSizeUp[14,*]=binCounts[10,*]
  binSizeUp[15,*]=binCounts[10,*]
  binSizeUp[16,*]=binCounts[11,*]
  binSizeUp[17,*]=binCounts[11,*]
  binSizeUp[18,*]=binCounts[12,*]
  binSizeUp[19,*]=binCounts[12,*]
  binSizeUp[20,*]=binCounts[13,*]
  binSizeUp[21,*]=binCounts[13,*]
  binSizeUp[22,*]=binCounts[14,*]
  binSizeUp[23,*]=binCounts[14,*]
  binSizeUp[24,*]=binCounts[15,*]
  binSizeUp[25,*]=binCounts[15,*]
  binSizeUp[26,*]=binCounts[16,*]
  binSizeUp[27,*]=binCounts[16,*]
  binSizeUp[28,*]=binCounts[17,*]
  binSizeUp[29,*]=binCounts[17,*]
  binSizeUp[30,*]=binCounts[18,*]
  binSizeUp[31,*]=binCounts[18,*]
  binSizeUp[32,*]=binCounts[19,*]
  binSizeUp[33,*]=binCounts[19,*]
  binSizeUp[34,*]=binCounts[20,*]
  binSizeUp[35,*]=binCounts[20,*]
  binSizeUp[36,*]=binCounts[21,*]
  binSizeUp[37,*]=binCounts[21,*]
  binSizeUp[38,*]=binCounts[22,*]
  binSizeUp[39,*]=binCounts[22,*]
  binSizeUp[40,*]=binCounts[23,*]
  binSizeUp[41,*]=binCounts[23,*]
  binSizeUp[42,*]=binCounts[24,*]
  binSizeUp[43,*]=binCounts[24,*]
  binSizeUp[44,*]=binCounts[25,*]
  binSizeUp[45,*]=binCounts[25,*]
  binSizeUp[46,*]=binCounts[26,*]
  binSizeUp[47,*]=binCounts[26,*]

  

  binCountsSum=dindgen(27,start=0,increment=0)
  for i=0,26 do begin
    binCountsSum[i]=total(binCounts[i,*])
  endfor

  binSizeUpSum=dindgen(48,start=0,increment=0)
  for i=0,47 do begin
    binSizeUpSum[i]=total(binSizeUp[i,*])
  endfor


  for u=0,nRows-1 do begin
    step=fix((float(u))/nRows*100.)
    if step mod 10 eq 0 and step ne 0 then print, strcompress('loop 1->'),string(step)

    date=[date,data.field001[u]]
    hourX=strsplit(data.field002[u],':',/extract)
    hour=[hour,hourX[0]]
    minX=strsplit(data.field002[u],':',/extract)
    min=[min,minX[1]]
    secX=strsplit(data.field002[u],':',/extract)
    secXB=strsplit(secX[2],'.',/extract)
    sec=[sec,secXB[0]]
    rejectADC=[rejectADC,rejectADCCol[u]]
    aveTransReject=[aveTransReject,aveTransRejectCol[u]]
    dofReject=[dofReject,dofRejectCol[u]]
    binCountsSecSum=[binCountsSecSum,total(binCounts[*,u])]
    

    pbpArr=[]

    for i=0,255 do begin
      toDecTime=[]
      toDecD=[]
      calcTime=0


      val=binary(pbp[i,u])


      valTime=reverse(val[0:19])
      valD=reverse(val[20:31])

      for j=0,19 do begin
        toDecTime=[toDecTime,valTime[j]*2.^j]
        if toDecTime[j] gt 0.000001 then calcTime=1
      endfor

      for j=0,11 do begin
        toDecD=[toDecD,valD[j]*2.^j]
      endfor

      if total(toDecD) gt .000001 then begin
        pbpACD[i,u]=total(toDecD)
      endif else begin
        pbpACD[i,u]=!VALUES.F_NAN
      endelse


      if calcTime then begin
        pbpTime[i,u]=(total(toDecTime)+firstTime)/1d6+i
      endif else begin
        pbpTime[i,u]=!VALUES.F_NAN
      endelse

    endfor
  endfor




  for j=0,n_elements(pbpACD[0,*])-1 do begin
    step=fix((float(j))/(n_elements(pbpACD[0,*])-1)*100.)
    if step mod 10 eq 0 and step ne 0 then print, strcompress('loop 2->'),string(step)
    for i=0,n_elements(pbpACD[*,0])-1 do begin
      if pbpACD[i,j] gt binADCBounds[0] and pbpACD[i,j] ne 4095. then begin
        x=where(pbpACD[i,j] lt binADCBounds)
        x=x[0]
        if x eq -1 and pbpACD[i,j] gt binADCBounds[0] then begin
          pbpBin[i,j]=!VALUES.F_NAN
          pbpD[i,j]=!VALUES.F_NAN
        endif else begin
          pbpBin[i,j]=x
          pbpD[i,j]=binDBounds[x]
        endelse
      endif else begin
        pbpBin[i,j]=!VALUES.F_NAN
        pbpD[i,j]=1.
      endelse
    endfor
  endfor
  
  

  save,filename='cdpdata.sav',date,hour,min,sec,binCounts,binCountsSum,binSizeUp,binSizeUpSum,rejectADC,aveTransReject,dofReject,$
    runtime,binCountsSecSum,pbpD

end