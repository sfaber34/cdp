function n, var
  return, float(n_elements(var)-1)
end

function n1, var
  return, float(n_elements(var))
end

function xLog, aIn,bIn,count
    a=float(min([aIn,bIn]))
    b=float(max([aIn,bIn]))
    vals=FINDGEN(count)*(ALOG10(b)-ALOG10(a))/(count-1)+ALOG10(a)
    vals=10.^vals
    return, vals
end  