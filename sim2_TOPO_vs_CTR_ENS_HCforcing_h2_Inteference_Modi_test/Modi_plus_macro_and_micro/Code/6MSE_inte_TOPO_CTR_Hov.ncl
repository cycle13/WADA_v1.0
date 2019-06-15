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

var_diff_CTR_TOPO = new((/96,96,144/),double)

PRECT_diff_CTR_TOPO = new((/96,96,144/),double)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,31
;do index = 0,7
;do index = 0,0

;this path for PRECT only
TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"

MSE_TOPO_mean_str = "MSE_DSE_LE.TOPOTEST.time"+str_time(index)+".nc"
MSE_CTR_mean_str = "MSE_DSE_LE.CTR.time"+str_time(index)+".nc"

var_str = (/"MSE_inte","PRECT"/)

do i_var = 0, 1

var = var_str(i_var)

if (i_var .ne. 1) then
MSE_dir = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/"

f_TOPO_mean = addfile(MSE_dir+"TOPO_TEST/"+MSE_TOPO_mean_str,"r")
f_CTR_mean = addfile(MSE_dir+"CTR/"+MSE_CTR_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
var_mean_CTR = f_CTR_mean->$var$

else   ;  i_var = 5, for PRECT
;dimension different from previous ones
delete(var_mean_TOPO)
delete(var_mean_CTR)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
var_mean_CTR = f_CTR_mean->$var$

end if
 
;--------------

if (i_var .eq. 0) then
   var_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR
   var_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR - var_mean_TOPO

else
   PRECT_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR
   PRECT_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR - var_mean_TOPO

end if

end do ; do ivar

delete(var_mean_TOPO)

delete(var_mean_CTR)

end do ; do index
;========================

var_diff_CTR_TOPO&time = ispan(1,96,1)
PRECT_diff_CTR_TOPO&time = ispan(1,96,1)

PRECT_diff_CTR_TOPO = PRECT_diff_CTR_TOPO * 8.64e7
PRECT_diff_CTR_TOPO@units = "mm/day"
;

;=============== average over lat (-5,5) in preparation for Hovmueler=========
;total_days = 11
;total_hrs = 48
total_hrs = 96

lat_c1 = -5.0
lat_c2 = 5.0

lon_c1 = 260.0 
lon_c2 = 320.0

var_diff_CTR_TOPO_hov = dim_avg_n_Wrap(var_diff_CTR_TOPO(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat

PRECT_diff_CTR_TOPO_hov = dim_avg_n_Wrap(PRECT_diff_CTR_TOPO(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat

printVarSummary(var_diff_CTR_TOPO_hov)

printVarSummary(PRECT_diff_CTR_TOPO_hov)

;================ plot ===========

wks = gsn_open_wks("png","../Figures/6_Hov_Regional_MSE_inte_TOPO_vs_CTR")

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

;----------
X_diff_CTR_TOPO_hov = var_diff_CTR_TOPO_hov

res@cnLevelSelectionMode = "ManualLevels"

res@cnMinLevelValF = -1.5
res@cnMaxLevelValF = 1.5
res@cnLevelSpacingF = 0.1

res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.

res@gsnRightString = "MSE_inte, 1000-50hPa, (kJ/kg)"
;----------

plot_var = gsn_csm_hov(wks,X_diff_CTR_TOPO_hov,res)

;---------
delete(res@gsnCenterString)

res@cnFillOn = True
res@cnLineLabelsOn = False
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -6.0
res@cnMaxLevelValF = 6.0
res@cnLevelSpacingF = 0.5

res@tiMainString = "CTR - TOPO, ENS(180)"
res@gsnLeftString = "PRECT(mm/day)"
gsn_reverse_colormap(wks)

plot_P = gsn_csm_hov(wks,PRECT_diff_CTR_TOPO_hov,res)


overlay(plot_P,plot_var)
draw(plot_P)
frame(wks)



end
