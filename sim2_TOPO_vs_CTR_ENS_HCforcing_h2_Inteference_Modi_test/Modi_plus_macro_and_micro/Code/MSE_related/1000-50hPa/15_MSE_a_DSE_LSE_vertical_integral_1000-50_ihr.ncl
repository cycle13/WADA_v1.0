;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180807, for ENS(180), PTTEND
;Note: modified 20190506 for hourly PTTEND

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

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.std.mean.TOPOTEST.MSE."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.std.mean.CTR.MSE."+str_time(index)+".nc"

var_str = (/"MSE_mean","DSE_mean","LSE_mean"/)

do i_var = 0, dimsizes(var_str) -1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)

;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS_mean,1,P0mb,1,False)
;printVarSummary(var_mean_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS_mean,1,P0mb,1,False)
;printVarSummary(var_mean_CTR_pnew)

;================= 1000-50hPa weighted average ========
pbot = 1000.0  ; hPa, threshold of integration
ptop = 50.0  ; hPa, threshold of integration

PS_CTR = f_CTR_mean->PS_mean  ; in Pa
PS_CTR = PS_CTR/100.0  ; in hPa
PS_CTR@units = "hPa"
; must from bottom to top
var_mean_CTR_inte = vibeta(pnew(::-1), var_mean_CTR_pnew(time|:,lat|:,lon|:,lev_p|::-1),1,PS_CTR,pbot,ptop)
var_mean_CTR_inte = var_mean_CTR_inte / (pbot - ptop)  
var_mean_CTR_inte@units = "K/sec"

PS_TOPO = f_TOPO_mean->PS_mean  ; in Pa
PS_TOPO = PS_TOPO/100.0  ; in hPa
PS_TOPO@units = "hPa"
; must from bottom to top
var_mean_TOPO_inte = vibeta(pnew(::-1), var_mean_TOPO_pnew(time|:,lat|:,lon|:,lev_p|::-1),1,PS_TOPO,pbot,ptop)
var_mean_TOPO_inte = var_mean_TOPO_inte / (pbot - ptop)  
var_mean_TOPO_inte@units = "K/sec"

var_mean_TOPO_inte!0 = "time"
var_mean_TOPO_inte&time = f_TOPO_mean->time
var_mean_TOPO_inte!1 = "lat"
var_mean_TOPO_inte&lat = f_TOPO_mean->lat
var_mean_TOPO_inte!2 = "lon"
var_mean_TOPO_inte&lon = f_TOPO_mean->lon

var_mean_CTR_inte!0 = "time"
var_mean_CTR_inte&time = f_CTR_mean->time
var_mean_CTR_inte!1 = "lat"
var_mean_CTR_inte&lat = f_CTR_mean->lat
var_mean_CTR_inte!2 = "lon"
var_mean_CTR_inte&lon = f_CTR_mean->lon

printVarSummary(var_mean_TOPO_inte)
printVarSummary(var_mean_CTR_inte)

diff_CTR_TOPO_inte = var_mean_CTR_inte
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


;================ plot ===========
;total 12 days in the TOPOTEST after branching

;total_days = 12
total_hrs = 3

do i_hr = 0,total_hrs-1
;do i_day = 0,3
 
wks = gsn_open_wks("png","../Figures/15_Regional_MSE_DSE_LSE_50-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;wks = gsn_open_wks("x11","Global_PTTEND_50-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
plot = new(9,graphic)

res = True
res@gsnDraw = False
res@gsnFrame = False

res@cnFillOn = True
res@cnLinesOn = False


res@gsnAddCyclic = True

;res@pmLabelBarWidthF  = 0.4
;res@pmLabelBarHeightF = 0.06
;res@pmLabelBarOrthogonalPosF = 0.15
;res@lbLabelAngleF      = 45
;res@lbLabelFontHeightF = 0.01

;res_vc = True
;res_vc@gsnFrame = True
;res_vc@gsnDraw = True
;res_vc@vcGlyphStyle               = "LineArrow"
;res_vc@vcLineArrowThicknessF      = 3
;res_vc@vcMinDistanceF             = 0.02
;res_vc@vcRefLengthF               = 0.03
;
;res_vc@vcRefAnnoOn               = True
;res_vc@vcRefMagnitudeF           = 2 
;res_vc@vcRefAnnoString1          = "2"
;res_vc@vcRefAnnoSide             = "Top"
;res_vc@vcRefAnnoString2On        = False
;res_vc@vcRefAnnoPerimOn          = False
;res_vc@vcRefAnnoOrthogonalPosF   = -0.12
;res_vc@vcRefAnnoParallelPosF     = 0.999
;res_vc@vcRefAnnoBackgroundColor  = "Purple"
;res_vc@vcVectorDrawOrder         = "PostDraw"
;

;res@gsnRightString            = "Wind"
;res_vc@gsnLeftString = ""
;res_vc@gsnRightString = ""

res@tiMainString = "CTR, ENS(9), ihr="+tostring(index*3+i_hr+1)
res@tiMainFontHeightF = 0.015
res@gsnLeftString = "1000-50hPa wgt avg MSE"
res@gsnRightString = "kJ/kg"

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 160.0
res@cnMaxLevelValF = 360.0
res@cnLevelSpacingF = 10.0

plot(0) = gsn_csm_contour_map(wks,MSE_CTR_inte(i_hr,:,:),res)

res@gsnLeftString = "1000-50hPa wgt avg DSE"
plot(1) = gsn_csm_contour_map(wks,DSE_CTR_inte(i_hr,:,:),res)

res@gsnLeftString = "1000-50hPa wgt avg LSE"

res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 15.0
res@cnLevelSpacingF = 1.0
plot(2) = gsn_csm_contour_map(wks,LSE_CTR_inte(i_hr,:,:),res)

res@tiMainString = "TOPO, ENS(9), ihr="+tostring(index*3+i_hr+1)

res@gsnLeftString = "1000-50hPa wgt avg MSE"
res@cnMinLevelValF = 160.0
res@cnMaxLevelValF = 360.0
res@cnLevelSpacingF = 10.0
plot(3) = gsn_csm_contour_map(wks,MSE_TOPO_inte(i_hr,:,:),res)

res@gsnLeftString = "1000-50hPa wgt avg DSE"
plot(4) = gsn_csm_contour_map(wks,DSE_TOPO_inte(i_hr,:,:),res)

res@gsnLeftString = "1000-50hPa wgt avg LSE"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 15.0
res@cnLevelSpacingF = 1.0
plot(5) = gsn_csm_contour_map(wks,LSE_TOPO_inte(i_hr,:,:),res)

;res@cnMinLevelValF = -6.0
;res@cnMaxLevelValF = 6.0
;res@cnLevelSpacingF = 0.4
res@tiMainString = "CTR - TOPO, ENS(9), ihr="+tostring(index*3+i_hr+1)

res@gsnLeftString = "1000-50hPa wgt avg MSE"

res@cnMinLevelValF = -1.6
res@cnMaxLevelValF = 1.6
res@cnLevelSpacingF = 0.2
plot(6) = gsn_csm_contour_map(wks,MSE_diff_CTR_TOPO_inte(i_hr,:,:),res)

res@gsnLeftString = "1000-50hPa wgt avg DSE"
plot(7) = gsn_csm_contour_map(wks,DSE_diff_CTR_TOPO_inte(i_hr,:,:),res)

res@gsnLeftString = "1000-50hPa wgt avg LSE"
plot(8) = gsn_csm_contour_map(wks,LSE_diff_CTR_TOPO_inte(i_hr,:,:),res)

;--------------
resP = True
resP@txString = "Verti_inte MSE, DSE, LSE in CTR, TOPO and CTR-TOPO, ihr="+tostring(index*3+i_hr+1)
gsn_panel(wks, plot, (/3,3/), resP)


end do ; do i_hr

;-------- output nc files -------
dir_TOPO_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/TOPO_TEST/"
dir_CTR_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/CTR/"
system("rm "+dir_TOPO_out+"MSE_DSE_LE.TOPOTEST.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"MSE_DSE_LE.TOPOTEST.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1, True)
ncdf_TOPO->MSE_inte = MSE_TOPO_inte
ncdf_TOPO->DSE_inte = DSE_TOPO_inte
ncdf_TOPO->LSE_inte = LSE_TOPO_inte

system("rm "+dir_CTR_out+"MSE_DSE_LE.CTR.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"MSE_DSE_LE.CTR.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_CTR,"time",-1, True)
ncdf_CTR->MSE_inte = MSE_CTR_inte
ncdf_CTR->DSE_inte = DSE_CTR_inte
ncdf_CTR->LSE_inte = LSE_CTR_inte

end do ; do index

end
