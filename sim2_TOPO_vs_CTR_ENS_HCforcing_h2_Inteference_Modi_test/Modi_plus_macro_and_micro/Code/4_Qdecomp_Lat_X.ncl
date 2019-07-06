;Function:  Use QAP:I to calculate partialQ/partialT. Then minus PTEQ to estimate Q_adv from horizontal and vertical
;partialQ_partialT term, Total_adv term, PTEQ term. CTR and TOPO, CTR - TOPO
;Date: 20190705

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

;-------------
str_time = new(32,string)
;time_label = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = "time"+tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
;time_label(i_str_time) = "time"+str_time(i_str_time)
end do

;time_label = (/"time0-5","time6-11","time12-17","time18-23","time24-29","time30-35","time36-41","time42-47"/)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

QAP_mean_CTR = new((/96, 30, 96, 144/),double)
QAP_mean_TOPO = new((/96, 30, 96, 144/),double)
QAP_diff_CTR_TOPO = new((/96, 30, 96, 144/),double)

PTEQ_mean_CTR = new((/96, 30, 96, 144/),double)
PTEQ_mean_TOPO = new((/96, 30, 96, 144/),double)
PTEQ_diff_CTR_TOPO = new((/96, 30, 96, 144/),double)

Qt_mean_CTR = new((/95, 30, 96, 144/),double)  ; partial Q/ partial t; QAP(i) - QAP(i-1)
Qt_mean_TOPO = new((/95, 30, 96, 144/),double)
Qt_diff_CTR_TOPO = new((/95, 30, 96, 144/),double)

Qadv_mean_CTR = new((/95, 30, 96, 144/),double)  ; Qt - PTEQ
Qadv_mean_TOPO = new((/95, 30, 96, 144/),double)
Qadv_diff_CTR_TOPO = new((/95, 30, 96, 144/),double)

do index = 0,31
;do index = 10,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
;TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
;TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/CTR/"
;CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR."+str_time(index)+".nc"

var_str = (/"QAP","PTEQ"/)

do i_var = 0, dimsizes(var_str)-1
;do i_var = 5, dimsizes(var_str)-1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)

;========== hybrid coordinate to pressure coordinate ====
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
pnew = (/3.64346569404006, 7.59481964632869, 14.3566322512925,\
    24.6122200042009, 38.2682997733355, 54.5954797416925, 72.0124505460262,\
    87.8212302923203, 103.317126631737, 121.547240763903, 142.994038760662,\
    168.225079774857, 197.908086702228, 232.828618958592, 273.910816758871,\
    322.241902351379, 379.100903868675, 445.992574095726, 524.687174707651,\
    609.778694808483, 691.389430314302, 763.404481112957, 820.858368650079,\
    859.53476652503, 887.020248919725, 912.644546944648, 936.198398470879,\
    957.485479535535, 976.325407391414, 992.556095123291 /)

;pnew = fspan(100.0,1000.0,200)

P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_mean_TOPO_pnew&lev_p@units = "hPa" 
;printVarSummary(var_mean_TOPO_pnew&lev_p)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev_p@units = "hPa"
;printVarSummary(var_mean_CTR_pnew)

diff_CTR_TOPO = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_CTR_TOPO = var_mean_CTR_pnew - var_mean_TOPO_pnew
diff_CTR_TOPO@units = var_mean_TOPO@units
diff_CTR_TOPO@long_name = var_mean_TOPO@long_name

if (i_var .eq. 0) then
   QAP_mean_CTR(index*3:index*3+2,:,:,:) = var_mean_CTR_pnew
   QAP_mean_TOPO(index*3:index*3+2,:,:,:) = var_mean_TOPO_pnew
   QAP_diff_CTR_TOPO(index*3:index*3+2,:,:,:) = diff_CTR_TOPO
end if
if (i_var .eq. 1) then
   PTEQ_mean_CTR(index*3:index*3+2,:,:,:) = var_mean_CTR_pnew
   PTEQ_mean_TOPO(index*3:index*3+2,:,:,:) = var_mean_TOPO_pnew
   PTEQ_diff_CTR_TOPO(index*3:index*3+2,:,:,:) = diff_CTR_TOPO
end if

end do ; do ivar

end do ; do index

Qt_mean_CTR = QAP_mean_CTR(1:95,:,:,:) ; metadata
Qt_mean_CTR = QAP_mean_CTR(1:95,:,:,:) - QAP_mean_CTR(0:94,:,:,:)  ; partial Q / partial t = (QAP(i) - QAP(i-1)) / 1 hr
Qt_mean_CTR@units = "kg/kg /hr"
Qt_mean_CTR@long_name = "partial Q/ partial t, local specific humidity changes with respect to time"

Qt_mean_TOPO = QAP_mean_TOPO(1:95,:,:,:) ; metadata
Qt_mean_TOPO = QAP_mean_TOPO(1:95,:,:,:) - QAP_mean_TOPO(0:94,:,:,:)  ; partial Q / partial t = QAP(i) - QAP(i-1)
Qt_mean_TOPO@units = "kg/kg / hr"
Qt_mean_TOPO@long_name = "partial Q/ partial t, local specific humidity changes with respect to time"

Qt_diff_CTR_TOPO = QAP_diff_CTR_TOPO(1:95,:,:,:) ; metadata
Qt_diff_CTR_TOPO = QAP_diff_CTR_TOPO(1:95,:,:,:) - QAP_diff_CTR_TOPO(0:94,:,:,:)  ; partial Q / partial t = QAP(i) - QAP(i-1)
Qt_diff_CTR_TOPO@units = "kg/kg / hr"
Qt_diff_CTR_TOPO@long_name = "partial Q/ partial t, local specific humidity changes with respect to time"

PTEQ_mean_CTR2 = PTEQ_mean_CTR(1:95,:,:,:) ; make it consistent with Qt in time dimension,
PTEQ_mean_CTR2 = PTEQ_mean_CTR2 * 3600 ; make it also convert from kg/kg/s to kg/kg/hr
PTEQ_mean_CTR2@units = "kg/kg/hr"
PTEQ_mean_TOPO2 = PTEQ_mean_TOPO(1:95,:,:,:)
PTEQ_mean_TOPO2 = PTEQ_mean_TOPO2 * 3600
PTEQ_mean_TOPO2@units = "kg/kg/hr"
PTEQ_diff_CTR_TOPO2 = PTEQ_diff_CTR_TOPO(1:95,:,:,:) 
PTEQ_diff_CTR_TOPO2 = PTEQ_diff_CTR_TOPO2 * 3600
PTEQ_diff_CTR_TOPO2@units = "kg/kg/hr"

Qadv_mean_CTR = Qt_mean_CTR ; metadata
Qadv_mean_CTR = Qt_mean_CTR - PTEQ_mean_CTR2

Qadv_mean_TOPO = Qt_mean_TOPO
Qadv_mean_TOPO = Qt_mean_TOPO - PTEQ_mean_TOPO2

Qadv_diff_CTR_TOPO = Qt_diff_CTR_TOPO ; metadata
Qadv_diff_CTR_TOPO = Qt_diff_CTR_TOPO - PTEQ_diff_CTR_TOPO2

printVarSummary(QAP_diff_CTR_TOPO)
printVarSummary(Qt_diff_CTR_TOPO)
printVarSummary(Qadv_diff_CTR_TOPO)
;printVarSummary(U_diff_TOPO_CTR_sig)
printVarSummary(PTEQ_diff_CTR_TOPO)
printVarSummary(PTEQ_diff_CTR_TOPO2)
;printVarSummary(V_diff_TOPO_CTR_sig)

;------------------- selection of critical lat and lon
;lat_t = 0.0
;lat_t = -10.0
lat_t = -20.0

lon_1 = 260.0
lon_2 = 320.0

;lev_1 = 300.0
lev_1 = 100.0
lev_2 = 1000.0
;----------- Add topography ------
f_TOPO = addfile(prefix+"/scratch/hongcheq/NERSC_Cori_WADA_simulation/F_AMIP_CAM5_WADA_TOPO_1998_sim2_1998-12-01_HCforcing/atm/hist/F_AMIP_CAM5_WADA_TOPO_1998_sim2_1998-12-01_HCforcing.cam.h1.1998-12-05-00000.nc","r")
PHIS = f_TOPO->PHIS
hgt = PHIS(0,{lat_t},{lon_1:lon_2})  ; metadata and dimension
hgt = hgt/9.8
hgt@units = "m"   ; gpm
gp = 1013*(1-6.5/288000*hgt)^5.255  ; convert m to hPa using Standard Atmosphere
gp@units = "hPa"
copy_VarCoords(hgt,gp)
printVarSummary(gp)
;================ plot ===========

plot = new(9,graphic)

total_hrs = 95

do i_hr = 0,total_hrs-1   ; the first hour is not there due to QAP(i) - QAP(i-1)

wks = gsn_open_wks("png","../Figures/4_Qdecomp_Lat_"+sprintf("%4.1f",lat_t)+"_ihr_"+tostring(i_hr+2))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -8.0e-4
res@cnMaxLevelValF = 8.0e-4
res@cnLevelSpacingF = 1.0e-4

;res@tiMainFontHeightF = 0.015
res@tiMainString = "partial_Q/partial_t"
res@gsnLeftString = "  " ; avoid having too long names
plot(0) = gsn_csm_pres_hgt(wks,Qt_mean_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "PTEQ: Q total physics tendency"
plot(1) = gsn_csm_pres_hgt(wks,PTEQ_mean_CTR2(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "Q total advection"
plot(2) = gsn_csm_pres_hgt(wks,Qadv_mean_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "partial_Q/partial_t"
plot(3) = gsn_csm_pres_hgt(wks,Qt_mean_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "PTEQ: Q total physics tendency"
plot(4) = gsn_csm_pres_hgt(wks,PTEQ_mean_TOPO2(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "Q total advection"
plot(5) = gsn_csm_pres_hgt(wks,Qadv_mean_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;--------------------------- 

res@tiMainString = "partial_Q/partial_t"
plot(6) = gsn_csm_pres_hgt(wks,Qt_diff_CTR_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "PTEQ: Q total physics tendency"
plot(7) = gsn_csm_pres_hgt(wks,PTEQ_diff_CTR_TOPO2(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "Q total advection"
plot(8) = gsn_csm_pres_hgt(wks,Qadv_diff_CTR_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;------add topography ----
mres   = True
mres@gsnLeftString       = " "
mres@gsnRightString      = " "
mres@gsnDraw             = False                ; do not draw the plot
mres@gsnFrame            = False                ; do not advance the frame
mres@xyLineThicknesses   = (/3.0/)              ; make line thicker
mres@xyLineColors        = (/"black"/)          ; change line color

mres@gsnBelowYRefLineColor = (/ "black", "black"/)  
mres@gsnYRefLine           = (/ lev_1 ,lev_2 /)   

plot_topo0  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(0),plot_topo0)
plot_topo1  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(1),plot_topo1)
plot_topo2  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(2),plot_topo2)
plot_topo3  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(3),plot_topo3)
plot_topo4  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(4),plot_topo4)
plot_topo5  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(5),plot_topo5)
plot_topo6  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(6),plot_topo6)
plot_topo7  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(7),plot_topo7)
plot_topo8  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot(8),plot_topo8)

;============ panel plot ====

str_LST = (/"20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"/)

pres = True
pres@txString = "CTR vs TOPO, ENS(9), ihr="+tostring(i_hr+2) +", LST_75W ("+str_LST(mod(i_hr+2,24))+")"+", lat="+sprintf("%5.1f",lat_t)

gsn_panel(wks,plot,(/3,3/),pres)



end do ; do i_hr 


end
