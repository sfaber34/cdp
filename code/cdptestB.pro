pro cdptestB
  restore,'cdpdata.sav'
  cgcleanup


  h1=histogram(pbpd[*,*],min=3)
  h2=histogram(binSizeUp[*,*],min=3)
  
  p1=barplot(dindgen(48,start=0,increment=1),h1,histogram=0,dimensions=[1600,1200],nbars=2,index=1,fill_color='red')
  p1=barplot(dindgen(49,start=0,increment=1),binSizeUp,histogram=0,nbars=2,index=0,/overplot)


end