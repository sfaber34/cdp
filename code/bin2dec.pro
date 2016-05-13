pro bin2dec
;bin='' - returned 37
bin='000111011110001100010111000011'

;11100011 -2
;00011101 -3
;11000011 -0
;000101   -1


binArr=[]

for i=0,bin.strlen()-1 do begin
  binArr=[binArr,float(bin.charat(i))]
endfor

binArr2=binArr[19:n_elements(binArr)-1]

sum=[]
k=n_elements(binArr2)-1

for i=0,n_elements(binArr2)-1 do begin 
  sum=[sum,binArr2[i]*2.^k]
  k--
endfor

print, total(sum)

end