pro calGlares
  px20=[8,8,7,8,9,8,8,9,8,8,8,9,9,10,9,10,9,9,8,9] ;20 um
  px40=[19,18,18,19,17,18,18,18,19,19,18,18,18,17,16,18,18,18,17,16] ;40 um
  px50=[20,21,18,20,21,21,18,19,19,20,19,20,18,22,21,21,21,20,21,22] ;50 um
  
  xVar=[replicate(18.2,20),replicate(42.3,20),replicate(49.,20)]
  yVar=[px20,px40,px50]
  
  zeros=dindgen(100000)*0
  s1=scatterplot(xVar,yVar,dimensions=[1100,900])
  f1=linfit([zeros,xVar],[zeros,yVar])
  xF=dindgen(61)
  p1=plot(xF,f1[0]+xF*f1[1],'r',/overplot)
  
  ;--- =0.41922800 px/um
  ;--- =2.3853369 um/px   
end