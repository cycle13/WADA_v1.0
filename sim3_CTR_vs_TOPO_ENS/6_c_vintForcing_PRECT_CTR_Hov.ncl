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

vf_TOPO_CTR = new((/96,96,144/),double)

PRECT_CTR = new((/96,96,144/),double)

str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47",\
             "48-53","54-59","60-65","66-71","72-77","78-83","84-89","90-95"/)

do index = 0,15
;do index = 0,7
;do index = 0,0

TOPO_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_vf_str = "vint_forcing.mean_std.TOPO."+str_time(index)+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

f_vf_TOPO = addfile(TOPO_dir+TOPO_vf_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
;f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

vf_mean_TOPO = f_vf_TOPO->vint_forcing_TOPO_mean

pr_mean_CTR = f_CTR_mean->PRECT

vf_TOPO_CTR(index*6:index*6+5,:,:) = vf_mean_TOPO
PRECT_CTR(index*6:index*6+5,:,:) = pr_mean_CTR

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

wks = gsn_open_wks("png","6_c_vintForcing_PRECT_CTR_Hov")
gsn_define_colormap(wks,"MPL_BLues")
gsn_reverse_colormap(wks)

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

;----------

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.3
res@cnMaxLevelValF = -0.02
res@cnLevelSpacingF = 0.01

res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.
res@gsnRightString = vf_TOPO_CTR@units

vf_TOPO_CTR_hov@long_name = "" ; to avoid long_name being printed out on top of the figures
;----------

plot_var1 = gsn_csm_hov(wks,vf_TOPO_CTR_hov,res)
plot_var1 = ColorNegDashZeroPosContour(plot_var1,"red","magenta","blue")

;res@gsnCenterString = "siglvl=0.1"
;plot_var_sig = gsn_csm_hov(wks_sig,X_diff_TOPO_CTR_hov_sig,res)

;---------

res@cnFillOn = True
res@cnLineLabelsOn = False
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 12.0
res@cnLevelSpacingF = 0.5

res@gsnCenterString = ""
res@tiMainString = "CTR, ENS(180), PRECT, vint_forcing"
res@gsnLeftString = "mm/day"

gsn_reverse_colormap(wks)

plot_P = gsn_csm_hov(wks,PRECT_CTR_hov,res)


overlay(plot_P,plot_var1)
draw(plot_P)
frame(wks)


end
