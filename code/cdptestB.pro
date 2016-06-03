pro cdptestB
  restore,'cdpdata.sav'
  cgcleanup
  
  p1=barplot(xbin,pbpdsum,histogram=0,dimensions=[1600,1200],nbars=2,index=1,fill_color='red')
  p1=barplot(xbin,bindsum,histogram=0,nbars=2,index=0,/overplot)


end