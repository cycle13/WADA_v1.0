;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF

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

;================
;-----Add box points to delineate area which may explain the vertical growth of temperature anomaly ----------
Amazon_lon_test1 = (/360.0-72.0,360.0-65.0/)
Amazon_lat_test1 = (/-10.0,2.0/)
xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/)
;---------------

;------- Add another box which delineate where to average the dMSE/dt calculation -----
Amazon_lon_test2 = (/360.0-80.0,360.0-75.0/)
Amazon_lat_test2 = (/-10.0,2.0/)
xpts_Amazon_test2 = (/Amazon_lon_test2(0),Amazon_lon_test2(1),Amazon_lon_test2(1),Amazon_lon_test2(0),Amazon_lon_test2(0)/)
ypts_Amazon_test2 = (/Amazon_lat_test2(0),Amazon_lat_test2(0),Amazon_lat_test2(1),Amazon_lat_test2(1),Amazon_lat_test2(0)/)

;-----------add some variables to hold areal averaged SHFLX_CTR, SHFLX_TOPO, SHFLX_CTR_TOPO
SHFLX_CTR = new(num_time,double)
SHFLX_TOPO = new(num_time,double)
SHFLX_CTR_TOPO = new(num_time,double)
SHFLX_CTR!0 = "time"
SHFLX_TOPO!0 = "time"
SHFLX_CTR_TOPO!0 = "time"

;-----------

do index = 0,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/TOPO_TEST/"
;TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/Old/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/CTR/"
;CTR_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/Old/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

var = (/"SHFLX"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_TOPO)

var_mean_CTR_temp = f_CTR_mean->$var$
var_mean_CTR = var_mean_CTR_temp(:,:,:)   ; 
;printVarSummary(var_mean_CTR)
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_CTR)

siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO,var_std_TOPO^2,indep_sample,var_mean_CTR,var_std_CTR^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO ; metadata
;diff_TOPO_CTR = var_mean_TOPO - var_mean_CTR
diff_TOPO_CTR = var_mean_CTR - var_mean_TOPO

diff_TOPO_CTR_sig = var_mean_TOPO ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO - var_mean_CTR,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_CTR - var_mean_TOPO,diff_TOPO_CTR@_FillValue)

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)


;================ plot ===========
;total 12 days in the TOPOTEST after branching
;total_days = 12
total_hr = 3

do i_hr = 0,total_hr-1
;do i_day = 0,1
;---------
 
wks = gsn_open_wks("x11","../Figures/8_a_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;wks = gsn_open_wks("png","Global_"+var+"_TOPO_vs_CTR_iday_"+tostring(i_day+1))
wks_sig = gsn_open_wks("x11","../Figures/8_a_Sig_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;wks_sig = gsn_open_wks("png","Sig_Global_"+var+"_TOPO_vs_CTR_iday_"+tostring(i_day+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = var+", CTR - TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -60.0
res@cnMaxLevelValF = 60.0
res@cnLevelSpacingF = 5.0

;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0
res@mpMaxLatF = 25.0
res@mpMinLatF = -35.0
res@mpMaxLonF = 360.0 - 30.0
res@mpMinLonF = 360.0 - 110.0
;
res@gsnLeftString = var

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_hr,:,:),res)

plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_hr,:,:),res)

;----------- add polygon -------
dum_Amazon = new(4,graphic)
dum_Amazon_sig = new(4,graphic)

dum_Amazon2 = new(4,graphic)
dum_Amazon2_sig = new(4,graphic)
;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 4.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon(i)=gsn_add_polyline(wks,plot,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_sig(i)=gsn_add_polyline(wks_sig,plot_sig,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do

do i = 0 , 3
  dum_Amazon2(i)=gsn_add_polyline(wks,plot,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon2_sig(i)=gsn_add_polyline(wks_sig,plot_sig,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
end do

;------------------
draw(plot)
draw(plot_sig)
frame(wks)
frame(wks_sig)
;--------------
delete(dum_Amazon)
delete(dum_Amazon_sig)


;-------Save variales for SHFLX_CTR, SHFLX_TOPO, SHFLX_CTR_TOPO as areal average, put std aside for now------
rad = 4.0*atan(1.0)/180.0
clat = cos(f_TOPO_mean->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad)

SHFLX_CTR(index*3+i_hr) = wgt_areaave_Wrap(var_mean_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
SHFLX_TOPO(index*3+i_hr) = wgt_areaave_Wrap(var_mean_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
SHFLX_CTR_TOPO(index*3+i_hr) = wgt_areaave_Wrap(diff_TOPO_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)

;------------

end do ; do i_hr

end do ; do index

printVarSummary(SHFLX_CTR)
printVarSummary(SHFLX_TOPO)
printVarSummary(SHFLX_CTR_TOPO)

;------------output nc files------------
dir_out_nc = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/"
fil_out_nc = "SHFLX_avg_box_hourly_96hrs.nc"
system("rm "+dir_out_nc+fil_out_nc)
ncdf = addfile(dir_out_nc+fil_out_nc,"c")
filedimdef(ncdf,"time",-1,True)
ncdf->SHFLX_CTR = SHFLX_CTR
ncdf->SHFLX_TOPO = SHFLX_TOPO
ncdf->SHFLX_CTR_TOPO =  SHFLX_CTR_TOPO



end
