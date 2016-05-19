pro bin2dec


xbins=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
xbinlabels=[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]


;data=read_csv('data/CDP_20160512_173403.csv')
data=read_csv('data/shortTest.csv')

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

for u=0,nRows-1 do begin
  date[u]=data.field001[0]
  
  ;ASSIGN PBP
  for i=0,204 do begin
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
  firstZero=where(pbp eq 0)
  
  for i=0,firstZero[0] do begin
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
    pbpTime[i,u]=total(toDecTime)   
    
  endfor
endfor


for j=0,n_elements(pbpTime[0,*])-1 do begin
  for i=0,n_elements(pbpTime[*,0])-1 do begin
    x=[x,pbpTime[i,j]]
    y=[y,pbpD[i,j]]
  endfor
endfor


p1=scatterplot(x,y)


stop



print,'Time=',valB,'->',total(toDecTime)
;print,'Diam=',valB,'->',total(toDecD)


print, total(sum)

end