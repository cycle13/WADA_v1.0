;Function: 1. Illustrate the area of the Andes and the Amazon where the areal average will be computed;
;          2. Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [hfss(Amazon) - hfss(Andes)]
;Note: From Mike, NGMS calculation over the Amazon may not be reliable, use Y-axis NGMS(Amazon)
;Date: 20180219
;Note: Modified 20180222
;Note: Modified 20180305 to include map-form raw precip for every single model with boxes overlain, and raw - multi-model-mean; do the same thing for NGMS.
;Note: Modified 20180313 so that a non-rectangle around the Andes.
;Note: modified 20180315, replace Y-axis NGMS with hfss

begin

;=========================
pr_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/pr/"
hfss_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/hfss/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M",\
                "IPSL-CM5A-LR",   "HadGEM2-A",    "CMCC-CM",      "MPI-ESM-MR", "ACCESS1-0",\
                "CSIRO-Mk3-6-0",  "IPSL-CM5A-MR","IPSL-CM5B-LR", "MPI-ESM-LR", "MRI-AGCM3-2H",\
                "inmcm4",         "MIROC-ESM",    "MRI-CGCM3",    "MIROC5",    "GFDL-CM3",\
                "GFDL-HIRAM-C360","GFDL-HIRAM-C180"/)

precip_diff_x = new(dimsizes(WADA_labels),double)
hfss_y = new(dimsizes(WADA_labels),double)

precip_models = (/pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"/)

hfss_models = (/hfss_dir_name+"hfss_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc",\
                hfss_dir_name+"hfss_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"/)

GPCP_file  = (/"/project/projectdirs/m2840/hongcheq/GPCP/GPCP_197901-200812_clim.nc"/)

;======== Raw precipitation and precipitation - Multi-model-mean ======
;======= with  two boxes for the Andes and the Amazon overlain for every single model
;=======  do the same thing for hfss ===================

plot_map_overlain = new(dimsizes(WADA_labels),graphic)    ; for raw precip clim multi-panel map
plot_map_overlain2 = new(dimsizes(WADA_labels),graphic)   ; for precip model minus MMM multi-panel map
plot_map_overlain3 = new(dimsizes(WADA_labels),graphic)   ; for raw hfss clim multi-panel map
plot_map_overlain4 = new(dimsizes(WADA_labels),graphic)   ; for hfss model minus MMM multi-panel map

;============

Andes_lon_test1 = (/280.0,283.0/)
Andes_lat_test1 = (/-10.0,1.0/)

Andes_lon_test2 = (/282.0,285.0/)
Andes_lat_test2 = (/1.0,4.0/)

Andes_lon_test3 = (/283.0,287.0/)
Andes_lat_test3 = (/4.0,8.0/)

Andes_lon_test4 = (/283.0,288.0/)
Andes_lat_test4 = (/-15.0,-10.0/)

Andes_lon_test5 = (/288.0,293.0/)
Andes_lat_test5 = (/-17.0,-13.0/)

Andes_lon_test6 = (/290.0,297.0/)
Andes_lat_test6 = (/-28.0,-17.0/)

Amazon_lon_test1 = (/288.0,310.0/)
Amazon_lat_test1 = (/-11.0,4.0/)

Amazon_lon_test2 = (/295.0,305.0/)
Amazon_lat_test2 = (/4.0,7.0/)

Amazon_lon_test3 = (/295.0,300.0/)
Amazon_lat_test3 = (/7.0,10.0/)

Amazon_lon_test4 = (/310.0,314.0/)
Amazon_lat_test4 = (/-5.0,0.0/)

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

;============

wks  = gsn_open_wks("x11","WADA_illustration_1")           
res                             = True
res@gsnDraw = False
res@gsnFrame = False
res@mpFillOn                    = False        ; turn off gray fill
res@cnFillOn = True
res@lbLabelBarOn = False
res@cnInfoLabelOn = False
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 10.0
res@cnLevelSpacingF = 1.0

res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
res@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines

res@mpMaxLatF                   = 30          ; choose subregion           
res@mpMinLatF                   = -50
res@mpMaxLonF                   = 340
res@mpMinLonF                   = 260

dum_Andes1 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes2 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes3 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes4 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes5 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes6 = new(4*dimsizes(WADA_labels),graphic)  

dum_Amazon1 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon2 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon3 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon4 = new(4*dimsizes(WADA_labels),graphic)

do i_model = 0,dimsizes(WADA_labels) -1

pr_clim_file = addfile(precip_models(i_model),"r")
pr_clim = pr_clim_file->pr_clim
pr_clim = pr_clim * 86400.0 ; 
pr_clim@units = "mm/day"

res@gsnCenterString = WADA_labels(i_model)

plot_map_overlain(i_model) = gsn_csm_contour_map(wks,pr_clim,res)                 ; draw map

;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 2.0                       ; thickness of lines

do i = 0 , 3
  dum_Andes1(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)      
  dum_Andes2(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)      
  dum_Andes3(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)      
  dum_Andes4(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)      
  dum_Andes5(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)      
  dum_Andes6(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)      

  dum_Amazon1(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon2(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon3(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon4(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      

end do 

delete(pr_clim)

end do ; do i_model

;-----------------
resP = True           ; modify the panel plot
resP@gsnPanelMainString = "CMIP5 models, AMIP 197901-200812, precip clim"
                                                 ; use this for NCL V6.3.0 and earlier
; resP@txString           = "A plot with a common label bar"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks,plot_map_overlain,(/4,6/), resP)               ; now draw as one plot

;----------- plot precipitation multi-model-mean --------
wks_MMM_precip = gsn_open_wks("x11","WADA_precip_MMM_2")
precip_clim_MMM_file = addfile("/project/projectdirs/m2840/hongcheq/CMIP5/pr/Multi-Model-Mean_regrid_pr_clim_197901-200812.nc","r")
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
res@tiMainString = "Multi-Model-Mean"
plot_precip_MMM = gsn_csm_contour_map(wks_MMM_precip,pr_MMM,res)

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
  dum_Andes_pr_MMM1(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)      
  dum_Andes_pr_MMM2(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)      
  dum_Andes_pr_MMM3(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)      
  dum_Andes_pr_MMM4(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)      
  dum_Andes_pr_MMM5(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)      
  dum_Andes_pr_MMM6(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)      

  dum_Amazon_pr_MMM1(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon_pr_MMM2(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon_pr_MMM3(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon_pr_MMM4(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      

end do 

draw(plot_precip_MMM)
frame(wks_MMM_precip)

;-------------- Add Multi-model-mean minus GPCP ----------------
;----------First step, interpolating GPCP to model grid --------
f_GPCP = addfile(GPCP_file,"r")
pr_clim_GPCP = f_GPCP->pr_clim_GPCP
printVarSummary(pr_clim_GPCP)

pr_clim_GPCP_regrid = linint2_Wrap(pr_clim_GPCP&lon,pr_clim_GPCP&lat,pr_clim_GPCP,True,pr_MMM&lon ,pr_MMM&lat , 0)
printVarSummary(pr_clim_GPCP_regrid)

;--------- Second step, plot the (MMM - GPCP) ----------
diff_pr_MMM_GPCP = pr_MMM  ; meta data
diff_pr_MMM_GPCP = pr_MMM - pr_clim_GPCP_regrid
printVarSummary(diff_pr_MMM_GPCP)

;---------- plot this precipitation Multi-Model-Mean minus GPCP climatology ---
wks_MMM_GPCP_precip = gsn_open_wks("x11","WADA_precip_MMM-GPCP3")

res = True
res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "pr_MMM - GPCP"
res@tiMainString = "Multi-Model-Mean minus GPCP, 197901--200812 clim"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot_precip_MMM_GPCP = gsn_csm_contour_map(wks_MMM_GPCP_precip,diff_pr_MMM_GPCP,res)

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
  dum_Andes_pr_MMM_GPCP1(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)      
  dum_Andes_pr_MMM_GPCP2(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)      
  dum_Andes_pr_MMM_GPCP3(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)      
  dum_Andes_pr_MMM_GPCP4(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)      
  dum_Andes_pr_MMM_GPCP5(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)      
  dum_Andes_pr_MMM_GPCP6(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)      

  dum_Amazon_pr_MMM_GPCP1(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon_pr_MMM_GPCP2(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon_pr_MMM_GPCP3(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon_pr_MMM_GPCP4(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      

end do

draw(plot_precip_MMM_GPCP)
frame(wks_MMM_GPCP_precip)

;------------ plot precipitation single model minus multi-model-mean -------

wks_anom  = gsn_open_wks("x11","WADA_single_model_Precip_minus_MMM4")

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

dum_Andes_pr_anom1 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_pr_anom2 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_pr_anom3 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_pr_anom4 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_pr_anom5 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_pr_anom6 = new(4*dimsizes(WADA_labels),graphic)  

dum_Amazon_pr_anom1 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_pr_anom2 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_pr_anom3 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_pr_anom4 = new(4*dimsizes(WADA_labels),graphic)

do i_model = 0,dimsizes(WADA_labels) -1

pr_anom_file = addfile(pr_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_pr_clim_197901-200812.nc","r")
pr_anom = pr_anom_file->pr_clim_minus_MMM
pr_anom = pr_anom * 86400.0 ; 
pr_anom@units = "mm/day"

res@gsnCenterString = WADA_labels(i_model)
res@gsnLeftString = "pr_anom"
res@tiMainString = ""

plot_map_overlain2(i_model) = gsn_csm_contour_map(wks_anom,pr_anom,res)                 ; draw map
;----------- Add polygons ---------

do i = 0 , 3
  dum_Andes_pr_anom1(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)    
  dum_Andes_pr_anom2(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)    
  dum_Andes_pr_anom3(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)    
  dum_Andes_pr_anom4(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)    
  dum_Andes_pr_anom5(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)    
  dum_Andes_pr_anom6(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)    
  
  dum_Amazon_pr_anom1(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon_pr_anom2(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon_pr_anom3(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon_pr_anom4(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      

end do 

delete(pr_anom)

end do ; do i_model

;-----------------
resP = True           ; modify the panel plot
resP@gsnPanelMainString = "CMIP5 models, AMIP 197901-200812, precip - MMM"
                                                 ; use this for NCL V6.3.0 and earlier
; resP@txString           = "A plot with a common label bar"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks_anom,plot_map_overlain2,(/4,6/), resP)               ; now draw as one plot

;============================ Plot the Raw hfss ==================================
wks_hfss_clim  = gsn_open_wks("x11","WADA_hfss_clim_5")

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 100.0
res@cnLevelSpacingF = 10.0

dum_Andes_hfss_clim1 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_hfss_clim2 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_hfss_clim3 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_hfss_clim4 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_hfss_clim5 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_hfss_clim6 = new(4*dimsizes(WADA_labels),graphic)  

dum_Amazon_hfss_clim1 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_hfss_clim2 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_hfss_clim3 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_hfss_clim4 = new(4*dimsizes(WADA_labels),graphic)

do i_model = 0,dimsizes(WADA_labels) -1

hfss_clim_file = addfile(hfss_models(i_model),"r")
hfss_clim = hfss_clim_file->hfss_clim

res@gsnLeftString = "hfss_clim"
res@gsnCenterString = WADA_labels(i_model)

plot_map_overlain3(i_model) = gsn_csm_contour_map(wks_hfss_clim,hfss_clim,res)                 ; draw map
;----------- Add polygons ---------
do i = 0 , 3
  dum_Andes_hfss_clim1(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)      
  dum_Andes_hfss_clim2(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)      
  dum_Andes_hfss_clim3(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)      
  dum_Andes_hfss_clim4(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)      
  dum_Andes_hfss_clim5(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)      
  dum_Andes_hfss_clim6(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)      

  dum_Amazon_hfss_clim1(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon_hfss_clim2(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon_hfss_clim3(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon_hfss_clim4(i+i_model*4)=gsn_add_polyline(wks_hfss_clim,plot_map_overlain3(i_model),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      
end do 

delete(hfss_clim)

end do ; do i_model

;-----------------
resP = True           ; modify the panel plot
resP@gsnPanelMainString = "CMIP5 models, AMIP 197901-200812, hfss clim"
                                                 ; use this for NCL V6.3.0 and earlier
; resP@txString           = "A plot with a common label bar"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks_hfss_clim,plot_map_overlain3,(/4,6/), resP)               ; now draw as one plot

;=========================== Plot the Multi-model-mean for hfss  ==================

wks_MMM_hfss = gsn_open_wks("x11","WADA_hfss_MMM_6")

hfss_clim_MMM_file = addfile("/project/projectdirs/m2840/hongcheq/CMIP5/hfss/Multi-Model-Mean_regrid_hfss_clim_197901-200812.nc","r")
hfss_MMM = hfss_clim_MMM_file->hfss_MMM

res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "hfss_regrid_MMM"
res@tiMainString = "Multi-Model-Mean"
plot_hfss_MMM = gsn_csm_contour_map(wks_MMM_hfss,hfss_MMM,res)

dum_Andes_hfss_MMM1 = new(4,graphic)
dum_Andes_hfss_MMM2 = new(4,graphic)
dum_Andes_hfss_MMM3 = new(4,graphic)
dum_Andes_hfss_MMM4 = new(4,graphic)
dum_Andes_hfss_MMM5 = new(4,graphic)
dum_Andes_hfss_MMM6 = new(4,graphic)

dum_Amazon_hfss_MMM1 = new(4,graphic)
dum_Amazon_hfss_MMM2 = new(4,graphic)
dum_Amazon_hfss_MMM3 = new(4,graphic)
dum_Amazon_hfss_MMM4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_hfss_MMM1(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)      
  dum_Andes_hfss_MMM2(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)      
  dum_Andes_hfss_MMM3(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)      
  dum_Andes_hfss_MMM4(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)      
  dum_Andes_hfss_MMM5(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)      
  dum_Andes_hfss_MMM6(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)      

  dum_Amazon_hfss_MMM1(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon_hfss_MMM2(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon_hfss_MMM3(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon_hfss_MMM4(i)=gsn_add_polyline(wks_MMM_hfss,plot_hfss_MMM,xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      
end do 

draw(plot_hfss_MMM)
frame(wks_MMM_hfss)

;------------ plot hfss single model minus multi-model-mean -------

wks_anom_hfss  = gsn_open_wks("x11","WADA_single_model_hfss_minus_MMM_7")

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -50.0
res@cnMaxLevelValF = 50.0
res@cnLevelSpacingF = 5.0

dum_Andes3_1 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes3_2 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes3_3 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes3_4 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes3_5 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes3_6 = new(4*dimsizes(WADA_labels),graphic)  

dum_Amazon3_1 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon3_2 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon3_3 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon3_4 = new(4*dimsizes(WADA_labels),graphic)

do i_model = 0,dimsizes(WADA_labels) -1

hfss_anom_file = addfile(hfss_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_hfss_clim_197901-200812.nc","r")
hfss_anom = hfss_anom_file->hfss_clim_minus_MMM

res@gsnCenterString = WADA_labels(i_model)
res@gsnLeftString = "hfss_anom"
res@tiMainString = ""
res@gsnRightString = "W/m2"

plot_map_overlain4(i_model) = gsn_csm_contour_map(wks_anom_hfss,hfss_anom,res)                 ; draw map
;----------- Add polygons ---------

do i = 0 , 3
  dum_Andes3_1(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)      
  dum_Andes3_2(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)      
  dum_Andes3_3(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)      
  dum_Andes3_4(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)      
  dum_Andes3_5(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)      
  dum_Andes3_6(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)      
  
  dum_Amazon3_1(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon3_2(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon3_3(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon3_4(i+i_model*4)=gsn_add_polyline(wks_anom_hfss,plot_map_overlain4(i_model),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      
end do 

delete(hfss_anom)

end do ; do i_model

;-----------------
resP = True           ; modify the panel plot
resP@gsnPanelMainString = "CMIP5 models, AMIP 197901-200812, hfss - MMM"
                                                 ; use this for NCL V6.3.0 and earlier
; resP@txString           = "A plot with a common label bar"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks_anom_hfss,plot_map_overlain4,(/4,6/), resP)               ; now draw as one plot

;================== Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [hfss(Amazon)] 
;====================== =====================
rad  = 4.*atan(1.)/180.    ;

;do imodel = 8,8
do imodel = 0,dimsizes(WADA_labels) - 1
;------------ Diff of precip ----------
pr_clim_file = addfile(precip_models(imodel),"r")
pr_clim_temp = pr_clim_file->pr_clim

coslat_Andes_pr1 = cos(pr_clim_file->lat({Andes_lat_test1(0):Andes_lat_test1(1)})*rad) 
coslat_Andes_pr2 = cos(pr_clim_file->lat({Andes_lat_test2(0):Andes_lat_test2(1)})*rad) 
coslat_Andes_pr3 = cos(pr_clim_file->lat({Andes_lat_test3(0):Andes_lat_test3(1)})*rad) 
coslat_Andes_pr4 = cos(pr_clim_file->lat({Andes_lat_test4(0):Andes_lat_test4(1)})*rad) 
coslat_Andes_pr5 = cos(pr_clim_file->lat({Andes_lat_test5(0):Andes_lat_test5(1)})*rad) 
coslat_Andes_pr6 = cos(pr_clim_file->lat({Andes_lat_test6(0):Andes_lat_test6(1)})*rad) 

coslat_Amazon_pr1 = cos(pr_clim_file->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad) 
coslat_Amazon_pr2 = cos(pr_clim_file->lat({Amazon_lat_test2(0):Amazon_lat_test2(1)})*rad) 
coslat_Amazon_pr3 = cos(pr_clim_file->lat({Amazon_lat_test3(0):Amazon_lat_test3(1)})*rad) 
coslat_Amazon_pr4 = cos(pr_clim_file->lat({Amazon_lat_test4(0):Amazon_lat_test4(1)})*rad) 

Andes_ave1 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test1(0):Andes_lat_test1(1)},{Andes_lon_test1(0):Andes_lon_test1(1)}),coslat_Andes_pr1,1.0,0)
Andes_ave2 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test2(0):Andes_lat_test2(1)},{Andes_lon_test2(0):Andes_lon_test2(1)}),coslat_Andes_pr2,1.0,0)
Andes_ave3 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test3(0):Andes_lat_test3(1)},{Andes_lon_test3(0):Andes_lon_test3(1)}),coslat_Andes_pr3,1.0,0)
Andes_ave4 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test4(0):Andes_lat_test4(1)},{Andes_lon_test4(0):Andes_lon_test4(1)}),coslat_Andes_pr4,1.0,0)
Andes_ave5 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test5(0):Andes_lat_test5(1)},{Andes_lon_test5(0):Andes_lon_test5(1)}),coslat_Andes_pr5,1.0,0)
Andes_ave6 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test6(0):Andes_lat_test6(1)},{Andes_lon_test6(0):Andes_lon_test6(1)}),coslat_Andes_pr6,1.0,0)

Amazon_ave1 = wgt_areaave_Wrap(pr_clim_temp({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),coslat_Amazon_pr1,1.0,0)
Amazon_ave2 = wgt_areaave_Wrap(pr_clim_temp({Amazon_lat_test2(0):Amazon_lat_test2(1)},{Amazon_lon_test2(0):Amazon_lon_test2(1)}),coslat_Amazon_pr2,1.0,0)
Amazon_ave3 = wgt_areaave_Wrap(pr_clim_temp({Amazon_lat_test3(0):Amazon_lat_test3(1)},{Amazon_lon_test3(0):Amazon_lon_test3(1)}),coslat_Amazon_pr3,1.0,0)
Amazon_ave4 = wgt_areaave_Wrap(pr_clim_temp({Amazon_lat_test4(0):Amazon_lat_test4(1)},{Amazon_lon_test4(0):Amazon_lon_test4(1)}),coslat_Amazon_pr4,1.0,0)

;------- area weighted average across all the boxes over the Andes
rsph = 1.0   ; the result of area_poly_sphere then times radius squared can be in km2 

qorder     = gc_clkwise(ypts_Andes_test1(::-1), xpts_Andes_test1(::-1))   ; (lat,lon)

area1_Andes = area_poly_sphere(ypts_Andes_test1(::-1),xpts_Andes_test1(::-1),1.0)
area2_Andes = area_poly_sphere(ypts_Andes_test2(::-1),xpts_Andes_test2(::-1),1.0)
area3_Andes = area_poly_sphere(ypts_Andes_test3(::-1),xpts_Andes_test3(::-1),1.0) 
area4_Andes = area_poly_sphere(ypts_Andes_test4(::-1),xpts_Andes_test4(::-1),1.0)
area5_Andes = area_poly_sphere(ypts_Andes_test5(::-1),xpts_Andes_test5(::-1),1.0)
area6_Andes = area_poly_sphere(ypts_Andes_test6(::-1),xpts_Andes_test6(::-1),1.0)

;print(area1)
;print(area2)
;print(area3)
;print(area4)
;print(area5)
;print(area6)

Andes_ave = (Andes_ave1 * area1_Andes + Andes_ave2 * area2_Andes + Andes_ave3 * area3_Andes + Andes_ave4 * area4_Andes + Andes_ave5 * area5_Andes + Andes_ave6 * area6_Andes) / (area1_Andes+area2_Andes+area3_Andes+area4_Andes+area5_Andes+area6_Andes)

area1_Amazon = area_poly_sphere(ypts_Amazon_test1(::-1),xpts_Amazon_test1(::-1),1.0)
area2_Amazon = area_poly_sphere(ypts_Amazon_test2(::-1),xpts_Amazon_test2(::-1),1.0)
area3_Amazon = area_poly_sphere(ypts_Amazon_test3(::-1),xpts_Amazon_test3(::-1),1.0) 
area4_Amazon = area_poly_sphere(ypts_Amazon_test4(::-1),xpts_Amazon_test4(::-1),1.0)

Amazon_ave = (Amazon_ave1 * area1_Amazon + Amazon_ave2 * area2_Amazon + Amazon_ave3 * area3_Amazon + Amazon_ave4 * area4_Amazon ) / (area1_Amazon+area2_Amazon+area3_Amazon+area4_Amazon)

precip_diff_x(imodel) = Andes_ave - Amazon_ave

delete(pr_clim_temp)
delete(coslat_Andes_pr1)
delete(coslat_Andes_pr2)
delete(coslat_Andes_pr3)
delete(coslat_Andes_pr4)
delete(coslat_Andes_pr5)
delete(coslat_Andes_pr6)
delete(coslat_Amazon_pr1)
delete(coslat_Amazon_pr2)
delete(coslat_Amazon_pr3)
delete(coslat_Amazon_pr4)
;--------------  hfss averaged over Amazon -----------
;======= Mike: Be cautious about the hfss calculation over topographical regions, only use hfss over the Amazon in Y-axis

hfss_clim_file = addfile(hfss_models(imodel),"r")
hfss_clim_temp = hfss_clim_file->hfss_clim

coslat_Amazon_hfss1 = cos(hfss_clim_file->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad) 
coslat_Amazon_hfss2 = cos(hfss_clim_file->lat({Amazon_lat_test2(0):Amazon_lat_test2(1)})*rad) 
coslat_Amazon_hfss3 = cos(hfss_clim_file->lat({Amazon_lat_test3(0):Amazon_lat_test3(1)})*rad) 
coslat_Amazon_hfss4 = cos(hfss_clim_file->lat({Amazon_lat_test4(0):Amazon_lat_test4(1)})*rad) 

Amazon_ave_hfss1 = wgt_areaave_Wrap(hfss_clim_temp({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),coslat_Amazon_hfss1,1.0,0)
Amazon_ave_hfss2 = wgt_areaave_Wrap(hfss_clim_temp({Amazon_lat_test2(0):Amazon_lat_test2(1)},{Amazon_lon_test2(0):Amazon_lon_test2(1)}),coslat_Amazon_hfss2,1.0,0)
Amazon_ave_hfss3 = wgt_areaave_Wrap(hfss_clim_temp({Amazon_lat_test3(0):Amazon_lat_test3(1)},{Amazon_lon_test3(0):Amazon_lon_test3(1)}),coslat_Amazon_hfss3,1.0,0)
Amazon_ave_hfss4 = wgt_areaave_Wrap(hfss_clim_temp({Amazon_lat_test4(0):Amazon_lat_test4(1)},{Amazon_lon_test4(0):Amazon_lon_test4(1)}),coslat_Amazon_hfss4,1.0,0)

hfss_y(imodel) = (Amazon_ave_hfss1 * area1_Amazon + Amazon_ave_hfss2 * area2_Amazon + Amazon_ave_hfss3 * area3_Amazon + Amazon_ave_hfss4 * area4_Amazon ) / (area1_Amazon+area2_Amazon+area3_Amazon+area4_Amazon)

delete(hfss_clim_temp)
delete(coslat_Amazon_hfss1)
delete(coslat_Amazon_hfss2)
delete(coslat_Amazon_hfss3)
delete(coslat_Amazon_hfss4)

end do ; do imodel

precip_diff_x = precip_diff_x * 86400.0 ; from kg/m2/sec to mm/day
precip_diff_x@long_name = "precip(Andes) - precip(Amazon) for a multitude of models"
precip_diff_x@units = "mm/day"
hfss_y@long_name = "hfss(Amazon) for a multitude of models"
hfss_y@units = "W/m2"

print(precip_diff_x)
print(hfss_y)

;========== Calculate the correlation coefficient ====
r = escorc(precip_diff_x,hfss_y)
n_size = dimsizes(precip_diff_x)

t = r*sqrt((n_size-2)/(1-r^2))      
p = student_t(t, n_size-2)
psig = 0.05                       ; test significance level                     
print("r="+sprintf("%7.3e",r))
print("p="+sprintf("%7.3e",p))            ;

;====================== Plot precip_diff_x VS hfss_y ========
wks_CMIP   = gsn_open_wks ("x11","WADA_CMIP5_8")

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
res_CMIP@tiMainString      = "WADA associated with hfss"          
res_CMIP@tiXAxisString = "pr(Andes) - pr(Amazon), mm/day"
res_CMIP@tiYAxisString = "hfss(Amazon), W/m2"
res_CMIP@xyMarkLineMode    = "Markers"                
res_CMIP@xyMarkers         =  markers(0:dimsizes(WADA_labels)-1)                   
res_CMIP@xyMonoMarkerColor  = False
res_CMIP@xyMarkerColors     = colors(0:dimsizes(WADA_labels)-1) 
res_CMIP@xyMarkerSizeF     = 0.02                    

res_CMIP@gsnLeftString = "correlation="+sprintf("%7.3e",r)
res_CMIP@gsnRightString = "p="+sprintf("%7.3e",p)

res_CMIP@trXMinF = -6.0
res_CMIP@trXMaxF = 6.0
res_CMIP@trYMinF = 0.0
res_CMIP@trYMaxF = 120.0

plot_CMIP  = gsn_csm_xy(wks_CMIP,transpose((/precip_diff_x,precip_diff_x/)),transpose((/hfss_y,hfss_y/)),res_CMIP)              

;--------- Draw a marker label -----
  xpos_marker1    = (/0.22,0.22+0.12,0.22+0.12*2,0.22+0.12*3,0.22+0.12*4/)
  xpos_text1    = (/  0.23,0.23+0.12,0.23+0.12*2,0.23+0.12*3,0.23+0.12*4/)

  mkres               = True         ; Marker resources
  txres               = True         ; Text resources
  txres@txFontHeightF = 0.0085
  txres@txJust        = "CenterLeft"

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

draw(plot_CMIP)
frame(wks_CMIP)

end
