pro sizeGlares
  imgPath='../images/30umtestB/75000/0004.jpg'
  ;imgPath='../images/30umtestB/500/0478.jpg'
  img=read_image(imgPath)
  
  ref=1.331 ;refractive index of water for .658 um laser
  ang=120. ;camera/laser angle
  ang=.5*ang*!DtoR
  
  
  
  threshA=50
  
  imgB=image(img)
  
  sig=whereB(img ge threshA,xind=sigX,yind=sigY)
  sigArr=make_array(n1(img[*,0]),n1(img[0,*]))*0
  sigArr[sigX,sigY]=1
  
  midY=floor(mean(sigY))
  
  midYInds=where(sigArr[*,midY] eq 1)
  midYIndsDiff=midYInds-shift(midYInds,1)
  midYIndsDiff=midYIndsDiff[1:n(midYIndsDiff)]
  
  dGlarePx=max(midYIndsDiff)
  
  dDrop=2.*dGlarePx / (ref*cos(ang) / (1.+ref^2.-2.*ref*cos(ang))^(1./2.) + sin(ang))

  dUm=dDrop*2.3
  
  s1=scatterplot(sigx+1.5,sigy+1.5,symbol='.',sym_size=2,sym_color='red',/overplot)
  s1.xrange=[0,767]
  s1.yrange=[0,592]
  p1=plot([0,767],[midY,midY],'g',/overplot)
  
  print, dum
end