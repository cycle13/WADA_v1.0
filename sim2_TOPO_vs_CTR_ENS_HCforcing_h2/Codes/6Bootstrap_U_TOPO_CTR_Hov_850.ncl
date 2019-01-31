;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180913 for Hovmueller
;Note: modified 20181002 for sim2_WADA...

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

do i_str_time = 0,31
str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
end do

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47",\
;             "48-53","54-59","60-65","66-71","72-77","78-83","84-89","90-95"/)


nhrs = 96

U_diff_TOPO_CTR = new((/nhrs,13,96,144/),double)
U_diff_TOPO_CTR_sig = new((/nhrs,13,96,144/),double)
V_diff_TOPO_CTR = new((/nhrs,13,96,144/),double)
V_diff_TOPO_CTR_sig = new((/nhrs,13,96,144/),double)
OMEGA_diff_TOPO_CTR = new((/nhrs,13,96,144/),double)
OMEGA_diff_TOPO_CTR_sig = new((/nhrs,13,96,144/),double)
T_diff_TOPO_CTR = new((/nhrs,13,96,144/),double)
T_diff_TOPO_CTR_sig = new((/nhrs,13,96,144/),double)
Z3_diff_TOPO_CTR = new((/nhrs,13,96,144/),double)
Z3_diff_TOPO_CTR_sig = new((/nhrs,13,96,144/),double)

PRECT_diff_TOPO_CTR = new((/nhrs,96,144/),double)
PRECT_diff_TOPO_CTR_sig = new((/nhrs,96,144/),double)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47",\
;             "48-53","54-59","60-65","66-71","72-77","78-83","84-89","90-95"/)

do index = 0,31
;do index = 0,15
;do index = 0,7
;do index = 0,0

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
;TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"
TOPO_check = "ENS.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"
CTR_check = "ENS.CTR.time"+str_time(index)+".nc"

var_str = (/"U","V","OMEGA","T","Z3","PRECT"/)

do i_var = 0, 5

var = var_str(i_var)

if (i_var .ne. 5) then
f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
;f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")
TOPO_check_file = addfile(TOPO_dir+TOPO_check,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
;f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")
CTR_check_file = addfile(CTR_dir+CTR_check,"r")

var_mean_TOPO = f_TOPO_mean->$var$
var_TOPO = TOPO_check_file->$var$

var_mean_CTR = f_CTR_mean->$var$
var_CTR = CTR_check_file->$var$

else   ;  i_var = 5, for PRECT
;dimension different from previous ones
delete(var_mean_TOPO)
delete(var_TOPO)
delete(var_mean_CTR)
delete(var_CTR)

var_mean_TOPO = f_TOPO_mean->$var$
var_TOPO = TOPO_check_file->$var$

var_mean_CTR = f_CTR_mean->$var$
var_CTR = CTR_check_file->$var$

end if
 
;--------------

if (i_var .ne. 5) then   ; for PRECT, it doesn't have a lev dimension
;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_TOPO_pnew)
;var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_TOPO_pnew = vinth2p(var_TOPO,hyam,hybm,pnew,TOPO_check_file->PS,1,P0mb,1,False)
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_CTR_pnew)
;var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_CTR_pnew = vinth2p(var_CTR,hyam,hybm,pnew,CTR_check_file->PS,1,P0mb,1,False)
;printVarSummary(var_std_CTR_pnew)

else   ; for PRECT
;PRECT is in different dimension from others, delete previous used vars
delete(var_mean_TOPO_pnew)
;delete(var_std_TOPO_pnew)
delete(var_TOPO_pnew)
delete(var_mean_CTR_pnew)
;delete(var_std_CTR_pnew)
delete(var_CTR_pnew)

var_mean_TOPO_pnew = var_mean_TOPO
;var_std_TOPO_pnew = var_std_TOPO
var_TOPO_pnew = var_TOPO
var_mean_CTR_pnew = var_mean_CTR
;var_std_CTR_pnew = var_std_CTR
var_CTR_pnew = var_CTR

end if  ; if i_var .ne. 5

;;---------------- student t test ----------
;siglvl = 0.1
;indep_sample = 180
;;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
;prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;;printVarSummary(prob)
;
;;-------------- This is for bootstrapping test for significance test ----------

nBoot = 400
;nBoot = 1000
nDim = 0
opt = False

if (i_var .lt. 5) then 

;------------- i_var < 5, meaning U,V,OMEGA, & other variables, var_CTR in (members, time,lev, lat, lon) 5d ------
diffBootLow = var_CTR(0,:,:,:,:)  ; dimension data
diffBootHi = var_CTR(0,:,:,:,:)
printVarSummary(diffBootLow)

do i_hr = 0,2    
print(i_hr)
printVarSummary(var_CTR(:,i_hr,:,:,:)) ; make sure it's 4-d
BootStrap = bootstrap_diff(var_CTR(:,i_hr,:,:,:), var_TOPO(:,i_hr,:,:,:), nBoot, nDim, opt)
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

else
;------------- i_var == 5, meaning PRECT, var_CTR in (members, time, lat, lon) 4d ------
diffBootLow = var_CTR(0,:,:,:)  ; dimension data
diffBootHi = var_CTR(0,:,:,:)
printVarSummary(diffBootLow)

do i_hr = 0,2    
print(i_hr)
printVarSummary(var_CTR(:,i_hr,:,:)) ; make sure it's 3-d
BootStrap = bootstrap_diff(var_CTR(:,i_hr,:,:), var_TOPO(:,i_hr,:,:), nBoot, nDim, opt)
diffBoot = BootStrap[0]
diffBootAvg = BootStrap[1]
diffBootStd = BootStrap[2]
delete(BootStrap)

;-------use these two values to determine is var_mean_TOPO_pnew - var_mean_CTR_pnew is significant at 0.05 significance level
diffBootLow(i_hr,:,:) = bootstrap_estimate(diffBoot, 0.025, False)   ;  2.5% lower confidence bound 
;diffBootMed = bootstrap_estimate(diffBoot, 0.500, False)   ; 50.0% median of bootstrapped estimates
diffBootHi(i_hr,:,:)  = bootstrap_estimate(diffBoot, 0.975, False)   ; 97.5% upper confidence bound
printVarSummary(diffBoot)   ; information only
printVarSummary(diffBootLow)  
end do ; do i_hr
print("-----------")
print("bootstrapping finished")

delete(diffBootLow)
delete(diffBootHi)

end if ; if i_var .eq. 5
;---------------

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_TOPO_CTR = var_mean_CTR_pnew - var_mean_TOPO_pnew

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR_sig@_FillValue)
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_CTR_pnew - var_mean_TOPO_pnew,diff_TOPO_CTR_sig@_FillValue)
diff_TOPO_CTR_sig = where( (diff_TOPO_CTR_sig .le. diffBootLow) .or. (diff_TOPO_CTR_sig .ge. diffBootHi ), var_mean_CTR_pnew - var_mean_TOPO_pnew,diff_TOPO_CTR_sig@_FillValue)

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   U_diff_TOPO_CTR(index*3:index*3+2,:,:,:) = diff_TOPO_CTR
   U_diff_TOPO_CTR_sig(index*3:index*3+2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 1) then
   V_diff_TOPO_CTR(index*3:index*3+2,:,:,:) = diff_TOPO_CTR
   V_diff_TOPO_CTR_sig(index*3:index*3+2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 2) then
   OMEGA_diff_TOPO_CTR(index*3:index*3+2,:,:,:) = diff_TOPO_CTR
   OMEGA_diff_TOPO_CTR_sig(index*3:index*3+2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 3) then
   T_diff_TOPO_CTR(index*3:index*3+2,:,:,:) = diff_TOPO_CTR
   T_diff_TOPO_CTR_sig(index*3:index*3+2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 4) then
   Z3_diff_TOPO_CTR(index*3:index*3+2,:,:,:) = diff_TOPO_CTR
   Z3_diff_TOPO_CTR_sig(index*3:index*3+2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 5) then
   PRECT_diff_TOPO_CTR(index*3:index*3+2,:,:) = diff_TOPO_CTR
   PRECT_diff_TOPO_CTR_sig(index*3:index*3+2,:,:) = diff_TOPO_CTR_sig

end if
end if
end if
end if
end if
end if

;delete(prob)
delete(diff_TOPO_CTR)
delete(diff_TOPO_CTR_sig)

end do ; do ivar

delete(var_mean_TOPO)
;delete(var_std_TOPO_temp)
;delete(var_std_TOPO)
delete(var_TOPO)

delete(var_mean_CTR)
;delete(var_std_CTR_temp)
;delete(var_std_CTR)
delete(var_CTR)

delete(var_mean_TOPO_pnew)
;delete(var_std_TOPO_pnew)
delete(var_TOPO_pnew)

delete(var_mean_CTR_pnew) 
;delete(var_std_CTR_pnew)
delete(var_CTR_pnew)


end do ; do index

;printVarSummary(U_diff_TOPO_CTR)
;printVarSummary(U_diff_TOPO_CTR_sig)
;printVarSummary(V_diff_TOPO_CTR)
;printVarSummary(V_diff_TOPO_CTR_sig)
;printVarSummary(OMEGA_diff_TOPO_CTR)
;printVarSummary(OMEGA_diff_TOPO_CTR_sig)
;printVarSummary(T_diff_TOPO_CTR)
;printVarSummary(T_diff_TOPO_CTR_sig)
;printVarSummary(Z3_diff_TOPO_CTR)
;printVarSummary(Z3_diff_TOPO_CTR_sig)
;
;printVarSummary(PRECT_diff_TOPO_CTR)
;printVarSummary(PRECT_diff_TOPO_CTR_sig)
;
;========================

U_diff_TOPO_CTR&time = ispan(1,nhrs,1)
U_diff_TOPO_CTR_sig&time = ispan(1,nhrs,1)
V_diff_TOPO_CTR&time = ispan(1,nhrs,1)
V_diff_TOPO_CTR_sig&time = ispan(1,nhrs,1)
OMEGA_diff_TOPO_CTR&time = ispan(1,nhrs,1)
OMEGA_diff_TOPO_CTR_sig&time = ispan(1,nhrs,1)
T_diff_TOPO_CTR&time = ispan(1,nhrs,1)
T_diff_TOPO_CTR_sig&time = ispan(1,nhrs,1)
Z3_diff_TOPO_CTR&time = ispan(1,nhrs,1)
Z3_diff_TOPO_CTR_sig&time = ispan(1,nhrs,1)
PRECT_diff_TOPO_CTR&time = ispan(1,nhrs,1)
PRECT_diff_TOPO_CTR_sig&time = ispan(1,nhrs,1)

PRECT_diff_TOPO_CTR = PRECT_diff_TOPO_CTR * 8.64e7
PRECT_diff_TOPO_CTR_sig = PRECT_diff_TOPO_CTR_sig * 8.64e7
PRECT_diff_TOPO_CTR@units = "mm/day"
PRECT_diff_TOPO_CTR_sig@units = "mm/day"
;
;printVarSummary(U_diff_TOPO_CTR)
;printVarSummary(U_diff_TOPO_CTR_sig)
;printVarSummary(Z3_diff_TOPO_CTR)
;printVarSummary(Z3_diff_TOPO_CTR_sig)
;printVarSummary(PRECT_diff_TOPO_CTR)
;printVarSummary(PRECT_diff_TOPO_CTR_sig)

;=============== average over lat (-5,5) in preparation for Hovmueler=========
;total_days = 11
;total_hrs = 48
total_hrs = nhrs

pr_levels = 850.0

lat_c1 = -5.0
lat_c2 = 5.0

lon_c1 = 260.0 
lon_c2 = 320.0

U_diff_TOPO_CTR_hov = dim_avg_n_Wrap(U_diff_TOPO_CTR(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
U_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(U_diff_TOPO_CTR_sig(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

V_diff_TOPO_CTR_hov = dim_avg_n_Wrap(V_diff_TOPO_CTR(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
V_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(V_diff_TOPO_CTR_sig(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

OMEGA_diff_TOPO_CTR_hov = dim_avg_n_Wrap(OMEGA_diff_TOPO_CTR(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
OMEGA_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(OMEGA_diff_TOPO_CTR_sig(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

T_diff_TOPO_CTR_hov = dim_avg_n_Wrap(T_diff_TOPO_CTR(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
T_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(T_diff_TOPO_CTR_sig(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

Z3_diff_TOPO_CTR_hov = dim_avg_n_Wrap(Z3_diff_TOPO_CTR(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
Z3_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(Z3_diff_TOPO_CTR_sig(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

PRECT_diff_TOPO_CTR_hov = dim_avg_n_Wrap(PRECT_diff_TOPO_CTR(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
PRECT_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(PRECT_diff_TOPO_CTR_sig(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

printVarSummary(U_diff_TOPO_CTR_hov)
printVarSummary(U_diff_TOPO_CTR_hov_sig)

printVarSummary(PRECT_diff_TOPO_CTR_hov)
printVarSummary(PRECT_diff_TOPO_CTR_hov_sig)

;================ plot ===========

wks = gsn_open_wks("png","../Figures/6Bootstrap_Hov_Regional_U_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")
wks_sig = gsn_open_wks("png","../Figures/6Bootstrap_Sig_Hov_Regional_U_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

;----------
X_diff_TOPO_CTR_hov = U_diff_TOPO_CTR_hov
X_diff_TOPO_CTR_hov_sig = U_diff_TOPO_CTR_hov_sig

res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = -4.8
;res@cnMaxLevelValF = 1.6

res@cnMinLevelValF = -1.6  ; 
res@cnMaxLevelValF = 4.8  ; 

res@cnLevelSpacingF = 0.1

;;TO avoid dense contours around the Andeans
;res@cnLevelSelectionMode = "ExplicitLevels"
;res@cnLevels    = (/ -1.6, -1.5, -1.4, -1.3, -1.2, -1.1, -/) 

res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.
res@gsnRightString = "U(m/sec),"+sprintf("%4.1f",pr_levels) + "hPa"
;----------
res@vpHeightF = 0.6
res@vpWidthF = 0.3  ; suggested by Mike, to double the Y time axis.

res@tmYLMode = "Manual"
res@tmYLTickStartF = 0
res@tmYLTickEndF = 96
res@tmYLTickSpacingF = 4

plot_var = gsn_csm_hov(wks,X_diff_TOPO_CTR_hov,res)

;res@gsnCenterString = "siglvl=0.1"
res@gsnCenterString = "Bootstrap_siglvl=0.05"
plot_var_sig = gsn_csm_hov(wks_sig,X_diff_TOPO_CTR_hov_sig,res)

;---------
delete(res@gsnCenterString)

res@cnFillOn = True
res@cnLineLabelsOn = False
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -12.0
res@cnMaxLevelValF = 12.0
res@cnLevelSpacingF = 0.5

res@tiMainString = "CTR - TOPO, ENS(180)"
;res@gsnLeftString = "PRECT(mm/day)"
res@gsnLeftString = ""
gsn_reverse_colormap(wks)

plot_P = gsn_csm_hov(wks,PRECT_diff_TOPO_CTR_hov,res)

gsn_reverse_colormap(wks_sig)
plot_P_sig = gsn_csm_hov(wks_sig,PRECT_diff_TOPO_CTR_hov_sig,res)

overlay(plot_P,plot_var)
draw(plot_P)
frame(wks)

overlay(plot_P_sig,plot_var_sig)
draw(plot_P_sig)
frame(wks_sig)



end
