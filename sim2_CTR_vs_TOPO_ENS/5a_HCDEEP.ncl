;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF
;Note: modified on 20181001 

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
;
;;------------ As a correction to HCDEEP and HCSHALLOW --------
;;------------- the real TOPO forcing are HCDEEP * (-1) * (sgh_hgfrac(i) -1)
f_SGH30 = addfile("/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
sgh30 = f_SGH30->SGH30

sgh_htfrac = new((/96,144/),float)

do i=0,95
do j=0,143
    if (sgh30(i,j) .lt. 100.0) then
           sgh_htfrac(i,j) = 1.0
    else if (sgh30(i,j) .lt. 200.0) then
            sgh_htfrac(i,j) = 1.0 - ((tofloat(sgh30(i,j)) - 100.0) / 100.0)
           sgh_htfrac(i,j) = -0.01 * tofloat(sgh30(i,j)) + 2.0
    else
           sgh_htfrac(i,j) = 0.0
    end if
    end if
end do
end do
printVarSummary(sgh_htfrac)

;------------
;=============

str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,7

TOPO_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

var = (/"HCDEEP"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

printVarSummary(var_mean_TOPO)

;do i_lat = 0,95
;do i_lon = 0,143
;var_mean_TOPO(:,:,i_lat,i_lon) = var_mean_TOPO(:,:,i_lat,i_lon) * (-1.0) * (sgh_htfrac(i_lat,i_lon)-1.0)
;end do
;end do

;printVarSummary(var_mean_TOPO)

;============================
diff_TOPO_CTR = var_mean_TOPO ; metadata

printVarSummary(diff_TOPO_CTR)

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
total_hr = 6

pressure = 500.0
str_pressure = "500hPa" 

do i_hr = 0,total_hr-1
;do i_hr = 0,1
 
wks = gsn_open_wks("x11","5_Regional_"+var+"_"+str_pressure+"_TOPO_vs_CTR_ihr_"+tostring(index*6+i_hr+1))
gsn_define_colormap(wks,"MPL_BLues")
gsn_reverse_colormap(wks)  

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = var+", TOPO forcing, ENS(180), ihr="+tostring(index*6+i_hr+1)
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
