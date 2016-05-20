pro bin2dec


xbins=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
xbinlabels=[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]

binLoc=[91,111,159,190,215,243,254,272,301,355,382,488,636,751,846,959,1070,1297,1452,1665,1851,2016,2230,2513,2771,3003,3220,3424,3660,4095]
x=[80,3700]
bins=dindgen(n_elements(x))

for i=0,n_elements(x)-1 do begin
  for e=0,n_elements(binLoc)-1 do begin
    if x[i] lt binLoc[e] then begin
      bins[i]=e+1
      break
    endif
  endfor
endfor




;data=read_csv('data/CDP_20160512_173403.csv')
data=read_csv('data/CDP_20160519_203922D.csv')

nRows = n_elements(data.(0))

time = make_array(nRows)
pbp=make_array(255,nRows,/long)
val=make_array(255,nRows)
pbpD=make_array(255,nRows)
pbpTime=make_array(255,nRows)
binCounts=make_array(30,nRows)
date=make_array(nRows,/string)
x=[]
y=[]


firstTime=data.(49)

for u=0,nRows-1 do begin
  date[u]=data.field001[0]
  
  ;ASSIGN PBP
  for i=0,254 do begin
    x=data.(i+50)
    pbp[i,u]=x[u]
  endfor
  
  
  ;ASSIGN BIN COUNTS
;  for k=0,29 do begin
;    binCounts[k,u]=data.(k+19)
;  endfor
  
  
;  for m=0,29 do begin
;    binsums=total(binCounts[m,u])
;  endfor
  
  pbpArr=[]
  ;firstZero=where(pbp eq 0)  
  
  for i=0,254 do begin
    toDecTime=[]
    toDecD=[]
    
    
    val=binary(pbp[i,u])
    
    
    valTime=reverse(val[0:19])
    valD=reverse(val[20:31]) 
    
    for j=0,19 do begin
      toDecTime=[toDecTime,valTime[j]*2.^j]
    endfor
  
    for j=0,11 do begin
      toDecD=[toDecD,valD[j]*2.^j]
    endfor
          
       
    pbpD[i,u]=total(toDecD)
    pbpTime[i,u]=total(toDecTime)+firstTime[u]+u*1000.   
    
  endfor
endfor

pbpTime=pbpTime[where(pbpD ne 0)]
pbpD=pbpD[where(pbpD ne 0)]


;x=reform(pbpTime,n_elements(pbpTime))
;y=reform(pbpD,n_elements(pbpD))


binLoc=[20,83,105,173,219,265,307,353,367,407,428,445,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]
histBins=histogram(pbpD,locations=binLoc,nbins=30)
print,pbpD
p1=scatterplot(pbpTime,pbpD)
p1.yrange=[1700,2150]

stop



print,'Time=',valB,'->',total(toDecTime)
;print,'Diam=',valB,'->',total(toDecD)


print, total(sum)

end