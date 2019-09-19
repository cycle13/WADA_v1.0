
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

Q_diff_TOPO_CTR = new((/96,30,96,144/),double)
Q_diff_TOPO_CTR_sig = new((/96,30,96,144/),double)

Q_hori_adv_diff_TOPO_CTR = new((/96,30,96,144/),double)
Q_hori_adv_diff_TOPO_CTR_sig = new((/96,30,96,144/),double)

Q_vert_adv_diff_TOPO_CTR = new((/96,30,96,144/),double)
Q_vert_adv_diff_TOPO_CTR_sig = new((/96,30,96,144/),double)


do index = 0,31
;do index = 0,5

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
;TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
;TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST."+str_time(index)+".nc"

TOPO_mean_std_Qadv_dir = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/TOPO_TEST/"
TOPO_mean_std_Qadv = "ENS.std.mean.TOPOTEST.Qadv."+str_time(index)+".nc"
TOPO_mean_std_Q_vert_adv = "ENS.std.mean.TOPOTEST.Q_vert_adv."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
;CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR."+str_time(index)+".nc"

CTR_mean_std_Qadv_dir = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/CTR/"
CTR_mean_std_Qadv = "ENS.std.mean.CTR.Qadv."+str_time(index)+".nc"
CTR_mean_std_Q_vert_adv = "ENS.std.mean.CTR.Q_vert_adv."+str_time(index)+".nc"

var_str = (/"Q","var_hori_adv","var_vert_adv"/)  ; here var_adv means Qadv

do i_var = 0, dimsizes(var_str)-1
;do i_var = 5, dimsizes(var_str)-1

if (i_var .eq. 0) then
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

else if (i_var .eq. 1)  then  ; for advection since they are in different files

f_TOPO_Qadv = addfile(TOPO_mean_std_Qadv_dir+TOPO_mean_std_Qadv,"r")
f_CTR_Qadv = addfile(CTR_mean_std_Qadv_dir+CTR_mean_std_Qadv,"r")

var_mean_TOPO = - tofloat(f_TOPO_Qadv->var_adv_TOPO_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
; for advection, you want to that become - (U*(dX)/dlon + V*(dY)/dlat)
var_std_TOPO = tofloat(f_TOPO_Qadv->var_adv_TOPO_std) * 3600.0 * 1000.0
copy_VarMeta(f_TOPO_Qadv->var_adv_TOPO_mean,var_mean_TOPO)
copy_VarMeta(f_TOPO_Qadv->var_adv_TOPO_std,var_std_TOPO)
var_mean_TOPO@units = "(g/kg)/hr"
var_std_TOPO@units = "(g/kg)/hr"

printVarSummary(var_mean_TOPO)
printVarSummary(var_std_TOPO)

var_mean_CTR = - tofloat(f_CTR_Qadv->var_adv_CTR_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
var_std_CTR =  tofloat(f_CTR_Qadv->var_adv_CTR_std)   * 3600.0   * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
copy_VarMeta(f_CTR_Qadv->var_adv_CTR_mean,var_mean_CTR)
copy_VarMeta(f_CTR_Qadv->var_adv_CTR_std,var_std_CTR)
var_mean_CTR@units = "(g/kg)/hr"
var_std_CTR@units = "(g/kg)/hr"

printVarSummary(var_mean_CTR)
printVarSummary(var_std_CTR)

else

f_TOPO_Q_vert_adv = addfile(TOPO_mean_std_Qadv_dir+TOPO_mean_std_Q_vert_adv,"r")
f_CTR_Q_vert_adv = addfile(CTR_mean_std_Qadv_dir+CTR_mean_std_Q_vert_adv,"r")

var_mean_TOPO = - tofloat(f_TOPO_Q_vert_adv->var_vert_adv_TOPO_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
; for vertical advection, you want to OMEGA*dQ/dp to become -OMEGA*(dQ)/dp
var_std_TOPO = tofloat(f_TOPO_Q_vert_adv->var_vert_adv_TOPO_std) * 3600.0 * 1000.0
copy_VarMeta(f_TOPO_Q_vert_adv->var_vert_adv_TOPO_mean,var_mean_TOPO)
copy_VarMeta(f_TOPO_Q_vert_adv->var_vert_adv_TOPO_std,var_std_TOPO)
var_mean_TOPO@units = "(g/kg)/hr"
var_std_TOPO@units = "(g/kg)/hr"

printVarSummary(var_mean_TOPO)
printVarSummary(var_std_TOPO)

var_mean_CTR = - tofloat(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
var_std_CTR =  tofloat(f_CTR_Q_vert_adv->var_vert_adv_CTR_std)   * 3600.0   * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
copy_VarMeta(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean,var_mean_CTR)
copy_VarMeta(f_CTR_Q_vert_adv->var_vert_adv_CTR_std,var_std_CTR)
var_mean_CTR@units = "(g/kg)/hr"
var_std_CTR@units = "(g/kg)/hr"

printVarSummary(var_mean_CTR)
printVarSummary(var_std_CTR)

end if

end if

;========== hybrid coordinate to pressure coordinate ====
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
;pnew = fspan(100.0,1000.0,200)
pnew = f_CTR_mean->lev

P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

if (i_var .le. 1) then
var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_mean_TOPO_pnew&lev@units = "hPa" 
;printVarSummary(var_mean_TOPO_pnew&lev_p)

var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_std_TOPO_pnew&lev@units = "hPa"
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev@units = "hPa"
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_std_CTR_pnew&lev@units = "hPa"
;printVarSummary(var_std_CTR_pnew)

else
delete(var_mean_TOPO_pnew)
delete(var_std_TOPO_pnew)
delete(var_mean_CTR_pnew)
delete(var_std_CTR_pnew)

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam(1:29),hybm(1:29),pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_mean_TOPO_pnew&lev@units = "hPa" 
;printVarSummary(var_mean_TOPO_pnew&lev_p)

var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam(1:29),hybm(1:29),pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_std_TOPO_pnew&lev@units = "hPa"
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam(1:29),hybm(1:29),pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev@units = "hPa"
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam(1:29),hybm(1:29),pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_std_CTR_pnew&lev@units = "hPa"
;printVarSummary(var_std_CTR_pnew)

end if

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180

siglvl = 0.1
indep_sample = 9
;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_TOPO_CTR = var_mean_CTR_pnew - var_mean_TOPO_pnew
diff_TOPO_CTR@units = var_mean_TOPO@units
diff_TOPO_CTR@long_name = var_mean_TOPO@long_name

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_CTR_pnew - var_mean_TOPO_pnew,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig@units = var_mean_TOPO@units
diff_TOPO_CTR_sig@long_name = var_mean_TOPO@long_name

;printVarSummary(diff_TOPO_CTR)
;printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   Q_mean_CTR = var_mean_CTR_pnew
   Q_mean_CTR = Q_mean_CTR * 1000.0 ; from kg/kg g/kg
   Q_mean_CTR@units = "g/kg"
   Q_diff_TOPO_CTR(num1(index):num2(index),:,:,:) = diff_TOPO_CTR
   Q_diff_TOPO_CTR(num1(index):num2(index),:,:,:) = diff_TOPO_CTR * 1000
   Q_diff_TOPO_CTR@units = "g/kg"
   Q_diff_TOPO_CTR_sig(num1(index):num2(index),:,:,:) = diff_TOPO_CTR_sig 
   Q_diff_TOPO_CTR_sig(num1(index):num2(index),:,:,:) = diff_TOPO_CTR_sig * 1000
   Q_diff_TOPO_CTR_sig@units = "g/kg"
else if (i_var .eq. 1) then
   Q_hori_adv_mean_CTR = var_mean_CTR_pnew
   Q_hori_adv_diff_TOPO_CTR(num1(index):num2(index),:,:,:) = diff_TOPO_CTR
   Q_hori_adv_diff_TOPO_CTR_sig(num1(index):num2(index),:,:,:) = diff_TOPO_CTR_sig
else
   Q_vert_adv_mean_CTR = var_mean_CTR_pnew
   Q_vert_adv_diff_TOPO_CTR(num1(index):num2(index),:,:,:) = diff_TOPO_CTR
   Q_vert_adv_diff_TOPO_CTR_sig(num1(index):num2(index),:,:,:) = diff_TOPO_CTR_sig
end if

end if

delete(var_mean_CTR)
delete(var_mean_TOPO)
delete(var_std_CTR)
delete(var_std_TOPO)

end do ; do ivar

end do ; do index

Qt_diff = Q_diff_TOPO_CTR(1:95,:,:,:)
Qt_diff = Q_diff_TOPO_CTR(1:95,:,:,:) - Q_diff_TOPO_CTR(0:94,:,:,:)
Qt_diff@units = "g/kg / hr"

printVarSummary(Q_diff_TOPO_CTR)
printVarSummary(Qt_diff)
printVarSummary(Q_hori_adv_diff_TOPO_CTR)
printVarSummary(Q_vert_adv_diff_TOPO_CTR)

;------------------- selection of critical lat and lon
;lat_t = 0.0
lat_t = -10.0

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
;total 6 hrs in the TOPOTEST after branching

total_hrs =96

plot = new(4,graphic)
;plot_sig = new(4,graphic)

do i_hr = 1,total_hrs-1   ; from hour 2 to hour 96
print(i_hr)
;do i_day = 0,3

wks = gsn_open_wks("png","../Figures/4_Refine_10S_to100hPa_Q_Qt_Q_hori_adv_Q_vert_adv_TOPO_vs_CTR_ihr_"+tostring(i_hr+1))
;wks_sig = gsn_open_wks("png","../Figures/4_Refine_Sig_10S_to100hPa_U_V_OMEGA_T_Q_Qadv_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -4.0
res@cnMaxLevelValF = 4.0
res@cnLevelSpacingF = 1.0

;res@tiMainFontHeightF = 0.015
;----------

res@cnMinLevelValF = -0.5
res@cnMaxLevelValF = 0.5
res@cnLevelSpacingF = 0.02
res@gsnLeftString = "Q"
plot(0) = gsn_csm_pres_hgt(wks,Q_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(4) = gsn_csm_pres_hgt(wks_sig,Q_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@cnMinLevelValF = -0.5
res@cnMaxLevelValF = 0.5
res@cnLevelSpacingF = 0.02
res@gsnLeftString = "partial_Q/partial_t"
plot(1) = gsn_csm_pres_hgt(wks,Qt_diff(i_hr-1,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res) ; Note Qt only has hr=1 to hr=96

res@cnMinLevelValF = -0.2
res@cnMaxLevelValF = 0.2
res@cnLevelSpacingF = 0.01
res@gsnLeftString = "Horizontal advection of Q"
plot(2) = gsn_csm_pres_hgt(wks,Q_hori_adv_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(5) = gsn_csm_pres_hgt(wks_sig,Qadv_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@cnMinLevelValF = -0.2
res@cnMaxLevelValF = 0.2
res@cnLevelSpacingF = 0.01
res@tiMainString = "  "
res@gsnLeftString = "Vertical advection of Q"
plot(3) = gsn_csm_pres_hgt(wks,Q_vert_adv_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
 
;============ panel plot ====

str_LST = (/"20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"/)

pres = True
pres@txString = "CTR - TOPO, ENS(9), ihr="+tostring(i_hr+1) +", LST_75W ("+str_LST(mod(i_hr,24))+")"+", lat="+sprintf("%5.1f",lat_t)

gsn_panel(wks,plot,(/2,2/),pres)

;gsn_panel(wks_sig,plot_sig,(/3,2/),pres)


end do ; do i_day 


end
