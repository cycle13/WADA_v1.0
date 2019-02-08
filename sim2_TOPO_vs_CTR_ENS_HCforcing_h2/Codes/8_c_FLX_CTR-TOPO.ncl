;Function: SHFLX difference between CTR ensemble and TOPO ensemble, with significance.
;Date: 20181031

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

chunk = 1
;num_time = 4
num_time = 96

;=====================================
TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/TOPO_TEST/"
;TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_str = "ENS.std.mean.TOPOTEST.FLX.CF.nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/CTR/"
;CTR_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_str = "ENS.std.mean.CTR.FLX.CF.nc"

;var = (/"MSE"/)

f_TOPO = addfile(TOPO_dir+TOPO_str,"r")

f_CTR = addfile(CTR_dir+CTR_str,"r")

FLX_mean_TOPO = f_TOPO->FLX_TOPO_mean
FLX_std_TOPO = f_TOPO->FLX_TOPO_std

FLX_mean_CTR = f_CTR->FLX_CTR_mean
FLX_std_CTR = f_CTR->FLX_CTR_std

siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(FLX_mean_TOPO,FLX_std_TOPO^2,indep_sample,FLX_mean_CTR,FLX_std_CTR^2,indep_sample,True,False)
;printVarSummary(prob)

diff_TOPO_CTR = FLX_mean_TOPO ; metadata
;diff_TOPO_CTR = var_mean_TOPO - var_mean_CTR
diff_TOPO_CTR = FLX_mean_CTR - FLX_mean_TOPO

diff_TOPO_CTR_sig = FLX_mean_TOPO ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO - var_mean_CTR,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,FLX_mean_CTR - FLX_mean_TOPO,diff_TOPO_CTR@_FillValue)

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)

;-----Add box points to delineate area which may explain the vertical growth of temperature anomaly ----------
Amazon_lon_test1 = (/360.0-72.0,360.0-65.0/)
Amazon_lat_test1 = (/-10.0,2.0/)
xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/)
;---------------

;-----------add some variables to hold areal averaged FLX_CTR, FLX_TOPO, FLX_CTR_TOPO
FLX_CTR = new(num_time,double)
FLX_TOPO = new(num_time,double)
FLX_CTR_TOPO = new(num_time,double)
FLX_CTR!0 = "time"
FLX_TOPO!0 = "time"
FLX_CTR_TOPO!0 = "time"

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
total_hr = 96
;total_hr = 6
;total_day = 4

do i_hr = 0,total_hr-1

wks = gsn_open_wks("png","../Figures/8_c_Regional_FLX_lowlevel_TOPO_vs_CTR_ihr"+tostring(i_hr+1))
wks_sig = gsn_open_wks("png","../Figures/8_c_Sig_Regional_FLX_lowlevel_TOPO_vs_CTR_ihr"+tostring(i_hr+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = "SHFLX+LHFLX, CTR - TOPO, ENS(180), ihr="+tostring(i_hr+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -60.0
res@cnMaxLevelValF = 60.0
res@cnLevelSpacingF = 5.0
;res@cnMinLevelValF = -10.0
;res@cnMaxLevelValF = 10.0
;res@cnLevelSpacingF = 0.5

;res@cnMinLevelValF = -0.5
;res@cnMaxLevelValF = 0.5
;res@cnLevelSpacingF = 0.05

;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0

res@mpMaxLatF = 25.0
res@mpMinLatF = -35.0
res@mpMaxLonF = 360.0 - 30.0
res@mpMinLonF = 360.0 - 110.0


res@gsnLeftString = "SHFLX+LHFLX"
;lowest three level are lev = 957, 976, 992.

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_hr,:,:),res)
delete(res@gsnCenterString)

plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_hr,:,:),res)
delete(res@gsnCenterString)

;----------- add polygon -------
dum_Amazon = new(4,graphic)
dum_Amazon_sig = new(4,graphic)
;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 4.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon(i)=gsn_add_polyline(wks,plot,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_sig(i)=gsn_add_polyline(wks_sig,plot_sig,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do

;------------------
draw(plot)
draw(plot_sig)
frame(wks)
frame(wks_sig)
;--------------
delete(dum_Amazon)
delete(dum_Amazon_sig)

;-------Save variales for FLX_CTR, FLX_TOPO, FLX_CTR_TOPO as areal average, put std aside for now------
rad = 4.0*atan(1.0)/180.0
clat = cos(f_TOPO->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad)

FLX_CTR(i_hr) = wgt_areaave_Wrap(FLX_mean_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
FLX_TOPO(i_hr) = wgt_areaave_Wrap(FLX_mean_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)
FLX_CTR_TOPO(i_hr) = wgt_areaave_Wrap(diff_TOPO_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)

end do
;==============================

printVarSummary(FLX_CTR)
printVarSummary(FLX_TOPO)
printVarSummary(FLX_CTR_TOPO)

;------------output nc files------------
dir_out_nc = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/"
fil_out_nc = "FLX_avg_box_hourly_96hrs.nc"
system("rm "+dir_out_nc+fil_out_nc)
ncdf = addfile(dir_out_nc+fil_out_nc,"c")
filedimdef(ncdf,"time",-1,True)
ncdf->FLX_CTR = FLX_CTR
ncdf->FLX_TOPO = FLX_TOPO
ncdf->FLX_CTR_TOPO =  FLX_CTR_TOPO


end
