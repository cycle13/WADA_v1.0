;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)

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

;do index = 0,31
;do index = 4,31
do index = 0,5
print(index)

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
;TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"
;TOPO_std_str = "ENS.std.TOPOTEST."+str_time(index)+".nc"
TOPO_check = "ENS.TOPOTEST."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
;CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR."+str_time(index)+".nc"
CTR_check = "ENS.CTR."+str_time(index)+".nc"

var_str = (/"OMEGA","T"/)

;do i_var = 0, dimsizes(var_str)-1
do i_var = 0, dimsizes(var_str)-1
;do i_var = 5, dimsizes(var_str)-1

if (i_var .ne. 5) then
var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
;f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")
TOPO_check_file = addfile(TOPO_dir+TOPO_check,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
;f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")
CTR_check_file = addfile(CTR_dir+CTR_check,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_TOPO = TOPO_check_file->$var$

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)
var_CTR = CTR_check_file->$var$

;else    ; for Tadv since they are in different files
;
;f_TOPO_Tadv = addfile(TOPO_dir+TOPO_mean_std_Tadv,"r")
;f_CTR_Tadv = addfile(CTR_dir+CTR_mean_std_Tadv,"r")
;
;var_mean_TOPO = - tofloat(f_TOPO_Tadv->Tadv_TOPO_mean) * 3600.0  ; for advection, you want to that become - (U*(dX)/dlon + V*(dY)/dlat)
;var_std_TOPO = tofloat(f_TOPO_Tadv->Tadv_TOPO_std) * 3600.0
;copy_VarMeta(f_TOPO_Tadv->Tadv_TOPO_mean,var_mean_TOPO)
;copy_VarMeta(f_TOPO_Tadv->Tadv_TOPO_std,var_std_TOPO)
;var_mean_TOPO@units = "K/hr"
;var_std_TOPO@units = "K/hr"
;
;printVarSummary(var_mean_TOPO)
;printVarSummary(var_std_TOPO)
;
;var_mean_CTR = - tofloat(f_CTR_Tadv->Tadv_CTR_mean) * 3600.0
;var_std_CTR =  tofloat(f_CTR_Tadv->Tadv_CTR_std)   * 3600.0
;copy_VarMeta(f_CTR_Tadv->Tadv_CTR_mean,var_mean_CTR)
;copy_VarMeta(f_CTR_Tadv->Tadv_CTR_std,var_std_CTR)
;var_mean_CTR@units = "K/hr"
;var_std_CTR@units = "K/hr"
;
;printVarSummary(var_mean_CTR)
;printVarSummary(var_std_CTR)

end if

;========== hybrid coordinate to pressure coordinate ====
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
pnew = fspan(100.0,1000.0,200)

P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_mean_TOPO_pnew&lev_p@units = "hPa" 
;printVarSummary(var_mean_TOPO_pnew&lev_p)

;var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;var_std_TOPO_pnew&lev_p@units = "hPa"
var_TOPO_pnew = vinth2p(var_TOPO,hyam,hybm,pnew,TOPO_check_file->PS,1,P0mb,1,False)
var_TOPO_pnew&lev_p@units = "hPa"
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev_p@units = "hPa"
;printVarSummary(var_mean_CTR_pnew)
;var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;var_std_CTR_pnew&lev_p@units = "hPa"
var_CTR_pnew = vinth2p(var_CTR,hyam,hybm,pnew,CTR_check_file->PS,1,P0mb,1,False)
var_CTR_pnew&lev_p@units = "hPa"
;printVarSummary(var_std_CTR_pnew)

;;--------------student t test
;siglvl = 0.1
;indep_sample = 180
;;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
;prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;;printVarSummary(prob)

;;-------------- This is for bootstrapping test for significance test ----------

;nBoot = 400
nBoot = 5

;nBoot = 1000
nDim = 0
opt = False

diffBootLow = var_CTR_pnew(0,:,:,:,:)  ; dimension data
diffBootHi = var_CTR_pnew(0,:,:,:,:)
printVarSummary(diffBootLow)

do i_hr = 0,2    
print(i_hr)
printVarSummary(var_CTR_pnew(:,i_hr,:,:,:)) ; make sure it's 4-d
BootStrap = bootstrap_diff(var_CTR_pnew(:,i_hr,:,:,:), var_TOPO_pnew(:,i_hr,:,:,:), nBoot, nDim, opt)
diffBoot = BootStrap[0]
diffBootAvg = BootStrap[1]
diffBootStd = BootStrap[2]
delete(BootStrap)

;-------use these two values to determine is var_mean_TOPO_pnew - var_mean_CTR_pnew is significant at 0.05 significance level
diffBootLow(i_hr,:,:,:) = bootstrap_estimate(diffBoot, 0.025, False)   ;  2.5% lower confidence bound 
;diffBootMed = bootstrap_estimate(diffBoot, 0.500, False)   ; 50.0% median of bootstrapped estimates
diffBootHi(i_hr,:,:,:)  = bootstrap_estimate(diffBoot, 0.975, False)   ; 97.5% upper confidence bound
printVarSummary(diffBoot)   ; information only
printVarSummary(diffBootLow)  
end do ; do i_hr = 0,2


; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_TOPO_CTR = var_mean_CTR_pnew - var_mean_TOPO_pnew
diff_TOPO_CTR@units = var_mean_TOPO@units
diff_TOPO_CTR@long_name = var_mean_TOPO@long_name

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR@_FillValue)
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_CTR_pnew - var_mean_TOPO_pnew,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig = where( (diff_TOPO_CTR_sig .le. diffBootLow) .or. (diff_TOPO_CTR_sig .ge. diffBootHi ), var_mean_CTR_pnew - var_mean_TOPO_pnew,diff_TOPO_CTR_sig@_FillValue)
diff_TOPO_CTR_sig@units = var_mean_TOPO@units
diff_TOPO_CTR_sig@long_name = var_mean_TOPO@long_name

;printVarSummary(diff_TOPO_CTR)
;printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   OMEGA_mean_CTR = var_mean_CTR_pnew
   OMEGA_diff_TOPO_CTR = diff_TOPO_CTR
   OMEGA_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else if (i_var .eq. 1) then
   T_mean_CTR = var_mean_CTR_pnew
   T_diff_TOPO_CTR = diff_TOPO_CTR
   T_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
end if
end if

end do ; do ivar

;printVarSummary(U_diff_TOPO_CTR)
;printVarSummary(U_diff_TOPO_CTR_sig)
;printVarSummary(V_diff_TOPO_CTR)
;printVarSummary(V_diff_TOPO_CTR_sig)
printVarSummary(OMEGA_diff_TOPO_CTR)
printVarSummary(OMEGA_diff_TOPO_CTR_sig)
;printVarSummary(OMEGA_diff_TOPO_CTR_sig)
printVarSummary(T_diff_TOPO_CTR)
printVarSummary(T_diff_TOPO_CTR_sig)
;printVarSummary(Q_diff_TOPO_CTR)
;printVarSummary(Tadv_diff_TOPO_CTR)

;------------------- selection of critical lat and lon
;lat_t = 0.0
lat_t = -15.0

lon_1 = 260.0
lon_2 = 320.0

lev_1 = 300.0
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

total_hrs = 3

;plot = new(6,graphic)
;plot_sig = new(6,graphic)
plot = new(2,graphic)
plot_sig = new(2,graphic)

do i_hr = 0,total_hrs-1
;do i_day = 0,3

wks = gsn_open_wks("png","../Figures/4Bootstrap_EQ_OMEGA_T_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
wks_sig = gsn_open_wks("x11","../Figures/4Bootstrap_Sig_EQ_OMEGA_T__TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))

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

;plot(0) = gsn_csm_pres_hgt(wks,U_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(0) = gsn_csm_pres_hgt(wks_sig,U_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;plot(1) = gsn_csm_pres_hgt(wks,V_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(1) = gsn_csm_pres_hgt(wks_sig,V_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@cnMinLevelValF = -0.1
res@cnMaxLevelValF = 0.1
res@cnLevelSpacingF = 0.02

;;plot(2) = gsn_csm_pres_hgt(wks,OMEGA_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;;plot_sig(2) = gsn_csm_pres_hgt(wks_sig,OMEGA_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
plot(0) = gsn_csm_pres_hgt(wks,OMEGA_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
plot_sig(0) = gsn_csm_pres_hgt(wks_sig,OMEGA_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

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

plot_topo2  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
plot_topo2_sig = gsn_csm_xy(wks_sig,gp&lon,gp,mres)
;overlay(plot(2),plot_topo2)
;overlay(plot_sig(2),plot_topo2_sig)
overlay(plot(0),plot_topo2)
overlay(plot_sig(0),plot_topo2_sig)
;draw(plot)
;frame(wks)
;----------------

res@cnMinLevelValF = -1.0
res@cnMaxLevelValF = 1.0
res@cnLevelSpacingF = 0.2
;plot(3) = gsn_csm_pres_hgt(wks,T_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(3) = gsn_csm_pres_hgt(wks_sig,T_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
plot(1) = gsn_csm_pres_hgt(wks,T_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
plot_sig(1) = gsn_csm_pres_hgt(wks_sig,T_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(1) = gsn_csm_contour_map(wks_sig,T_diff_TOPO_CTR_sig(i_hr,{lev_2},{(lat_t-20.0):(lat_t+20.0)},{lon_1:lon_2}),res)

plot_topo3  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
plot_topo3_sig = gsn_csm_xy(wks_sig,gp&lon,gp,mres)
;overlay(plot(3),plot_topo3)
;overlay(plot_sig(3),plot_topo3_sig)
overlay(plot(1),plot_topo3)
overlay(plot_sig(1),plot_topo3_sig)
;----------

;res@cnMinLevelValF = -0.0006
;res@cnMaxLevelValF = 0.0006
;res@cnLevelSpacingF = 0.0002
;plot(4) = gsn_csm_pres_hgt(wks,Q_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(4) = gsn_csm_pres_hgt(wks_sig,Q_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;res@cnMinLevelValF = -0.4
;res@cnMaxLevelValF = 0.4
;res@cnLevelSpacingF = 0.05
;
;plot(5) = gsn_csm_pres_hgt(wks,Tadv_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
;plot_sig(5) = gsn_csm_pres_hgt(wks_sig,Tadv_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
; 
;============ panel plot ====

str_LST = (/"20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"/)

pres = True
pres@txString = "CTR - TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1) +", LST_75W ("+str_LST(mod(index*3+i_hr,24))+")"+", lat="+sprintf("%5.1f",lat_t)

;gsn_panel(wks,plot,(/3,2/),pres)
;gsn_panel(wks_sig,plot_sig,(/3,2/),pres)

gsn_panel(wks,plot,(/1,2/),pres)
gsn_panel(wks_sig,plot_sig,(/1,2/),pres)


end do ; do i_day 

end do ; do index

end
