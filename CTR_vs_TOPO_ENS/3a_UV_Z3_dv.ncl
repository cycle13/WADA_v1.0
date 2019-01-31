;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
;TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/Old/"
TOPO_mean_str = "ENS.mean.TOPOTEST.nc"
TOPO_std_str = "ENS.std.TOPOTEST.nc"
TOPO_check = "ENS.TOPOTEST.nc"

;CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/Old/"
CTR_mean_str = "ENS.mean.CTR.nc"
CTR_std_str = "ENS.std.CTR.nc"
CTR_check = "ENS.CTR.nc"

;============= Check if U, V, Z3 follows normal distribution ====
TOPO_check_file = addfile(TOPO_dir+TOPO_check,"r")
CTR_check_file = addfile(CTR_dir+CTR_check,"r")
;lat_check = 0
;lon_check = 360 - 75  ; 75W
lat_check = -5
lon_check = 360 - 75  ; 75W
;lev_check = 200  ; roughly 200hPa
lev_check = 850  ; roughly 200hPa

U_CTR = CTR_check_file->U(:,3,{lev_check},{lat_check},{lon_check}) ; all realization dimension, 3rd day after branching off
V_CTR = CTR_check_file->V(:,3,{lev_check},{lat_check},{lon_check})
Z3_CTR = CTR_check_file->Z3(:,3,{lev_check},{lat_check},{lon_check})

U_TOPO = TOPO_check_file->U(:,3,{lev_check},{lat_check},{lon_check}) ; all realization dimension, 3rd day after branching off
V_TOPO = TOPO_check_file->V(:,3,{lev_check},{lat_check},{lon_check})
Z3_TOPO = TOPO_check_file->Z3(:,3,{lev_check},{lat_check},{lon_check})

wks_check = gsn_open_wks("png","TEST_Gaussian_U_V_Z3_lev_"+tostring(lev_check)+"lat_"+tostring(lat_check)+"_lon_"+tostring(lon_check))

res_check = True

;res_check@gsnLeftString = "Check Gaussian on day 3, at lev="+tostring(lev_check)+", lat="+tostring(lat_check)+", lon="+tostring(lon_check) 

res_check@tiMainString = "CTR" 

res_check@gsnFrame = False
res_check@gsnDraw = False

CTR_Updf = pdfx(U_CTR, 30, False)
CTR_Vpdf = pdfx(V_CTR, 30, False)
CTR_Z3pdf = pdfx(Z3_CTR, 30, False)
TOPO_Updf = pdfx(U_TOPO, 30, False)
TOPO_Vpdf = pdfx(V_TOPO, 30, False)
TOPO_Z3pdf = pdfx(Z3_TOPO, 30, False)

plot_check = new(6,graphic)

plot_check(0) = gsn_csm_xy(wks_check, CTR_Updf@bin_center, CTR_Updf, res_check)
plot_check(1) = gsn_csm_xy(wks_check, CTR_Vpdf@bin_center, CTR_Vpdf, res_check)
plot_check(2) = gsn_csm_xy(wks_check, CTR_Z3pdf@bin_center, CTR_Z3pdf, res_check)

res_check@tiMainString = "TOPO" 

plot_check(3) = gsn_csm_xy(wks_check, TOPO_Updf@bin_center, TOPO_Updf, res_check)
plot_check(4) = gsn_csm_xy(wks_check, TOPO_Vpdf@bin_center, TOPO_Vpdf, res_check)
plot_check(5) = gsn_csm_xy(wks_check, TOPO_Z3pdf@bin_center, TOPO_Z3pdf, res_check)

res_p_check = True
res_p_check@txString = "Check Gaussian on day 3, at lev="+tostring(lev_check)+", lat="+tostring(lat_check)+", lon="+tostring(lon_check) 

gsn_panel(wks_check, plot_check,(/2,3/),res_p_check) 

;==================================
;===================================

;var_str = (/"U","V","Z3","dv"/)
var_str = (/"U","V","Z3"/)

;do i_var = 0, 3
do i_var = 0, 2

var = var_str(i_var)

if (i_var .le. 2) then

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_CTR)

else
f_TOPO_div = addfile(TOPO_dir+"ENS.std.mean.TOPOTEST.div.nc","r")
f_CTR_div = addfile(CTR_dir+"ENS.std.mean.CTR.div.nc","r")

var_mean_TOPO = tofloat(f_TOPO_div->div_TOPO_mean)
var_std_TOPO = tofloat(f_TOPO_div->div_TOPO_std)

var_mean_CTR = tofloat(f_CTR_div->div_CTR_mean)
var_std_CTR = tofloat(f_CTR_div->div_CTR_std)

end if ; if (i_var .le. 2)

;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_TOPO_pnew)
var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_CTR_pnew)

siglvl = 0.1
indep_sample = 180
;;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;----------
printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR_sig@_FillValue)

;printVarSummary(diff_TOPO_CTR)
;printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   U_mean_CTR = var_mean_CTR_pnew   ; for Clim plot
   U_diff_TOPO_CTR = diff_TOPO_CTR
   U_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else if (i_var .eq. 1) then
   V_mean_CTR = var_mean_CTR_pnew   ; for Clim plot
   V_diff_TOPO_CTR = diff_TOPO_CTR
   V_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else if (i_var .eq. 2) then
   Z3_mean_CTR = var_mean_CTR_pnew   ; for Clim plot
   Z3_diff_TOPO_CTR = diff_TOPO_CTR
   Z3_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else
   div_mean_CTR = var_mean_CTR_pnew   ; for Clim plot
   div_diff_TOPO_CTR = diff_TOPO_CTR
   div_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
end if
end if
end if

end do ; do ivar

;printVarSummary(U_diff_TOPO_CTR)
;printVarSummary(U_diff_TOPO_CTR_sig)
;printVarSummary(V_diff_TOPO_CTR)
;printVarSummary(V_diff_TOPO_CTR_sig)
;printVarSummary(Z3_diff_TOPO_CTR)
;printVarSummary(Z3_diff_TOPO_CTR_sig)
printVarSummary(div_diff_TOPO_CTR)
printVarSummary(div_diff_TOPO_CTR_sig)

;================ plot ===========
;total 12 days in the TOPOTEST after branching
;pr_levels = (/200,500,850/)

pr_levels = (/200,850/)
;pr_levels = (/850/)

;total_days = 12
total_days = 10

do i_pr = 0,dimsizes(pr_levels) - 1

do i_day = 0,total_days-1
;do i_day = 0,3
 
wks = gsn_open_wks("x11","Global_U_V_Z3_dv_TOPO_vs_CTR_iday_"+tostring(pr_levels(i_pr))+"hPa_"+tostring(i_day+1))
;wks = gsn_open_wks("png","Regional_U_V_Z3_dv_TOPO_vs_CTR_iday_"+tostring(pr_levels(i_pr))+"hPa_"+tostring(i_day+1))
wks_sig = gsn_open_wks("x11","Sig_Global_U_V_Z3_dv_TOPO_vs_CTR_iday_"+tostring(pr_levels(i_pr))+"hPa_"+tostring(i_day+1))
;wks_sig = gsn_open_wks("png","Sig_Regional_U_V_Z3_dv_TOPO_vs_CTR_iday_"+tostring(pr_levels(i_pr))+"hPa_"+tostring(i_day+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -20.0
res@cnMaxLevelValF = 20.0
res@cnLevelSpacingF = 1.0
res@gsnContourNegLineDashPattern = 1

res@gsnAddCyclic = True

res@pmLabelBarWidthF  = 0.4
res@pmLabelBarHeightF = 0.06
res@pmLabelBarOrthogonalPosF = 0.15
res@lbLabelAngleF      = 45
res@lbLabelFontHeightF = 0.01

res_vc = True
res_vc@gsnFrame = False
res_vc@gsnDraw = False
res_vc@vcGlyphStyle               = "LineArrow"
res_vc@vcLineArrowThicknessF      = 3
res_vc@vcMinDistanceF             = 0.02
res_vc@vcRefLengthF               = 0.03

res_vc@vcRefAnnoOn               = True
res_vc@vcRefMagnitudeF           = 4 
res_vc@vcRefAnnoString1          = "4"
res_vc@vcRefAnnoSide             = "Top"
res_vc@vcRefAnnoString2On        = False
res_vc@vcRefAnnoPerimOn          = False
res_vc@vcRefAnnoOrthogonalPosF   = -0.12
res_vc@vcRefAnnoParallelPosF     = 0.999
res_vc@vcRefAnnoBackgroundColor  = "Purple"
res_vc@vcVectorDrawOrder         = "PostDraw"

res_vc@gsnRightString            = "Wind"
res_vc@gsnLeftString = ""
res_vc@gsnRightString = ""

res@tiMainString = "U,V (m/sec); Z3 (m); divergence (/sec) @"+tostring(pr_levels(i_pr))+"hPa, TOPO - CTR, ENS(180), iday="+tostring(i_day+1)
res@tiMainFontHeightF = 0.015
res@gsnLeftString = ""
res@gsnRightString = ""

plot_Z3 = gsn_csm_contour(wks,Z3_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),res)
plot_Z3_sig = gsn_csm_contour(wks_sig,Z3_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),res)

plot_UV = gsn_csm_vector(wks,U_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),res_vc)
plot_UV_sig = gsn_csm_vector(wks_sig,U_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),res_vc)

res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True
res@cnLevelSelectionMode = "ManualLevels"

if (pr_levels(i_pr) .eq. 200) then
res@cnMinLevelValF = -1.0e-5
res@cnMaxLevelValF = 1.0e-5
res@cnLevelSpacingF = 0.1e-5
else            ; 850hPa
res@cnMinLevelValF = -2.0e-6
res@cnMaxLevelValF = 2.0e-6
res@cnLevelSpacingF = 0.2e-6
end if

;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0

printVarSummary(f_TOPO_mean->lat)
printVarSummary(f_TOPO_mean->lon)

;plot_dv = gsn_csm_contour_map(wks,uv2dvF_Wrap(U_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),f_TOPO_mean->lat,f_TOPO_mean->lon,3),res)

plot_dv = gsn_csm_contour_map(wks,div_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),res)
plot_dv_sig = gsn_csm_contour_map(wks_sig,div_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),res)
;;;plot_dv = gsn_csm_contour_map(wks,uv2dv_cfd(U_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),f_TOPO_mean->lat,f_TOPO_mean->lon,3),res)
;;;plot_dv_sig = gsn_csm_contour_map(wks_sig,uv2dv_cfd(U_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),f_TOPO_mean->lat,f_TOPO_mean->lon,3),res)

;Note: please put the shading plot as the base for the overlay (the first plot) so that the contour of plot_Z3 will not be swallowed.
overlay(plot_dv,plot_Z3)
overlay(plot_dv,plot_UV)
draw(plot_dv)
frame(wks)

overlay(plot_dv_sig,plot_Z3_sig)
overlay(plot_dv_sig,plot_UV_sig)
draw(plot_dv_sig)
frame(wks_sig)


end do ; do i_day 

;======== Note: that sampling frequency is every 10 days per member through DJF, DJF mean all first 10 days for the ENS ===

;wks_clim = gsn_open_wks("png","Clim_Regional_U_V_Z3_dv_CTR_"+pr_levels(i_pr)+"hPa")
wks_clim = gsn_open_wks("png","Clim_Global_U_V_Z3_dv_CTR_"+pr_levels(i_pr)+"hPa")

res@gsnFrame = False
res@gsnDraw = False

res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"

res@tiMainFontHeightF = 0.015
res@gsnLeftString = ""
res@gsnRightString = ""

res@tiMainString = "U,V (m/sec); Z3 (m); divergence (/sec) @"+tostring(pr_levels(i_pr))+"hPa, CTR ENS(180), DJF Clim"

plot_dv_clim = gsn_csm_contour_map(wks_clim,dim_avg_n_Wrap(div_mean_CTR(0:9,{pr_levels(i_pr)},:,:),0),res)

res@cnLevelSelectionMode = "ManualLevels"

delete(res@cnMinLevelValF)
delete(res@cnMaxLevelValF) 
delete(res@cnLevelSpacingF)

res@gsnContourNegLineDashPattern = 1

res@gsnAddCyclic = True

res@pmLabelBarWidthF  = 0.4
res@pmLabelBarHeightF = 0.06
res@pmLabelBarOrthogonalPosF = 0.15
res@lbLabelAngleF      = 45
res@lbLabelFontHeightF = 0.01

if (pr_levels(i_pr) .eq. 200) then
res@cnMinLevelValF = 10800.
res@cnMaxLevelValF = 12400.
res@cnLevelSpacingF = 50.
else
res@cnMinLevelValF = 1160.
res@cnMaxLevelValF = 1560.
res@cnLevelSpacingF = 10.
end if

res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

plot_Z3_clim = gsn_csm_contour(wks_clim,dim_avg_n_Wrap(Z3_mean_CTR(0:9,{pr_levels(i_pr)},:,:),0),res)

res_vc = True
res_vc@gsnFrame = False
res_vc@gsnDraw = False

res_vc@vcGlyphStyle               = "LineArrow"
res_vc@vcLineArrowThicknessF      = 1
res_vc@vcMinDistanceF             = 0.02
res_vc@vcRefLengthF               = 0.03

res_vc@vcRefAnnoOn               = True

if (pr_levels(i_pr) .eq. 200) then
res_vc@vcRefMagnitudeF           = 15
res_vc@vcRefAnnoString1          = "15"
else
res_vc@vcRefMagnitudeF           = 6
res_vc@vcRefAnnoString1          = "6"
end if

res_vc@vcRefAnnoSide             = "Top"
res_vc@vcRefAnnoString2On        = False
res_vc@vcRefAnnoPerimOn          = False
res_vc@vcRefAnnoOrthogonalPosF   = -0.12
res_vc@vcRefAnnoParallelPosF     = 0.999
res_vc@vcRefAnnoBackgroundColor  = "Purple"
res_vc@vcVectorDrawOrder         = "PostDraw"

res_vc@gsnRightString            = "Wind"
res_vc@gsnLeftString = ""
res_vc@gsnRightString = ""

plot_UV_clim = gsn_csm_vector(wks_clim,dim_avg_n_Wrap(U_mean_CTR(0:9,{pr_levels(i_pr)},:,:),0),dim_avg_n_Wrap(V_mean_CTR(0:9,{pr_levels(i_pr)},:,:),0),res_vc)

overlay(plot_dv_clim,plot_Z3_clim)
overlay(plot_dv_clim,plot_UV_clim)

draw(plot_dv_clim)
frame(wks_clim)

end do ; do i_pr

end
