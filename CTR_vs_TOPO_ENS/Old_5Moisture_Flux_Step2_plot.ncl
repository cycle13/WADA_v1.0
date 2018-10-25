;Function: Moisture Flux difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180726
;Ref
;Payne, A. E., and G. Magnusdottir (2014), Dynamics of Landfalling Atmospheric Rivers over the North Pacific in 30 Years of MERRA Reanalysis, JOURNAL OF CLIMATE, 27(18), 7133-7150, doi: 10.1175/JCLI-D-14-00034.1.
;Payne, A. E., and G. Magnusdottir (2015), An evaluation of atmospheric rivers over the North Pacific in CMIP5 and their response to warming under RCP 8.5, Journal of Geophysical Research: Atmospheres, 120(21), 2015JD023586-022015JD023586, doi: 10.1002/2015JD023586.
;Lavers, D. A., G. Villarini, R. P. Allan, E. F. Wood, and A. J. Wade (2012), The detection of atmospheric rivers in atmospheric reanalyses and their links to British winter floods and the large-scale climatic circulation, Journal of Geophysical Research-Atmospheres, 117.

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;================based on mean and std of moisture flux of CTR and TOPO, calculate TOPO-CTR with significance===================
dir_TOPO = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"                     ; Output directory
fil_TOPO = "QU_QV_IVT.mean_std.TOPO.nc"             ; Output file

dir_CTR = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"                     ; Output directory
fil_CTR = "QU_QV_IVT.mean_std.CTR.nc"             ; Output file

f_TOPO = addfile(dir_TOPO+fil_TOPO,"r")
f_CTR = addfile(dir_CTR+fil_CTR,"r")

QU_TOPO_mean = f_TOPO->QU_TOPO_mean
QU_TOPO_std = f_TOPO->QU_TOPO_std
QV_TOPO_mean = f_TOPO->QV_TOPO_mean
QV_TOPO_std = f_TOPO->QV_TOPO_std
IVT_TOPO_mean = f_TOPO->IVT_TOPO_mean
IVT_TOPO_std = f_TOPO->IVT_TOPO_std
copy_VarCoords(QU_TOPO_mean,IVT_TOPO_mean)
copy_VarCoords(QU_TOPO_mean,IVT_TOPO_std)

QU_CTR_mean = f_CTR->QU_CTR_mean
QU_CTR_std = f_CTR->QU_CTR_std
QV_CTR_mean = f_CTR->QV_CTR_mean
QV_CTR_std = f_CTR->QV_CTR_std
IVT_CTR_mean = f_CTR->IVT_CTR_mean
IVT_CTR_std = f_CTR->IVT_CTR_std
copy_VarCoords(QU_CTR_mean,IVT_CTR_mean)
copy_VarCoords(QU_CTR_mean,IVT_CTR_std)

printVarSummary(QU_TOPO_mean)
printVarSummary(QU_TOPO_std)
printVarSummary(QV_TOPO_mean)
printVarSummary(QV_TOPO_std)
printVarSummary(IVT_TOPO_mean)
printVarSummary(IVT_TOPO_std)

printVarSummary(QU_CTR_mean)
printVarSummary(QU_CTR_std)
printVarSummary(QV_CTR_mean)
printVarSummary(QV_CTR_std)
printVarSummary(IVT_CTR_mean)
printVarSummary(IVT_CTR_std)

;=========================
siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
;-----------------QU----------
prob_QU = ttest(QU_TOPO_mean,QU_TOPO_std^2,indep_sample,QU_CTR_mean,QU_CTR_std^2,indep_sample,True,False)
;printVarSummary(prob_QU)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR_QU = QU_TOPO_mean ; metadata
diff_TOPO_CTR_QU = QU_TOPO_mean - QU_CTR_mean

diff_TOPO_CTR_QU_sig = QU_TOPO_mean ; metadata
diff_TOPO_CTR_QU_sig = where(prob_QU .lt. siglvl,QU_TOPO_mean - QU_CTR_mean,diff_TOPO_CTR_QU@_FillValue)

printVarSummary(diff_TOPO_CTR_QU)
printVarSummary(diff_TOPO_CTR_QU_sig)

;-------------QV----------------
prob_QV = ttest(QV_TOPO_mean,QV_TOPO_std^2,indep_sample,QV_CTR_mean,QV_CTR_std^2,indep_sample,True,False)
;printVarSummary(prob_QV)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR_QV = QV_TOPO_mean ; metadata
diff_TOPO_CTR_QV = QV_TOPO_mean - QV_CTR_mean

diff_TOPO_CTR_QV_sig = QV_TOPO_mean ; metadata
diff_TOPO_CTR_QV_sig = where(prob_QV .lt. siglvl,QV_TOPO_mean - QV_CTR_mean,diff_TOPO_CTR_QV@_FillValue)

printVarSummary(diff_TOPO_CTR_QV)
printVarSummary(diff_TOPO_CTR_QV_sig)

;;------------ IVT -------------
;;;wait for 5Moisture_Flux_Step1.ncl to calculate IVT mean and std
prob_IVT = ttest(IVT_TOPO_mean,IVT_TOPO_std^2,indep_sample,IVT_CTR_mean,IVT_CTR_std^2,indep_sample,True,False)
printVarSummary(prob_IVT)

;; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR_IVT = IVT_TOPO_mean ; metadata
diff_TOPO_CTR_IVT = IVT_TOPO_mean - IVT_CTR_mean

diff_TOPO_CTR_IVT_sig = IVT_TOPO_mean ; metadata
diff_TOPO_CTR_IVT_sig = where(prob_IVT .lt. siglvl,IVT_TOPO_mean - IVT_CTR_mean,diff_TOPO_CTR_IVT@_FillValue)

printVarSummary(diff_TOPO_CTR_IVT)
printVarSummary(diff_TOPO_CTR_IVT_sig)

;================ plot ===========
;total 12 days in the TOPOTEST after branching
total_days = 12
do i_day = 0,total_days-1
;do i_day = 0,1
 
wks = gsn_open_wks("png","Regional_IVT_TOPO_vs_CTR_iday_"+tostring(i_day+1))
;wks = gsn_open_wks("x11","Global_IVT_TOPO_vs_CTR_iday_"+tostring(i_day+1))
wks_sig = gsn_open_wks("png","Sig_Regional_IVT_TOPO_vs_CTR_iday_"+tostring(i_day+1))
;wks_sig = gsn_open_wks("x11","Sig_Global_IVT_TOPO_vs_CTR_iday_"+tostring(i_day+1))

;gsn_reverse_colormap(wks)    ; blue color indicate positive precip changes
;gsn_reverse_colormap(wks_sig)    ; blue color indicate positive precip changes

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = "IVT, TOPO - CTR, ENS(180), iday="+tostring(i_day+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -50.0
res@cnMaxLevelValF = 50.0
res@cnLevelSpacingF = 2.0

res@gsnLeftString = "IVT"

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR_IVT(i_day,:,:),res)
plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_IVT_sig(i_day,:,:),res)

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

plot_UV = gsn_csm_vector(wks,diff_TOPO_CTR_QU(i_day,:,:),diff_TOPO_CTR_QV(i_day,:,:),res_vc)
plot_UV_sig = gsn_csm_vector(wks_sig,diff_TOPO_CTR_QU_sig(i_day,:,:),diff_TOPO_CTR_QV_sig(i_day,:,:),res_vc)

;Note: please put the shading plot as the base for the overlay (the first plot) so that the contour of plot_Z3 will not be swallowed.
overlay(plot,plot_UV)
overlay(plot_sig,plot_UV_sig)
draw(plot)
draw(plot_sig)
frame(wks)
frame(wks_sig)
end do

;=================== CTR ENS (180), Clim ==========

wks_clim = gsn_open_wks("png","Clim_Regional_IVT_CTR")

res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 300.0
res@cnLevelSpacingF = 10.0

res@tiMainString = "IVT, CTR ENS(180), DJF Clim"

plot_clim = gsn_csm_contour_map_ce(wks_clim,dim_avg_n_Wrap(IVT_CTR_mean(0:9,:,:),0),res)

res_vc@vcRefMagnitudeF           = 200
res_vc@vcRefAnnoString1          = "200"

plot_UV_clim = gsn_csm_vector(wks_clim,dim_avg_n_Wrap(QU_CTR_mean(0:9,:,:),0),dim_avg_n_Wrap(QV_CTR_mean(0:9,:,:),0),res_vc)

overlay(plot_clim,plot_UV_clim)
draw(plot_clim)
frame(wks_clim)


end
