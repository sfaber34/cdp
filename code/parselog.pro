pro parseLog
  
  name='logTimingTestB'
  path='data/logSaves/logSave'+name+'.sav'
  
  restore,path
  
  ;----FILTER TO SEQUENCE BOUNDS-----
  seqStart=[]
  seqEnd=[]
  for i=double(0),n(array) do begin
    if strmatch(array[i],'*MoveTo:*') ne 0 then seqStart=[seqStart,i]
    if strmatch(array[i],'*Sequencer - StateChange: Idle*') ne 0 then seqEnd=[seqEnd,i]
  endfor
  
  array=array[seqStart[0]:seqEnd]
  
  
  ;---------GET MOVE INDS-------------
  startI=[]
  startAbsI=[]
  startDescIPre=[]
  endAbsI=[]
  endI=[]
  endPosBothI=[]
  for i=double(0),n(array) do begin
    if strmatch(array[i],'*::MoveRelative*') ne 0 then startI=[startI,i]
    if strmatch(array[i],'*::MoveTo*') ne 0 then startAbsI=[startAbsI,i]
    if strmatch(array[i],'*Description:*') ne 0 then startDescIPre=[startDescIPre,i]
    if strmatch(array[i],'*Task Completed: Performs a MoveRelative command*') ne 0 then endI=[endI,i]
    if strmatch(array[i],'*Task Completed: Performs a MoveTo command*') ne 0 then endAbsI=[endAbsI,i]
    if strmatch(array[i],'*MOTOR_REPLY_STATUS*Status: 80101400*Position:*') ne 0 then endPosBothI=[endPosBothI,i]
  endfor
  
  startTimeI=startI-1
  startTimeAbsI=startAbsI-1

  startDescI=[]
  for i=double(0), n(startI) do begin
    moveDiff=double(startI[i]-startDescIPre)
    moveDiff[where(moveDiff lt 0)]=!values.d_nan
    startDescI=[startDescI,startDescIPre[where(moveDiff eq min(moveDiff))]]
  endfor
  
  startDescAbsI=[]
  for i=double(0), n(startAbsI) do begin
    moveDiff=double(startAbsI[i]-startDescIPre)
    moveDiff[where(moveDiff lt 0)]=!values.d_nan
    startDescAbsI=[startDescAbsI,startDescIPre[where(moveDiff eq min(moveDiff))]]
  endfor
  
  motorNumI=startDescI+1
  motorNumAbsI=startDescAbsI+1
  
  ;-----------PARSE INFO-----------
  startTime=getTime(array[startTimeI])
  startTimeAbs=getTime(array[startTimeAbsI])
  endTime=getTime(array[endI])
  endTimeAbs=getTime(array[endAbsI])
  endPosBoth=getPos(array[endPosBothI])/409600. ;IN MICRON OFFSET FROM CENTER: 25MM
  motorNum=getMotor(array[motorNumI])
  motorNumAbs=getMotor(array[motorNumAbsI])
  
  desc=getDesc(array[startDescI])
  desc=strcompress(reform(desc,n1(desc[0,*])))
  descNum=convertDesc(desc)
  descAbs=getDesc(array[startdescAbsI])
  descAbs=reform(descAbs,n1(descAbs[0,*]))
  
  endPosAbs=endPosBoth[0:1]
  endPos=endPosBoth[2:n(endPosBoth)]
  
  nXMoves=n1(where(motorNum eq 1))
  nYMoves=n1(where(motorNum eq 2))
  mR=floor(nYMoves/nXMoves)+1.
  
  seqStartTime=max(endTimeAbs)
  startXPos=min(endPosAbs)
  startYPos=max(endPosAbs)
  
  xRepVal=startXPos
  xPos=[xRepVal]  
  for i=double(0),n(endPos) do begin
    if motorNum[i] eq 2 then xPos=[xPos,xRepVal]
    if motorNum[i] eq 1 then begin
      xRepVal=endPos[i]
      xPos=[xPos,xRepVal]
    endif
  endfor
  xPos=xPos[0:n(xPos)-1]
  
  
  
  yPos=[startYPos]
  for i=double(0),n(endPos) do begin
    if motorNum[i] eq 2 then yPos=[yPos,endPos[i]]
    if motorNum[i] eq 1 then yPos=[yPos,endPos[i-1]]
  endfor
  yPos=yPos[0:n(yPos)-1]

  
  ;startTimePos=[endTimeAbs[n(endTimeAbs)],startTime]
  measureStartTime=[endTimeAbs[n(endTimeAbs)],endTime[0:n(measureStart)-1]]
  measureEndTime=startTime
  
  ;--------MAIN ARRAY FOR STORING INTERVAL VALUES---------
  mProps=make_array(4,n1(xPos))
  mProps[0,*]=xPos
  mProps[1,*]=yPos
  mProps[2,*]=measureStartTime
  mProps[3,*]=measureEndTime
  stop
  
  
end


function getTime, line
  hour=double(strmid(line,11,2))*3600.
  min=double(strmid(line,14,2))*60.
  sec=double(strmid(line,17,6))
  decTime=hour+min+sec
  return,decTime
end



function getPos, line
  valid=strpos(line,'Position: ')
  line=double(strmid(line, valid+10, strlen(line)))
  line=line[0,*]
  lineB=reform(line,n1(line[0,*]))
  return,lineB
end



function getDesc, line
  valid=strpos(line,':')
  lineSub=strmid(line, valid+1, strlen(line))
  lineSubB=lineSub[0,*]
  lineSubB=strcompress(lineSubB)
  return, lineSubB
end



function getMotor, line
  valid=strpos(line,':')
  lineSub=strmid(line, valid-1, 1)
  lineSubB=[]
  for i=double(0),n(lineSub[0,*]) do begin
    if lineSub[0,i] eq 1 then lineSubB=[lineSubB,1] else lineSubB=[lineSubB,2]
  endfor
  return,lineSubB
end



function convertDesc, array
  a=where(array eq ' legDown')
  b=where(array eq ' legUp')
  c=where(array eq ' xOverA')
  d=where(array eq ' xOverB')
  
  ret=make_array(n1(array))
  ret[a]=0
  ret[b]=1
  ret[c]=2
  ret[d]=3
  return,ret
end  



pro readLogFile
  ;-----READ FILE-----
  
  name='logTimingTestB'
  
  openPath='data/logs/'+name+'.log'
  savePath='data/logSaves/logSave'+name+'.sav'
  
  openr,lun,openPath,/get_lun

  array = ''
  line = ''
  WHILE NOT EOF(lun) DO BEGIN & $
    READF, lun, line & $
    array = [array, line] & $
  ENDWHILE

  free_lun,lun
  
  save,filename=savePath,array
end  
