pro parseLogOld

  ;-----READ FILE-----
  path='data/logs/logi.log'
  openr,lun,path,/get_lun

  array = ''
  line = ''
  WHILE NOT EOF(lun) DO BEGIN &
  READF, lun, line & array = [array, line]
ENDWHILE

free_lun,lun


setVelI=[]
for i=0,n(array) do begin
  if strmatch(array[i],'*Sets Velocity*') ne 0 then setVelI=[setVelI,i]
endfor

array=array[max(setVelI)+1.:n(array)]


;-----SEARCH FILE/FIND LINES-----
xMoveRelStartI=[]
xMoveEndI=[]
xMoveEndPosI=[]
xMoveAbsStartI=[]

yMoveRelStartI=[]
yMoveEndI=[]
yMoveEndPosI=[]
yMoveAbsStartI=[]



for i=0,n(array) do begin
  if strmatch(array[i],'*70868919-1*::MoveRelative*') ne 0 then xMoveRelStartI=[xMoveRelStartI,i]
  ;if strmatch(array[i],'*70868919-1*::MoveTo*') ne 0 then xMoveAbsStartI=[xMoveAbsStartI,i]
  if strmatch(array[i],'*70868919-1*::Moved*') ne 0 then xMoveEndI=[xMoveEndI,i]
  if strmatch(array[i],'*70868919-1*Position:*') ne 0 and strmatch(array[i],'*,*Moving*') eq 0 then xMoveEndPosI=[xMoveEndPosI,i]

  if strmatch(array[i],'*70868919-2*::MoveRelative*') ne 0 then yMoveRelStartI=[yMoveRelStartI,i]
  ;if strmatch(array[i],'*70868919-2*::MoveTo*') ne 0 then yMoveAbsStartI=[yMoveAbsStartI,i]
  if strmatch(array[i],'*70868919-2*::Moved*') ne 0 then yMoveEndI=[yMoveEndI,i]
  if strmatch(array[i],'*70868919-2*Position:*') ne 0 and strmatch(array[i],'*,*Moving*') eq 0 then yMoveEndPosI=[yMoveEndPosI,i]
endfor



;xMoveAbsStartTime=getTime(array[xMoveAbsStartI])
xMoveRelStartTime=getTime(array[xMoveRelStartI])
xMoveStartTime=xMoveRelStartTime
xMoveEndTime=getTime(array[xMoveEndI])

;yMoveAbsStartTime=getTime(array[yMoveAbsStartI])
yMoveRelStartTime=getTime(array[yMoveRelStartI])
yMoveStartTime=yMoveRelStartTime
yMoveEndTime=getTime(array[yMoveEndI])

moveStartTime=[xMoveStartTime,yMoveStartTime]
moveStartTime=moveStartTime[sort(moveStartTime)]

moveEndTime=[xMoveEndTime,yMoveEndTime]
moveEndTime=moveEndTime[sort(moveEndTime)]

xMoveEndPos=[]
for i=0,n(xMoveEndPosI) do begin
  xMoveEndPos=[xMoveEndPos,getPos(array[xMoveEndPosI[i]])]
endfor

yMoveEndPos=[]
for i=0,n(yMoveEndPosI) do begin
  yMoveEndPos=[yMoveEndPos,getPos(array[yMoveEndPosI[i]])]
endfor
yMoveEndPos=[max(yMoveEndPos),yMoveEndPos]
xMoveEndPos=xMoveEndPos[0:n(xMoveEndPos)-1]
xMoveEndPos=xMoveEndPos/409600.*100.
yMoveEndPos=yMoveEndPos/409600.*100.

moveRatio=floor(n1(yMoveEndPos)/n1(xMoveEndPos))+1.


xMoveEndPosEx=[]
yMoveEndPosEx=[]
for i=0,n(xMoveEndPos) do begin
  xMoveEndPosEx=[xMoveEndPosEx,replicate(xMoveEndPos[i],moveRatio)]
endfor

yMoveEndPosSub=yMoveEndPos[0:moveRatio-1]
yMoveEndPosSubB=reverse(yMoveEndPosSub)
yPosMax=max(yMoveEndPosSub)
yPosMin=min(yMoveEndPosSub)

yMoveEndPosCon=[]
for i=0, n1(xMoveEndPosEx)/moveRatio do begin
  yMoveEndPosEx=[yMoveEndPosEx,yMoveEndPosSub,yMoveEndPosSubB]
endfor

yMoveEndPosEx=yMoveEndPosEx[0:n(xMoveEndPosEx)]




stop


end


function getTimeOld, line
  hour=double(strmid(line,0,1))*3600.
  min=double(strmid(line,3,4))*60.
  sec=double(strmid(line,6,11))
  decTime=hour+min+sec
  return,decTime
end

function getPosOld, line
  valid=strpos(line,'Position: ')
  line=double(strmid(line, valid+10, strlen(line)))

  return,line
end