;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180913 for Hovmueller
;Note: modified 20180921 for PBLH

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
;TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing_PBL_related/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.nc"
TOPO_std_str = "ENS.std.TOPOTEST.nc"

;CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing_PBL_related/CTR/"
CTR_mean_str = "ENS.mean.CTR.nc"
CTR_std_str = "ENS.std.CTR.nc"

var_str = (/"PBLH","PRECL"/)

do i_var = 0, 1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:)   ; get rid of the first realization dimension

var_mean_CTR = f_CTR_mean->$var$
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:)   ; get rid of the first realization dimension

siglvl = 0.1
indep_sample = 180
;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO,var_std_TOPO^2,indep_sample,var_mean_CTR,var_std_CTR^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO ; metadata
diff_TOPO_CTR = var_mean_TOPO - var_mean_CTR

diff_TOPO_CTR_sig = var_mean_TOPO ; metadata
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO - var_mean_CTR,diff_TOPO_CTR_sig@_FillValue)

;printVarSummary(diff_TOPO_CTR)
;printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   var_diff_TOPO_CTR = diff_TOPO_CTR
   var_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else 
   PRECL_diff_TOPO_CTR = diff_TOPO_CTR
   PRECL_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig

end if

end do ; do ivar

var_diff_TOPO_CTR&time = ispan(1,12,1)
var_diff_TOPO_CTR_sig&time = ispan(1,12,1)
PRECL_diff_TOPO_CTR&time = ispan(1,12,1)
PRECL_diff_TOPO_CTR_sig&time = ispan(1,12,1)

PRECL_diff_TOPO_CTR = PRECL_diff_TOPO_CTR * 8.64e7
PRECL_diff_TOPO_CTR_sig = PRECL_diff_TOPO_CTR_sig * 8.64e7
PRECL_diff_TOPO_CTR@units = "mm/day"
PRECL_diff_TOPO_CTR_sig@units = "mm/day"
;
printVarSummary(var_diff_TOPO_CTR)
printVarSummary(var_diff_TOPO_CTR_sig)
printVarSummary(PRECL_diff_TOPO_CTR)
printVarSummary(PRECL_diff_TOPO_CTR_sig)

;=============== average over lat (-5,5) in preparation for Hovmueler=========
;total_days = 11
total_days = 6

;pr_levels = 200.0

lat_c1 = -5.0
lat_c2 = 5.0
lon_c1 = 260.0 
lon_c2 = 320.0

var_diff_TOPO_CTR_hov = dim_avg_n_Wrap(var_diff_TOPO_CTR(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
var_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(var_diff_TOPO_CTR_sig(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

PRECL_diff_TOPO_CTR_hov = dim_avg_n_Wrap(PRECL_diff_TOPO_CTR(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
PRECL_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(PRECL_diff_TOPO_CTR_sig(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

printVarSummary(var_diff_TOPO_CTR_hov)
printVarSummary(var_diff_TOPO_CTR_hov_sig)

printVarSummary(PRECL_diff_TOPO_CTR_hov)
printVarSummary(PRECL_diff_TOPO_CTR_hov_sig)

;================ plot ===========

wks = gsn_open_wks("x11","Hov_Regional_"+var_str(0)+"_"+var_str(1)+"_TOPO_vs_CTR")
wks_sig = gsn_open_wks("x11","Sig_Hov_Regional_"+var_str(0)+"_"+var_str(1)+"_TOPO_vs_CTR")

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -120.0
res@cnMaxLevelValF = 320.0
res@cnLevelSpacingF = 20.0
res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.

res@gsnLeftString = ""
res@gsnRightString = ""

plot_var = gsn_csm_hov(wks,var_diff_TOPO_CTR_hov,res)

res@gsnCenterString = "siglvl=0.1"

plot_var_sig = gsn_csm_hov(wks_sig,var_diff_TOPO_CTR_hov_sig,res)

;---------
delete(res@gsnCenterString)

res@cnFillOn = True
res@cnLineLabelsOn = False
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -6.0
res@cnMaxLevelValF = 6.0
res@cnLevelSpacingF = 0.25

res@tiMainString = "TOPO - CTR, ENS(180)"
res@gsnLeftString = "PRECL(mm/day)"
res@gsnRightString = "PBLH(m)"
gsn_reverse_colormap(wks)

plot_P = gsn_csm_hov(wks,PRECL_diff_TOPO_CTR_hov,res)

gsn_reverse_colormap(wks_sig)
plot_P_sig = gsn_csm_hov(wks_sig,PRECL_diff_TOPO_CTR_hov_sig,res)

overlay(plot_P,plot_var)
draw(plot_P)
frame(wks)

overlay(plot_P_sig,plot_var_sig)
draw(plot_P_sig)
frame(wks_sig)


end
