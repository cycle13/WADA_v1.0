;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD/"

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

;================
Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)

xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/)
;---------------
CAPE_CTR_AM = new(num_time,double)
CAPE_TOPO_AM = new(num_time,double)
CAPE_CTR_TOPO_AM = new(num_time,double)
CIN_CTR_AM = new(num_time,double)
CIN_TOPO_AM = new(num_time,double)
CIN_CTR_TOPO_AM = new(num_time,double)

CAPE_CTR_AM!0 = "time"
CAPE_TOPO_AM!0 = "time"
CAPE_CTR_TOPO_AM!0 = "time"
CIN_CTR_AM!0 = "time"
CIN_TOPO_AM!0 = "time"
CIN_CTR_TOPO_AM!0 = "time"

;-----------
;---Some constant variables -----
f_const_str = prefix+"/scratch/hongcheq/NERSC_Cori_WADA_simulation/F_AMIP_CAM5_WADA_TOPO_1989_sim2_1989-12-01_HCforcing/atm/hist/F_AMIP_CAM5_WADA_TOPO_1989_sim2_1989-12-01_HCforcing.cam.h1.1989-12-02-00000.nc"
f_const = addfile(f_const_str,"r")

hyam = f_const->hyam
hybm = f_const->hybm
P0 = 100000. ;in Pa

PHIS = f_const->PHIS
printVarSummary(PHIS)
;----------to make sure Zsfc has the same dimension as the PS in the wrf_cape_2d function--
Zsfc = new((/3,96,144/),float)
Zsfc(0,:,:) = PHIS/9.8
Zsfc(1,:,:) = PHIS/9.8
Zsfc(2,:,:) = PHIS/9.8
Zsfc@units = "m"
printVarSummary(Zsfc)
;------------
do index = 0,31
;do index = 0,2

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"

;;;var = (/"SHFLX"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")

PS_TOPO = f_TOPO_mean->PS ;in Pa
PS_CTR = f_CTR_mean->PS

pm_TOPO = pres_hybrid_ccm(PS_TOPO,P0,hyam,hybm)  ; should in Pa
pm_CTR = pres_hybrid_ccm(PS_CTR,P0,hyam,hybm)   ; should in Pa
pm_TOPO@units = "Pa"
pm_CTR@units = "Pa"
copy_VarCoords(f_TOPO_mean->T,pm_TOPO)
copy_VarCoords(f_TOPO_mean->T,pm_CTR)
printVarSummary(pm_TOPO)
printVarSummary(pm_CTR)

T_TOPO = f_TOPO_mean->T
Q_TOPO = f_TOPO_mean->Q
Z3_TOPO = f_TOPO_mean->Z3
PS_TOPO = f_TOPO_mean->PS

T_CTR = f_CTR_mean->T
Q_CTR = f_CTR_mean->Q
Z3_CTR = f_CTR_mean->Z3
PS_CTR = f_CTR_mean->PS

;cinfo_TOPO = wrf_cape_2d(pm_TOPO,T_TOPO,Q_TOPO,Z3_TOPO,Zsfc,PS_TOPO,True)
;cinfo_CTR = wrf_cape_2d(pm_CTR,T_CTR,Q_CTR,Z3_CTR,Zsfc,PS_CTR,True)
; Note https://www.ncl.ucar.edu/Document/Functions/Built-in/wrf_cape_2d.shtml
; This is maximum CAPE and maximum CIN

cinfo_TOPO = wrf_cape_3d(pm_TOPO,T_TOPO,Q_TOPO,Z3_TOPO,Zsfc,PS_TOPO,True)
cinfo_CTR = wrf_cape_3d(pm_CTR,T_CTR,Q_CTR,Z3_CTR,Zsfc,PS_CTR,True)

printVarSummary(cinfo_TOPO)
;print(T_TOPO&lev(25:29))
printVarSummary(cinfo_CTR)

CAPE_TOPO = cinfo_TOPO(0,:,29,:,:)
;CAPE_TOPO = cinfo_TOPO(0,:,:,:)
copy_VarCoords(PS_TOPO,CAPE_TOPO)
CAPE_TOPO@units = "J/kg"

CIN_TOPO = cinfo_TOPO(1,:,29,:,:)
;CIN_TOPO = cinfo_TOPO(1,:,:,:)
copy_VarCoords(PS_TOPO,CIN_TOPO)
CIN_TOPO@units = "J/kg"

CAPE_CTR = cinfo_CTR(0,:,29,:,:)
;CAPE_CTR = cinfo_CTR(0,:,:,:)
copy_VarCoords(PS_CTR,CAPE_CTR)
CAPE_CTR@units = "J/kg"

CIN_CTR = cinfo_CTR(1,:,29,:,:)
;CIN_CTR = cinfo_CTR(1,:,:,:)
copy_VarCoords(PS_CTR,CIN_CTR)
CIN_CTR@units = "J/kg"

printVarSummary(CAPE_TOPO)
printVarSummary(CIN_TOPO)
printVarSummary(CAPE_CTR)
printVarSummary(CIN_CTR)
;;=============================

CAPE_diff_CTR_TOPO = CAPE_TOPO ; metadata
CAPE_diff_CTR_TOPO = CAPE_CTR - CAPE_TOPO

CIN_diff_CTR_TOPO = CIN_TOPO ; metadata
CIN_diff_CTR_TOPO = CIN_CTR - CIN_TOPO

printVarSummary(CAPE_diff_CTR_TOPO)
printVarSummary(CIN_diff_CTR_TOPO)

;================ plot ===========
;total 12 days in the TOPOTEST after branching
;total_days = 12
total_hr = 3

do i_hr = 0,total_hr-1
;do i_day = 0,1
;---------
 
wks = gsn_open_wks("png","./Figures/13_a_Regional_CAPE_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
wks2 = gsn_open_wks("png","./Figures/13_a_Regional_CIN_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = "CAPE, CTR - TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -60.0
res@cnMaxLevelValF = 60.0
res@cnLevelSpacingF = 5.0

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0
;
res@gsnLeftString = "CAPE"

plot = gsn_csm_contour_map_ce(wks,CAPE_diff_CTR_TOPO(i_hr,:,:),res)

res@tiMainString = "CIN, CTR - TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@gsnLeftString = "CAPE"
plot2 = gsn_csm_contour_map_ce(wks2,CIN_diff_CTR_TOPO(i_hr,:,:),res)

;----------- add polygon -------
dum_Amazon = new(4,graphic)
dum_Amazon2 = new(4,graphic)
;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 4.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon(i)=gsn_add_polyline(wks,plot,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon2(i)=gsn_add_polyline(wks2,plot2,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do

;------------------
draw(plot)
frame(wks)
draw(plot2)
frame(wks2)
;--------------
delete(dum_Amazon)

;----------------------------
rad = 4.0*atan(1.0)/180.0
clat = cos(f_TOPO_mean->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad)

CAPE_CTR_AM(index*3+i_hr) = wgt_areaave_Wrap(CAPE_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
CAPE_TOPO_AM(index*3+i_hr) = wgt_areaave_Wrap(CAPE_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
CAPE_CTR_TOPO_AM(index*3+i_hr) = wgt_areaave_Wrap(CAPE_diff_CTR_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)

CIN_CTR_AM(index*3+i_hr) = wgt_areaave_Wrap(CIN_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
CIN_TOPO_AM(index*3+i_hr) = wgt_areaave_Wrap(CIN_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
CIN_CTR_TOPO_AM(index*3+i_hr) = wgt_areaave_Wrap(CIN_diff_CTR_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
;------------

end do ; do i_hr

end do ; do index

printVarSummary(CAPE_CTR_AM)
printVarSummary(CAPE_TOPO_AM)
printVarSummary(CAPE_CTR_TOPO_AM)

;------------output nc files------------
dir_out_nc = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/CAPE_CIN/"
fil_out_nc = "LowestLevel_using_wrf_cape_3d_CAPE_CIN_avg_box_hourly_96hrs.nc"
system("rm "+dir_out_nc+fil_out_nc)
ncdf = addfile(dir_out_nc+fil_out_nc,"c")
filedimdef(ncdf,"time",-1,True)
ncdf->CAPE_CTR_AM = CAPE_CTR_AM
ncdf->CAPE_TOPO_AM = CAPE_TOPO_AM
ncdf->CAPE_CTR_TOPO_AM = CAPE_CTR_TOPO_AM

ncdf->CIN_CTR_AM = CIN_CTR_AM
ncdf->CIN_TOPO_AM = CIN_TOPO_AM
ncdf->CIN_CTR_TOPO_AM = CIN_CTR_TOPO_AM



end
