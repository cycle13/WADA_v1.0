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

OMEGA_diff_TOPO_CTR = new((/nhrs,13,96,144/),double)
OMEGA_diff_TOPO_CTR_sig = new((/nhrs,13,96,144/),double)

LSE_inte_diff_TOPO_CTR = new((/nhrs,96,144/),double)
LSE_inte_diff_TOPO_CTR_sig = new((/nhrs,96,144/),double)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47",\
;             "48-53","54-59","60-65","66-71","72-77","78-83","84-89","90-95"/)

do index = 0,31
;do index = 0,15
;do index = 0,7
;do index = 0,0

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

var_str = (/"OMEGA","LSE_inte"/)   ; TMQ is not saved in hourly data, LSE_inte  = vertical_integral of Lv*q, here as a proxy.

do i_var = 0, 1

var = var_str(i_var)

if (i_var .eq. 0) then
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

else   ;  
;dimension different from previous ones
delete(var_mean_TOPO)
delete(var_std_TOPO_temp)
delete(var_std_TOPO)
delete(var_mean_CTR)
delete(var_std_CTR_temp)
delete(var_std_CTR)

dir_TOPO_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/TOPO_TEST/"
dir_CTR_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/CTR/"

f_TOPO_mean = addfile(dir_TOPO_out+"MSE_DSE_LE.TOPOTEST.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","r")
f_CTR_mean = addfile(dir_CTR_out+"MSE_DSE_LE.CTR.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","r")

var_mean_TOPO = f_TOPO_mean->$var$

var_mean_CTR = f_CTR_mean->$var$
end if
 
;--------------

if (i_var .eq. 0) then   ; for LSE_inte, it doesn't have a lev dimension
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

else   ; for LSE_inte
;PRECT is in different dimension from others, delete previous used vars
delete(var_mean_TOPO_pnew)
delete(var_std_TOPO_pnew)
delete(var_mean_CTR_pnew)
delete(var_std_CTR_pnew)

var_mean_TOPO_pnew = var_mean_TOPO
var_mean_CTR_pnew = var_mean_CTR

end if  ; if i_var .ne. 4

siglvl = 0.1
;indep_sample = 180
indep_sample = 9
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_TOPO_CTR = var_mean_CTR_pnew - var_mean_TOPO_pnew

printVarSummary(diff_TOPO_CTR)

if (i_var .eq. 0) then
   OMEGA_diff_TOPO_CTR(index*3:index*3+2,:,:,:) = diff_TOPO_CTR
else
   LSE_inte_diff_TOPO_CTR(index*3:index*3+2,:,:) = diff_TOPO_CTR

end if

delete(diff_TOPO_CTR)

end do ; do ivar

delete(var_mean_TOPO)

delete(var_mean_CTR)

delete(var_mean_TOPO_pnew)

delete(var_mean_CTR_pnew) 


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

OMEGA_diff_TOPO_CTR&time = ispan(1,nhrs,1)
LSE_inte_diff_TOPO_CTR&time = ispan(1,nhrs,1)

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

pr_levels = 500.0

;lat_c1 = -5.0
;lat_c2 = 5.0

;lat_c1 = -15.0
;lat_c2 = -5.0

lat_c1 = -25.0
lat_c2 = -15.0

lon_c1 = 260.0 
lon_c2 = 320.0

OMEGA_diff_TOPO_CTR_hov = dim_avg_n_Wrap(OMEGA_diff_TOPO_CTR(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat

LSE_inte_diff_TOPO_CTR_hov = dim_avg_n_Wrap(LSE_inte_diff_TOPO_CTR(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat

;================ plot ===========

wks = gsn_open_wks("png","../Figures/6_Hov_Regional_OMEGA500_LSE_"+sprintf("%4.1f",lat_c1)+"--"+sprintf("%4.1f",lat_c2)+"inte_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

;----------
X_diff_TOPO_CTR_hov = OMEGA_diff_TOPO_CTR_hov

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.2  ; 
res@cnMaxLevelValF = 0.2  ; 
res@cnLevelSpacingF = 0.01

;res@cnLevelSpacingF = 0.1
;res@gsnContourLineThicknessesScale = 3.0
res@gsnContourLineThicknessesScale = 2.0

;;TO avoid dense contours around the Andeans
;res@cnLevelSelectionMode = "ExplicitLevels"
;res@cnLevels    = (/ -1.6, -1.5, -1.4, -1.3, -1.2, -1.1, -/) 

res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.
res@gsnRightString = "OMEGA(Pa/sec),"+sprintf("%4.1f",pr_levels) + "hPa"
;----------
res@vpHeightF = 0.6
res@vpWidthF = 0.3  ; suggested by Mike, to double the Y time axis.

res@tmYLMode = "Manual"
res@tmYLTickStartF = 0
res@tmYLTickEndF = 96
res@tmYLTickSpacingF = 4

plot_var = gsn_csm_hov(wks,X_diff_TOPO_CTR_hov,res)

;---------
delete(res@gsnCenterString)

res@cnFillOn = True
res@cnLineLabelsOn = False
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -1.0
res@cnMaxLevelValF = 1.0
res@cnLevelSpacingF = 0.05

;res@tiMainString = "CTR - TOPO, ENS(180)"
res@tiMainString = "CTR - TOPO, ENS(9), LSE_inte (kJ/kg)"
;res@gsnLeftString = "LSE_inte, kJ/kg"
res@gsnLeftString = ""
gsn_reverse_colormap(wks)

plot_P = gsn_csm_hov(wks,LSE_inte_diff_TOPO_CTR_hov,res)

overlay(plot_P,plot_var)
draw(plot_P)
frame(wks)


end
