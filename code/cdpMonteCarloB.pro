pro cdpMonteCarloB
  areaQ=2.4e-7 ;qualified area [m2]
  areaE=2.01e-5 ;extended area [m2]
  dt=2.5e-7 ;time for 1 clock cycle [s]
  
  saEX=8d-3 ;estimate from lance 2012 [m]
  ;saEY=5d-4
  
  ;saEX=1d
  saEY=1d

  conc=2d
  simDist=1d ;simulation distance [m]
  as=1d ;airspeed [m s-1]
  
  rand=randomu(!null,2,400,/double)
  
  coordX=rand[0,*]*saEX
  coordY=rand[1,*]*saEY
  
  p1=scatterplot(coordX,coordY)
  stop
  
end