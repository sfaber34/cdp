pro cdptestB
  restore,'cdpdata.sav'
  cgcleanup


  h1=histogram(pbpbin[*,*],min=1,max=30,nbins=30)
  
  p1=barplot(dindgen(30,start=0,increment=1),h1,histogram=0,dimensions=[1600,1200],nbars=2,index=1,fill_color='red')
  p1=barplot(dindgen(30,start=0,increment=1),binCountsSum,histogram=0,nbars=2,index=0,/overplot)


end