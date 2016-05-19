pro toBin

valB=403465290
val=binary(valB)
valTime=reverse(val[0:19])
valD=reverse(val[20:31])

toDecTime=[]
toDecD=[]
for i=0,19 do begin
  toDecTime=[toDecTime,valTime[i]*2.^i]
endfor

for i=0,11 do begin
  toDecD=[toDecD,valD[i]*2.^i]
endfor

print,'Time=',valB,'->',total(toDecTime)
print,'Diam=',valB,'->',total(toDecD)




;number=4
;bin = STRARR(8)
;FOR j=0,7 DO BEGIN
;  powerOfTwo = 2L^j
;  IF (LONG(number) AND powerOfTwo) EQ powerOfTwo THEN $
;    bin(j) = '1' ELSE bin(j) = '0'
;ENDFOR
;bin=reverse(bin)
;print,bin
end