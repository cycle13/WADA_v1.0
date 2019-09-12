
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
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"
PS_mean_TOPO_str = "ENS.std.mean.TOPOTEST.MSE.3term."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"
PS_mean_CTR_str = "ENS.std.mean.CTR.MSE.3term."+str_time(index)+".nc"

var_str = (/"T"/)

do i_var = 0, dimsizes(var_str) -1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_PS_mean_TOPO = addfile(TOPO_dir+PS_mean_TOPO_str,"r")
f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_PS_mean_CTR = addfile(CTR_dir+PS_mean_CTR_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)

var_mean_TOPO@_FillValue = -9999
var_mean_CTR@_FillValue = -9999

printVarSummary(var_mean_TOPO)
printVarSummary(var_mean_CTR)

;========== hybrid coordinate to pressure coordinate ====
pnew = f_CTR_mean->lev
pnew@units = "hPa"
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_PS_mean_TOPO->PS_mean,1,P0mb,1,False)
var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_PS_mean_CTR->PS_mean,1,P0mb,1,False)

var_mean_TOPO_pnew@_FillValue = -9999
var_mean_CTR_pnew@_FillValue = -9999
printVarSummary(var_mean_CTR_pnew)

;================= 1000-50hPa weighted average ========
pbot = 1000.0  ; hPa, threshold of integration
ptop = 50.0  ; hPa, threshold of integration
;ptop = 850.0  ; hPa, threshold of integration
;ptop = 150.0  ; hPa, threshold of integration

PS_CTR = f_PS_mean_CTR->PS_mean  ; in Pa
PS_CTR = PS_CTR/100.0  ; in hPa
PS_CTR@units = "hPa"
; must from bottom to top
;dp = dpres_plevel(pnew, PS_CTR, ptop, 0)
;var_mean_CTR_inte =  wgt_vertical_n(var_mean_CTR_pnew , dp, 0, 1 )

;var_mean_CTR_inte = vibeta(pnew(::-1), var_mean_CTR_pnew(time|:,lat|:,lon|:,lev_p|::-1),1,PS_CTR,pbot,ptop)
var_mean_CTR_inte = vibeta(pnew(::-1), var_mean_CTR_pnew(time|:,lat|:,lon|:,lev|::-1),1,PS_CTR,pbot,ptop)
var_mean_CTR_inte = var_mean_CTR_inte / (pbot - ptop)  
var_mean_CTR_inte@units = "K"

PS_TOPO = f_PS_mean_TOPO->PS_mean  ; in Pa
PS_TOPO = PS_TOPO/100.0  ; in hPa
PS_TOPO@units = "hPa"
; must from bottom to top
;var_mean_TOPO_inte = vibeta(pnew(::-1), var_mean_TOPO_pnew(time|:,lat|:,lon|:,lev_p|::-1),1,PS_TOPO,pbot,ptop)
var_mean_TOPO_inte = vibeta(pnew(::-1), var_mean_TOPO_pnew(time|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)
var_mean_TOPO_inte = var_mean_TOPO_inte / (pbot - ptop)  
var_mean_TOPO_inte@units = "K"

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
T_CTR_inte = var_mean_CTR_inte ; metadata
T_CTR_inte@units = "Kelvin"
T_CTR_inte&lat = f_CTR_mean->lat
T_CTR_inte&lon = f_CTR_mean->lon

T_TOPO_inte = var_mean_TOPO_inte; metadata
T_TOPO_inte@units = "Kelvin"
T_TOPO_inte&lat = f_TOPO_mean->lat
T_TOPO_inte&lon = f_TOPO_mean->lon

T_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
T_diff_CTR_TOPO_inte@units = "Kelvin"
T_diff_CTR_TOPO_inte&lat = f_CTR_mean->lat
T_diff_CTR_TOPO_inte&lon = f_CTR_mean->lon
end if

end do ; do ivar

;================ plot ===========
;total 12 days in the TOPOTEST after branching

;total_days = 12
total_hrs = 3

do i_hr = 0,total_hrs-1
;do i_day = 0,3
 
wks = gsn_open_wks("x11","../Figures/15_Regional_T_TEST__TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;wks = gsn_open_wks("x11","Global_PTTEND_50-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
plot = new(3,graphic)

res = True
res@gsnDraw = False
res@gsnFrame = False

res@cnFillOn = True
res@cnLinesOn = False

;res@gsnAddCyclic = True

res@tiMainString = "ENS(9), ihr="+tostring(index*3+i_hr+1)
res@tiMainFontHeightF = 0.015
res@gsnLeftString = "wgt avg T, CTR"
res@gsnRightString = "Kelvin"

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0

;res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = 260.0
;res@cnMaxLevelValF = 300.0
;res@cnLevelSpacingF = 5.0

plot(0) = gsn_csm_contour_map(wks,T_CTR_inte(i_hr,:,:),res)
;plot(0) = gsn_csm_contour_map(wks,var_mean_CTR(i_hr,{900.0},:,:),res)

res@gsnLeftString = " wgt avg T, TOPO"
plot(1) = gsn_csm_contour_map(wks,T_TOPO_inte(i_hr,:,:),res)
;plot(1) = gsn_csm_contour_map(wks,var_mean_TOPO(i_hr,{900.0},:,:),res)

res@gsnLeftString = " wgt avg T, CTR-TOPO"

;res@cnMinLevelValF = -3.0
;res@cnMaxLevelValF = 3.0
;res@cnLevelSpacingF = 0.5
plot(2) = gsn_csm_contour_map(wks,T_diff_CTR_TOPO_inte(i_hr,:,:),res)
;plot(2) = gsn_csm_contour_map(wks,temp,res)

;--------------
resP = True
resP@txString = "wgt_avg T in CTR, TOPO and CTR-TOPO, ihr="+tostring(index*3+i_hr+1)
gsn_panel(wks, plot, (/3,1/), resP)


end do ; do i_hr


end do ; do index

end
