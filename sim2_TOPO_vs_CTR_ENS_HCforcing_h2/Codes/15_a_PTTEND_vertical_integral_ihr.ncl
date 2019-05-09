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

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_PTTEND/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST."+str_time(index)+".nc" 

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_PTTEND/CTR/"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR."+str_time(index)+".nc"

var_str = (/"PTTEND"/)

do i_var = 0, dimsizes(var_str) -1

var = var_str(i_var)

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

;================= 1000-50hPa weighted average ========
pbot = 1000.0  ; hPa, threshold of integration
ptop = 50.0  ; hPa, threshold of integration

PS_CTR = f_CTR_mean->PS  ; in Pa
PS_CTR = PS_CTR/100.0  ; in hPa
PS_CTR@units = "hPa"
; must from bottom to top
var_mean_CTR_inte = vibeta(pnew(::-1), var_mean_CTR_pnew(time|:,lat|:,lon|:,lev_p|::-1),1,PS_CTR,pbot,ptop)
var_mean_CTR_inte = var_mean_CTR_inte / (pbot - ptop)  
var_mean_CTR_inte@units = "K/sec"

PS_TOPO = f_TOPO_mean->PS  ; in Pa
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
PTTEND_CTR_inte = var_mean_CTR_inte ; metadata
PTTEND_CTR_inte = var_mean_CTR_inte * 24 * 60 * 60  ; from K/sec to K/day
printVarSummary(PTTEND_CTR_inte&lon)

PTTEND_TOPO_inte = var_mean_TOPO_inte ; metadata
PTTEND_TOPO_inte = var_mean_TOPO_inte * 24 * 60 * 60

PTTEND_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
PTTEND_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte * 24 * 60 * 60  ; from K/sec to K/day

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
 
wks = gsn_open_wks("png","../Figures/15_Regional_PTTEND_50-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;wks = gsn_open_wks("x11","Global_PTTEND_50-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
plot = new(3,graphic)

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

res@tiMainString = "CTR - TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@tiMainFontHeightF = 0.015
res@gsnLeftString = "1000-50hPa wgt avg PTTEND"
res@gsnRightString = "K/day"

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -6.0
res@cnMaxLevelValF = 6.0
res@cnLevelSpacingF = 0.4
res@gsnContourNegLineDashPattern = 1

plot(0) = gsn_csm_contour_map(wks,PTTEND_diff_CTR_TOPO_inte(i_hr,:,:),res)

;res@cnMinLevelValF = -5.0
;res@cnMaxLevelValF = 5.0
;res@cnLevelSpacingF = 0.2

res@tiMainString = "CTR, ENS(180), ihr="+tostring(index*3+i_hr+1)

res@cnMinLevelValF = -6.0
res@cnMaxLevelValF = 6.0
res@cnLevelSpacingF = 0.4

plot(1) = gsn_csm_contour_map(wks,PTTEND_CTR_inte(i_hr,:,:),res)

res@tiMainString = "TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)

plot(2) = gsn_csm_contour_map(wks,PTTEND_TOPO_inte(i_hr,:,:),res)

;--------------
resP = True
resP@txString = "Vertically integrated PTTEND in CTR, TOPO and CTR-TOPO"
gsn_panel(wks, plot, (/1,3/), resP)

end do ; do i_hr

end do ; do index

end
