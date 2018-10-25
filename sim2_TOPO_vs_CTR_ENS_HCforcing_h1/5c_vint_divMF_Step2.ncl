;Function: Moisture Flux difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180726
;Ref
;Payne, A. E., and G. Magnusdottir (2014), Dynamics of Landfalling Atmospheric Rivers over the North Pacific in 30 Years of MERRA Reanalysis, JOURNAL OF CLIMATE, 27(18), 7133-7150, doi: 10.1175/JCLI-D-14-00034.1.
;Payne, A. E., and G. Magnusdottir (2015), An evaluation of atmospheric rivers over the North Pacific in CMIP5 and their response to warming under RCP 8.5, Journal of Geophysical Research: Atmospheres, 120(21), 2015JD023586-022015JD023586, doi: 10.1002/2015JD023586.
;Lavers, D. A., G. Villarini, R. P. Allan, E. F. Wood, and A. J. Wade (2012), The detection of atmospheric rivers in atmospheric reanalyses and their links to British winter floods and the large-scale climatic circulation, Journal of Geophysical Research-Atmospheres, 117.

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;================based on mean and std of moisture flux of CTR and TOPO, calculate TOPO-CTR with significance===================
dir_TOPO = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;dir_TOPO = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"                     ; Output directory
fil_TOPO_divMF = "vint_divMF.mean_std.TOPO.nc"

dir_CTR = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;dir_CTR = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"                     ; Output directory
fil_CTR_divMF = "vint_divMF.mean_std.CTR.nc"

f_TOPO_divMF = addfile(dir_TOPO+fil_TOPO_divMF,"r")
f_CTR_divMF = addfile(dir_CTR+fil_CTR_divMF,"r")

vint_divMF_TOPO_mean = f_TOPO_divMF->vint_divMF_TOPO_mean
vint_divMF_TOPO_std = f_TOPO_divMF->vint_divMF_TOPO_std

;printVarSummary(vint_divMF_TOPO_mean)

;;===============================

;copy_VarCoords(QU_TOPO_mean,vint_divMF_TOPO_mean)
;copy_VarCoords(QU_TOPO_mean,vint_divMF_TOPO_std)

printVarSummary(vint_divMF_TOPO_mean)
printVarSummary(vint_divMF_TOPO_std)
;----------------------

vint_divMF_CTR_mean = f_CTR_divMF->vint_divMF_CTR_mean
vint_divMF_CTR_std = f_CTR_divMF->vint_divMF_CTR_std

printVarSummary(vint_divMF_CTR_mean)
printVarSummary(vint_divMF_CTR_std)

;=============

printVarSummary(vint_divMF_TOPO_mean)
printVarSummary(vint_divMF_TOPO_std)

printVarSummary(vint_divMF_CTR_mean)
printVarSummary(vint_divMF_CTR_std)

;=========================
siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
;;------------ vint_divMF -------------
prob_vint_divMF = ttest(vint_divMF_TOPO_mean,vint_divMF_TOPO_std^2,indep_sample,vint_divMF_CTR_mean,vint_divMF_CTR_std^2,indep_sample,True,False)
printVarSummary(prob_vint_divMF)

;; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR_vint_divMF = vint_divMF_TOPO_mean ; metadata
;diff_TOPO_CTR_vint_divMF = vint_divMF_TOPO_mean - vint_divMF_CTR_mean
diff_TOPO_CTR_vint_divMF = vint_divMF_CTR_mean - vint_divMF_TOPO_mean

diff_TOPO_CTR_vint_divMF_sig = vint_divMF_TOPO_mean ; metadata
;diff_TOPO_CTR_vint_divMF_sig = where(prob_vint_divMF .lt. siglvl,vint_divMF_TOPO_mean - vint_divMF_CTR_mean,diff_TOPO_CTR_vint_divMF@_FillValue)
diff_TOPO_CTR_vint_divMF_sig = where(prob_vint_divMF .lt. siglvl,vint_divMF_CTR_mean - vint_divMF_TOPO_mean,diff_TOPO_CTR_vint_divMF@_FillValue)

printVarSummary(diff_TOPO_CTR_vint_divMF)
printVarSummary(diff_TOPO_CTR_vint_divMF_sig)

;------------------------------
;================ plot ===========
;total 12 days in the TOPOTEST after branching
;total_days = 12
total_days = 4

do i_day = 0,total_days-1
;do i_day = 0,1
 
wks = gsn_open_wks("png","Regional_vint_divMF_TOPO_vs_CTR_iday_"+tostring(i_day+1))
;wks = gsn_open_wks("png","Global_IVT_TOPO_vs_CTR_iday_"+tostring(i_day+1))
wks_sig = gsn_open_wks("png","Sig_Regional_vint_divMF_TOPO_vs_CTR_iday_"+tostring(i_day+1))
;wks_sig = gsn_open_wks("png","Sig_Global_IVT_TOPO_vs_CTR_iday_"+tostring(i_day+1))

;gsn_reverse_colormap(wks)    ; blue color indicate positive precip changes
;gsn_reverse_colormap(wks_sig)    ; blue color indicate positive precip changes

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@gsnDraw = True
res@gsnFrame = True
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

;res@tiMainString = "IVT, TOPO - CTR, ENS(180), iday="+tostring(i_day+1)
;res@tiMainString = "vint_divMF, sfc-300hPa, TOPO-CTR, ENS(180), iday="+tostring(i_day+1)
res@tiMainString = "vint_divMF, sfc-300hPa, CTR-TOPO, ENS(180), iday="+tostring(i_day+1)
res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = -50.0
;res@cnMaxLevelValF = 50.0
;res@cnLevelSpacingF = 2.0
res@cnMinLevelValF = -1.2e-4
res@cnMaxLevelValF = 1.2e-4
res@cnLevelSpacingF = 1.0e-5

res@gsnLeftString = "1/g*Int{div[(u,v)q]}dp"

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0

;;;plot = gsn_csm_contour_map_ce(wks,diff_div_IVT_TOPO_CTR(i_day,:,:),res)
plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR_vint_divMF(i_day,:,:),res)
plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_vint_divMF_sig(i_day,:,:),res)

res_vc = True
res_vc@gsnFrame = False
res_vc@gsnDraw = False
res_vc@vcGlyphStyle               = "LineArrow"
res_vc@vcLineArrowThicknessF      = 3
res_vc@vcMinDistanceF             = 0.02
res_vc@vcRefLengthF               = 0.03

res_vc@vcRefAnnoOn               = True
res_vc@vcRefMagnitudeF           = 50
res_vc@vcRefAnnoString1          = "50"
res_vc@vcRefAnnoSide             = "Top"
res_vc@vcRefAnnoString2On        = False
res_vc@vcRefAnnoPerimOn          = False
res_vc@vcRefAnnoOrthogonalPosF   = -0.18
res_vc@vcRefAnnoParallelPosF     = 0.999
res_vc@vcRefAnnoBackgroundColor  = "Purple"
res_vc@vcVectorDrawOrder         = "PostDraw"

res_vc@gsnRightString            = "Wind"
res_vc@gsnLeftString = ""
res_vc@gsnRightString = ""

;plot_UV = gsn_csm_vector(wks,diff_TOPO_CTR_QU(i_day,:,:),diff_TOPO_CTR_QV(i_day,:,:),res_vc)
;plot_UV_sig = gsn_csm_vector(wks_sig,diff_TOPO_CTR_QU_sig(i_day,:,:),diff_TOPO_CTR_QV_sig(i_day,:,:),res_vc)

;Note: please put the shading plot as the base for the overlay (the first plot) so that the contour of plot_Z3 will not be swallowed.
;overlay(plot,plot_UV)
;overlay(plot_sig,plot_UV_sig)
;draw(plot)
;draw(plot_sig)
;frame(wks)
;frame(wks_sig)
end do

;;=================== CTR ENS (180), Clim ==========
;
;wks_clim = gsn_open_wks("x11","Clim_Regional_vint_divMF_CTR")
;
;;res@cnMinLevelValF = 0.0
;;res@cnMaxLevelValF = 300.0
;;res@cnLevelSpacingF = 10.0
;
;res@cnMinLevelValF = -1.2e-4
;res@cnMaxLevelValF = 1.2e-4
;res@cnLevelSpacingF = 1.0e-5
;
;;res@tiMainString = "IVT, CTR ENS(180), DJF Clim"
;res@tiMainString = "vint_divMF, sfc-300hPa, CTR ENS(180), DJF Clim"
;res@gsnRightString = "kg/(meter^2*sec)"
;
;;plot_clim = gsn_csm_contour_map_ce(wks_clim,dim_avg_n_Wrap(IVT_CTR_mean(0:9,:,:),0),res)
;plot_clim = gsn_csm_contour_map_ce(wks_clim,dim_avg_n_Wrap(vint_divMF_CTR_mean(0:9,:,:),0),res)
;
;res_vc@vcRefMagnitudeF           = 200
;res_vc@vcRefAnnoString1          = "200"
;
;;plot_UV_clim = gsn_csm_vector(wks_clim,dim_avg_n_Wrap(QU_CTR_mean(0:9,:,:),0),dim_avg_n_Wrap(QV_CTR_mean(0:9,:,:),0),res_vc)
;
;;overlay(plot_clim,plot_UV_clim)
;;draw(plot_clim)
;;frame(wks_clim)
;

end
