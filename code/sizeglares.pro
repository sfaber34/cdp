pro sizeGlares
  
  
  ;--------------PATH--------------------
  ;dirpath='../images/30umTest080416B/75000' ; Path to dir containing streaks
  dirpath='../images/30umTest080416B/1000/' ; Path to dir containing streaks
  ;dirpath=dialog_pickfile(/read)
  
  ;--------------OPTIONS-------------------
  test=0
  
  threshA=150
  threshB=15
  ref=1.331 ;refractive index of water for .658 um laser
  ang=120. ;camera/laser angle
  ang=.5*ang*!DtoR ;ang=ang/2 and convert to radians
  umToPx=2.4
  
  
  
  imgPath=file_search(dirpath+'*')
  
  ;imgHold=make_array(767,592)
  meanSig=[]
  for i=0,n(imgPath) do begin
    imgHold=read_image(imgPath[i])
    sig=where(imgHold gt threshA)
    gt0=where(imgHold gt 0)
    if max(sig) ne -1 then meanSig=[temporary(meanSig),mean(imgHold[gt0])] else meanSig=[temporary(meanSig),!Values.d_nan]
    meanSigHold=meanSig
  endfor
  
  sigB=where(meanSigHold le q1(meanSig)) ;Find Images with good streaks
  meanSig=meanSigHold
  meanSig[sigB]=!Values.d_nan
  imgPath=imgPath[where(finite(meanSig))] ;Filter path array to only images with good streaks
  
  dUm=[]
  for i=0,n(imgPath) do begin
    img=read_image(imgPath[i])
    ;img=rot(img,20)
    if test eq 1 then imgB=image(imgPath[i])
    ;if test eq 1 then tv,img
    
;    sigVert=whereB(img ge 250,xind=sigVertX,yind=sigVertY) ;For vertically alligning images
;    histVertY=histogram(sigVertY,locations=locs)
;    vertYTop=q3(locs)
;    vertYBottom=q1(locs)
;    vertXTop=med(sigVertX[where(sigVertY eq vertYTop)])
;    vertXBottom=med(sigVertX[where(sigVertY eq vertYBottom)])
;    plot1=plot([vertXBottom,vertXTop],[vertYBottom,vertYTop],/overplot,'r')
;    
;    corAngle=sin((vertYTop-vertYBottom) / (vertXTop-vertXBottom))
;    img=rot(img,corAngle*(1./!dtor*(-1.)))
;    tv,img

    sig=whereB(img ge threshA,xind=sigX,yind=sigY) ;Find large streak signal pixels
    sigSmallStr=whereB(img ge threshB,xind=sigSmallX,yind=sigSmallY) ;Find small streak signal pixels
    
    sigSmallY=sigSmallY[where(sigSmallX gt max(sigX)+ceil((max(sigX)-min(sigX))*1.3))] ;Only select small streak pixels which are right of large streak
    sigSmallX=sigSmallX[where(sigSmallX gt max(sigX)+ceil((max(sigX)-min(sigX))*1.3))]
    
    sigArr=make_array(n1(img[*,0]),n1(img[0,*]))*0
    sigArr[sigX,sigY]=1
    sigArr[sigSmallX,sigSmallY]=1
    if test eq 1 then sigArrSmall=make_array(n1(img[*,0]),n1(img[0,*]))*0 ;For testing only
    if test eq 1 then sigArrSmall[sigSmallX,sigSmallY]=1 ;For testing only

    ;Find the streak center point
    midYHist=histogram(sigY,LOCATIONS=locs)
    locs=locs[where(midYHist eq max(midYHist))]
    midY=locs[.5*n1(locs)]
    midYInds=where(sigArr[*,midY] eq 1)
    
    ;Find streak x gaps
    midYIndsDiff=midYInds-shift(midYInds,1)
    midYIndsDiff=midYIndsDiff[1:n(midYIndsDiff)]
    dGlarePx=max(midYIndsDiff)

    dDrop=2.*dGlarePx / (ref*cos(ang) / (1.+ref^2.-2.*ref*cos(ang))^(1./2.) + sin(ang))
    dUm=[temporary(dUm),dDrop*umToPx]

    if test eq 1 then begin
      s1=scatterplot(sigx+1.,sigy+1.5,symbol='square',sym_size=1.5,sym_color='red',/overplot,sym_transparency=70)
      s1=scatterplot(sigsmallx+1.,sigsmally+1.5,symbol='square',sym_size=1.5,sym_color='red',/overplot,sym_transparency=70)
      ;s1.xrange=[0,767]
      ;s1.yrange=[0,592]
      p1=plot([0,767],[midY,midY],'g',/overplot)
    endif
  endfor
  


  ;----------------------SHOW RESULTS--------------------------
  h1=hist(dum)
  h1.font_size=22
  h1.xrange=[2,50]
  ;h1.xminor=0
  h1.xmajor=13
  
  print,dum
  
end