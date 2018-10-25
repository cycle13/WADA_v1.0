;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF
;Note: modified on 20181001 

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;=============

str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,7

TOPO_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "vint_forcing.mean_std.TOPO."+str_time(index)+".nc"

var = (/"vint_forcing_TOPO_mean"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

printVarSummary(var_mean_TOPO)

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
total_hr = 6

do i_hr = 0,total_hr-1
;do i_hr = 0,1
 
wks = gsn_open_wks("png","5_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*6+i_hr+1))
gsn_define_colormap(wks,"MPL_BLues")
gsn_reverse_colormap(wks)  

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = "vint_forcing, TOPO, ENS(180), ihr="+tostring(index*6+i_hr+1)

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.5
;res@cnMaxLevelValF = 10.0e-5
res@cnMaxLevelValF =  0.0
res@cnLevelSpacingF = 0.01

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0
;
res@gsnLeftString = var

res@gsnCenterString = ""
res@gsnLeftString = ""

plot = gsn_csm_contour_map_ce(wks,var_mean_TOPO(i_hr,:,:),res)

end do

end do ; do index

end
