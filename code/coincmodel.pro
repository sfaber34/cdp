pro coincModel

  ;------------------------------------------------------------------------------------------------------------------------------------------------------
  conc=300
  meanD=5
  nCoinc=50
  ;------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
  

  binD=[2,3,4,5,6,7,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
  binADC=[30,83,105,173,219,265,307,367,428,502,593,726,913,1100,1258,1396,1523,1661,1803,2008,2274,2533,2782,3017,3252,3477,3716,4025]
  ;s1=scatterplot(binD,binADC,dimensions=[1400,1100],/device,margin=60)
  fit1=poly_fit(binD,binADC,10,yfit=yfit)
;  xs=dindgen(1001,start=0,increment=50./1001.)
;  fit1Curve=fit1[0]+fit1[1]*xs+fit1[2]*xs^2.+fit1[3]*xs^3.+fit1[4]*xs^4.+fit1[5]*xs^5.+fit1[6]*xs^6.+fit1[7]*xs^7.+fit1[8]*xs^8.+fit1[9]*xs^9.+fit1[10]*xs^10.
;  p1=plot(xs,fit1Curve,'r',/overplot)
  

  
  ;GENERATE RANDOM GAMMA DROP DIAMETER DISTRIBUTION
  foo=!null
  dDist=randomu(foo,conc,gamma=meanD)
  oobA=where(dDist gt 50)
  oobB=where(dDist lt 2)
  if oobA[0] ne -1 then  dDist[where(dDist gt 50)]=!values.D_infinity
  if oobB[0] ne -1 then dDist[where(dDist lt 2)]=!values.D_nan
  
  ;APPLY SIZER VOTAGE FOR DIAMETER DISTRIBUTION
  adcDist=fit1[0]+fit1[1]*dDist+fit1[2]*dDist^2.+fit1[3]*dDist^3.+fit1[4]*dDist^4.+fit1[5]*dDist^5.+fit1[6]*dDist^6.+fit1[7]*dDist^7.+fit1[8]*dDist^8.+fit1[9]*dDist^9.+fit1[10]*dDist^10.
  
  ;REBIN FOR CDP BINS 
  binN=make_array(n1(binD,-1))*0
  for i=0,n1(binD,-2) do begin
    x=where(adcDist gt binADC[i] and adcDist lt binADC[i+1],count)
    if count ne 0 then binN[i]=count
  endfor
  
  ;MAKE CDP WITHOUT COINC
  h1=barplot(binN,/histogram)
  yBounds=[h1.yrange]
  
  
  ;RANDOMLY PICK DROPS TO APPLY COINC
  coincIA=ceil(randomu(foo,nCoinc)*conc) ;choose inds to take coinc from
  coincIB=ceil(randomu(foo,nCoinc)*conc) ;choose inds to apply coinc to
  coincIA[where(coincIA eq n1(dDist))]=n1(dDist)-1.
  coincIB[where(coincIB eq n1(dDist))]=n1(dDist)-1.
  
  ;SUM COINC DROPS AND REMOVE SELECTED COINC
  coincADC=adcDist[coincIA]
  for i=0,nCoinc-1 do begin
    adcDist[coincIB[i]]=adcDist[coincIB[i]]+adcDist[coincIA[i]]
  endfor
  adcDist[coincIA]=!values.d_nan
  
  ;RECALC CDP HIST FROM ADC VALUES
  binNB=make_array(n1(binD,-1))*0
  for i=0,n1(binADC,-2) do begin
    x=where(adcDist gt binADC[i] and adcDist lt binADC[i+1],count)
    if count ne 0 then binNB[i]=count
  endfor
  h2=barplot(binNB,fill_color='red',/histogram)
  h2.yrange=yBounds
end