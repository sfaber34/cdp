pro cdpMonteCarlo

cgcleanup

areaQ=2.4e-7 ;qualified area [m2]
areaE=2.01e-5 ;extended area [m2]
dt=2.5e-7 ;time for 1 clock cycle [s]

conc=1d4
simDist=10d ;simulation distance [m]
as=100d ;airspeed [m s-1]


intArrQ=1d/(as*areaQ*conc*(1d6)) ;idealized interarrival [s]
intArrE=1d/(as*areaE*conc*(1d6))

t=0d
tLastDropQ=0d
tLastDropE=0d
time=simDist/as
tArr=[]
x=[];testing
xTime=[0]

tNextDropQ=1d/randomu(!null,poisson=(1d/intArrQ),/double)
tNextDropE=1d/randomu(!null,poisson=(1d/intArrE),/double)

nt=0d
while t lt time do begin
  dt=min([tNextDropQ,tNextDropE])
  
  if tNextDropQ le tLastDropQ then begin
    x=[x,tNextDropQ]
    tArr=[tArr,tLastDropQ]  
    xTime=[xTime,t]
    tLastDropQ=0d
    tNextDropQ=(-1d)*(alog(randomu(!null,/double))*intArrQ)
  endif
    tLastDropQ=tLastDropQ+dt
    t=t+dt
    nt++
    if(nt eq 1000000) then begin
       print,(t/time)*100d
       nt=0d
    endif
endwhile



tarrNoCo=tarr[where(tarr lt intArrQ)]
tarrCo=tarr[where(tarr gt intArrQ)]

print,n1(tarrCo)/n1(tarr)

nbins=30d

locs=xLog(min(tarr),max(tarr),nbins)
binnedRatio = Value_Locate(locs, tarrCo)
hCo=float(histogram(binnedRatio,min=0,max=nbins-1))


binnedRatioB = Value_Locate(locs, tarrnoco)
hNoCo=float(histogram(binnedRatioB,min=0,max=nbins-1))

freqco=hCo/total(tarr)

b1=barplot(dindgen(n1(hCo),start=0,increment=1),freqco,fill_color='red',dimensions=[1600,1000],margin=50,transparency=30,/device)
b2=barplot(dindgen(n1(hNoCo),start=0,increment=1),transparency=30,hNoCo/total(tarr),xtickname=string(locs),/overplot)


end