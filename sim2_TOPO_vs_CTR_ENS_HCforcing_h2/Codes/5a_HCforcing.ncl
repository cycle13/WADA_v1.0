;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF
;Note: modified on 20181001 

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
;------------
;=============
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

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

var = (/"HCforcing"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

printVarSummary(var_mean_TOPO)

;============================
diff_TOPO_CTR = var_mean_TOPO ; metadata

printVarSummary(diff_TOPO_CTR)

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
total_hr = 3

pressure = 500.0
str_pressure = "500hPa" 

do i_hr = 0,total_hr-1
;do i_hr = 0,1
 
wks = gsn_open_wks("x11","5_Regional_"+var+"_"+str_pressure+"_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
gsn_define_colormap(wks,"MPL_BLues")
gsn_reverse_colormap(wks)  

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = var+", TOPO forcing, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@gsnCenterString = sprintf("%5.1f",pressure)+"hPa"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -10.0e-5
;res@cnMaxLevelValF = 10.0e-5
res@cnMaxLevelValF = 0.0
res@cnLevelSpacingF = 1.0e-5

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0
;
res@gsnLeftString = var

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_hr,{pressure},:,:),res)

end do

end do ; do index

end
