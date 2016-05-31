pro cdptestB
  restore,'cdpdata.sav'

;  p1=plot(runtime,aveTransReject,dimensions=[1600,1200])
;  p2=plot(runtime,dofReject,/overplot,'r')
;  p3=plot(runtime,binCountsSecSum,/overplot,'b')
  

  p1=barplot(dindgen(27,start=0,increment=1),binCountsSum,histogram=1,dimensions=[1600,1200])
  p2=barplot(dindgen(48,start=2,increment=1),binSizeUpSum,histogram=1)
end