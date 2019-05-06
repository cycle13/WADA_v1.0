;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180807, for ENS(180), PTTEND

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing_PTTEND/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.nc"
TOPO_std_str = "ENS.std.TOPOTEST.nc"

CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing_PTTEND/CTR/"
CTR_mean_str = "ENS.mean.CTR.nc"
CTR_std_str = "ENS.std.CTR.nc"

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

diff_TOPO_CTR_inte = var_mean_TOPO_inte
diff_TOPO_CTR_inte = var_mean_TOPO_inte - var_mean_CTR_inte

printVarSummary(diff_TOPO_CTR_inte)

;---------------------------

;if (i_var .eq. 0) then
   PTTEND_mean_CTR_inte = var_mean_CTR_inte   ; for Clim plot
   PTTEND_diff_TOPO_CTR_inte = diff_TOPO_CTR_inte
;else
;   V_mean_CTR_inte = var_mean_CTR_inte   ; for Clim plot
;   V_diff_TOPO_CTR_inte = diff_TOPO_CTR_inte
;end if

end do ; do ivar

printVarSummary(PTTEND_diff_TOPO_CTR_inte)
;printVarSummary(V_diff_TOPO_CTR_inte)

;printVarSummary(f_TOPO_mean->PS)
;printVarSummary(f_CTR_mean->PS)
;print(V_diff_TOPO_CTR&lev_p)

;================ plot ===========
;total 12 days in the TOPOTEST after branching

;total_days = 12
total_days = 10

do i_day = 0,total_days-1
;do i_day = 0,3
 
;wks = gsn_open_wks("png","Regional_PTTEND_50-1000hPa_TOPO_vs_CTR_iday_"+tostring(i_day+1))
wks = gsn_open_wks("x11","Global_PTTEND_50-1000hPa_TOPO_vs_CTR_iday_"+tostring(i_day+1))

res = True
res@gsnDraw = True
res@gsnFrame = True

res@cnFillOn = True
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -5.0e-5
res@cnMaxLevelValF = 5.0e-5
res@cnLevelSpacingF = 0.2e-5
res@gsnContourNegLineDashPattern = 1

res@gsnAddCyclic = True

res@pmLabelBarWidthF  = 0.4
res@pmLabelBarHeightF = 0.06
res@pmLabelBarOrthogonalPosF = 0.15
res@lbLabelAngleF      = 45
res@lbLabelFontHeightF = 0.01

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

res@tiMainString = "PTTEND (K/sec); 1000-50hPa wgt avg , TOPO - CTR, ENS(180), iday="+tostring(i_day+1)
res@tiMainFontHeightF = 0.015
res@gsnLeftString = "diff_PTTEND"
res@gsnRightString = "K/sec"

;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0

plot = gsn_csm_contour_map(wks,PTTEND_diff_TOPO_CTR_inte(i_day,:,:),res)


end do ; do i_day 

;======== Note: that sampling frequency is every 10 days per member through DJF, DJF mean all first 10 days for the ENS ===

;wks_clim = gsn_open_wks("png","Clim_Regional_PTTEND-1000-50hPa_CTR")
wks_clim = gsn_open_wks("x11","Clim_Global_PTTEND-1000-50hPa_CTR")


res = True
res@gsnFrame = True
res@gsnDraw = True

;res@vcGlyphStyle               = "LineArrow"
;res@vcLineArrowThicknessF      = 1
;res@vcMinDistanceF             = 0.02
;res@vcRefLengthF               = 0.03

;res@vcRefAnnoOn               = True

;res@vcRefMagnitudeF           = 6
;res@vcRefAnnoString1          = "6"

;res@vcRefAnnoSide             = "Top"
;res@vcRefAnnoString2On        = False
;res@vcRefAnnoPerimOn          = False
;res@vcRefAnnoOrthogonalPosF   = -0.12
;res@vcRefAnnoParallelPosF     = 0.999
;res@vcRefAnnoBackgroundColor  = "Purple"
;res@vcVectorDrawOrder         = "PostDraw"

res@tiMainString = "PTTEND (K/sec); 1000-50hPa wgt avg , CTR, ENS(180), Clim"
res@gsnLeftString = "PTTEND"
res@gsnRightString = "K/sec"

plot_clim = gsn_csm_contour_map(wks_clim,dim_avg_n_Wrap(PTTEND_mean_CTR_inte(0:9,:,:),0),res)



end
