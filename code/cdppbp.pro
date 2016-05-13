pro cdpPbp


  data=read_csv('data/CDP_20160512_173403.csv')

;  t1[0]= where(time eq '18:22:10.70')
;  t1[1]= where(time eq '18:22:12.70')
  
  nRows = n_elements(data.(0))

  time = make_array(nRows)
  pbp=make_array(255,nRows)
  binCounts=make_array(30,nRows)

  date=data.field001[0]
  
  ;ASSIGN PBP
  for i=0,254 do begin
    pbp[i,*]=data.(i+50)
  endfor
  
  ;ASSIGN BIN COUNTS
  for k=0,29 do begin
    binCounts[k,*]=data.(k+19)
  endfor
  
  
  for m=0,29 do begin
    binsums=total(binCounts[m,*])
  endfor
  
  
  print, binCounts[*,0]

  xbins=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  xbinlabels=[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]


 
  return

end