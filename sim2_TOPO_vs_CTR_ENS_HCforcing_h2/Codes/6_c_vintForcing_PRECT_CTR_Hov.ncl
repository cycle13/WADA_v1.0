;Function: TOPO Forcing + PRECT diff between TOPO and CTR, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180913 for Hovmueller
;Note: modified 20181002 for sim2_WADA...

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

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


vf_TOPO_CTR = new((/96,96,144/),double)

PRECT_CTR = new((/96,96,144/),double)

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47",\
;             "48-53","54-59","60-65","66-71","72-77","78-83","84-89","90-95"/)

do index = 0,31
;do index = 0,15
;do index = 0,7
;do index = 0,0

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_vf_str = "vint_forcing.mean_std.TOPO."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

f_vf_TOPO = addfile(TOPO_dir+TOPO_vf_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
;f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

vf_mean_TOPO = f_vf_TOPO->vint_forcing_TOPO_mean

pr_mean_CTR = f_CTR_mean->PRECT

vf_TOPO_CTR(index*3:index*3+2,:,:) = vf_mean_TOPO
PRECT_CTR(index*3:index*3+2,:,:) = pr_mean_CTR

end do ; do index

;
;========================

vf_TOPO_CTR&time = ispan(1,96,1)
PRECT_CTR&time = ispan(1,96,1)

PRECT_CTR = PRECT_CTR * 8.64e7
PRECT_CTR@units = "mm/day"
;
printVarSummary(vf_TOPO_CTR)
printVarSummary(PRECT_CTR)

;-------- based on Mike's comment, change units -
vf_TOPO_CTR = vf_TOPO_CTR * 1004.0    ; specific capacity of dry air 1004.0 J/(kg*K)
vf_TOPO_CTR@units = "W/m2"

;=============== average over lat (-5,5) in preparation for Hovmueler=========
;total_days = 11
;total_hrs = 48
total_hrs = 96

lat_c1 = -5.0
lat_c2 = 5.0

lon_c1 = 260.0 
lon_c2 = 320.0

vf_TOPO_CTR_hov = dim_avg_n_Wrap(vf_TOPO_CTR(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat

PRECT_CTR_hov = dim_avg_n_Wrap(PRECT_CTR(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat

printVarSummary(vf_TOPO_CTR_hov)

printVarSummary(PRECT_CTR_hov)

;================ plot ===========

wks = gsn_open_wks("png","../Figures/6_c_vintForcing_PRECT_CTR_Hov")
gsn_define_colormap(wks,"MPL_BLues")
gsn_reverse_colormap(wks)

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

res@vpHeightF = 0.6
res@vpWidthF = 0.3  ; suggested by Mike, to double the Y time axis.

res@tmYLMode = "Manual"
res@tmYLTickStartF = 0
res@tmYLTickEndF = 96
res@tmYLTickSpacingF = 4

;----------

res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = -300.0
;res@cnMaxLevelValF = -20.0
res@cnMinLevelValF = 20.0
res@cnMaxLevelValF = 300.0
res@cnLevelSpacingF = 40.0

res@gsnContourNegLineDashPattern = 1
res@gsnContourLineThicknessesScale = 3.0
res@gsnContourZeroLineThicknessF = 2.0
res@gsnRightString = vf_TOPO_CTR@units

vf_TOPO_CTR_hov@long_name = "" ; to avoid long_name being printed out on top of the figures
;----------


;plot_var1 = gsn_csm_hov(wks,vf_TOPO_CTR_hov,res)
vf_TOPO_CTR_hov = - vf_TOPO_CTR_hov
plot_var1 = gsn_csm_hov(wks,vf_TOPO_CTR_hov,res)
plot_var1 = ColorNegDashZeroPosContour(plot_var1,"red","magenta","blue")
;plot_var1 = ColorNegDashZeroPosContour(plot_var1,"blue","magenta","yellow")

;res@gsnCenterString = "siglvl=0.1"
;plot_var_sig = gsn_csm_hov(wks_sig,X_diff_TOPO_CTR_hov_sig,res)

;---------

res@cnFillOn = True
res@cnLineLabelsOn = False
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 12.0
res@cnLevelSpacingF = 1.0

res@gsnCenterString = ""
res@tiMainString = "CTR, ENS(180), PRECT, vint_forcing_heat"
res@gsnLeftString = "mm/day"

gsn_reverse_colormap(wks)

plot_P = gsn_csm_hov(wks,PRECT_CTR_hov,res)


overlay(plot_P,plot_var1)
draw(plot_P)
frame(wks)


end
