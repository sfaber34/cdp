pro timeVBinCounts
  restore,'cdpdata.sav'
  cgcleanup
  
  g1=bincounts[0,*]+bincounts[1,*]+bincounts[2,*]+bincounts[3,*]+bincounts[4,*]+bincounts[5,*]+bincounts[6,*]+bincounts[7,*]+bincounts[8,*]
  g2=bincounts[9,*]+bincounts[10,*]+bincounts[11,*]+bincounts[12,*]+bincounts[13,*]+bincounts[14,*]+bincounts[15,*]+bincounts[16,*]+bincounts[17,*]
  g3=bincounts[18,*]+bincounts[19,*]+bincounts[20,*]+bincounts[21,*]+bincounts[22,*]+bincounts[23,*]+bincounts[24,*]+bincounts[25,*]+bincounts[26,*]

  p1=plot(runTime,g1,dimensions=[1600,1200],layout=[1,3,1],margin=[30,30,30,30],/device)
  p2=plot(runTime,g1+g2,'b',layout=[1,3,2],margin=[30,30,30,40],/device,/current)
  p3=plot(runTime,g1+g2+g3,'r',layout=[1,3,3],margin=[30,50,30,40],/device,/current)


  p4=plot(runTime,binsecsum,dimensions=[1600,1200])
  


end