pro dsdExamples
  

  countsIn=[[0,2.,0,3.,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],$
  [0,0,0,3.,0,2.,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
  
  diamIn=[1.5,2.5,3.5,4.5,5.5,6.5,7.5,9.,11.,13.,15.,17.,19.,21.,23.,25.,27.,29.,31.,33.,35.,37.,39.,41.,43.,45.,47.,49.]
  diamLabels=[2,3,4,5,6,7,8,10,12.,14.,16.,18.,20.,22.,24.,26.,28.,30.,32.,34.,36.,38.,30.,42.,44.,46.,48.,50.]
  
;  counts=[2,3]
;  diam=[2.5,4.5]
  
  ;mean=3.7
  ;vmd=4.29483
  
  w=window(dimensions=[1600,1200])
  
  for i=0,n_elements(countsIn[0,*])-1 do begin
    counts=countsIn[*,i]
    diam=diamIn
    
    nonZero=where(counts gt 0)
    counts=counts[nonZero]
    diam=diam[nonZero]
    
    diamMin=min(diam)
    diamMax=max(diam)
    
    diamHistX=dindgen(28,start=1,increment=1)
    firstM=total(counts*diam)/total(counts)
    
    xb=(diam)^3.*(counts)
    xc=(diam)^4.*(counts)
    vmd=total(xc)/total(xb)
    
    p1=barplot(diam,counts,histogram=1,xtickname=string(diamLabels),dimensions=[1600,1200],layout=[1,2,i+1],margin=50,/device,/current)
    t1=text(1400,890-(i*900/2),string(firstM),/device)
    t2=text(1400,870-(i*900/2),string(vmd),/device)
    t2=text(1400,850-(i*900/2),string(vmd-firstM),/device)
  endfor
  
end