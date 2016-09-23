pro sizeGlaresDir


  ;--------------PATH--------------------
  dirpath='../images/30umTest080416c/testc/' ; Path to dir containing streaks
  ;dirpath='../images/30umTest080416a/1000/' ; Path to dir containing streaks
  ;dirpath=dialog_pickfile(/read)

  ;--------------OPTIONS-------------------
  test=0
  showImgDir=0
  showImgMark=0

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
    if test eq 1 then imgB=image(imgPath[i])
    imgDir=make_array(n1(img[*,0]))
    imgDirB=make_array(n1(img[*,0]))
    imgMean=make_array(n1(img[*,0]))
    imgsig=make_array(n1(img[*,0]),n1(img[0,*]))
    
    
    for k=0,n(img[*,0]) do begin
      sig=where(img[k,*] gt 0)
      if sig[0] gt -1 then imgmean[k]=total(img[k,sig]) else imgmean[k]=0
    endfor
    
    imgDir=ts_diff(imgmean,1)

    if showImgDir eq 1 then begin
      p1=plot(imgmean)
      p3=plot(imgdir,/overplot,'--r')
    endif
    
    maxDir=where(imgdir eq max(imgDir))
    dirSubset=imgDir
    dirSubset[0:maxDir+1]=!values.d_nan 
    minDir=where(dirSubset eq min(dirSubset))
    
    ;print,mindir-maxDir
    
    if showImgMark eq 1 then begin
      imgB=image(imgPath[i])
      p4=plot([mindir,mindir],[0,400],'b',/overplot)
      p5=plot([maxdir,maxdir],[0,400],'b',/overplot)
    endif
    

    ;Find streak x gaps
    dGlarePx=mindir-maxDir-1
    
    print,imgPath[i]
    print,dGlarePx
    
    dDrop=2.*dGlarePx / (ref*cos(ang) / (1.+ref^2.-2.*ref*cos(ang))^(1./2.) + sin(ang))
    dUm=[temporary(dUm),dDrop*umToPx]
  endfor



  ;----------------------SHOW RESULTS--------------------------
  h1=hist(dum)
  h1.font_size=22
  h1.xrange=[2,50]
  ;h1.xminor=0
  h1.xmajor=13
  h1.ymajor=9


  print,dum
  print,'-----',mean(dum),'-----'

end