;Function: 5 rows x 3 columns,
;          1st row, 1st column:  r1i1p1 Multi-Model-Mean (MMM) for CMIP5 AMIP experiments of precipitation over Amazon
;          1st row, 2nd column:  GPCP data
;          1st row, 3rd column:  r1i1p1 MMM minus GPCP
;          2nd row, follow the 1st row convention, but for DJF only;
;          3rd row, follow the 1st row convention, but for MAM only;
;          4th row, follow the 1st row convention, but for JJA only;
;          5th row, follow the 1st row convention, but for SON only.
;Date: 20180514

;Note: WADAselection

begin

pr_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/pr/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M", "IPSL-CM5A-LR",\
               "CMCC-CM",      "MPI-ESM-MR",     "ACCESS1-0", "CSIRO-Mk3-6-0", "IPSL-CM5A-MR", "IPSL-CM5B-LR",\
              "MPI-ESM-LR",   "MRI-AGCM3-2H",     "inmcm4",     "MIROC-ESM",    "MRI-CGCM3",    "MIROC5" ,\
              "HadGEM2-A" ,  "GFDL-CM3", "GFDL-HIRAM-C360", "GFDL-HIRAM-C180" /)


;precip_models = (/pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
;                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)


Andes_lon_test1 = (/280.0,283.0/)
Andes_lat_test1 = (/-10.0,1.0/)

Andes_lon_test2 = (/283.0,285.0/)
Andes_lat_test2 = (/1.0,4.0/)

Andes_lon_test3 = (/283.0,287.0/)
Andes_lat_test3 = (/4.0,8.0/)

Andes_lon_test4 = (/283.0,288.0/)
Andes_lat_test4 = (/-13.0,-10.0/)

Andes_lon_test5 = (/288.0,293.0/)
Andes_lat_test5 = (/-17.0,-13.0/)

Andes_lon_test6 = (/290.0,297.0/)
Andes_lat_test6 = (/-28.0,-17.0/)

Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)

Amazon_lon_test2 = (/295.0,304.0/)
Amazon_lat_test2 = (/4.0,6.0/)

Amazon_lon_test3 = (/295.0,299.0/)
Amazon_lat_test3 = (/6.0,9.0/)

Amazon_lon_test4 = (/309.0,312.0/)
Amazon_lat_test4 = (/-7.0,0.0/)

xpts_Andes_test1 = (/Andes_lon_test1(0),Andes_lon_test1(1),Andes_lon_test1(1),Andes_lon_test1(0),Andes_lon_test1(0)/)
ypts_Andes_test1 = (/Andes_lat_test1(0),Andes_lat_test1(0),Andes_lat_test1(1),Andes_lat_test1(1),Andes_lat_test1(0)/)
xpts_Andes_test2 = (/Andes_lon_test2(0),Andes_lon_test2(1),Andes_lon_test2(1),Andes_lon_test2(0),Andes_lon_test2(0)/)
ypts_Andes_test2 = (/Andes_lat_test2(0),Andes_lat_test2(0),Andes_lat_test2(1),Andes_lat_test2(1),Andes_lat_test2(0)/)
xpts_Andes_test3 = (/Andes_lon_test3(0),Andes_lon_test3(1),Andes_lon_test3(1),Andes_lon_test3(0),Andes_lon_test3(0)/)
ypts_Andes_test3 = (/Andes_lat_test3(0),Andes_lat_test3(0),Andes_lat_test3(1),Andes_lat_test3(1),Andes_lat_test3(0)/)
xpts_Andes_test4 = (/Andes_lon_test4(0),Andes_lon_test4(1),Andes_lon_test4(1),Andes_lon_test4(0),Andes_lon_test4(0)/)
ypts_Andes_test4 = (/Andes_lat_test4(0),Andes_lat_test4(0),Andes_lat_test4(1),Andes_lat_test4(1),Andes_lat_test4(0)/)
xpts_Andes_test5 = (/Andes_lon_test5(0),Andes_lon_test5(1),Andes_lon_test5(1),Andes_lon_test5(0),Andes_lon_test5(0)/)
ypts_Andes_test5 = (/Andes_lat_test5(0),Andes_lat_test5(0),Andes_lat_test5(1),Andes_lat_test5(1),Andes_lat_test5(0)/)
xpts_Andes_test6 = (/Andes_lon_test6(0),Andes_lon_test6(1),Andes_lon_test6(1),Andes_lon_test6(0),Andes_lon_test6(0)/)
ypts_Andes_test6 = (/Andes_lat_test6(0),Andes_lat_test6(0),Andes_lat_test6(1),Andes_lat_test6(1),Andes_lat_test6(0)/)
xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/)
xpts_Amazon_test2 = (/Amazon_lon_test2(0),Amazon_lon_test2(1),Amazon_lon_test2(1),Amazon_lon_test2(0),Amazon_lon_test2(0)/)
ypts_Amazon_test2 = (/Amazon_lat_test2(0),Amazon_lat_test2(0),Amazon_lat_test2(1),Amazon_lat_test2(1),Amazon_lat_test2(0)/)
xpts_Amazon_test3 = (/Amazon_lon_test3(0),Amazon_lon_test3(1),Amazon_lon_test3(1),Amazon_lon_test3(0),Amazon_lon_test3(0)/)
ypts_Amazon_test3 = (/Amazon_lat_test3(0),Amazon_lat_test3(0),Amazon_lat_test3(1),Amazon_lat_test3(1),Amazon_lat_test3(0)/)
xpts_Amazon_test4 = (/Amazon_lon_test4(0),Amazon_lon_test4(1),Amazon_lon_test4(1),Amazon_lon_test4(0),Amazon_lon_test4(0)/)
ypts_Amazon_test4 = (/Amazon_lat_test4(0),Amazon_lat_test4(0),Amazon_lat_test4(1),Amazon_lat_test4(1),Amazon_lat_test4(0)/)

;----------- plot precipitation multi-model-mean --------
;wks = gsn_open_wks("x11","Seasonality_Global_precip")
wks = gsn_open_wks("x11","Seasonality_SouthAmerica_precip")

wks_temp = gsn_open_wks("x11","Precip_MMM_GPCP")

gsn_reverse_colormap(wks)
gsn_reverse_colormap(wks_temp)

plot = new(15,graphic)

precip_clim_MMM_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/pr/Multi-Model-Mean_regrid_pr_clim_198201-200812.nc","r")
pr_MMM = precip_clim_MMM_file->pr_MMM
pr_mon_MMM = precip_clim_MMM_file->pr_mon_MMM

pr_MMM = pr_MMM * 86400.0
pr_MMM@units = "mm/day"

pr_mon_MMM = pr_mon_MMM * 86400.0
pr_mon_MMM@units = "mm/day"

printVarSummary(pr_mon_MMM)

res                             = True
res@gsnDraw = False
res@gsnFrame = False
res@mpFillOn                    = False        ; turn off gray fill
res@cnFillOn = True
res@cnInfoLabelOn = False
res@cnLinesOn = False

res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
res@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines

res@mpMaxLatF                   = 30          ; choose subregion           
res@mpMinLatF                   = -50
res@mpMaxLonF                   = 340
res@mpMinLonF                   = 260
;
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 1.0

res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_MMM"
res@tiMainString = "Precip clim, MMM, annual"
plot(0) = gsn_csm_contour_map(wks,pr_MMM,res)

;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 2.0                       ; thickness of lines

dum_Andes_pr_MMM1 = new(4,graphic)
dum_Andes_pr_MMM2 = new(4,graphic)
dum_Andes_pr_MMM3 = new(4,graphic)
dum_Andes_pr_MMM4 = new(4,graphic)
dum_Andes_pr_MMM5 = new(4,graphic)
dum_Andes_pr_MMM6 = new(4,graphic)

dum_Amazon_pr_MMM1 = new(4,graphic)
dum_Amazon_pr_MMM2 = new(4,graphic)
dum_Amazon_pr_MMM3 = new(4,graphic)
dum_Amazon_pr_MMM4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM1(i)=gsn_add_polyline(wks,plot(0),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM2(i)=gsn_add_polyline(wks,plot(0),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM3(i)=gsn_add_polyline(wks,plot(0),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM4(i)=gsn_add_polyline(wks,plot(0),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM5(i)=gsn_add_polyline(wks,plot(0),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM6(i)=gsn_add_polyline(wks,plot(0),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM1(i)=gsn_add_polyline(wks,plot(0),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM2(i)=gsn_add_polyline(wks,plot(0),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM3(i)=gsn_add_polyline(wks,plot(0),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM4(i)=gsn_add_polyline(wks,plot(0),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

draw(plot)
frame(wks)

exit

;=======================
;----------GPCP regridded already --------

GPCP_file  = (/"/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_198201-200812_clim.regrid.288x192.nc"/)
f_GPCP = addfile(GPCP_file,"r")
pr_clim_GPCP = f_GPCP->pr_clim_GPCP
printVarSummary(pr_clim_GPCP)
pr_mon_clim_GPCP = f_GPCP->pr_mon_clim_GPCP
printVarSummary(pr_mon_clim_GPCP)
 
res@gsnCenterString = ""
res@gsnLeftString = "pr_GPCP"
res@tiMainString = "Precip clim, GPCP, annual"

plot(1) = gsn_csm_contour_map(wks,pr_clim_GPCP,res)

dum_Andes_pr_GPCP1 = new(4,graphic)
dum_Andes_pr_GPCP2 = new(4,graphic)
dum_Andes_pr_GPCP3 = new(4,graphic)
dum_Andes_pr_GPCP4 = new(4,graphic)
dum_Andes_pr_GPCP5 = new(4,graphic)
dum_Andes_pr_GPCP6 = new(4,graphic)

dum_Amazon_pr_GPCP1 = new(4,graphic)
dum_Amazon_pr_GPCP2 = new(4,graphic)
dum_Amazon_pr_GPCP3 = new(4,graphic)
dum_Amazon_pr_GPCP4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_GPCP1(i)=gsn_add_polyline(wks,plot(1),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_GPCP2(i)=gsn_add_polyline(wks,plot(1),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_GPCP3(i)=gsn_add_polyline(wks,plot(1),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_GPCP4(i)=gsn_add_polyline(wks,plot(1),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_GPCP5(i)=gsn_add_polyline(wks,plot(1),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_GPCP6(i)=gsn_add_polyline(wks,plot(1),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_GPCP1(i)=gsn_add_polyline(wks,plot(1),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_GPCP2(i)=gsn_add_polyline(wks,plot(1),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_GPCP3(i)=gsn_add_polyline(wks,plot(1),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_GPCP4(i)=gsn_add_polyline(wks,plot(1),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;-------------- Add Multi-model-mean minus GPCP ----------------

diff_pr_MMM_GPCP = pr_MMM  ; meta data
diff_pr_MMM_GPCP = pr_MMM - pr_clim_GPCP
printVarSummary(diff_pr_MMM_GPCP)

;---------- plot this precipitation Multi-Model-Mean minus GPCP climatology ---

res@gsnCenterString = ""
res@gsnLeftString = "pr_MMM - GPCP"
res@tiMainString = "MMM minus GPCP, annual"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(2) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP,res)

;change resources for this temp plot
res@gsnDraw = True
res@gsnFrame = True
res@tiMainString = "MMM anom, annual mean, 198201-200812"
res@gsnLeftString = "r1i1p1_MMM - GPCP"
plot_temp = gsn_csm_contour_map(wks_temp,diff_pr_MMM_GPCP,res)

res@gsnDraw = False
res@gsnFrame = False


dum_Andes_pr_MMM_GPCP1 = new(4,graphic)
dum_Andes_pr_MMM_GPCP2 = new(4,graphic)
dum_Andes_pr_MMM_GPCP3 = new(4,graphic)
dum_Andes_pr_MMM_GPCP4 = new(4,graphic)
dum_Andes_pr_MMM_GPCP5 = new(4,graphic)
dum_Andes_pr_MMM_GPCP6 = new(4,graphic)

dum_Amazon_pr_MMM_GPCP1 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP2 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP3 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_GPCP1(i)=gsn_add_polyline(wks,plot(2),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP2(i)=gsn_add_polyline(wks,plot(2),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP3(i)=gsn_add_polyline(wks,plot(2),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP4(i)=gsn_add_polyline(wks,plot(2),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP5(i)=gsn_add_polyline(wks,plot(2),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP6(i)=gsn_add_polyline(wks,plot(2),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_GPCP1(i)=gsn_add_polyline(wks,plot(2),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP2(i)=gsn_add_polyline(wks,plot(2),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP3(i)=gsn_add_polyline(wks,plot(2),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP4(i)=gsn_add_polyline(wks,plot(2),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================= Multi Model Mean (MMM) precip DJF clim ========
MMM_DJF = pr_mon_MMM(0,:,:) ; metadata
MMM_DJF = (pr_mon_MMM(0,:,:) + pr_mon_MMM(1,:,:) + pr_mon_MMM(11,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_DJF)

res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 1.0

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_MMM_DJF"
res@tiMainString = "Precip clim, MMM, DJF"
plot(3) = gsn_csm_contour_map(wks,MMM_DJF,res)

dum_Andes_pr_MMM_DJF1 = new(4,graphic)
dum_Andes_pr_MMM_DJF2 = new(4,graphic)
dum_Andes_pr_MMM_DJF3 = new(4,graphic)
dum_Andes_pr_MMM_DJF4 = new(4,graphic)
dum_Andes_pr_MMM_DJF5 = new(4,graphic)
dum_Andes_pr_MMM_DJF6 = new(4,graphic)

dum_Amazon_pr_MMM_DJF1 = new(4,graphic)
dum_Amazon_pr_MMM_DJF2 = new(4,graphic)
dum_Amazon_pr_MMM_DJF3 = new(4,graphic)
dum_Amazon_pr_MMM_DJF4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_DJF1(i)=gsn_add_polyline(wks,plot(3),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_DJF2(i)=gsn_add_polyline(wks,plot(3),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_DJF3(i)=gsn_add_polyline(wks,plot(3),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_DJF4(i)=gsn_add_polyline(wks,plot(3),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_DJF5(i)=gsn_add_polyline(wks,plot(3),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_DJF6(i)=gsn_add_polyline(wks,plot(3),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_DJF1(i)=gsn_add_polyline(wks,plot(3),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_DJF2(i)=gsn_add_polyline(wks,plot(3),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_DJF3(i)=gsn_add_polyline(wks,plot(3),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_DJF4(i)=gsn_add_polyline(wks,plot(3),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;=============================  GPCP precip DJF clim ===========

GPCP_DJF = pr_mon_clim_GPCP(0,:,:) ; metadata
GPCP_DJF = (pr_mon_clim_GPCP(0,:,:) + pr_mon_MMM(1,:,:) + pr_mon_MMM(11,:,:)) / 3.0
printVarSummary(GPCP_DJF)

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_GPCP_DJF"
res@tiMainString = "Precip clim, GPCP, DJF"
plot(4) = gsn_csm_contour_map(wks,GPCP_DJF,res)

dum_Andes_pr_GPCP_DJF1 = new(4,graphic)
dum_Andes_pr_GPCP_DJF2 = new(4,graphic)
dum_Andes_pr_GPCP_DJF3 = new(4,graphic)
dum_Andes_pr_GPCP_DJF4 = new(4,graphic)
dum_Andes_pr_GPCP_DJF5 = new(4,graphic)
dum_Andes_pr_GPCP_DJF6 = new(4,graphic)

dum_Amazon_pr_GPCP_DJF1 = new(4,graphic)
dum_Amazon_pr_GPCP_DJF2 = new(4,graphic)
dum_Amazon_pr_GPCP_DJF3 = new(4,graphic)
dum_Amazon_pr_GPCP_DJF4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_GPCP_DJF1(i)=gsn_add_polyline(wks,plot(4),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_GPCP_DJF2(i)=gsn_add_polyline(wks,plot(4),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_GPCP_DJF3(i)=gsn_add_polyline(wks,plot(4),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_GPCP_DJF4(i)=gsn_add_polyline(wks,plot(4),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_GPCP_DJF5(i)=gsn_add_polyline(wks,plot(4),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_GPCP_DJF6(i)=gsn_add_polyline(wks,plot(4),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_GPCP_DJF1(i)=gsn_add_polyline(wks,plot(4),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_GPCP_DJF2(i)=gsn_add_polyline(wks,plot(4),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_GPCP_DJF3(i)=gsn_add_polyline(wks,plot(4),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_GPCP_DJF4(i)=gsn_add_polyline(wks,plot(4),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================== MMM DJF clim minus GPCP DJF clim 

diff_pr_MMM_GPCP_DJF = MMM_DJF  ; meta data
diff_pr_MMM_GPCP_DJF = MMM_DJF - GPCP_DJF
printVarSummary(diff_pr_MMM_GPCP_DJF)

;---------- plot this precipitation Multi-Model-Mean minus GPCP DJF climatology ---

res@gsnCenterString = ""
res@gsnLeftString = "MMM_DJF - GPCP_DJF"
res@tiMainString = "MMM minus GPCP, DJF"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(5) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_DJF,res)

dum_Andes_pr_MMM_GPCP_DJF1 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_DJF2 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_DJF3 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_DJF4 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_DJF5 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_DJF6 = new(4,graphic)

dum_Amazon_pr_MMM_GPCP_DJF1 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_DJF2 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_DJF3 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_DJF4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_GPCP_DJF1(i)=gsn_add_polyline(wks,plot(5),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_DJF2(i)=gsn_add_polyline(wks,plot(5),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_DJF3(i)=gsn_add_polyline(wks,plot(5),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_DJF4(i)=gsn_add_polyline(wks,plot(5),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_DJF5(i)=gsn_add_polyline(wks,plot(5),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_DJF6(i)=gsn_add_polyline(wks,plot(5),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_GPCP_DJF1(i)=gsn_add_polyline(wks,plot(5),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_DJF2(i)=gsn_add_polyline(wks,plot(5),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_DJF3(i)=gsn_add_polyline(wks,plot(5),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_DJF4(i)=gsn_add_polyline(wks,plot(5),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================= Multi Model Mean (MMM) precip MAM clim ========
MMM_MAM = pr_mon_MMM(2,:,:) ; metadata
MMM_MAM = (pr_mon_MMM(2,:,:) + pr_mon_MMM(3,:,:) + pr_mon_MMM(4,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_MAM)

res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 1.0

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_MMM_MAM"
res@tiMainString = "Precip clim, MMM, MAM"
plot(6) = gsn_csm_contour_map(wks,MMM_MAM,res)

dum_Andes_pr_MMM_MAM1 = new(4,graphic)
dum_Andes_pr_MMM_MAM2 = new(4,graphic)
dum_Andes_pr_MMM_MAM3 = new(4,graphic)
dum_Andes_pr_MMM_MAM4 = new(4,graphic)
dum_Andes_pr_MMM_MAM5 = new(4,graphic)
dum_Andes_pr_MMM_MAM6 = new(4,graphic)

dum_Amazon_pr_MMM_MAM1 = new(4,graphic)
dum_Amazon_pr_MMM_MAM2 = new(4,graphic)
dum_Amazon_pr_MMM_MAM3 = new(4,graphic)
dum_Amazon_pr_MMM_MAM4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_MAM1(i)=gsn_add_polyline(wks,plot(6),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_MAM2(i)=gsn_add_polyline(wks,plot(6),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_MAM3(i)=gsn_add_polyline(wks,plot(6),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_MAM4(i)=gsn_add_polyline(wks,plot(6),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_MAM5(i)=gsn_add_polyline(wks,plot(6),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_MAM6(i)=gsn_add_polyline(wks,plot(6),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_MAM1(i)=gsn_add_polyline(wks,plot(6),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_MAM2(i)=gsn_add_polyline(wks,plot(6),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_MAM3(i)=gsn_add_polyline(wks,plot(6),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_MAM4(i)=gsn_add_polyline(wks,plot(6),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;=============================  GPCP precip MAM clim ===========

GPCP_MAM = pr_mon_clim_GPCP(2,:,:) ; metadata
GPCP_MAM = (pr_mon_clim_GPCP(2,:,:) + pr_mon_MMM(3,:,:) + pr_mon_MMM(4,:,:)) / 3.0
printVarSummary(GPCP_MAM)

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_GPCP_MAM"
res@tiMainString = "Precip clim, GPCP, MAM"
plot(7) = gsn_csm_contour_map(wks,GPCP_MAM,res)

dum_Andes_pr_GPCP_MAM1 = new(4,graphic)
dum_Andes_pr_GPCP_MAM2 = new(4,graphic)
dum_Andes_pr_GPCP_MAM3 = new(4,graphic)
dum_Andes_pr_GPCP_MAM4 = new(4,graphic)
dum_Andes_pr_GPCP_MAM5 = new(4,graphic)
dum_Andes_pr_GPCP_MAM6 = new(4,graphic)

dum_Amazon_pr_GPCP_MAM1 = new(4,graphic)
dum_Amazon_pr_GPCP_MAM2 = new(4,graphic)
dum_Amazon_pr_GPCP_MAM3 = new(4,graphic)
dum_Amazon_pr_GPCP_MAM4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_GPCP_MAM1(i)=gsn_add_polyline(wks,plot(7),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_GPCP_MAM2(i)=gsn_add_polyline(wks,plot(7),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_GPCP_MAM3(i)=gsn_add_polyline(wks,plot(7),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_GPCP_MAM4(i)=gsn_add_polyline(wks,plot(7),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_GPCP_MAM5(i)=gsn_add_polyline(wks,plot(7),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_GPCP_MAM6(i)=gsn_add_polyline(wks,plot(7),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_GPCP_MAM1(i)=gsn_add_polyline(wks,plot(7),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_GPCP_MAM2(i)=gsn_add_polyline(wks,plot(7),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_GPCP_MAM3(i)=gsn_add_polyline(wks,plot(7),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_GPCP_MAM4(i)=gsn_add_polyline(wks,plot(7),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================== MMM MAM clim minus GPCP MAM clim 

diff_pr_MMM_GPCP_MAM = MMM_MAM  ; meta data
diff_pr_MMM_GPCP_MAM = MMM_MAM - GPCP_MAM
printVarSummary(diff_pr_MMM_GPCP_MAM)

;---------- plot this precipitation Multi-Model-Mean minus GPCP MAM climatology ---

res@gsnCenterString = ""
res@gsnLeftString = "MMM_MAM - GPCP_MAM"
res@tiMainString = "MMM minus GPCP, MAM"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(8) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_MAM,res)

dum_Andes_pr_MMM_GPCP_MAM1 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_MAM2 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_MAM3 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_MAM4 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_MAM5 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_MAM6 = new(4,graphic)

dum_Amazon_pr_MMM_GPCP_MAM1 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_MAM2 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_MAM3 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_MAM4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_GPCP_MAM1(i)=gsn_add_polyline(wks,plot(8),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_MAM2(i)=gsn_add_polyline(wks,plot(8),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_MAM3(i)=gsn_add_polyline(wks,plot(8),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_MAM4(i)=gsn_add_polyline(wks,plot(8),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_MAM5(i)=gsn_add_polyline(wks,plot(8),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_MAM6(i)=gsn_add_polyline(wks,plot(8),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_GPCP_MAM1(i)=gsn_add_polyline(wks,plot(8),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_MAM2(i)=gsn_add_polyline(wks,plot(8),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_MAM3(i)=gsn_add_polyline(wks,plot(8),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_MAM4(i)=gsn_add_polyline(wks,plot(8),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================= Multi Model Mean (MMM) precip JJA clim ========
MMM_JJA = pr_mon_MMM(5,:,:) ; metadata
MMM_JJA = (pr_mon_MMM(5,:,:) + pr_mon_MMM(6,:,:) + pr_mon_MMM(7,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_JJA)

res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 1.0

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_MMM_JJA"
res@tiMainString = "Precip clim, MMM, JJA"
plot(9) = gsn_csm_contour_map(wks,MMM_JJA,res)

dum_Andes_pr_MMM_JJA1 = new(4,graphic)
dum_Andes_pr_MMM_JJA2 = new(4,graphic)
dum_Andes_pr_MMM_JJA3 = new(4,graphic)
dum_Andes_pr_MMM_JJA4 = new(4,graphic)
dum_Andes_pr_MMM_JJA5 = new(4,graphic)
dum_Andes_pr_MMM_JJA6 = new(4,graphic)

dum_Amazon_pr_MMM_JJA1 = new(4,graphic)
dum_Amazon_pr_MMM_JJA2 = new(4,graphic)
dum_Amazon_pr_MMM_JJA3 = new(4,graphic)
dum_Amazon_pr_MMM_JJA4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_JJA1(i)=gsn_add_polyline(wks,plot(9),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_JJA2(i)=gsn_add_polyline(wks,plot(9),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_JJA3(i)=gsn_add_polyline(wks,plot(9),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_JJA4(i)=gsn_add_polyline(wks,plot(9),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_JJA5(i)=gsn_add_polyline(wks,plot(9),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_JJA6(i)=gsn_add_polyline(wks,plot(9),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_JJA1(i)=gsn_add_polyline(wks,plot(9),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_JJA2(i)=gsn_add_polyline(wks,plot(9),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_JJA3(i)=gsn_add_polyline(wks,plot(9),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_JJA4(i)=gsn_add_polyline(wks,plot(9),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;=============================  GPCP precip JJA clim ===========

GPCP_JJA = pr_mon_clim_GPCP(5,:,:) ; metadata
GPCP_JJA = (pr_mon_clim_GPCP(5,:,:) + pr_mon_MMM(6,:,:) + pr_mon_MMM(7,:,:)) / 3.0
printVarSummary(GPCP_JJA)

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_GPCP_JJA"
res@tiMainString = "Precip clim, GPCP, JJA"
plot(10) = gsn_csm_contour_map(wks,GPCP_JJA,res)

dum_Andes_pr_GPCP_JJA1 = new(4,graphic)
dum_Andes_pr_GPCP_JJA2 = new(4,graphic)
dum_Andes_pr_GPCP_JJA3 = new(4,graphic)
dum_Andes_pr_GPCP_JJA4 = new(4,graphic)
dum_Andes_pr_GPCP_JJA5 = new(4,graphic)
dum_Andes_pr_GPCP_JJA6 = new(4,graphic)

dum_Amazon_pr_GPCP_JJA1 = new(4,graphic)
dum_Amazon_pr_GPCP_JJA2 = new(4,graphic)
dum_Amazon_pr_GPCP_JJA3 = new(4,graphic)
dum_Amazon_pr_GPCP_JJA4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_GPCP_JJA1(i)=gsn_add_polyline(wks,plot(10),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_GPCP_JJA2(i)=gsn_add_polyline(wks,plot(10),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_GPCP_JJA3(i)=gsn_add_polyline(wks,plot(10),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_GPCP_JJA4(i)=gsn_add_polyline(wks,plot(10),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_GPCP_JJA5(i)=gsn_add_polyline(wks,plot(10),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_GPCP_JJA6(i)=gsn_add_polyline(wks,plot(10),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_GPCP_JJA1(i)=gsn_add_polyline(wks,plot(10),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_GPCP_JJA2(i)=gsn_add_polyline(wks,plot(10),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_GPCP_JJA3(i)=gsn_add_polyline(wks,plot(10),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_GPCP_JJA4(i)=gsn_add_polyline(wks,plot(10),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================== MMM JJA clim minus GPCP JJA clim 

diff_pr_MMM_GPCP_JJA = MMM_JJA  ; meta data
diff_pr_MMM_GPCP_JJA = MMM_JJA - GPCP_JJA
printVarSummary(diff_pr_MMM_GPCP_JJA)

;---------- plot this precipitation Multi-Model-Mean minus GPCP JJA climatology ---

res@gsnCenterString = ""
res@gsnLeftString = "MMM_JJA - GPCP_JJA"
res@tiMainString = "MMM minus GPCP, JJA"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(11) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_JJA,res)

dum_Andes_pr_MMM_GPCP_JJA1 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_JJA2 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_JJA3 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_JJA4 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_JJA5 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_JJA6 = new(4,graphic)

dum_Amazon_pr_MMM_GPCP_JJA1 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_JJA2 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_JJA3 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_JJA4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_GPCP_JJA1(i)=gsn_add_polyline(wks,plot(11),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_JJA2(i)=gsn_add_polyline(wks,plot(11),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_JJA3(i)=gsn_add_polyline(wks,plot(11),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_JJA4(i)=gsn_add_polyline(wks,plot(11),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_JJA5(i)=gsn_add_polyline(wks,plot(11),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_JJA6(i)=gsn_add_polyline(wks,plot(11),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_GPCP_JJA1(i)=gsn_add_polyline(wks,plot(11),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_JJA2(i)=gsn_add_polyline(wks,plot(11),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_JJA3(i)=gsn_add_polyline(wks,plot(11),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_JJA4(i)=gsn_add_polyline(wks,plot(11),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================= Multi Model Mean (MMM) precip SON clim ========
MMM_SON = pr_mon_MMM(8,:,:) ; metadata
MMM_SON = (pr_mon_MMM(8,:,:) + pr_mon_MMM(9,:,:) + pr_mon_MMM(10,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_SON)

res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 1.0

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_MMM_SON"
res@tiMainString = "Precip clim, MMM, SON"
plot(12) = gsn_csm_contour_map(wks,MMM_SON,res)

dum_Andes_pr_MMM_SON1 = new(4,graphic)
dum_Andes_pr_MMM_SON2 = new(4,graphic)
dum_Andes_pr_MMM_SON3 = new(4,graphic)
dum_Andes_pr_MMM_SON4 = new(4,graphic)
dum_Andes_pr_MMM_SON5 = new(4,graphic)
dum_Andes_pr_MMM_SON6 = new(4,graphic)

dum_Amazon_pr_MMM_SON1 = new(4,graphic)
dum_Amazon_pr_MMM_SON2 = new(4,graphic)
dum_Amazon_pr_MMM_SON3 = new(4,graphic)
dum_Amazon_pr_MMM_SON4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_SON1(i)=gsn_add_polyline(wks,plot(12),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_SON2(i)=gsn_add_polyline(wks,plot(12),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_SON3(i)=gsn_add_polyline(wks,plot(12),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_SON4(i)=gsn_add_polyline(wks,plot(12),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_SON5(i)=gsn_add_polyline(wks,plot(12),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_SON6(i)=gsn_add_polyline(wks,plot(12),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_SON1(i)=gsn_add_polyline(wks,plot(12),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_SON2(i)=gsn_add_polyline(wks,plot(12),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_SON3(i)=gsn_add_polyline(wks,plot(12),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_SON4(i)=gsn_add_polyline(wks,plot(12),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;=============================  GPCP precip SON clim ===========

GPCP_SON = pr_mon_clim_GPCP(8,:,:) ; metadata
GPCP_SON = (pr_mon_clim_GPCP(8,:,:) + pr_mon_MMM(9,:,:) + pr_mon_MMM(10,:,:)) / 3.0
printVarSummary(GPCP_SON)

res@gsnCenterString = ""
res@gsnLeftString = "pr_regrid_GPCP_SON"
res@tiMainString = "Precip clim, GPCP, SON"
plot(13) = gsn_csm_contour_map(wks,GPCP_SON,res)

dum_Andes_pr_GPCP_SON1 = new(4,graphic)
dum_Andes_pr_GPCP_SON2 = new(4,graphic)
dum_Andes_pr_GPCP_SON3 = new(4,graphic)
dum_Andes_pr_GPCP_SON4 = new(4,graphic)
dum_Andes_pr_GPCP_SON5 = new(4,graphic)
dum_Andes_pr_GPCP_SON6 = new(4,graphic)

dum_Amazon_pr_GPCP_SON1 = new(4,graphic)
dum_Amazon_pr_GPCP_SON2 = new(4,graphic)
dum_Amazon_pr_GPCP_SON3 = new(4,graphic)
dum_Amazon_pr_GPCP_SON4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_GPCP_SON1(i)=gsn_add_polyline(wks,plot(13),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_GPCP_SON2(i)=gsn_add_polyline(wks,plot(13),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_GPCP_SON3(i)=gsn_add_polyline(wks,plot(13),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_GPCP_SON4(i)=gsn_add_polyline(wks,plot(13),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_GPCP_SON5(i)=gsn_add_polyline(wks,plot(13),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_GPCP_SON6(i)=gsn_add_polyline(wks,plot(13),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_GPCP_SON1(i)=gsn_add_polyline(wks,plot(13),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_GPCP_SON2(i)=gsn_add_polyline(wks,plot(13),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_GPCP_SON3(i)=gsn_add_polyline(wks,plot(13),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_GPCP_SON4(i)=gsn_add_polyline(wks,plot(13),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============================== MMM SON clim minus GPCP SON clim 

diff_pr_MMM_GPCP_SON = MMM_SON  ; meta data
diff_pr_MMM_GPCP_SON = MMM_SON - GPCP_SON
printVarSummary(diff_pr_MMM_GPCP_SON)

;---------- plot this precipitation Multi-Model-Mean minus GPCP JJA climatology ---

res@gsnCenterString = ""
res@gsnLeftString = "MMM_SON - GPCP_SON"
res@tiMainString = "MMM minus GPCP, SON"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(14) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_SON,res)

dum_Andes_pr_MMM_GPCP_SON1 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_SON2 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_SON3 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_SON4 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_SON5 = new(4,graphic)
dum_Andes_pr_MMM_GPCP_SON6 = new(4,graphic)

dum_Amazon_pr_MMM_GPCP_SON1 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_SON2 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_SON3 = new(4,graphic)
dum_Amazon_pr_MMM_GPCP_SON4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_GPCP_SON1(i)=gsn_add_polyline(wks,plot(14),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_SON2(i)=gsn_add_polyline(wks,plot(14),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_SON3(i)=gsn_add_polyline(wks,plot(14),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_SON4(i)=gsn_add_polyline(wks,plot(14),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_SON5(i)=gsn_add_polyline(wks,plot(14),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_pr_MMM_GPCP_SON6(i)=gsn_add_polyline(wks,plot(14),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_pr_MMM_GPCP_SON1(i)=gsn_add_polyline(wks,plot(14),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_SON2(i)=gsn_add_polyline(wks,plot(14),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_SON3(i)=gsn_add_polyline(wks,plot(14),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_pr_MMM_GPCP_SON4(i)=gsn_add_polyline(wks,plot(14),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

;============= Panel plot =========
resP = True
resP@txString = "r1i1p1 MMM vs GPCP, annual vs seasonal, 198201-200812"
resP@lbLabelFontHeightF = 0.007

gsn_panel(wks,plot,(/5,3/),resP)













end           
