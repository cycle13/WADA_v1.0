;Function: SHFLX difference between CTR ensemble and TOPO ensemble, with significance.
;Date: 20181031

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

chunk = 1
num_time = 4

;=====================================
TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes_SHFLX_LHFLX_SWCF_LWCF/TOPO_TEST/"
;TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_str = "ENS.std.mean.TOPOTEST.FLX.CF.nc"

CTR_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes_SHFLX_LHFLX_SWCF_LWCF/CTR/"
;CTR_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_str = "ENS.std.mean.CTR.FLX.CF.nc"

;var = (/"MSE"/)

f_TOPO = addfile(TOPO_dir+TOPO_str,"r")

f_CTR = addfile(CTR_dir+CTR_str,"r")

CF_mean_TOPO = f_TOPO->CF_TOPO_mean
CF_std_TOPO = f_TOPO->CF_TOPO_std

CF_mean_CTR = f_CTR->CF_CTR_mean
CF_std_CTR = f_CTR->CF_CTR_std

siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(CF_mean_TOPO,CF_std_TOPO^2,indep_sample,CF_mean_CTR,CF_std_CTR^2,indep_sample,True,False)
;printVarSummary(prob)

diff_TOPO_CTR = CF_mean_TOPO ; metadata
;diff_TOPO_CTR = var_mean_TOPO - var_mean_CTR
diff_TOPO_CTR = CF_mean_CTR - CF_mean_TOPO

diff_TOPO_CTR_sig = CF_mean_TOPO ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO - var_mean_CTR,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,CF_mean_CTR - CF_mean_TOPO,diff_TOPO_CTR@_FillValue)

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
;total_hr = 6
total_day = 4

do i_day = 0,total_day-1

wks = gsn_open_wks("pdf","../Figures/9_c_Regional_CF_lowlevel_TOPO_vs_CTR_iday"+tostring(i_day+1))
wks_sig = gsn_open_wks("pdf","../Figures/9_c_Sig_Regional_CF_lowlevel_TOPO_vs_CTR_iday"+tostring(i_day+1))

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = "SWCF+LWCF, CTR - TOPO, ENS(180), iday="+tostring(i_day+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -70.0
res@cnMaxLevelValF = 70.0
res@cnLevelSpacingF = 5.0
;res@cnMinLevelValF = -10.0
;res@cnMaxLevelValF = 10.0
;res@cnLevelSpacingF = 0.5

;res@cnMinLevelValF = -0.5
;res@cnMaxLevelValF = 0.5
;res@cnLevelSpacingF = 0.05

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0
;
res@gsnLeftString = "SWCF+LWCF"
;lowest three level are lev = 957, 976, 992.

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_day,:,:),res)
delete(res@gsnCenterString)

plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_day,:,:),res)
delete(res@gsnCenterString)

end do
;==============================



end
