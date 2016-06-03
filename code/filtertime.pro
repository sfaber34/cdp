pro filterTime, t1, t2
  restore,'cdpdata.sav'
  
  date=date[t1:t2]
  hour=hour[t1:t2]
  min=min[t1:t2]
  sec=sec[t1:t2]
  binD=binD[t1:t2]
  binDSum=binDSum[t1:t2]
  binDEx=binDEx[t1:t2]
  binDExSum=binDExSum[t1:t2]
  adcReject=adcReject[t1:t2]
  aveTransReject=aveTransReject[t1:t2]
  dofReject=dofReject[t1:t2]
  runtime=runtime[t1:t2]
  binsecsum=binsecsum[t1:t2]
  pbpD=pbpD[t1:t2]
  pbpBin=pbpBin[t1:t2]
  xBin=xBin[t1:t2]
  xBinEx=xBinEx[t1:t2]
  pbpSecSum=pbpSecSum[t1:t2]
  pbpDEx=pbpDEx[t1:t2]
  pbpDSum=pbpDSum[t1:t2]
  pbpDExSum=pbpDExSum[t1:t2]
  pbpACD=pbpACD[t1:t2]
  pbpTime=pbpTime[t1:t2]
  
  save,filename='cdpdatafiltered.sav',date,hour,min,sec,binD,binDSum,binDEx,binDExSum,adcReject,aveTransReject,dofReject,$
    runtime,binsecsum,pbpD,pbpBin,xBin,xBinEx,pbpSecSum,pbpDEx,pbpDSum,pbpDExSum,pbpACD,pbpTime,/verbose
end

pro showTime
  restore,'cdpdata.sav'
  cgcleanup

  p1=plot(runTime,binsecsum,dimensions=[1600,1200])

end
