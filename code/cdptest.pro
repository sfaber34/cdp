pro cdptest


  data=read_csv('../data/cdptest2.csv')

  ;  t1[0]= where(time eq '18:22:10.70')
  ;  t1[1]= where(time eq '18:22:12.70')

  nRows = n_elements(data.(0))

  time = make_array(nRows)
  pbp=make_array(nRows,2)

  ;date=data.field001[0]

    for i=0,1 do begin
      pbp[i,*]=data.(i+2)
    endfor
  print, pbp[*,0]

  xbins=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  xbinlabels=[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]



  return

end