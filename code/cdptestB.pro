pro cdptestB
  restore,'cdpdata.sav'
  

  p1=barplot(dindgen(30,start=0,increment=1),binCountsSum,histogram=1)
  p2=barplot(dindgen(48,start=2,increment=1),binBoundUpSum,histogram=1)
end