;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.nc"
TOPO_std_str = "ENS.std.TOPOTEST.nc"

CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.nc"
CTR_std_str = "ENS.std.CTR.nc"

var_str = (/"U","V"/)

do i_var = 0, 1

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

;================= 700-900hPa weighted average ========
pbot = 900.0  ; hPa, threshold of integration
ptop = 700.0  ; hPa, threshold of integration

PS_CTR = f_CTR_mean->PS  ; in Pa
PS_CTR = PS_CTR/100.0  ; in hPa
PS_CTR@units = "hPa"
; must from bottom to top
var_mean_CTR_inte = vibeta(pnew(::-1), var_mean_CTR_pnew(time|:,lat|:,lon|:,lev_p|::-1),1,PS_CTR,pbot,ptop)
var_mean_CTR_inte = var_mean_CTR_inte / (pbot - ptop)  
var_mean_CTR_inte@units = "m/sec"

PS_TOPO = f_TOPO_mean->PS  ; in Pa
PS_TOPO = PS_TOPO/100.0  ; in hPa
PS_TOPO@units = "hPa"
; must from bottom to top
var_mean_TOPO_inte = vibeta(pnew(::-1), var_mean_TOPO_pnew(time|:,lat|:,lon|:,lev_p|::-1),1,PS_TOPO,pbot,ptop)
var_mean_TOPO_inte = var_mean_TOPO_inte / (pbot - ptop)  
var_mean_TOPO_inte@units = "m/sec"

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

if (i_var .eq. 0) then
   U_mean_CTR_inte = var_mean_CTR_inte   ; for Clim plot
   U_diff_TOPO_CTR_inte = diff_TOPO_CTR_inte
else
   V_mean_CTR_inte = var_mean_CTR_inte   ; for Clim plot
   V_diff_TOPO_CTR_inte = diff_TOPO_CTR_inte
end if
end do ; do ivar

printVarSummary(U_diff_TOPO_CTR_inte)
printVarSummary(V_diff_TOPO_CTR_inte)

;printVarSummary(f_TOPO_mean->PS)
;printVarSummary(f_CTR_mean->PS)
;print(V_diff_TOPO_CTR&lev_p)

;================ plot ===========
;total 12 days in the TOPOTEST after branching

;total_days = 12
total_days = 10

do i_day = 0,total_days-1
;do i_day = 0,3
 
wks = gsn_open_wks("png","Regional_U_V_700-900_TOPO_vs_CTR_iday_"+tostring(i_day+1))

res_vc = True
res_vc@gsnDraw = False
res_vc@gsnFrame = False

;res_vc@cnLevelSelectionMode = "ManualLevels"
;res_vc@cnMinLevelValF = -20.0
;res_vc@cnMaxLevelValF = 20.0
;res_vc@cnLevelSpacingF = 1.0
;res_vc@gsnContourNegLineDashPattern = 1

res_vc@gsnAddCyclic = True

;res@pmLabelBarWidthF  = 0.4
;res@pmLabelBarHeightF = 0.06
;res@pmLabelBarOrthogonalPosF = 0.15
;res@lbLabelAngleF      = 45
;res@lbLabelFontHeightF = 0.01

res_vc = True
res_vc@gsnFrame = True
res_vc@gsnDraw = True
res_vc@vcGlyphStyle               = "LineArrow"
res_vc@vcLineArrowThicknessF      = 3
res_vc@vcMinDistanceF             = 0.02
res_vc@vcRefLengthF               = 0.03

res_vc@vcRefAnnoOn               = True
res_vc@vcRefMagnitudeF           = 2 
res_vc@vcRefAnnoString1          = "2"
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

res_vc@tiMainString = "U,V (m/sec); 900-700hPa wgt avg , TOPO - CTR, ENS(180), iday="+tostring(i_day+1)
res_vc@tiMainFontHeightF = 0.015
res_vc@gsnLeftString = ""
res_vc@gsnRightString = ""

res_vc@mpMaxLatF = 60.0
res_vc@mpMinLatF = -60.0
res_vc@mpMaxLonF = 350.0
res_vc@mpMinLonF = 230.0

plot_UV = gsn_csm_vector_map(wks,U_diff_TOPO_CTR_inte(i_day,:,:),V_diff_TOPO_CTR_inte(i_day,:,:),res_vc)


end do ; do i_day 

;======== Note: that sampling frequency is every 10 days per member through DJF, DJF mean all first 10 days for the ENS ===

wks_clim = gsn_open_wks("png","Clim_Regional_U_V_700-900_CTR")


res_vc = True
res_vc@gsnFrame = True
res_vc@gsnDraw = True

res_vc@vcGlyphStyle               = "LineArrow"
res_vc@vcLineArrowThicknessF      = 1
res_vc@vcMinDistanceF             = 0.02
res_vc@vcRefLengthF               = 0.03

res_vc@vcRefAnnoOn               = True

res_vc@vcRefMagnitudeF           = 6
res_vc@vcRefAnnoString1          = "6"

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

plot_UV_clim = gsn_csm_vector_map(wks_clim,dim_avg_n_Wrap(U_mean_CTR_inte(0:9,:,:),0),dim_avg_n_Wrap(V_mean_CTR_inte(0:9,:,:),0),res_vc)



end
