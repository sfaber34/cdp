pro cdpMonteCarlo

areaQ=2.4e-7 ;qualified area [m2]
areaE=2.01e-5 ;extended area [m2]
dt=2.5e-7 ;time for 1 clock cycle [s]

conc=1000d
simDist=10d ;simulation distance [m]
as=100d ;airspeed [m s-1]


nArrQ=(as*areaQ*conc*(1d6)) ;mean number drops crossing sample area [drops s-1]
nArrE=(as*areaE*conc*(1d6))

t=0d
tLastDropQ=0d
tLastDropE=0d
time=simDist/as
tArr=[]

tNextDropQ=1d/randomu(!null,poisson=nArrQ,/double)
tNextDropE=1d/randomu(!null,poisson=nArrE,/double)


while t lt time do begin
  dt=min([tNextDropQ,tNextDropE])
  
  if tNextDropQ le tLastDropQ then begin
    tArr=[tArr,tLastDropQ]  
    tLastDropQ=0d
    ;tNextDropQ=1d/randomu(!null,poisson=nArrQ,/double)
    tNextDropQ=(-1d)*(alog(randomu(!null,/double))*(1d/nArrQ))
  endif
    tLastDropQ=tLastDropQ+dt
    t=t+dt
endwhile

stop
;arr=[]
;for i=0,9999 do begin
;  x=randomu(fu,poisson=90)
;  arr=[arr,x]
;endfor
;
;h1=histogram(arr)
;b1=barplot(dindgen(n1(h1),start=min(x),increment=1),h1)
end