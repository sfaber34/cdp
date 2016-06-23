pro cdpMonteCarloB

  ;dt=2.5e-7 ;time for 1 clock cycle [s]
  dt=1d-3 ;for testing
  
  saEX=8d-3 ;estimate from lance 2012 [m]
  saEZ=5d-4
  
  conc=200d ;per cm3
  
  
  simDist=1d ;simulation distance [m]
  as=1d ;airspeed [m s-1]
  
  conc=conc*((saEX*saEZ*simDist)*1d6)
  
  
  ;------Create sample area-----
  
  saEcircX=dindgen(800,start=0,increment=saEZ/799.)
  saECircTop=(((.5*saEZ)^2.-(saEcircX-(.5*saEZ))^2.)^(1./2.))+(.5*saEZ)
  saECircBottom=-1.*(((.5*saEZ)^2.-(saEcircX-(.5*saEZ))^2.)^(1./2.))+(.5*saEZ)
  
;  saQcircX=dindgen(800,start=0,increment=saQZ/799.)
;  saQCircTop=(((.5*saQZ)^2.-(saQcircX-(.5*saQZ))^2.)^(1./2.))+(.5*saQZ)
;  saQCircBottom=-1.*(((.5*saQZ)^2.-(saQcircX-(.5*saQZ))^2.)^(1./2.))+(.5*saQZ)
  
  rand=randomu(!null,3,conc,/double)
  nCoords=n1(rand[0,*])
  
  dropX=reform(rand[0,*]*saEX,nCoords)
  dropY=reform(rand[1,*]*simDist,nCoords)
  dropZ=reform(rand[2,*]*saEZ,nCoords)
  
  p1=scatterplot3d(dropY,dropX,dropZ,dimensions=[1600,1200])
  p2=plot3d(dindgen(n1(saEcircX),increment=0,start=(.5*saEZ)),saEcircX,saECircTop,/overplot)
  
  
  p1=plot([0,1],[0,1],dimensions=[1200,800],margin=50,/device,/nodata)
  p1.xrange=[0,simDist]
  p1.yrange=[0,saEZ]
  
  psaETop=plot(saEcircX,saECircTop,/device,/overplot)
  psaeBottom=plot(saEcircX,saECircBottom,/device,/overplot)
  
  s2=scatterplot(dropY,dropZ,symbol='.',sym_size=3,sym_transparency=60,sym_filled=1,title='X/Z',/overplot)

  
  fu = Obj_New('IDLanROI', saEcircX, saECircTop)
  isinsaETop=where(fu->ContainsPoints(dropY,dropZ) eq 1,/null)
  Obj_Destroy, fu
  fuB = Obj_New('IDLanROI', saEcircX, saECircBottom)
  isinsaEBottom=where(fuB->ContainsPoints(dropY,dropZ) eq 1,/null)
  Obj_Destroy, fuB
  
  isInSaE=[isinsaETop,isinsaEBottom]
  
  s3=scatterplot(dropY[isInSaE],dropZ[isInSaE],symbol='.',sym_size=5,sym_transparency=30,sym_color='red',sym_filled=1,title='X/Z',/overplot)
  ;s3.xrange=[0,.015]

  stop
end