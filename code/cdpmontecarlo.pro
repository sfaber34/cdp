pro cdpMonteCarlo

areaQ=2.4e-7 ;qualified area [m2]
areaE=2.01e-5 ;extended area [m2]
dt=2.5e-7 ;time for 1 clock cycle [s]

conc=1000d
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
endwhile

n=124.
a=1.
b=45935.

elev=FINDGEN(N)*(ALOG10(b)-ALOG10(a))/(N-1)+ALOG10(a)
elev=10.^elev


;arr=[]
;for i=0,9999 do begin
;  x=randomu(fu,poisson=90)
;  arr=[arr,x]
;endfor
;
;h1=histogram(arr)
;b1=barplot(dindgen(n1(h1),start=min(x),increment=1),h1)
end