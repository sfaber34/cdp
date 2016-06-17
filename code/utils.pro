function n, var
  return, n_elements(var)-1
end

function n1, var
  return, n_elements(var)
end

function xLog, a,b,count
  if (b le a) then begin
    return,'b must be greater than a'
  endif else begin
    vals=FINDGEN(count)*(ALOG10(b)-ALOG10(a))/(count-1)+ALOG10(a)
    vals=10.^vals
    return, vals
  endelse
end  