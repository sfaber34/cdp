pro widgetTest

  base = WIDGET_BASE(/COLUMN)
  button = WIDGET_BUTTON(base, value='Done')
  button2 = WIDGET_BUTTON(base, value='asd')
  WIDGET_CONTROL, base, /REALIZE
  XMANAGER, 'w1', base
  

;  restore,'cdpdata.sav'
;  cgcleanup
;  p4=plot(runTime,binsecsum,dimensions=[1600,1200])

end

pro w1_event,x
  print,'test'
  print,x
end