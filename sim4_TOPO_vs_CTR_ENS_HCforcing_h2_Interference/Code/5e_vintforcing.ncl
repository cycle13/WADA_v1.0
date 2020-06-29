;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF
;Note: modified on 20181001 
;Note: modified on 20200628

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

;;-Note: run 6_a_TOPO_vintForcing_Hov.ncl  first to produce .nc files ----
;
;chunk = 32
;num_time = 96
;
;num1 = new(32,integer)
;num2 = new(32,integer)
;
;do i_chunk = 0,chunk-1
;num1_temp = i_chunk * num_time/chunk
;num2_temp = num1_temp + num_time/chunk - 1
;
;num1(i_chunk) = num1_temp
;num2(i_chunk) = num2_temp
;end do  ; do i_chunk
;
;;-------------
;str_time = new(32,string)
;
;do i_str_time = 0,31
;str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
;end do
;
;;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)
;
;do index = 0,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim4_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST/h2/"
TOPO_mean_str = "vint_forcing.temp.TOPO.2008-10-10.nc"

var = (/"vint_forcing_TOPO"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

printVarSummary(var_mean_TOPO)

;-------- based on Mike's comment, change units -
var_mean_TOPO = var_mean_TOPO * 1004.0    ; specific capacity of dry air 1004.0 J/(kg*K)
var_mean_TOPO@units = "W/m2"


;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
;total_hr = 3
total_hr = 24

; to make the variable to represent CTR - TOPO, rather than TOPO
var_mean_TOPO = -var_mean_TOPO

do i_hr = 0,total_hr-1
;do i_hr = 0,1
 
wks = gsn_open_wks("png","../Figures/5_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(i_hr+1))
;gsn_define_colormap(wks,"MPL_BLues")
gsn_define_colormap(wks,"MPL_Purples")
;gsn_reverse_colormap(wks)  

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

;res@tiMainString = "vint_forcing, TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@tiMainString = "vint_forcing_heat, ihr="+tostring(i_hr+1)

res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = -500.0
;res@cnMaxLevelValF = 10.0e-5
;res@cnMaxLevelValF =  0.0
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 500.0
res@cnLevelSpacingF = 20.0

;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0
res@mpMaxLatF = 25.0
res@mpMinLatF = -35.0
res@mpMaxLonF = 360.0 - 30.
res@mpMinLonF = 360.0 - 110

res@gsnLeftString = var

res@gsnCenterString = ""
res@gsnLeftString = ""

plot = gsn_csm_contour_map_ce(wks,var_mean_TOPO(i_hr,:,:),res)

end do

;;end do ; do index

end
