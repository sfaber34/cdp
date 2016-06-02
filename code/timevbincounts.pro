pro timeVBinCounts
  restore,'cdpdata.sav'
  cgcleanup

  p1=plot(runTime,bincounts[0,*]+bincounts[1,*]+bincounts[2,*]+bincounts[3,*]+bincounts[4,*]+bincounts[5,*]+bincounts[6,*]+bincounts[7,*]+bincounts[8,*],dimensions=[1600,1200])
  p2=plot(runTime,bincounts[9,*]+bincounts[10,*]+bincounts[11,*]+bincounts[12,*]+bincounts[13,*]+bincounts[14,*]+bincounts[15,*]+bincounts[16,*]+bincounts[17,*],'b',/overplot)
  p3=plot(runTime,bincounts[18,*]+bincounts[19,*]+bincounts[20,*]+bincounts[21,*]+bincounts[22,*]+bincounts[23,*]+bincounts[24,*]+bincounts[25,*]+bincounts[26,*],'r',/overplot)


  p4=plot(runTime,pbpsecsum,dimensions=[1600,1200])
  


end