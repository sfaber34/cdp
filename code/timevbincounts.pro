pro timeVbinCounts
  restore,'cdpdatafilter.sav'
  cgcleanup
  
  g1=binD[0,*]+binD[1,*]+binD[2,*]+binD[3,*]+binD[4,*]+binD[5,*]+binD[6,*]+binD[7,*]+binD[8,*]
  g2=binD[9,*]+binD[10,*]+binD[11,*]+binD[12,*]+binD[13,*]+binD[14,*]+binD[15,*]+binD[16,*]+binD[17,*]
  g3=binD[18,*]+binD[19,*]+binD[20,*]+binD[21,*]+binD[22,*]+binD[23,*]+binD[24,*]+binD[25,*]+binD[26,*]

  p1=plot(runTime,g1,dimensions=[1600,1200],layout=[1,3,1],margin=[30,30,30,30],/device)
  p2=plot(runTime,g1+g2,'b',layout=[1,3,2],margin=[30,30,30,40],/device,/current)
  p3=plot(runTime,g1+g2+g3,'r',layout=[1,3,3],margin=[30,50,30,40],/device,/current)


  p4=plot(runTime,binsecsum,dimensions=[1600,1200])
  


end