;Function: 
;          1.Figure1: Precipitation regrid multi-model-mean which will be further compared against with GPCP data, with boxes overlain;
;          2.Figure2: Precipitation MMM minus GPCP 1982-2008 clim, with boxes overlain;
;          3.Figure3: precipitation over western Amazon east of Andes field VS Omega(500hPa? 750hPa?).
;
;Date: 20191010

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;========================= Part I ===========================
;============================================================
pr_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/pr/"
BR_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/BR_processing/"
hus_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/hus_processing/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M", "IPSL-CM5A-LR",\
               "CMCC-CM",      "MPI-ESM-MR",     "ACCESS1-0", "CSIRO-Mk3-6-0", "IPSL-CM5A-MR", "IPSL-CM5B-LR",\
              "MPI-ESM-LR",   "MRI-AGCM3-2H",     "inmcm4",     "MIROC-ESM",    "MRI-CGCM3",    "MIROC5" ,\
              "HadGEM2-A" ,  "GFDL-CM3", "GFDL-HIRAM-C360", "GFDL-HIRAM-C180" /)

precip_diff_y = new(dimsizes(WADA_labels),double)
hus_x = new(dimsizes(WADA_labels),double)

precip_models = (/pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)

BR_models = (/BR_dir_name+"BR_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                 BR_dir_name+"BR_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)

hus_models = (/hus_dir_name+"hus_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                 hus_dir_name+"hus_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)

GPCP_file  = (/"/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_198201-200812_clim.regrid.288x192.nc"/)

MTE_file  = (/"/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_198201-200812_clim.nc"/)

;======== Raw precipitation and precipitation minus GPCP ======

plot_map_overlain = new(dimsizes(WADA_labels),graphic)    ; for raw precip clim multi-panel map

;============
Amazon_lon_test1 = (/286.0,293.0/)
Amazon_lat_test1 = (/-8.0,0.0/)

Amazon_lon_test2 = (/293.0,304.0/)
Amazon_lat_test2 = (/-10.0,1.0/)

 xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
 ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/) 

 xpts_Amazon_test2 = (/Amazon_lon_test2(0),Amazon_lon_test2(1),Amazon_lon_test2(1),Amazon_lon_test2(0),Amazon_lon_test2(0)/)
 ypts_Amazon_test2 = (/Amazon_lat_test2(0),Amazon_lat_test2(0),Amazon_lat_test2(1),Amazon_lat_test2(1),Amazon_lat_test2(0)/) 

res                             = True
res@gsnDraw = False
res@gsnFrame = False
res@mpFillOn                    = False        ; turn off gray fill
res@cnFillOn = True
res@lbLabelBarOn = False
res@cnInfoLabelOn = False

res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
res@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines

res@mpMaxLatF                   = 30          ; choose subregion           
res@mpMinLatF                   = -50
res@mpMaxLonF                   = 340
res@mpMinLonF                   = 260

;----------- plot precipitation multi-model-mean --------
wks_MMM_precip = gsn_open_wks("png","WADA_precip_MMM_2")
precip_clim_MMM_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/pr/Multi-Model-Mean_regrid_pr_clim_198201-200812.nc","r")
pr_MMM = precip_clim_MMM_file->pr_MMM

pr_MMM = pr_MMM * 86400.0
pr_MMM@units = "mm/day"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 1.0

res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_MMM"
res@tiMainString = "Precip clim, 198201-200812, Multi-Model-Mean"
plot_precip_MMM = gsn_csm_contour_map(wks_MMM_precip,pr_MMM,res)

dum_Amazon_pr_MMM1 = new(4,graphic)
dum_Amazon_pr_MMM2 = new(4,graphic)

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 2.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon_pr_MMM1(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
end do 

do i = 0 , 3
  dum_Amazon_pr_MMM2(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
end do 

draw(plot_precip_MMM)
frame(wks_MMM_precip)

;-------------- Add Multi-model-mean minus GPCP ----------------
;----------GPCP regridded already --------
f_GPCP = addfile(GPCP_file,"r")
pr_clim_GPCP = f_GPCP->pr_clim_GPCP
printVarSummary(pr_clim_GPCP)

diff_pr_MMM_GPCP = pr_MMM  ; meta data
diff_pr_MMM_GPCP = pr_MMM - pr_clim_GPCP
printVarSummary(diff_pr_MMM_GPCP)

;============================ Fig. 3 =================================
;---------- plot this precipitation Multi-Model-Mean minus GPCP climatology ---
wks_MMM_GPCP_precip = gsn_open_wks("png","WADA_precip_MMM-GPCP3")

res = True
res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "pr_MMM - GPCP"
res@tiMainString = "MMM clim minus GPCP clim, 198201--200812"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot_precip_MMM_GPCP = gsn_csm_contour_map(wks_MMM_GPCP_precip,diff_pr_MMM_GPCP,res)

dum_Amazon_pr_MMM_GPCP1 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP2 = new(4,graphic)

do i = 0 , 3
  dum_Amazon_pr_MMM_GPCP1(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
end do
do i = 0 , 3
  dum_Amazon_pr_MMM_GPCP2(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
end do

draw(plot_precip_MMM_GPCP)
frame(wks_MMM_GPCP_precip)

;==========================================Part 3=========================================================================
;=================================== Fig. 9 ============================
;================== Magnitude of biases in [precip(Andes) - precip(Amazon)  VS Magnitude of biases of [Bowen ratio over the Amazon] 
;====================== =====================
rad  = 4.*atan(1.)/180.    ;

;do imodel = 8,8
do imodel = 0,dimsizes(WADA_labels) - 1
;------------ Diff of precip ----------
if (imodel .eq. 0) then   ; CCSM4 does not have regrid file, just use it as it is
pr_file = addfile(pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc","r")
pr_mon_clim_regrid = pr_file->pr_mon_clim

else
pr_file = addfile(pr_dir_name+"regrid_precipitation_clim_198201-200812."+WADA_labels(imodel)+".nc","r")
pr_mon_clim_regrid = pr_file->pr_mon_clim_regrid

end if

pr_DJF_clim_regrid = pr_mon_clim_regrid(0,:,:) ; metadata
pr_DJF_clim_regrid = (pr_mon_clim_regrid(0,:,:) + pr_mon_clim_regrid(1,:,:) + pr_mon_clim_regrid(11,:,:) ) / 3.0
;========================

coslat_Amazon_pr2 = cos(pr_file->lat({Amazon_lat_test2(0):Amazon_lat_test2(1)})*rad) 

Amazon_ave2 = wgt_areaave_Wrap(pr_DJF_clim_regrid({Amazon_lat_test2(0):Amazon_lat_test2(1)},{Amazon_lon_test2(0):Amazon_lon_test2(1)}),coslat_Amazon_pr2,1.0,0)

precip_diff_y(imodel) = Amazon_ave2

delete(pr_mon_clim_regrid)
delete(pr_DJF_clim_regrid)
delete(coslat_Amazon_pr2)

;--------------  hus averaged over Amazon -----------
;level_target = 50000.0 ; plev is in Pa
level_target = 85000.0 ; plev is in Pa
if (imodel .eq. 0)then
hus_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/hus_processing/"+"hus_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc","r")
hus_mon_clim_regrid = hus_file->hus_mon_clim
else
hus_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/hus_processing/"+"regrid_hus_clim_198201-200812."+WADA_labels(imodel)+".nc","r")
hus_mon_clim_regrid = hus_file->hus_mon_clim_regrid
end if

hus_DJF_clim_regrid = hus_mon_clim_regrid(0,{level_target},:,:) ; metadata
hus_DJF_clim_regrid = (hus_mon_clim_regrid(0,{level_target},:,:)+hus_mon_clim_regrid(1,{level_target},:,:) +hus_mon_clim_regrid(11,{level_target},:,:) )/3.0

coslat_Amazon_hus1 = cos(hus_file->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad) 

Amazon_ave_hus1 = wgt_areaave_Wrap(hus_DJF_clim_regrid({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),coslat_Amazon_hus1,1.0,0)

hus_x(imodel) = Amazon_ave_hus1

delete(hus_mon_clim_regrid)
delete(hus_DJF_clim_regrid)
delete(coslat_Amazon_hus1)

end do ; do imodel

precip_diff_y = precip_diff_y * 86400.0 ; from kg/m2/sec to mm/day
precip_diff_y@long_name = "precip_DJF(Amazon) for a multitude of models"
precip_diff_y@units = "mm/day"

hus_x = hus_x * 1000.0 ; from kg/kg to g/kg, 
hus_x@long_name = "hus_DJF (Amazon), "+sprintf("%5.2f",level_target/100.0)+"hPa, for a multitude of models"
hus_x@units = "g/kg"

print(precip_diff_y)
print(hus_x)

;========== Calculate the correlation coefficient ====
r = escorc(precip_diff_y,hus_x)
n_size = dimsizes(precip_diff_y)

t = r*sqrt((n_size-2)/(1-r^2))      
p = student_t(t, n_size-2)
psig = 0.05                       ; test significance level                     
print("r="+sprintf("%7.3e",r))
print("p="+sprintf("%7.3e",p))            ;

;------ Linear regression------
rc    = regline(hus_x, precip_diff_y)          ; slope
pltarry = rc*hus_x + rc@yintercept              ; use solid line

;====================== Plot precip_diff_y VS hfss_y ========
wks_CMIP   = gsn_open_wks ("png","WADA_CMIP5_Precip_HUS_9_plev_"+sprintf("%5.1f",level_target/100.0))

colors  = (/"wheat4","dodgerblue2","firebrick","forestgreen","thistle3",\
            "tomato","deeppink2","darkorange2","purple","turquoise",\
            "turquoise4","violet","violetred","yellow4","yellowgreen",\
            "darkorchid","darksalmon","deepskyblue","firebrick4","deepskyblue3",\
            "aquamarine4",   "blue3",  "brown2",    "burlywood2","cadetblue3"/)
markers = (/0 , 2, 3, 4, 5,\
            6 , 7, 8, 9,10,\
            11,12,13,14,15,\
            0 , 2, 3, 4, 5,\
            6 , 7, 8, 9, 10/)    ; some models are same marker, but different color

res_CMIP                   = True                    
res_CMIP@gsnFrame = False
res_CMIP@gsnDraw = False
;res_CMIP@gsnMaximize       = True                     
res_CMIP@tiMainString      = "Precip(Amazon) vs HUS_850(Amazon), 1982-2008 DJF"          
res_CMIP@tiYAxisString = "pr_DJF(Amazon), mm/day"
res_CMIP@tiXAxisString = "HUS_850_DJF(Amazon), g/kg"
res_CMIP@xyMarkLineMode    = "Markers"                
res_CMIP@xyMarkers         =  markers(0:dimsizes(WADA_labels)-1)                   
res_CMIP@xyMonoMarkerColor  = False
res_CMIP@xyMarkerColors     = colors(0:dimsizes(WADA_labels)-1) 
res_CMIP@xyMarkerSizeF     = 0.02                    

res_CMIP@gsnLeftString = "correlation="+sprintf("%7.3e",r)
res_CMIP@gsnRightString = "p="+sprintf("%7.3e",p)

res_CMIP@trXMinF = 10.0
res_CMIP@trXMaxF = 15.0
res_CMIP@trYMinF = 2.0
res_CMIP@trYMaxF = 20.0

plot_CMIP  = gsn_csm_xy(wks_CMIP,transpose((/hus_x,hus_x/)),transpose((/precip_diff_y,precip_diff_y/)),res_CMIP)              
;------- linear regression ----

   res@xyMarkLineModes     = (/"Lines"/)  ; choose which have markers
   res@xyMarkers           = 16                     ; choose type of marker 
   res@xyMarkerColor       = "red"                  ; Marker color
   res@xyMarkerSizeF       = 0.005                  ; Marker size (default 0.01)
   res@xyDashPatterns      = 1                      ; solid line 
   res@xyLineThicknesses   = (/2/)                ; set second line to 2
   res@tmYLFormat          = "f"                    ; not necessary but nicer labels 

   res@gsnLeftString = ""
   res@gsnRightString=""
   res@gsnCenterString = ""
   plot_lr  = gsn_csm_xy (wks_CMIP,hus_x,pltarry,res)           ; create plot

overlay(plot_CMIP,plot_lr)
;frame(wks_CMIP)

;--------- Draw a marker label -----
  xpos_marker1    = (/0.22,0.22+0.12,0.22+0.12*2,0.22+0.12*3,0.22+0.12*4/)
  xpos_text1    = (/  0.23,0.23+0.12,0.23+0.12*2,0.23+0.12*3,0.23+0.12*4/)

  txres               = True         ; Text resources
  txres@txFontHeightF = 0.0085
  txres@txJust        = "CenterLeft"
  
 mkres               = True         ; Marker resources

do i = 0,4
     mkres@gsMarkerThicknessF = 3.5
     mkres@gsMarkerSizeF      = 0.0085
     mkres@gsMarkerIndex      = markers(i)
     mkres@gsMarkerColor  = colors(i)
     gsn_polymarker_ndc(wks_CMIP,xpos_marker1(i),0.78,mkres)
     gsn_text_ndc      (wks_CMIP,WADA_labels(i),xpos_text1(i),0.78,txres)
end do
;--- Start from another line
do i = 5,9
     mkres@gsMarkerIndex  = markers(i)
     mkres@gsMarkerColor  = colors(i)
     gsn_polymarker_ndc(wks_CMIP,xpos_marker1(i-5),0.76,mkres)
     gsn_text_ndc      (wks_CMIP,WADA_labels(i),xpos_text1(i-5),0.76,txres)
end do

do i = 10,14
     mkres@gsMarkerIndex  = markers(i)
     mkres@gsMarkerColor  = colors(i)
     gsn_polymarker_ndc(wks_CMIP,xpos_marker1(i-10),0.74,mkres)
     gsn_text_ndc      (wks_CMIP,WADA_labels(i),xpos_text1(i-10),0.74,txres)
end do

do i = 15,19
     mkres@gsMarkerIndex  = markers(i)
     mkres@gsMarkerColor  = colors(i)
     gsn_polymarker_ndc(wks_CMIP,xpos_marker1(i-15),0.72,mkres)
     gsn_text_ndc      (wks_CMIP,WADA_labels(i),xpos_text1(i-15),0.72,txres)
end do

do i = 20,dimsizes(WADA_labels)-1
     mkres@gsMarkerIndex  = markers(i)
     mkres@gsMarkerColor  = colors(i)
     gsn_polymarker_ndc(wks_CMIP,xpos_marker1(i-20),0.70,mkres)
     gsn_text_ndc      (wks_CMIP,WADA_labels(i),xpos_text1(i-20),0.70,txres)
end do

;-------- add a linear equation to it ---

txres@txFontHeightF = 0.02
eq_string = "y = "+sprintf("%5.2f",rc)+" * x + "+sprintf("%5.2f",rc@yintercept)
gsn_text_ndc(wks_CMIP,eq_string,0.55,0.25,txres)


draw(plot_CMIP)
frame(wks_CMIP)

end
