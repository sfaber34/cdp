pro bin2dec


binDBounds=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
binDLabels=[3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
binADCBounds=[30,83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]

;-------------------------------------------------------------------MOD BINS--------------------------------------------------------------------
;binDBounds=[0,2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
;binDLabels=[3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
;binADCBounds=[30,83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]



;data=read_csv('data/cdpPbp050516.csv')
data=read_csv('data/CDP_20160519_203922D.csv')


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


for i=0,254 do begin
  x=data.(i+50)
  pbp[i,*]=x
endfor

;ASSIGN BIN COUNTS
for i=0,29 do begin
  k=data.(i+19)
  binCounts[i,*]=k
endfor


for u=0,nRows-1 do begin
  step=fix((float(u))/nRows*100.)
  if step mod 10 eq 0 and step ne 0 then print, strcompress('loop 1->'),string(step)
  
  date[u]=data.field001[0]
  
  ;ASSIGN PBP
  
  
  
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
      ;t=0   
      ;for e=0,n_elements(pbpACD)-1 do begin
        ;if t lt n_elements(binDBounds)-1d then begin
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
          
          
;          if pbpDUp[i,j] gt 49 then begin
;            stop
;          endif
;          if binADCBounds[t] gt pbpACD[i,j] and t ne 0 then begin
;            pbpBin[i,j]=t
;            pbpDLow[i,j]=binDBounds[t-1]
;            pbpDUp[i,j]=binDBounds[t]          
;            break
;          endif
;          if binADCBounds[t] gt pbpACD[i,j] and t eq 0 then begin
;            pbpBin[i,j]=!VALUES.F_NAN
;            pbpDLow[i,j]=!VALUES.F_NAN
;            pbpDUp[i,j]=!VALUES.F_NAN
;            break
;          endif
;          if 0 eq 1 then begin
;            pbpBin[i,j]=!VALUES.F_NAN
;            pbpDLow[i,j]=!VALUES.F_NAN
;            pbpDUp[i,j]=!VALUES.F_NAN
;          endif
          ;t++
        ;endif
      ;endfor
    endif
  endfor
endfor



pbpDLow=pbpDLow[where(pbpACD gt .000000001)]
pbpDUp=pbpDUp[where(pbpACD gt .000000001)]
pbpTime=pbpTime[where(pbpTime gt .000000001)]
pbpACD=pbpACD[where(pbpACD gt .000000001)]


;p1=scatterplot(pbpTime,pbpACD)
;p1.yrange=[1700,2150]

h1=histogram(pbpDLow, min=2)
p1=barplot(dindgen(n_elements(h1),start=2,increment=1),h1)
stop


end