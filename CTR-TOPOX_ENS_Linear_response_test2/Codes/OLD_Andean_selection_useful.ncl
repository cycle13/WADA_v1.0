;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF
;Note: modified on 20181001 

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

chunk = 32
num_time = 96

num1 = new(32,integer)
num2 = new(32,integer)

do i_chunk = 0,chunk-1
num1_temp = i_chunk * num_time/chunk
num2_temp = num1_temp + num_time/chunk - 1

num1(i_chunk) = num1_temp
num2(i_chunk) = num2_temp
end do  ; do i_chunk

;-------------
str_time = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
end do

;============== WADA index ======
f_SGH30 = addfile("/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
SGH30 = f_SGH30->SGH30

SGH30m = SGH30
SGH30m = SGH30@_FillValue
SGH30m({-40:10},{270:300}) = SGH30({-40:10},{270:300})

do ilat = 0,95
   do ilon = 0,143
      if (.not. ismissing(SGH30m(ilat,ilon)) .and. SGH30m(ilat,ilon) .lt. 200.0) then
          SGH30m(ilat,ilon) = SGH30m@_FillValue
      end if
   end do
end do
printVarSummary(SGH30m)

;---------- Add the value of WADA index ------
Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)
xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/)
;===========
total_times = 96
WADA_index = new(total_times,double)
WADA_index_sig = new(total_times,double)

;=====================================

do index = 0,31
;do index = 0,7

TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

var = (/"PRECT"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_std_TOPO_temp = f_TOPO_std->$var$
;printVarSummary(var_std_TOPO_temp)
var_std_TOPO = var_std_TOPO_temp(0,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_CTR)

siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO,var_std_TOPO^2,indep_sample,var_mean_CTR,var_std_CTR^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
;
;===Note: In your previous analysis on daily output, TOPO and CTR time dimention matches well because in the 1_a_preprocessing, the processing of CTR files were using ncrcat connnect all together first, then use ncrcat again to tease out the slice of the same time  dimension as in TOPOTEST.
;=====   In this new 1 hr output, you used ncrcat to combine 4 day of files for CTR without combining all ~ 3month CTR data together, without using ncrcat (together with print(Calendar(X&time))), therefore, the CTR lag TOPO time dimension by 1 hr. You checked time_bnds to conclude this conclusion==== 

diff_TOPO_CTR = var_mean_TOPO ; metadata
;diff_TOPO_CTR = var_mean_TOPO - var_mean_CTR
diff_TOPO_CTR = var_mean_CTR - var_mean_TOPO

diff_TOPO_CTR_sig = var_mean_TOPO ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO - var_mean_CTR,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_CTR - var_mean_TOPO,diff_TOPO_CTR@_FillValue)

diff_TOPO_CTR = diff_TOPO_CTR * 8.64e7 ; m/sec to mm/day
diff_TOPO_CTR_sig = diff_TOPO_CTR_sig * 8.64e7 ; m/sec to mm/day
diff_TOPO_CTR@units = "mm/day"
diff_TOPO_CTR_sig@units = "mm/day"

diff_TOPO_CTR@_FillValue = 1.0e36
diff_TOPO_CTR_sig@_FillValue = 1.0e36

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)

var_mean_CTR = var_mean_CTR * 8.64e7
var_mean_CTR@units = "mm/day"

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
;total_hr = 6
total_hr = 3

do i_hr = 0,total_hr-1
;do i_hr = 0,1

WADA_index(index*3+i_hr) = avg(where(.not.ismissing(SGH30m),diff_TOPO_CTR(i_hr,:,:),diff_TOPO_CTR@_FillValue)) \
        - avg(diff_TOPO_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

WADA_index_sig(index*3+i_hr) = avg(where(.not.ismissing(SGH30m),diff_TOPO_CTR_sig(i_hr,:,:),diff_TOPO_CTR_sig@_FillValue))  \
        - avg(diff_TOPO_CTR_sig(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

;print(WADA_index)
;print(WADA_index_sig)

wks = gsn_open_wks("pdf","../Figures/2_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
wks_sig = gsn_open_wks("pdf","../Figures/2_Sig_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
wks_CTR = gsn_open_wks("pdf","../Figures/2_CTR_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))

gsn_reverse_colormap(wks)    ; blue color indicate positive precip changes
gsn_reverse_colormap(wks_sig)    ; blue color indicate positive precip changes
gsn_reverse_colormap(wks_CTR)    ; blue color indicate positive precip changes

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index(index*3+i_hr))

res@tiMainString = var+", CTR - TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)
;res@tiMainString = var+", TOPO - CTR, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = -4.0
;res@cnMaxLevelValF = 4.0
;res@cnLevelSpacingF = 0.5
res@cnMinLevelValF = -10.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 0.5

;res@cnMinLevelValF = -0.5
;res@cnMaxLevelValF = 0.5
;res@cnLevelSpacingF = 0.05

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0
;
res@gsnLeftString = var

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_hr,:,:),res)
delete(res@gsnCenterString)

;----------- add polygon and Andes shading -----
res2 = True
res2@gsnDraw = False
res2@gsnFrame = False
res2@cnFillOn = True
res2@cnFillPattern      = 16
res2@gsnLeftString = ""
res2@gsnRightString = "" ; unit in meter
res2@lbLabelBarOn = False

plot_SGHm = gsn_csm_contour(wks,SGH30m,res2)

;----------- add polygon -------
dum_Amazon = new(4,graphic)

;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 4.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon(i)=gsn_add_polyline(wks,plot,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do

overlay(plot,plot_SGHm)
draw(plot)
frame(wks)

delete(dum_Amazon)
;----------------


if (.not.ismissing(WADA_index_sig(index*3+i_hr))) then
res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index_sig(index*3+i_hr))
else
res@gsnCenterString = "WADAi=_FillValue"
end if

plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_hr,:,:),res)

delete(res@gsnCenterString)

;--------
plot_SGHm_sig = gsn_csm_contour(wks_sig,SGH30m,res2)

;----------- add polygon -------
dum_Amazon_sig = new(4,graphic)

;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 4.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon_sig(i)=gsn_add_polyline(wks_sig,plot_sig,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do


overlay(plot_sig,plot_SGHm_sig)
draw(plot_sig)
frame(wks_sig)
delete(dum_Amazon_sig)

;================
res@gsnFrame = True
res@gsnDraw = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 20.0
res@cnLevelSpacingF = 1.0

res@cnFillPalette = "MPL_Blues"

res@tiMainString = var+", CTR, ENS(180), ihr="+tostring(index*3+i_hr+1)

plot_CTR = gsn_csm_contour_map_ce(wks_CTR,var_mean_CTR(i_hr,:,:),res)

delete(res@cnFillPalette)

delete(res@gsnFrame)
delete(res@gsnDraw)
end do
;==============================

end do ; do index
;===============================
;------------- WADA index line plot -------

wks_WADA = gsn_open_wks("pdf","../Figures/WADA_index_line_hrly")

data_WADA = (/WADA_index,WADA_index_sig/)

resWADA = True
;resWADA@xyLineThicknesses = (/  1.0,   2.0/)          ; make second line thicker
;resWADA@xyLineColors      = (/"blue","red"/)          ; change line color
;resWADA@xyMarkers      = (/6,11/)
resWADA@xyLineThicknesses = (/  2.0/)          ; make second line thicker
resWADA@xyLineColors      = (/"red"/)          ; change line color
resWADA@xyMarkers      = (/11/)

resWADA@xyMarkLineMode = "MarkLines"               ; Markers *and* lines

resWADA@pmLegendDisplayMode    = "Always"              ; turn on legend

 resWADA@pmLegendSide           = "Top"                 ; Change location of 
 resWADA@pmLegendParallelPosF   = .80                   ; move units right
 resWADA@pmLegendOrthogonalPosF = -1.0                  ; more neg = down

 resWADA@pmLegendWidthF         = 0.12                  ; Change width and
 resWADA@pmLegendHeightF        = 0.25                  ; height of legend.
 resWADA@lgLabelFontHeightF     = .02                   ; change font height
 resWADA@lgPerimOn              = False                 ; no box around
; labels for the legend
; resWADA@xyExplicitLegendLabels = (/"WADAi","WADAi_sig"/)
 resWADA@xyExplicitLegendLabels = (/"WADAi_sig"/)

resWADA@tiMainString = "WADA index"
resWADA@tiYAxisString = "WADAi, mm/day"
resWADA@tiXAxisString = "No. of hr"
plotWADA  = gsn_csm_xy (wks_WADA,ispan(1,96,1),data_WADA(1,:),resWADA) ; create plot



end
