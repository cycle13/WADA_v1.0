;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180913 for Hovmueller
;Note: modified 20181002 for sim2_WADA...

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
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

U_diff_TOPO_CTR = new((/96,13,96,144/),double)
U_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)
V_diff_TOPO_CTR = new((/96,13,96,144/),double)
V_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)
OMEGA_diff_TOPO_CTR = new((/96,13,96,144/),double)
OMEGA_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)
T_diff_TOPO_CTR = new((/96,13,96,144/),double)
T_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)
Z3_diff_TOPO_CTR = new((/96,13,96,144/),double)
Z3_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)

PRECT_diff_TOPO_CTR = new((/96,96,144/),double)
PRECT_diff_TOPO_CTR_sig = new((/96,96,144/),double)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,31
;do index = 0,7
;do index = 0,0

TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

var_str = (/"U","V","OMEGA","T","Z3","PRECT"/)

do i_var = 0, 5

var = var_str(i_var)

if (i_var .ne. 5) then
f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:,:)   ; get rid of the first realization dimension

var_mean_CTR = f_CTR_mean->$var$
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:,:)   ; get rid of the first realization dimension

else   ;  i_var = 5, for PRECT
;dimension different from previous ones
delete(var_mean_TOPO)
delete(var_std_TOPO_temp)
delete(var_std_TOPO)
delete(var_mean_CTR)
delete(var_std_CTR_temp)
delete(var_std_CTR)

var_mean_TOPO = f_TOPO_mean->$var$
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:)   ; get rid of the first realization dimension

var_mean_CTR = f_CTR_mean->$var$
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:)   ; get rid of the first realization dimension
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
var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_CTR_pnew)

else   ; for PRECT
;PRECT is in different dimension from others, delete previous used vars
delete(var_mean_TOPO_pnew)
delete(var_std_TOPO_pnew)
delete(var_mean_CTR_pnew)
delete(var_std_CTR_pnew)

var_mean_TOPO_pnew = var_mean_TOPO
var_std_TOPO_pnew = var_std_TOPO
var_mean_CTR_pnew = var_mean_CTR
var_std_CTR_pnew = var_std_CTR

end if  ; if i_var .ne. 4

siglvl = 0.1
indep_sample = 180
;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_TOPO_CTR = var_mean_CTR_pnew - var_mean_TOPO_pnew

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR_sig@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_CTR_pnew - var_mean_TOPO_pnew,diff_TOPO_CTR_sig@_FillValue)

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

delete(prob)
delete(diff_TOPO_CTR)
delete(diff_TOPO_CTR_sig)

end do ; do ivar

delete(var_mean_TOPO)
delete(var_std_TOPO_temp)
delete(var_std_TOPO)

delete(var_mean_CTR)
delete(var_std_CTR_temp)
delete(var_std_CTR)

delete(var_mean_TOPO_pnew)
delete(var_std_TOPO_pnew)

delete(var_mean_CTR_pnew) 
delete(var_std_CTR_pnew)


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

U_diff_TOPO_CTR&time = ispan(1,96,1)
U_diff_TOPO_CTR_sig&time = ispan(1,96,1)
V_diff_TOPO_CTR&time = ispan(1,96,1)
V_diff_TOPO_CTR_sig&time = ispan(1,96,1)
OMEGA_diff_TOPO_CTR&time = ispan(1,96,1)
OMEGA_diff_TOPO_CTR_sig&time = ispan(1,96,1)
T_diff_TOPO_CTR&time = ispan(1,96,1)
T_diff_TOPO_CTR_sig&time = ispan(1,96,1)
Z3_diff_TOPO_CTR&time = ispan(1,96,1)
Z3_diff_TOPO_CTR_sig&time = ispan(1,96,1)
PRECT_diff_TOPO_CTR&time = ispan(1,96,1)
PRECT_diff_TOPO_CTR_sig&time = ispan(1,96,1)

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
total_hrs = 96

pr_levels = 850.0
;pr_levels = 200.0

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

wks = gsn_open_wks("png","6_Hov_Regional_V_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")
wks_sig = gsn_open_wks("png","6_Sig_Hov_Regional_V_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

;----------
X_diff_TOPO_CTR_hov = V_diff_TOPO_CTR_hov
X_diff_TOPO_CTR_hov_sig = V_diff_TOPO_CTR_hov_sig

res@cnLevelSelectionMode = "ManualLevels"

;res@cnMinLevelValF = -0.3
;res@cnMaxLevelValF = 1.8

res@cnMinLevelValF = -1.8
res@cnMaxLevelValF = 0.3

res@cnLevelSpacingF = 0.1

res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.

res@gsnRightString = "V(m/sec),"+sprintf("%4.1f",pr_levels) + "hPa"
;----------

plot_var = gsn_csm_hov(wks,X_diff_TOPO_CTR_hov,res)

res@gsnCenterString = "siglvl=0.1"
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
res@gsnLeftString = "PRECT(mm/day)"
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
