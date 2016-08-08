function test5PsiVals

;---------------------FOR 30 UM 16MM TESTS ON 07/28/16 VARIABLE PSI----------------------------
files=['30umtest/CDP_20160728_213831','30umtest/CDP_20160728_222600','30umtest/CDP_20160728_222907',$
  '30umtest/CDP_20160728_223225','30umtest/CDP_20160728_223533']
height=[16.,16.,16.,16.,16.]
pres=[5.,8.,10.,12.,14.]



;---------------------FOR 30 UM 10.5MM TESTS ON 07/28/16 VARIABLE PSI----------------------------
files=['30umtest/CDP_20160728_204529','30umtest/CDP_20160728_204755','30umtest/CDP_20160728_204938',$
  '30umtest/CDP_20160728_205123','30umtest/CDP_20160728_205306']
height=[10.5,10.5,10.5,10.5,10.5]
pres=[5.,7.,10.,14.,18.]



;---------------------FOR 30 UM 5 PSI TESTS ON 07/28/16 VARIABLE HEIGHT----------------------------
files=['30umtest/CDP_20160728_212253','30umtest/CDP_20160728_212828','30umtest/CDP_20160728_213339',$
  '30umtest/CDP_20160728_213831','30umtest/CDP_20160728_214531','30umtest/CDP_20160728_215443'] ;5 psi variable height
height=[22.7,20.8,18.4,16.,14.,12.]
pres=[5.,5.,5.,5.,5.,5.]

;---------------------FOR 30 UM 7 PSI TESTS ON 07/31/16 VARIABLE HEIGHT----------------------------
;files=['CDP_20160731_224433'] ;5 psi variable height
;height=[16.7]
;pres=[7.]





return,{files:files,height:height,pres:pres}
end




pro makeCdpSaves
  files=test5PsiVals()
  files=files.(0)
  for i=0,n(files) do begin
    cdpBase,file='data/'+files[i]+'.csv'
  endfor
end





pro plotBinDist
  input=test5PsiVals()
  files=input.(0)
  files=strsplit(files,'_',/extract)
  files=files.toarray()
  files=files[*,2]
  
  height=input.(1)
  pres=input.(2)
  
  varX=height
  
  
  for i=0,n(files) do begin
    restore,file='saves/'+files[i]+'.sav'
    plot=cdpHist(binNSum)
    plot.title=string(varX[i])
  endfor
end




pro plotCounts
  input=test5PsiVals()
  files=input.(0)
  files=strsplit(files,'_',/extract)
  files=files.toarray()
  files=files[*,2]

  height=input.(1)
  pres=input.(2)
  
  
  xVar=height
  
  
  for i=0,n(files) do begin
    restore,file='saves/'+files[i]+'.sav'
    plot=plot(binNSecSum)
    plot.title=string(xVar[i])
  endfor
end



pro vSecCounts
  input=test5PsiVals()
  files=input.(0)
  files=strsplit(files,'_',/extract)
  files=files.toarray()
  files=files[*,2]

  height=input.(1)
  pres=input.(2)  
  
  
  
  medCounts=[]
  q1Counts=[]
  q3Counts=[]
  binNMedB=[]
  varYB=[]
  for i=0,n(files) do begin
    restore,file='saves/'+files[i]+'.sav'
    
    varX=height
    varY=binNSkew
    
    countErr=abs(60.-binNSecSum)
    
    q1Counts=[q1Counts,q1(countErr)]
    q3Counts=[q3Counts,q3(countErr)]
    medCounts=[medCounts,mean(countErr)]
    binNMedB=[binNMedB,binNMed]
    varYB=[varYB,VarY]
  endfor
  
  s10=scatterplot(varX,binNMedB)
  
  s1=scatterplot(varX,medCounts,sym_color='blue',sym_filled=1,symbol='plus',sym_size=2.5)
  s2=scatterplot(varX,q3Counts,sym_color='red',/overplot,symbol='plus',sym_size=2)
  s3=scatterplot(varX,q1Counts,sym_color='red',/overplot,symbol='plus',sym_size=2)
  s3.font_size=22
end




pro vBin
  input=test5PsiVals()
  files=input.(0)
  files=strsplit(files,'_',/extract)
  files=files.toarray()
  files=files[*,2]

  height=input.(1)
  pres=input.(2)



  medCounts=[]
  q1Counts=[]
  q3Counts=[]
  binNMedB=[]
  varYB=[]
  for i=0,n(files) do begin
    restore,file='saves/'+files[i]+'.sav'

    varX=height
    varY=binNSkew

    countErr=60.-binNSecSum

    q1Counts=[q1Counts,q1(binnsum)]
    q3Counts=[q3Counts,q3(binnsum)]
    medCounts=[medCounts,med(binnsum)]
    binNMedB=[binNMedB,binNMed]
    varYB=[varYB,VarY]
  endfor

  s10=scatterplot(varX,binNMedB)

  s1=scatterplot(varX,medCounts,sym_color='blue')
  s2=scatterplot(varX,q3Counts,sym_color='red',/overplot)
  s3=scatterplot(varX,q1Counts,sym_color='red',/overplot)
end