pro cdptestB
  restore,'cdpdata.sav'
  cgcleanup
  
  p1=barplot(dindgen(48,start=0,increment=1),pbpdexsum,histogram=0,dimensions=[1600,1200],nbars=2,index=1,fill_color='red')
  p1=barplot(dindgen(48,start=0,increment=1),bindexsum,histogram=0,nbars=2,index=0,/overplot)


end