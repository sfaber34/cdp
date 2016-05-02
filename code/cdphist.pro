pro cdphist, data

;prelim steps
;file = dialog_pickfile()
;data = read_csv(file)

;file='Z:\Research\09-29-15\cdp_20150929c.csv'
;line=''
;num_lines=file_lines(file)
;time
;openr, unit, file, /get_lun
;readf, unit, line
;var1=strsplit(line, ',', /extract)

t1 = FLTARR(2)
time = data.field02

;options
individualplots = 0
beadsize = 50

t1[0]= where(time eq '18:22:10.70')
t1[1]= where(time eq '18:22:12.70')

rown = n_elements(time)

cdp = FLTARR(51, rown)


cdp[0,*] = data.field19
cdp[1,*] = data.field20
cdp[2,*] = data.field21
cdp[3,*] = data.field22
cdp[4,*] = data.field23
cdp[5,*] = data.field24
cdp[6,*] = data.field25
cdp[7,*] = data.field26
cdp[8,*] = data.field27
cdp[9,*] = data.field28
cdp[10,*] = data.field29
cdp[11,*] = data.field30
cdp[12,*] = data.field31
cdp[13,*] = data.field32
cdp[14,*] = data.field33
cdp[15,*] = data.field34
cdp[16,*] = data.field35
cdp[17,*] = data.field36
cdp[18,*] = data.field37
cdp[19,*] = data.field38
cdp[20,*] = data.field39
cdp[21,*] = data.field40
cdp[22,*] = data.field41
cdp[23,*] = data.field42
cdp[24,*] = data.field43
cdp[25,*] = data.field44
cdp[26,*] = data.field45
cdp[27,*] = data.field46
cdp[28,*] = data.field47
cdp[29,*] = data.field48  

xbins=[2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]
xbinlabels=[2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50]


if individualplots eq 1 then begin
;individual plots
for i = t1[0], t1[1] do begin
  hist = plot(cdp[*,i], histogram=1, dimensions=[1200,900])
  hist.title= string(beadsize)+'um Counts '+time[i]
hist.xtitle='Bin Number'
hist.ytitle='Count'
hist[0].TRANSPARENCY = 0
;hist.xtickv=xbins
hist.xminor=0
hist.xticklen=.02
hist.xsubticklen=1
hist.color='blue'
hist.xtickvalues=xbinlabels
hist.xrange=[2,50]
endfor

endif else begin

;sum bin counts
bins = total(cdp[*, t1[0]:t1[1]], 2)
sum = total(cdp[*, t1[0]:t1[1]])
sumint = uint(sum)
span = string(t1[1]-t1[0] + 1)
spanint = uint(span)

binsfreq = bins/sum

maxfreq = max(binsfreq)+.015

;bead size markers

hist = plot(xbins, binsfreq, histogram=1, dimensions=[1200,900], yrange=[0,maxfreq])
hist.title= string(beadsize)+' um Counts,'+string(sumint)+' total, over'+string(spanint)+' sec'
hist.xtitle='Upper Bin Size [um]'
hist.ytitle='Normalized Frequency'
hist[0].TRANSPARENCY = 0
;hist.xtickv=xbins
hist.xminor=0
hist.xticklen=.02
hist.xsubticklen=1
hist.xtickvalues=xbinlabels
hist.color='blue'
;hist.yticklen=1
hist.xrange=[2,50]

if beadsize eq 8 then begin
  
  vert1 = plot([7.1,7.1],[0,maxfreq], /overplot)
  vert2 = plot([6.9,6.9],[0,maxfreq], /overplot)
  vert3 = plot([7.3,7.3],[0,maxfreq], /overplot)
  vert2.linestyle=2
  vert3.linestyle=2
    
endif

if beadsize eq 15 then begin

  vert1 = plot([14,14],[0,maxfreq], /overplot)
  vert2 = plot([13.6,13.6],[0,maxfreq], /overplot)
  vert3 = plot([14.4,14.4],[0,maxfreq], /overplot)
  vert2.linestyle=2
  vert3.linestyle=2

endif

if beadsize eq 20 then begin

  vert1 = plot([15.7,15.7],[0,maxfreq], /overplot)
  vert2 = plot([15.4,15.4],[0,maxfreq], /overplot)
  vert3 = plot([16,16],[0,maxfreq], /overplot)
  vert2.linestyle=2
  vert3.linestyle=2

endif

if beadsize eq 30 then begin

  vert1 = plot([25.3,25.3],[0,maxfreq], /overplot)
  vert2 = plot([24.8,24.8],[0,maxfreq], /overplot)
  vert3 = plot([25.8,25.8],[0,maxfreq], /overplot)
  vert2.linestyle=2
  vert3.linestyle=2

endif

if beadsize eq 40 then begin

  vert1 = plot([35,35],[0,maxfreq], /overplot)
  vert2 = plot([34.1,34.1],[0,maxfreq], /overplot)
  vert3 = plot([35.9,35.9],[0,maxfreq], /overplot)
  vert2.linestyle=2
  vert3.linestyle=2

endif

if beadsize eq 50 then begin

  vert1 = plot([39.4,39.4],[0,maxfreq], /overplot)
  vert2 = plot([37.8,37.8],[0,maxfreq], /overplot)
  vert3 = plot([41,41],[0,maxfreq], /overplot)
  vert2.linestyle=2
  vert3.linestyle=2

endif
endelse



return 

end