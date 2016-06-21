pro cdpMonteCarlo

;cgcleanup

areaQ=2.4e-7 ;qualified area [m2]
areaE=2.01e-5 ;extended area [m2]
dt=2.5e-7 ;time for 1 clock cycle [s]

conc=100d6
simDist=100d ;simulation distance [m]
as=50d ;airspeed [m s-1]


intArrQ=1d/(as*areaQ*conc) ;idealized interarrival [s]
intArrE=1d/(as*areaE*conc)

t=0d
tLastDropQ=0d
tLastDropE=0d
time=simDist/as
tArr=[]
x=[]
xTime=[0]
xTimeFlag=0
coQFlag=0
coEFlag=0


flagCoQ=dindgen(100000)
flagCoE=dindgen(100000)
flagCoQ=!values.D_NAN
flagCoE=!values.D_NAN


tNextDropQ=1d/randomu(!null,poisson=(1d/intArrQ),/double)
tNextDropE=1d/randomu(!null,poisson=(1d/intArrE),/double)

nt=0d
tick=0d
while t lt time do begin
  dt=min([tNextDropQ,tNextDropE])
  
  if tNextDropQ le tLastDropQ then begin
    tArr=[temporary(tArr),tLastDropQ]
    tLastDropQ=0d
    tNextDropQ=(-1d)*(alog(randomu(!null,/double)))*intArrQ
    xTimeFlag=1
  endif
  if tNextDropE le tLastDropE then begin
    tArr=[temporary(tArr),tLastDropE]
    tLastDropE=0d
    tNextDropE=(-1d)*(alog(randomu(!null,/double)))*intArrE
    xTimeFlag=1
  endif
  
    tLastDropQ=tLastDropQ+dt
    tLastDropE=tLastDropE+dt
    
    if xTimeFlag then begin
      xTime=[temporary(xTime),t]
      
      
      xTimeFlag=0
    endif  
    
    
    t=t+dt
    nt++
    tick++
    if(nt eq 10000) then begin
       print,ceil((t/time)*100d)
       nt=0d
    endif
endwhile



tarrNoCo=[where(tarr lt intArrQ and tarr lt intArrE)]
tarrCoQ=[where(tarr gt intArrQ)]
tarrCoE=[where(tarr gt intArrE)]


print,n1(tarrCoQ)/n1(tarrNoCo)
print,n1(tarrCoE)/n1(tarrNoCo)

nbins=40d

locs=xLog(min(tarr),max(tarr),nbins)
binnedRatio = Value_Locate(locs, tarr[tarrCoQ])
hCo=float(histogram(binnedRatio,min=0,max=nbins-1))

binnedRatioC = Value_Locate(locs, tarr[tarrCoE])
hCoB=float(histogram(binnedRatioC,min=0,max=nbins-1))

binnedRatioB = Value_Locate(locs, tarr[tarrNoCo])
hNoCo=float(histogram(binnedRatioB,min=0,max=nbins-1))

freqco=hCo/n_elements(tarr)
freqcoB=hCoB/n_elements(tarr)
freqcono=hNoCo/n_elements(tarr)

b1=barplot(dindgen(n1(freqcoB),start=0,increment=1),freqcoB,fill_color='green',dimensions=[1600,1000],margin=[50,100,50,50],transparency=30,/device,histogram=1)
b3=barplot(dindgen(n1(freqco),start=0,increment=1),freqco,fill_color='red',transparency=30,xtickname=string(locs),histogram=1,/overplot)
b2=barplot(dindgen(n1(freqcono),start=0,increment=1),freqcono,transparency=30,xtickname=string(locs),histogram=1,/overplot)
b2.xrange=[0,n1(freqco)]
b2.xmajor=n1(freqco)+1
b2.xtickname=[string(locs),string(max(locs)),' ',' ']
b2.xtext_orientation=90
b2.xticklen=0


end