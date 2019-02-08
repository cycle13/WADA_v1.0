;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF
;Note: please_find_me_WADA

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/Old/"
TOPO_mean_str = "ENS.mean.TOPOTEST.nc"
TOPO_std_str = "ENS.std.TOPOTEST.nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/Old/"
CTR_mean_str = "ENS.mean.CTR.time0-5.nc"
CTR_std_str = "ENS.std.CTR.time0-5.nc"

var = (/"PRECT"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_TOPO)

var_mean_CTR_temp = f_CTR_mean->$var$
var_mean_CTR = var_mean_CTR_temp(0:3,:,:)   ; only the first 4 days
;printVarSummary(var_mean_CTR)
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,0:3,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_CTR)

siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO,var_std_TOPO^2,indep_sample,var_mean_CTR,var_std_CTR^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
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

;============== WADA index ======
f_SGH30 = addfile(prefix+"/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
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

;================ plot ===========
;total 12 days in the TOPOTEST after branching
;total_days = 12
total_days = 4

WADA_index = new(total_days,double)
Amazon_index = new(total_days,double)
WADA_index_sig = new(total_days,double)
Amazon_index_sig = new(total_days,double)

do i_day = 0,total_days-1
;do i_day = 0,1
;---------
;printVarSummary(diff_TOPO_CTR)

WADA_index(i_day) = avg(where(.not.ismissing(SGH30m),diff_TOPO_CTR(i_day,:,:),diff_TOPO_CTR@_FillValue)) \
        - avg(diff_TOPO_CTR(i_day,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

WADA_index_sig(i_day) = avg(where(.not.ismissing(SGH30m),diff_TOPO_CTR_sig(i_day,:,:),diff_TOPO_CTR_sig@_FillValue))  \
        - avg(diff_TOPO_CTR_sig(i_day,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))
;print(WADA_index)
;print(WADA_index_sig)

Amazon_index(i_day) = avg(diff_TOPO_CTR(i_day,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

Amazon_index_sig(i_day) =  avg(diff_TOPO_CTR_sig(i_day,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))
;---------
 
wks = gsn_open_wks("png","../Figures/Regional_"+var+"_TOPO_vs_CTR_iday_"+tostring(i_day+1))
;wks = gsn_open_wks("png","Global_"+var+"_TOPO_vs_CTR_iday_"+tostring(i_day+1))
wks_sig = gsn_open_wks("png","../Figures/Sig_Regional_"+var+"_TOPO_vs_CTR_iday_"+tostring(i_day+1))
;wks_sig = gsn_open_wks("png","Sig_Global_"+var+"_TOPO_vs_CTR_iday_"+tostring(i_day+1))

gsn_reverse_colormap(wks)    ; blue color indicate positive precip changes
gsn_reverse_colormap(wks_sig)    ; blue color indicate positive precip changes

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

;res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index(i_day))

res@tiMainString = var+", CTR - TOPO, ENS(180), iday="+tostring(i_day+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -8.0
res@cnMaxLevelValF = 8.0
res@cnLevelSpacingF = 1.0

;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0
res@mpMaxLatF = 25.0
res@mpMinLatF = -35.0
res@mpMaxLonF = 360.0 - 30.
res@mpMinLonF = 360.0 - 110.
;
res@gsnLeftString = var

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_day,:,:),res)

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

;---------------
;res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index_sig(i_day))

plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_day,:,:),res)

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
end do

;------------- WADA index line plot -------

;wks_WADA = gsn_open_wks("x11","../Figures/WADA_index_line_daily")
wks_WADA = gsn_open_wks("png","../Figures/Amazon_index_line_daily")

;data_WADA = (/WADA_index,WADA_index_sig/)
data_WADA = (/Amazon_index,Amazon_index_sig/)

resWADA = True
resWADA@xyLineThicknesses = (/  1.0,   2.0/)          ; make second line thicker
resWADA@xyLineColors      = (/"blue","red"/)          ; change line color
resWADA@xyMarkLineMode = "MarkLines"               ; Markers *and* lines
resWADA@xyMarkers      = (/6,11/)

resWADA@pmLegendDisplayMode    = "Always"              ; turn on legend
 
 resWADA@pmLegendSide           = "Top"                 ; Change location of 
 resWADA@pmLegendParallelPosF   = .80                   ; move units right
 resWADA@pmLegendOrthogonalPosF = -0.5                  ; more neg = down
 
 resWADA@pmLegendWidthF         = 0.12                  ; Change width and
 resWADA@pmLegendHeightF        = 0.25                  ; height of legend.
 resWADA@lgLabelFontHeightF     = .02                   ; change font height
 resWADA@lgPerimOn              = False                 ; no box around
; labels for the legend
; resWADA@xyExplicitLegendLabels = (/"WADAi","WADAi_sig"/)
 resWADA@xyExplicitLegendLabels = (/"Amazon","Amazon_sig"/)

resWADA@tiMainString = "Amazon rainfall response"
resWADA@tiYAxisString = "Amazon precip_avg, mm/day"
resWADA@tiXAxisString = "No. of day"
plotWADA  = gsn_csm_xy (wks_WADA,ispan(1,4,1),data_WADA,resWADA) ; create plot




end
