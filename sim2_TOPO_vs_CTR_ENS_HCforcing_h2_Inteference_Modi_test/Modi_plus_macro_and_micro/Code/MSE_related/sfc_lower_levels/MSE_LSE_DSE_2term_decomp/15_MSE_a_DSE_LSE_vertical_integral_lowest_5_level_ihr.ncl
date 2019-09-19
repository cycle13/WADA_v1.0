
load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

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

str_time = new(32,string)
;time_label = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = "time"+tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
;time_label(i_str_time) = "time"+str_time(i_str_time)
end do

do index = 0,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"+"OLD/"
TOPO_mean_str = "ENS.std.mean.TOPOTEST.MSE."+str_time(index)+".nc"

PS_TOPO_str = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
PS_mean_TOPO_str = "ENS.std.mean.TOPOTEST.MSE.3term."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.std.mean.CTR.MSE."+str_time(index)+".nc"

PS_CTR_str = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
PS_mean_CTR_str = "ENS.std.mean.CTR.MSE.3term."+str_time(index)+".nc"

hybrid_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
hybrid_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"

f_hybrid = addfile(hybrid_dir + hybrid_str,"r")

var_str = (/"MSE_mean","DSE_mean","LSE_mean"/)

do i_var = 0, dimsizes(var_str) -1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_PS_mean_TOPO = addfile(PS_TOPO_str+PS_mean_TOPO_str,"r")
f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_PS_mean_CTR = addfile(CTR_dir+PS_mean_CTR_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)

hyai = f_hybrid->hyai
hybi = f_hybrid->hybi

PS_TOPO = f_PS_mean_TOPO->PS_mean
P0 = 100000.0 ; Pa
dph_TOPO = dpres_hybrid_ccm(PS_TOPO,P0,hyai,hybi)
printVarSummary(PS_TOPO)
printVarSummary(dph_TOPO)

PS_CTR = f_PS_mean_CTR->PS_mean
dph_CTR = dpres_hybrid_ccm(PS_CTR,P0,hyai,hybi)

;------ lowest five layers ------
;lowest_lev = 5
lowest_lev = 10

var_mean_TOPO_inte = dim_sum_n_Wrap(var_mean_TOPO(:,30-lowest_lev:29,:,:) * dph_TOPO(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_TOPO(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_TOPO,var_mean_TOPO_inte)
printVarSummary(var_mean_TOPO_inte)

var_mean_CTR_inte = dim_sum_n_Wrap(var_mean_CTR(:,30-lowest_lev:29,:,:) * dph_CTR(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_CTR(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_CTR,var_mean_CTR_inte)
printVarSummary(var_mean_CTR_inte)

diff_CTR_TOPO_inte = var_mean_CTR_inte ; metadata
diff_CTR_TOPO_inte = var_mean_CTR_inte - var_mean_TOPO_inte
printVarSummary(diff_CTR_TOPO_inte)

;---------------------------
if (i_var .eq. 0) then
MSE_CTR_inte = var_mean_CTR_inte ; metadata
MSE_CTR_inte = var_mean_CTR_inte / 1000.0 ; metadata
MSE_CTR_inte@units = "kJ/kg"

MSE_TOPO_inte = var_mean_TOPO_inte; metadata
MSE_TOPO_inte = var_mean_TOPO_inte / 1000.0; metadata
MSE_TOPO_inte@units = "kJ/kg"

MSE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
MSE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte / 1000.0 ; metadata
MSE_TOPO_inte@units = "kJ/kg"
end if

if (i_var .eq. 1) then
DSE_CTR_inte = var_mean_CTR_inte ; metadata
DSE_CTR_inte = var_mean_CTR_inte /1000.0; metadata
DSE_CTR_inte@units = "kJ/kg"

DSE_TOPO_inte = var_mean_TOPO_inte ; metadata
DSE_TOPO_inte = var_mean_TOPO_inte /1000.0; metadata
DSE_TOPO_inte@units = "kJ/kg"

DSE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
DSE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte / 1000.0 ; metadata
DSE_diff_CTR_TOPO_inte@units = "kJ/kg"

end if

if (i_var .eq. 2) then
LSE_CTR_inte = var_mean_CTR_inte ; metadata
LSE_CTR_inte = var_mean_CTR_inte /1000.0; metadata
LSE_CTR_inte@units = "kJ/kg"

LSE_TOPO_inte = var_mean_TOPO_inte ; metadata
LSE_TOPO_inte = var_mean_TOPO_inte /1000.0 ; metadata
LSE_TOPO_inte@units = "kJ/kg"

LSE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
LSE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte / 1000.0 ; metadata
LSE_diff_CTR_TOPO_inte@units = "kJ/kg"

end if

end do ; do ivar

;printVarSummary(f_TOPO_mean->PS)
;printVarSummary(f_CTR_mean->PS)
;print(V_diff_TOPO_CTR&lev_p)

;;================ plot ===========
;;total 12 days in the TOPOTEST after branching
;
;;total_days = 12
;total_hrs = 3
;
;do i_hr = 0,total_hrs-1
;;do i_day = 0,3
; 
;wks = gsn_open_wks("png","../Figures/15_Regional_MSE_DSE_LSE_850-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;;wks = gsn_open_wks("x11","Global_PTTEND_50-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;plot = new(9,graphic)
;
;res = True
;res@gsnDraw = False
;res@gsnFrame = False
;
;res@cnFillOn = True
;res@cnLinesOn = False
;
;
;res@gsnAddCyclic = True
;
;;res@pmLabelBarWidthF  = 0.4
;;res@pmLabelBarHeightF = 0.06
;;res@pmLabelBarOrthogonalPosF = 0.15
;;res@lbLabelAngleF      = 45
;;res@lbLabelFontHeightF = 0.01
;
;;res_vc = True
;;res_vc@gsnFrame = True
;;res_vc@gsnDraw = True
;;res_vc@vcGlyphStyle               = "LineArrow"
;;res_vc@vcLineArrowThicknessF      = 3
;;res_vc@vcMinDistanceF             = 0.02
;;res_vc@vcRefLengthF               = 0.03
;;
;;res_vc@vcRefAnnoOn               = True
;;res_vc@vcRefMagnitudeF           = 2 
;;res_vc@vcRefAnnoString1          = "2"
;;res_vc@vcRefAnnoSide             = "Top"
;;res_vc@vcRefAnnoString2On        = False
;;res_vc@vcRefAnnoPerimOn          = False
;;res_vc@vcRefAnnoOrthogonalPosF   = -0.12
;;res_vc@vcRefAnnoParallelPosF     = 0.999
;;res_vc@vcRefAnnoBackgroundColor  = "Purple"
;;res_vc@vcVectorDrawOrder         = "PostDraw"
;;
;
;;res@gsnRightString            = "Wind"
;;res_vc@gsnLeftString = ""
;;res_vc@gsnRightString = ""
;
;res@tiMainString = "CTR, ENS(9), ihr="+tostring(index*3+i_hr+1)
;res@tiMainFontHeightF = 0.015
;res@gsnLeftString = "1000-850hPa wgt avg MSE"
;res@gsnRightString = "kJ/kg"
;
;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0
;
;res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = 160.0
;res@cnMaxLevelValF = 360.0
;res@cnLevelSpacingF = 10.0
;
;plot(0) = gsn_csm_contour_map(wks,MSE_CTR_inte(i_hr,:,:),res)
;
;res@gsnLeftString = "1000-850hPa wgt avg DSE"
;plot(1) = gsn_csm_contour_map(wks,DSE_CTR_inte(i_hr,:,:),res)
;
;res@gsnLeftString = "1000-850hPa wgt avg LSE"
;
;res@cnMinLevelValF = 0.0
;res@cnMaxLevelValF = 15.0
;res@cnLevelSpacingF = 1.0
;plot(2) = gsn_csm_contour_map(wks,LSE_CTR_inte(i_hr,:,:),res)
;
;res@tiMainString = "TOPO, ENS(9), ihr="+tostring(index*3+i_hr+1)
;
;res@gsnLeftString = "1000-850hPa wgt avg MSE"
;res@cnMinLevelValF = 160.0
;res@cnMaxLevelValF = 360.0
;res@cnLevelSpacingF = 10.0
;plot(3) = gsn_csm_contour_map(wks,MSE_TOPO_inte(i_hr,:,:),res)
;
;res@gsnLeftString = "1000-850hPa wgt avg DSE"
;plot(4) = gsn_csm_contour_map(wks,DSE_TOPO_inte(i_hr,:,:),res)
;
;res@gsnLeftString = "1000-850hPa wgt avg LSE"
;res@cnMinLevelValF = 0.0
;res@cnMaxLevelValF = 15.0
;res@cnLevelSpacingF = 1.0
;plot(5) = gsn_csm_contour_map(wks,LSE_TOPO_inte(i_hr,:,:),res)
;
;;res@cnMinLevelValF = -6.0
;;res@cnMaxLevelValF = 6.0
;;res@cnLevelSpacingF = 0.4
;res@tiMainString = "CTR - TOPO, ENS(9), ihr="+tostring(index*3+i_hr+1)
;
;res@gsnLeftString = "1000-850hPa wgt avg MSE"
;
;res@cnMinLevelValF = -1.6
;res@cnMaxLevelValF = 1.6
;res@cnLevelSpacingF = 0.2
;plot(6) = gsn_csm_contour_map(wks,MSE_diff_CTR_TOPO_inte(i_hr,:,:),res)
;
;res@gsnLeftString = "1000-850hPa wgt avg DSE"
;plot(7) = gsn_csm_contour_map(wks,DSE_diff_CTR_TOPO_inte(i_hr,:,:),res)
;
;res@gsnLeftString = "1000-850hPa wgt avg LSE"
;plot(8) = gsn_csm_contour_map(wks,LSE_diff_CTR_TOPO_inte(i_hr,:,:),res)
;
;;--------------
;resP = True
;resP@txString = "Verti_inte MSE, DSE, LSE in CTR, TOPO and CTR-TOPO, ihr="+tostring(index*3+i_hr+1)
;gsn_panel(wks, plot, (/3,3/), resP)
;
;
;end do ; do i_hr

;-------- output nc files -------
dir_TOPO_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/TOPO_TEST/"
dir_CTR_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/CTR/"
system("rm "+dir_TOPO_out+"MSE_DSE_LE.TOPOTEST.L10.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"MSE_DSE_LE.TOPOTEST.L10.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1, True)
ncdf_TOPO->MSE_inte = MSE_TOPO_inte
ncdf_TOPO->DSE_inte = DSE_TOPO_inte
ncdf_TOPO->LSE_inte = LSE_TOPO_inte

system("rm "+dir_CTR_out+"MSE_DSE_LE.CTR.L10.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"MSE_DSE_LE.CTR.L10.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_CTR,"time",-1, True)
ncdf_CTR->MSE_inte = MSE_CTR_inte
ncdf_CTR->DSE_inte = DSE_CTR_inte
ncdf_CTR->LSE_inte = LSE_CTR_inte

end do ; do index

end
