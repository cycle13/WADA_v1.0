;Function: 1. Illustrate the area of the Andes and the Amazon where the areal average will be computed;
;          2. Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [NGMS(Amazon) - NGMS(Andes)]
;Note: From Mike, NGMS calculation over the Amazon may not be reliable, use Y-axis NGMS(Amazon)
;Date: 20180219
;Note: Modified 20180222
;Note: Modified 20180305 to include map-form raw precip for every single model with boxes overlain, and raw - multi-model-mean; do the same thing for NGMS.
;Note: Modified 20180313 so that a non-rectangle around the Andes.

begin

;=========================
pr_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/pr/"
NGMS_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/Post-processing/NGMS/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M",\
                "IPSL-CM5A-LR",   "HadGEM2-A",    "CMCC-CM",      "MPI-ESM-MR", "ACCESS1-0",\
                "CSIRO-Mk3-6-0",  "IPSL-CM5A-MR","IPSL-CM5B-LR", "MPI-ESM-LR", "MRI-AGCM3-2H",\
                "inmcm4",         "MIROC-ESM",    "MRI-CGCM3",    "MIROC5",    "GFDL-CM3",\
                "GFDL-HIRAM-C360","GFDL-HIRAM-C180"/)

precip_diff_x = new(dimsizes(WADA_labels),double)
NGMS_y = new(dimsizes(WADA_labels),double)

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

NGMS_models = (/NGMS_dir_name+"NGMS_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"/)

GPCP_file  = (/"/project/projectdirs/m2840/hongcheq/GPCP/GPCP_197901-200812_clim.nc"/)

;======== Raw precipitation and precipitation - Multi-model-mean ======
;======= with  two boxes for the Andes and the Amazon overlain for every single model
;=======  do the same thing for NGMS ===================

plot_map_overlain = new(dimsizes(WADA_labels),graphic)    ; for raw precip clim multi-panel map
plot_map_overlain2 = new(dimsizes(WADA_labels),graphic)   ; for precip model minus MMM multi-panel map
plot_map_overlain3 = new(dimsizes(WADA_labels),graphic)   ; for raw NGMS clim multi-panel map
plot_map_overlain4 = new(dimsizes(WADA_labels),graphic)   ; for NGMS model minus MMM multi-panel map

;----------------
Andes_lon1 = 280.0
Andes_lon2 = 297.0
Andes_lat1 = -29.0
Andes_lat2 = 10.0

Amazon_lon1 = 289.0
Amazon_lon2 = 310.0
Amazon_lat1 = -12.0
Amazon_lat2 = 5.0

wks  = gsn_open_wks("pdf","WADA_illustration_"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)           
res                             = True
res@gsnDraw = False
res@gsnFrame = False
res@mpFillOn                    = False        ; turn off gray fill
res@cnFillOn = True
res@lbLabelBarOn = False
res@cnInfoLabelOn = False
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 12.0
res@cnLevelSpacingF = 1.0

res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
res@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines

res@mpMaxLatF                   = 30          ; choose subregion           
res@mpMinLatF                   = -50
res@mpMaxLonF                   = 340
res@mpMinLonF                   = 260

 xpts_Andes = (/Andes_lon1,Andes_lon2,Andes_lon2,Andes_lon1,Andes_lon1/)
 ypts_Andes = (/Andes_lat1,Andes_lat1,Andes_lat2,Andes_lat2,Andes_lat1/)
 xpts_Amazon = (/Amazon_lon1,Amazon_lon2,Amazon_lon2,Amazon_lon1,Amazon_lon1/)
 ypts_Amazon = (/Amazon_lat1,Amazon_lat1,Amazon_lat2,Amazon_lat2,Amazon_lat1/)

dum_Andes = new(4*dimsizes(WADA_labels),graphic)  
dum_Amazon = new(4*dimsizes(WADA_labels),graphic)

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
  dum_Andes(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Andes(i:i+1),ypts_Andes(i:i+1),respoly)      
  dum_Amazon(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain(i_model),xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)      
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

;------------ plot precipitation multi-model-mean --------
wks_MMM_precip = gsn_open_wks("x11","WADA_precip_MMM_"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)
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

dum_Andes_pr_MMM = new(4,graphic)
dum_Amazon_pr_MMM = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Andes(i:i+1),ypts_Andes(i:i+1),respoly)      
  dum_Amazon_pr_MMM(i)=gsn_add_polyline(wks_MMM_precip,plot_precip_MMM,xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)      
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
wks_MMM_GPCP_precip = gsn_open_wks("x11","WADA_precip_MMM-GPCP"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)

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

;end do ; do i_points

dum_Andes_pr_MMM_GPCP = new(4,graphic)
dum_Amazon_pr_MMM_GPCP = new(4,graphic)

do i = 0 , 3
  dum_Andes_pr_MMM_GPCP(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Andes(i:i+1),ypts_Andes(i:i+1),respoly)      
  dum_Amazon_pr_MMM_GPCP(i)=gsn_add_polyline(wks_MMM_GPCP_precip,plot_precip_MMM_GPCP,xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)      
end do
;------------------
;-------- mask the Andes based on topography ( using surface pressure as a threhold e.g., ps is less than a threshold) ----




;------------------------
draw(plot_precip_MMM_GPCP)
frame(wks_MMM_GPCP_precip)
exit

;=========================================
;------------ plot precipitation single model minus multi-model-mean -------

wks_anom  = gsn_open_wks("pdf","WADA_single_model_Precip_minus_MMM_"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)           
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

dum_Andes2 = new(4*dimsizes(WADA_labels),graphic)  
dum_Amazon2 = new(4*dimsizes(WADA_labels),graphic)

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
  dum_Andes2(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Andes(i:i+1),ypts_Andes(i:i+1),respoly)      
  dum_Amazon2(i+i_model*4)=gsn_add_polyline(wks_anom,plot_map_overlain2(i_model),xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)      
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

;============================ Plot the Raw NGMS ==================================

wks_NGMS_clim  = gsn_open_wks("pdf","WADA_NGMS_clim_"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)           
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -2.0
res@cnMaxLevelValF = 2.0
res@cnLevelSpacingF = 0.2

dum_Andes_NGMS_clim = new(4*dimsizes(WADA_labels),graphic)  
dum_Amazon_NGMS_clim = new(4*dimsizes(WADA_labels),graphic)

do i_model = 0,dimsizes(WADA_labels) -1

NGMS_clim_file = addfile(NGMS_models(i_model),"r")
NGMS_clim = NGMS_clim_file->NGMS

res@gsnLeftString = "NGMS_clim"
res@gsnCenterString = WADA_labels(i_model)

plot_map_overlain3(i_model) = gsn_csm_contour_map(wks_NGMS_clim,NGMS_clim,res)                 ; draw map
;----------- Add polygons ---------
do i = 0 , 3
  dum_Andes_NGMS_clim(i+i_model*4)=gsn_add_polyline(wks_NGMS_clim,plot_map_overlain3(i_model),xpts_Andes(i:i+1),ypts_Andes(i:i+1),respoly)      
  dum_Amazon_NGMS_clim(i+i_model*4)=gsn_add_polyline(wks_NGMS_clim,plot_map_overlain3(i_model),xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)      
end do 

delete(NGMS_clim)

end do ; do i_model

;-----------------
resP = True           ; modify the panel plot
resP@gsnPanelMainString = "CMIP5 models, AMIP 197901-200812, NGMS clim"
                                                 ; use this for NCL V6.3.0 and earlier
; resP@txString           = "A plot with a common label bar"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks_NGMS_clim,plot_map_overlain3,(/4,6/), resP)               ; now draw as one plot

;=========================== Plot the Multi-model-mean for NGMS  ==================
wks_MMM_NGMS = gsn_open_wks("pdf","WADA_NGMS_MMM_"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)
NGMS_clim_MMM_file = addfile("/project/projectdirs/m2840/hongcheq/CMIP5/Post-processing/NGMS/Multi-Model-Mean_regrid_NGMS_clim_197901-200812.nc","r")
NGMS_MMM = NGMS_clim_MMM_file->NGMS_MMM

res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "NGMS_regrid_MMM"
res@tiMainString = "Multi-Model-Mean"
plot_NGMS_MMM = gsn_csm_contour_map(wks_MMM_NGMS,NGMS_MMM,res)

dum_Andes_NGMS_MMM = new(4,graphic)
dum_Amazon_NGMS_MMM = new(4,graphic)

do i = 0 , 3
  dum_Andes_NGMS_MMM(i)=gsn_add_polyline(wks_MMM_NGMS,plot_NGMS_MMM,xpts_Andes(i:i+1),ypts_Andes(i:i+1),respoly)      
  dum_Amazon_NGMS_MMM(i)=gsn_add_polyline(wks_MMM_NGMS,plot_NGMS_MMM,xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)      
end do 

draw(plot_NGMS_MMM)
frame(wks_MMM_NGMS)

;------------ plot NGMS single model minus multi-model-mean -------

wks_anom_NGMS  = gsn_open_wks("pdf","WADA_single_model_NGMS_minus_MMM_"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)           
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.5
res@cnMaxLevelValF = 0.5
res@cnLevelSpacingF = 0.1

dum_Andes3 = new(4*dimsizes(WADA_labels),graphic)  
dum_Amazon3 = new(4*dimsizes(WADA_labels),graphic)

do i_model = 0,dimsizes(WADA_labels) -1

NGMS_anom_file = addfile(NGMS_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_NGMS_clim_197901-200812.nc","r")
NGMS_anom = NGMS_anom_file->NGMS_clim_minus_MMM

res@gsnCenterString = WADA_labels(i_model)
res@gsnLeftString = "NGMS_anom"
res@tiMainString = ""

plot_map_overlain4(i_model) = gsn_csm_contour_map(wks_anom_NGMS,NGMS_anom,res)                 ; draw map
;----------- Add polygons ---------

do i = 0 , 3
  dum_Andes3(i+i_model*4)=gsn_add_polyline(wks_anom_NGMS,plot_map_overlain4(i_model),xpts_Andes(i:i+1),ypts_Andes(i:i+1),respoly)      
  dum_Amazon3(i+i_model*4)=gsn_add_polyline(wks_anom_NGMS,plot_map_overlain4(i_model),xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)      
end do 

delete(NGMS_anom)

end do ; do i_model

;-----------------
resP = True           ; modify the panel plot
resP@gsnPanelMainString = "CMIP5 models, AMIP 197901-200812, NGMS - MMM"
                                                 ; use this for NCL V6.3.0 and earlier
; resP@txString           = "A plot with a common label bar"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks_anom_NGMS,plot_map_overlain4,(/4,6/), resP)               ; now draw as one plot

;================== Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [NGMS(Amazon) 
;====================== =====================
rad  = 4.*atan(1.)/180.    ;

;do imodel = 8,8
do imodel = 0,dimsizes(WADA_labels) - 1
;------------ Diff of precip ----------
pr_clim_file = addfile(precip_models(imodel),"r")
pr_clim_temp = pr_clim_file->pr_clim

coslat_Andes_pr = cos(pr_clim_file->lat({Andes_lat1:Andes_lat2})*rad) 
coslat_Amazon_pr = cos(pr_clim_file->lat({Amazon_lat1:Amazon_lat2})*rad) 

precip_diff_x(imodel) = wgt_areaave_Wrap(pr_clim_temp({Andes_lat1:Andes_lat2},{Andes_lon1:Andes_lon2}),coslat_Andes_pr,1.0,0) - wgt_areaave_Wrap(pr_clim_temp({Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}),coslat_Amazon_pr,1.0,0)

delete(pr_clim_temp)
delete(coslat_Andes_pr)
delete(coslat_Amazon_pr)
;-------------- Diff of NGMS -----------
;======= Mike: Be cautious about the NGMS calculation over topographical regions, only use NGMS over the Amazon in Y-axis

NGMS_clim_file = addfile(NGMS_models(imodel),"r")
NGMS_clim_temp = NGMS_clim_file->NGMS

coslat_Andes_NGMS = cos(NGMS_clim_file->lat({Andes_lat1:Andes_lat2})*rad) 
coslat_Amazon_NGMS = cos(NGMS_clim_file->lat({Amazon_lat1:Amazon_lat2})*rad) 

NGMS_y(imodel) = wgt_areaave_Wrap(NGMS_clim_temp({Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}),coslat_Amazon_NGMS,1.0,0) - wgt_areaave_Wrap(NGMS_clim_temp({Andes_lat1:Andes_lat2},{Andes_lon1:Andes_lon2}),coslat_Andes_NGMS,1.0,0)
;NGMS_y(imodel) = wgt_areaave_Wrap(NGMS_clim_temp({Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}),coslat_Amazon_NGMS,1.0,0) 

delete(NGMS_clim_temp)
delete(coslat_Andes_NGMS)
delete(coslat_Amazon_NGMS)

end do ; do imodel

precip_diff_x = precip_diff_x * 86400.0 ; from kg/m2/sec to mm/day
precip_diff_x@long_name = "precip(Andes) - precip(Amazon) for a multitude of models"
precip_diff_x@units = "mm/day"
;NGMS_y@long_name = "NGMS(Amazon) - NGMS(Andes) for a multitude of models"
NGMS_y@long_name = "NGMS(Amazon) for a multitude of models"
NGMS_y@units = "unitless"

print(precip_diff_x)
print(NGMS_y)

;========== Calculate the correlation coefficient ====
r = escorc(precip_diff_x,NGMS_y)
n_size = dimsizes(precip_diff_x)

t = r*sqrt((n_size-2)/(1-r^2))      
p = student_t(t, n_size-2)
psig = 0.05                       ; test significance level                     
print("r="+sprintf("%5.2f",r))
print("p="+sprintf("%5.2f",p))            ;

exit

;====================== Plot precip_diff_x VS NGMS_y ========
wks_CMIP   = gsn_open_wks ("pdf","WADA_CMIP5_"+Andes_lon1+Andes_lon2+Andes_lat1+Andes_lat2+Amazon_lon1+Amazon_lon2+Amazon_lat1+Amazon_lat2)          

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
res_CMIP@tiMainString      = "WADA associated with NGMS"          
res_CMIP@tiXAxisString = "pr(Andes) - pr(Amazon), mm/day"
;res_CMIP@tiYAxisString = "NGMS(Amazon) - NGMS(Andes), unitless"
res_CMIP@tiYAxisString = "NGMS(Amazon), unitless"
res_CMIP@xyMarkLineMode    = "Markers"                
res_CMIP@xyMarkers         =  markers(0:dimsizes(WADA_labels)-1)                   
res_CMIP@xyMonoMarkerColor  = False
res_CMIP@xyMarkerColors     = colors(0:dimsizes(WADA_labels)-1) 
res_CMIP@xyMarkerSizeF     = 0.02                    

res_CMIP@trXMinF = -9.0
res_CMIP@trXMaxF = 9.0
res_CMIP@trYMinF = -1.5
res_CMIP@trYMaxF = 1.5

plot_CMIP  = gsn_csm_xy(wks_CMIP,transpose((/precip_diff_x,precip_diff_x/)),transpose((/NGMS_y,NGMS_y/)),res_CMIP)              

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
