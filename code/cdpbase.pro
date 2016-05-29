pro cdpBase


  


  data=read_csv('data/CDP_20160512_173403.csv')


  nRows = n_elements(data.(0))

  time = make_array(nRows)
  pbp=make_array(255,nRows,/long)
  val=make_array(255,nRows)
  pbpACD=make_array(255,nRows)
  pbpDLow=make_array(255,nRows)
  pbpDUp=make_array(255,nRows)
  pbpBin=make_array(255,nRows)
  pbpTime=make_array(255,nRows)
  binCounts=make_array(30,nRows)
  binBoundUp=make_array(49,nRows)
  date=[]
  hour=[]
  min=[]
  sec=[]
  x=[]
  y=[]
  
  
  
  
  binDBounds=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  binDLabels=[3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  binADCBounds=[30,83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]




  firstTime=data.(49)


  for i=0,254 do begin
    x=data.(i+50)
    pbp[i,*]=x
  endfor

  ;ASSIGN BIN COUNTS
  for i=0,29 do begin
    k=data.(i+19)
    binCounts[i,*]=k
  endfor

  for i=0,11 do begin
    binBoundUp[i,*]=binCounts[i,*]
  endfor

  binBoundUp[12,*]=binCounts[12,*]
  binBoundUp[13,*]=binCounts[12,*]
  binBoundUp[14,*]=binCounts[13,*]
  binBoundUp[15,*]=binCounts[13,*]
  binBoundUp[16,*]=binCounts[14,*]
  binBoundUp[17,*]=binCounts[14,*]
  binBoundUp[18,*]=binCounts[15,*]
  binBoundUp[19,*]=binCounts[15,*]
  binBoundUp[20,*]=binCounts[16,*]
  binBoundUp[21,*]=binCounts[16,*]
  binBoundUp[22,*]=binCounts[17,*]
  binBoundUp[23,*]=binCounts[17,*]
  binBoundUp[24,*]=binCounts[18,*]
  binBoundUp[25,*]=binCounts[18,*]
  binBoundUp[26,*]=binCounts[19,*]
  binBoundUp[27,*]=binCounts[19,*]
  binBoundUp[28,*]=binCounts[20,*]
  binBoundUp[29,*]=binCounts[20,*]
  binBoundUp[30,*]=binCounts[21,*]
  binBoundUp[31,*]=binCounts[21,*]
  binBoundUp[32,*]=binCounts[22,*]
  binBoundUp[33,*]=binCounts[22,*]
  binBoundUp[34,*]=binCounts[23,*]
  binBoundUp[35,*]=binCounts[23,*]
  binBoundUp[36,*]=binCounts[24,*]
  binBoundUp[37,*]=binCounts[24,*]
  binBoundUp[38,*]=binCounts[25,*]
  binBoundUp[39,*]=binCounts[25,*]
  binBoundUp[40,*]=binCounts[26,*]
  binBoundUp[41,*]=binCounts[26,*]
  binBoundUp[42,*]=binCounts[27,*]
  binBoundUp[43,*]=binCounts[27,*]
  binBoundUp[44,*]=binCounts[28,*]
  binBoundUp[45,*]=binCounts[28,*]
  binBoundUp[46,*]=binCounts[29,*]
  binBoundUp[47,*]=binCounts[29,*]

  binCountsSum=dindgen(30,start=0,increment=0)
  for i=0,29 do begin
    binCountsSum[i]=total(binCounts[i,*])
  endfor

  binBoundUpSum=dindgen(48,start=0,increment=0)
  for i=0,47 do begin
    binBoundUpSum[i]=total(binBoundUp[i,*])
  endfor

  ;p1=barplot(dindgen(30,start=0,increment=1),binCountsSum,histogram=1)
  ;p2=barplot(dindgen(48,start=2,increment=1),binBoundUpSum,histogram=1)


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

    pbpArr=[]

    for i=0,254 do begin
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
        pbpTime[i,u]=(total(toDecTime)+firstTime[u])/1d6+u
      endif else begin
        pbpTime[i,u]=!VALUES.F_NAN
      endelse

    endfor
  endfor




  for j=0,n_elements(pbpACD[0,*])-1 do begin
    step=fix((float(j))/(n_elements(pbpACD[0,*])-1)*100.)
    if step mod 10 eq 0 and step ne 0 then print, strcompress('loop 2->'),string(step)
    for i=0,n_elements(pbpACD[*,0])-1 do begin
      if pbpACD[i,j] gt binADCBounds[0] then begin
        x=where(pbpACD[i,j] lt binADCBounds)
        x=x[0]
        if x eq -1 and pbpACD[i,j] gt binADCBounds[0] then begin
          pbpBin[i,j]=!VALUES.F_NAN
          pbpDLow[i,j]=!VALUES.F_NAN
          pbpDUp[i,j]=!VALUES.F_NAN
        endif else begin
          pbpBin[i,j]=x
          pbpDLow[i,j]=binDBounds[x-1]
          pbpDUp[i,j]=binDBounds[x]
        endelse
      endif
    endfor
  endfor

  save,filename='cdpdata.sav',date,hour,min,sec,binCounts,binCountsSum,binBoundUp,binBoundUpSum

end