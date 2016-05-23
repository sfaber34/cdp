pro bin2dec


binDBounds=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
binDLabels=[3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]

;binADCBounds=[91,111,159,190,215,243,254,272,301,355,382,488,636,751,846,959,1070,1297,1452,1665,1851,2016,2230,2513,2771,3003,3220,3424,3660,4095]
binADCBounds=[83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]




data=read_csv('data/cdpPbp050516.csv')

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
date=make_array(nRows,/string)
x=[]
y=[]


firstTime=data.(49)

for u=0,nRows-1 do begin
  step=fix((float(u))/nRows*100.)
  if step mod 10 eq 0 and step ne 0 then print, strcompress('loop 1->'),string(step)
  
  date[u]=data.field001[0]
  
  ;ASSIGN PBP
  for i=0,254 do begin
    x=data.(i+50)
    pbp[i,u]=x[u]
  endfor
  
  
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
    if pbpACD[i,j] gt 0. then begin      
      for e=0,n_elements(pbpACD)-1 do begin
        if e lt 30 then begin
          if binADCBounds[e] gt pbpACD[i,j] then begin
            pbpBin[i,j]=e+1
            pbpDLow[i,j]=binDBounds[e+1]
            pbpDUp[i,j]=binDBounds[e+1]
            break
          endif else begin
            if e eq 30 then begin
              pbpBin[i,j]=e
              pbpDLow[i,j]=binDBounds[e]
              pbpDUp[i,j]=binDBounds[e]
              break
            endif
          endelse
        endif
      endfor
    endif else begin
      break
    endelse
  endfor
endfor



pbpDLow=pbpDLow[where(pbpACD gt .000000001)]
pbpTime=pbpTime[where(pbpTime gt .000000001)]
pbpACD=pbpACD[where(pbpACD gt .000000001)]


;p1=scatterplot(pbpTime,pbpACD)
;p1.yrange=[1700,2150]

h1=histogram(pbpDLow, min=4)
p1=barplot(dindgen(n_elements(h1),start=0,increment=1),h1)
stop


end