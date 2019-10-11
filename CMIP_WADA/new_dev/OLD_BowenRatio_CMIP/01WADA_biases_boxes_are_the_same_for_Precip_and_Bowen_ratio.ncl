;Function: 
;Part I:
;          1.Figure1: Precipitation 1982-2008 27-year (considering FLUXNET-MTE data temporal span) clim for every CMIP5 model over Andes-Amazon region, with boxes overlain;
;          2.Figure2: Precipitation regrid multi-model-mean which will be further compared against with GPCP data, with boxes overlain;
;          3.Figure3: Precipitation MMM minus GPCP 1982-2008 clim, with boxes overlain;
;          4.Figure4: Precipitation minus GPCP (not MMM) for every single model, with boxes overlain;
;Part II:
;          5-8: figure 5-8, similar to 1-4, but for Bowen ratio rather than precip, using FLUXNET-MTE sensible and latent heat to calculate Bowen ratio.
;Part III:
;          9.Figure9: Anomalous precipitation field (Andes - Amazon) VS Anomalous Bowen ratio (Amazon). Precip relative to GPCP, while BR ralative to FLUXNET-MTE
;
;Date: 20180329

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;========================= Part I ===========================
;============================================================
pr_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/pr/"
BR_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/BR_processing/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M", "IPSL-CM5A-LR",\
               "CMCC-CM",      "MPI-ESM-MR",     "ACCESS1-0", "CSIRO-Mk3-6-0", "IPSL-CM5A-MR", "IPSL-CM5B-LR",\
              "MPI-ESM-LR",   "MRI-AGCM3-2H",     "inmcm4",     "MIROC-ESM",    "MRI-CGCM3",    "MIROC5" ,\
              "HadGEM2-A" ,  "GFDL-CM3", "GFDL-HIRAM-C360", "GFDL-HIRAM-C180" /)

precip_diff_x = new(dimsizes(WADA_labels),double)
BR_y = new(dimsizes(WADA_labels),double)

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

GPCP_file  = (/"/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_198201-200812_clim.regrid.288x192.nc"/)

MTE_file  = (/"/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_198201-200812_clim.nc"/)

;======== Raw precipitation and precipitation minus GPCP ======

plot_map_overlain = new(dimsizes(WADA_labels),graphic)    ; for raw precip clim multi-panel map
plot_map_overlain2 = new(dimsizes(WADA_labels),graphic)   ; for precip model minus GPCP  map

plot_map_overlain_BR = new(dimsizes(WADA_labels),graphic)    ; for raw Bowen ratio multi-panel map
plot_map_overlain2_BR = new(dimsizes(WADA_labels),graphic)   ; for Bowen ratio model minus FLUXNET-MTE  map

;============

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

;============ Fig.1================

wks  = gsn_open_wks("png","WADA_precip_clim_1")           
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
;resP@gsnPanelMainString = "CMIP5 models, AMIP 198201-200812, precip clim"
                                                 ; use this for NCL V6.3.0 and earlier
resP@txString           = "Precip clim, 198201-200812"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks,plot_map_overlain,(/5,5/), resP)               ; now draw as one plot

;====================================  Fig. 2 ============================
;----------- plot precipitation multi-model-mean --------
wks_MMM_precip = gsn_open_wks("pdf","WADA_precip_MMM_2")
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
;----------GPCP regridded already --------
f_GPCP = addfile(GPCP_file,"r")
pr_clim_GPCP = f_GPCP->pr_clim_GPCP
printVarSummary(pr_clim_GPCP)

diff_pr_MMM_GPCP = pr_MMM  ; meta data
diff_pr_MMM_GPCP = pr_MMM - pr_clim_GPCP
printVarSummary(diff_pr_MMM_GPCP)

;============================ Fig. 3 =================================
;---------- plot this precipitation Multi-Model-Mean minus GPCP climatology ---
wks_MMM_GPCP_precip = gsn_open_wks("pdf","WADA_precip_MMM-GPCP3")

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

;============================= Fig. 4 =============================
;------------ plot precipitation single model minus GPCP -------
;----------- modify this to minus GPCP -------

wks_anom  = gsn_open_wks("pdf","WADA_single_model_Precip_minus_GPCP4")

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

;=========================
do i_model = 0,dimsizes(WADA_labels) -1

pr_anom_file = addfile(pr_dir_name+WADA_labels(i_model)+"_minus_regridded_GPCP_pr_clim_198201-200812.nc","r")
pr_anom = pr_anom_file->pr_clim_minus_GPCP
pr_anom = pr_anom * 86400.0 ; 
pr_anom@units = "mm/day"

res@gsnCenterString = WADA_labels(i_model)
res@gsnLeftString = "pr_anom"
res@tiMainString = ""
res@lbLabelBarOn = False

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

delete(res@gsnLeftString)

;-----------------
resP = True           ; modify the panel plot
;resP@gsnPanelMainString = "CMIP5 models, AMIP 198212-200812, precip - GPCP"
                                                 ; use this for NCL V6.3.0 and earlier
resP@txString           = "Precip anom comparing to GPCP, 198201-200812"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks_anom,plot_map_overlain2,(/5,5/), resP)               ; now draw as one plot

;=========================== Part II ========================
;============================ Fig. 5 =========================
;===========================  Bowen ratio panel plot ================

wks  = gsn_open_wks("pdf","WADA_BR_clim_5")           
res                             = True
res@gsnDraw = False
res@gsnFrame = False
res@mpFillOn                    = False        ; turn off gray fill
res@cnFillOn = True
res@lbLabelBarOn = False
res@cnInfoLabelOn = False
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.3

res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
res@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines

res@mpMaxLatF                   = 30          ; choose subregion           
res@mpMinLatF                   = -50
res@mpMaxLonF                   = 340
res@mpMinLonF                   = 260

dum_BR_Andes1 = new(4*dimsizes(WADA_labels),graphic)  
dum_BR_Andes2 = new(4*dimsizes(WADA_labels),graphic)  
dum_BR_Andes3 = new(4*dimsizes(WADA_labels),graphic)  
dum_BR_Andes4 = new(4*dimsizes(WADA_labels),graphic)  
dum_BR_Andes5 = new(4*dimsizes(WADA_labels),graphic)  
dum_BR_Andes6 = new(4*dimsizes(WADA_labels),graphic)  

dum_BR_Amazon1 = new(4*dimsizes(WADA_labels),graphic)
dum_BR_Amazon2 = new(4*dimsizes(WADA_labels),graphic)
dum_BR_Amazon3 = new(4*dimsizes(WADA_labels),graphic)
dum_BR_Amazon4 = new(4*dimsizes(WADA_labels),graphic)

a = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
lsdata = a->LSMASK

do i_model = 0,dimsizes(WADA_labels) -1

BR_clim_file = addfile(BR_models(i_model),"r")
BR_clim = BR_clim_file->BR_clim

;=========land only
lsm  = landsea_mask(lsdata,BR_clim&lat,BR_clim&lon)
BR_clim = mask(BR_clim,lsm.eq.0,False)

res@gsnCenterString = WADA_labels(i_model)
res@gsnLeftString = "BR_clim"

plot_map_overlain_BR(i_model) = gsn_csm_contour_map(wks,BR_clim,res)                 ; draw map

;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 2.0                       ; thickness of lines

do i = 0 , 3
  dum_BR_Andes1(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)      
  dum_BR_Andes2(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)      
  dum_BR_Andes3(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)      
  dum_BR_Andes4(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)      
  dum_BR_Andes5(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)      
  dum_BR_Andes6(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)      

  dum_BR_Amazon1(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_BR_Amazon2(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_BR_Amazon3(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_BR_Amazon4(i+i_model*4)=gsn_add_polyline(wks,plot_map_overlain_BR(i_model),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      

end do 

delete(BR_clim)
delete(lsm)
end do ; do i_model
delete(res@gsnLeftString)

;-----------------
resP = True           ; modify the panel plot
;resP@gsnPanelMainString = "CMIP5 models, AMIP 198201-200812, precip clim"
                                                 ; use this for NCL V6.3.0 and earlier
resP@txString           = "Bowen ratio clim, 198201-200812"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks,plot_map_overlain_BR,(/5,5/), resP)               ; now draw as one plot

;======================= Fig. 6===========================
;------------------------- Multi-Model-Mean of Bowen ratio -------------
wks_MMM_BR = gsn_open_wks("pdf","WADA_BR_MMM_6")
BR_clim_MMM_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/BR_processing/Multi-Model-Mean_regrid_BR_clim_198201-200812.nc","r")
BR_MMM = BR_clim_MMM_file->BR_MMM

;====== land only -----
lsm  = landsea_mask(lsdata,BR_MMM&lat,BR_MMM&lon)
BR_MMM = mask(BR_MMM,lsm.eq.0,False)
;----------------------

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.3

res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "BR_regrid_MMM"
res@tiMainString = "BR clim, 198201-200812, Multi-Model-Mean"
plot_BR_MMM = gsn_csm_contour_map(wks_MMM_BR,BR_MMM,res)

dum_Andes_BR_MMM1 = new(4,graphic)
dum_Andes_BR_MMM2 = new(4,graphic)
dum_Andes_BR_MMM3 = new(4,graphic)
dum_Andes_BR_MMM4 = new(4,graphic)
dum_Andes_BR_MMM5 = new(4,graphic)
dum_Andes_BR_MMM6 = new(4,graphic)

dum_Amazon_BR_MMM1 = new(4,graphic)
dum_Amazon_BR_MMM2 = new(4,graphic)
dum_Amazon_BR_MMM3 = new(4,graphic)
dum_Amazon_BR_MMM4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_BR_MMM1(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_BR_MMM2(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_BR_MMM3(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_BR_MMM4(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_BR_MMM5(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_BR_MMM6(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_BR_MMM1(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_BR_MMM2(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_BR_MMM3(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_BR_MMM4(i)=gsn_add_polyline(wks_MMM_BR,plot_BR_MMM,xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

draw(plot_BR_MMM)
frame(wks_MMM_BR)
delete(lsm)

;-------------- Add Multi-model-mean minus FLUXNET-MTE ----------------
;----------FLUXNET-MTE regridded already --------
f_MTE = addfile(MTE_file,"r")
BR_clim_MTE = f_MTE->MTE_BR_clim
printVarSummary(BR_clim_MTE)

diff_BR_MMM_MTE = BR_MMM  ; meta data
diff_BR_MMM_MTE = BR_MMM - BR_clim_MTE
printVarSummary(diff_BR_MMM_MTE)

;====== land only -----
lsm  = landsea_mask(lsdata,diff_BR_MMM_MTE&lat,diff_BR_MMM_MTE&lon)
diff_BR_MMM_MTE = mask(diff_BR_MMM_MTE,lsm.eq.0,False)

;============================== Fig. 7 ================================
;----------------------
;---------- plot this precipitation Bowen ratio, Multi-Model-Mean minus FLUXNET-MTE climatology ---
wks_MMM_MTE_BR = gsn_open_wks("pdf","WADA_BR_MMM-MTE7")

res = True
res@lbLabelBarOn = True
res@gsnCenterString = ""
res@gsnLeftString = "BR_MMM - FLUXNTE-MTE"
res@tiMainString = "MMM clim minus FLUXNET-MTE clim, 198201-200812"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -2.0
res@cnMaxLevelValF = 2.0
res@cnLevelSpacingF = 0.4

plot_BR_MMM_MTE = gsn_csm_contour_map(wks_MMM_MTE_BR,diff_BR_MMM_MTE,res)

dum_Andes_BR_MMM_MTE1 = new(4,graphic)
dum_Andes_BR_MMM_MTE2 = new(4,graphic)
dum_Andes_BR_MMM_MTE3 = new(4,graphic)
dum_Andes_BR_MMM_MTE4 = new(4,graphic)
dum_Andes_BR_MMM_MTE5 = new(4,graphic)
dum_Andes_BR_MMM_MTE6 = new(4,graphic)

dum_Amazon_BR_MMM_MTE1 = new(4,graphic)
dum_Amazon_BR_MMM_MTE2 = new(4,graphic)
dum_Amazon_BR_MMM_MTE3 = new(4,graphic)
dum_Amazon_BR_MMM_MTE4 = new(4,graphic)

do i = 0 , 3
  dum_Andes_BR_MMM_MTE1(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)
  dum_Andes_BR_MMM_MTE2(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)
  dum_Andes_BR_MMM_MTE3(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)
  dum_Andes_BR_MMM_MTE4(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)
  dum_Andes_BR_MMM_MTE5(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)
  dum_Andes_BR_MMM_MTE6(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)

  dum_Amazon_BR_MMM_MTE1(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
  dum_Amazon_BR_MMM_MTE2(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)
  dum_Amazon_BR_MMM_MTE3(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)
  dum_Amazon_BR_MMM_MTE4(i)=gsn_add_polyline(wks_MMM_MTE_BR,plot_BR_MMM_MTE,xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)

end do

draw(plot_BR_MMM_MTE)
frame(wks_MMM_MTE_BR)

;============================ Fig. 8 ===========================
;------------ plot Bowen ratio single model minus FLUXNET-MTE -------

wks_anom_BR  = gsn_open_wks("pdf","WADA_single_model_BR_minus_MTE8")

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -2.0
res@cnMaxLevelValF = 2.0
res@cnLevelSpacingF = 0.4

dum_Andes_BR_anom1 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_BR_anom2 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_BR_anom3 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_BR_anom4 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_BR_anom5 = new(4*dimsizes(WADA_labels),graphic)  
dum_Andes_BR_anom6 = new(4*dimsizes(WADA_labels),graphic)  

dum_Amazon_BR_anom1 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_BR_anom2 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_BR_anom3 = new(4*dimsizes(WADA_labels),graphic)
dum_Amazon_BR_anom4 = new(4*dimsizes(WADA_labels),graphic)

;=========================
do i_model = 0,dimsizes(WADA_labels) -1

BR_anom_file = addfile(BR_dir_name+WADA_labels(i_model)+"_minus_regridded_FLUXNET-MTE_BR_clim_198201-200812.nc","r")
BR_anom = BR_anom_file->BR_clim_minus_MTE

res@gsnCenterString = WADA_labels(i_model)
res@gsnLeftString = "BR_anom"
res@tiMainString = ""
res@lbLabelBarOn = False

plot_map_overlain2_BR(i_model) = gsn_csm_contour_map(wks_anom_BR,BR_anom,res)                 ; draw map
;----------- Add polygons ---------

do i = 0 , 3
  dum_Andes_BR_anom1(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),respoly)    
  dum_Andes_BR_anom2(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),respoly)    
  dum_Andes_BR_anom3(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),respoly)    
  dum_Andes_BR_anom4(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),respoly)    
  dum_Andes_BR_anom5(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),respoly)    
  dum_Andes_BR_anom6(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),respoly)    
  
  dum_Amazon_BR_anom1(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
  dum_Amazon_BR_anom2(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
  dum_Amazon_BR_anom3(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Amazon_test3(i:i+1),ypts_Amazon_test3(i:i+1),respoly)      
  dum_Amazon_BR_anom4(i+i_model*4)=gsn_add_polyline(wks_anom_BR,plot_map_overlain2_BR(i_model),xpts_Amazon_test4(i:i+1),ypts_Amazon_test4(i:i+1),respoly)      

end do 

delete(BR_anom)

end do ; do i_model

;-----------------
resP = True           ; modify the panel plot
;resP@gsnPanelMainString = "CMIP5 models, AMIP 198212-200812, precip - GPCP"
                                                 ; use this for NCL V6.3.0 and earlier
resP@txString           = "Bowen ratio anom comparing to FLUXNET-MTE, 198201-200812"
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.007               ; make labels smaller

gsn_panel(wks_anom_BR,plot_map_overlain2_BR,(/5,5/), resP)               ; now draw as one plot

;==========================================Part 3=========================================================================
;=================================== Fig. 9 ============================
;================== Magnitude of biases in [precip(Andes) - precip(Amazon)  VS Magnitude of biases of [Bowen ratio over the Amazon] 
;====================== =====================
rad  = 4.*atan(1.)/180.    ;

;do imodel = 8,8
do imodel = 0,dimsizes(WADA_labels) - 1
;------------ Diff of precip ----------
pr_anom_file = addfile(pr_dir_name+WADA_labels(imodel)+"_minus_regridded_GPCP_pr_clim_198201-200812.nc","r")
pr_anom_temp = pr_anom_file->pr_clim_minus_GPCP

;====== land only -----
lsm  = landsea_mask(lsdata,pr_anom_temp&lat,pr_anom_temp&lon)
pr_anom_temp = mask(pr_anom_temp,lsm.eq.0,False)

;========================

coslat_Andes_pr1 = cos(pr_anom_file->lat({Andes_lat_test1(0):Andes_lat_test1(1)})*rad) 
coslat_Andes_pr2 = cos(pr_anom_file->lat({Andes_lat_test2(0):Andes_lat_test2(1)})*rad) 
coslat_Andes_pr3 = cos(pr_anom_file->lat({Andes_lat_test3(0):Andes_lat_test3(1)})*rad) 
coslat_Andes_pr4 = cos(pr_anom_file->lat({Andes_lat_test4(0):Andes_lat_test4(1)})*rad) 
coslat_Andes_pr5 = cos(pr_anom_file->lat({Andes_lat_test5(0):Andes_lat_test5(1)})*rad) 
coslat_Andes_pr6 = cos(pr_anom_file->lat({Andes_lat_test6(0):Andes_lat_test6(1)})*rad) 

coslat_Amazon_pr1 = cos(pr_anom_file->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad) 
coslat_Amazon_pr2 = cos(pr_anom_file->lat({Amazon_lat_test2(0):Amazon_lat_test2(1)})*rad) 
coslat_Amazon_pr3 = cos(pr_anom_file->lat({Amazon_lat_test3(0):Amazon_lat_test3(1)})*rad) 
coslat_Amazon_pr4 = cos(pr_anom_file->lat({Amazon_lat_test4(0):Amazon_lat_test4(1)})*rad) 

Andes_ave1 = wgt_areaave_Wrap(pr_anom_temp({Andes_lat_test1(0):Andes_lat_test1(1)},{Andes_lon_test1(0):Andes_lon_test1(1)}),coslat_Andes_pr1,1.0,0)
Andes_ave2 = wgt_areaave_Wrap(pr_anom_temp({Andes_lat_test2(0):Andes_lat_test2(1)},{Andes_lon_test2(0):Andes_lon_test2(1)}),coslat_Andes_pr2,1.0,0)
Andes_ave3 = wgt_areaave_Wrap(pr_anom_temp({Andes_lat_test3(0):Andes_lat_test3(1)},{Andes_lon_test3(0):Andes_lon_test3(1)}),coslat_Andes_pr3,1.0,0)
Andes_ave4 = wgt_areaave_Wrap(pr_anom_temp({Andes_lat_test4(0):Andes_lat_test4(1)},{Andes_lon_test4(0):Andes_lon_test4(1)}),coslat_Andes_pr4,1.0,0)
Andes_ave5 = wgt_areaave_Wrap(pr_anom_temp({Andes_lat_test5(0):Andes_lat_test5(1)},{Andes_lon_test5(0):Andes_lon_test5(1)}),coslat_Andes_pr5,1.0,0)
Andes_ave6 = wgt_areaave_Wrap(pr_anom_temp({Andes_lat_test6(0):Andes_lat_test6(1)},{Andes_lon_test6(0):Andes_lon_test6(1)}),coslat_Andes_pr6,1.0,0)

Amazon_ave1 = wgt_areaave_Wrap(pr_anom_temp({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),coslat_Amazon_pr1,1.0,0)
Amazon_ave2 = wgt_areaave_Wrap(pr_anom_temp({Amazon_lat_test2(0):Amazon_lat_test2(1)},{Amazon_lon_test2(0):Amazon_lon_test2(1)}),coslat_Amazon_pr2,1.0,0)
Amazon_ave3 = wgt_areaave_Wrap(pr_anom_temp({Amazon_lat_test3(0):Amazon_lat_test3(1)},{Amazon_lon_test3(0):Amazon_lon_test3(1)}),coslat_Amazon_pr3,1.0,0)
Amazon_ave4 = wgt_areaave_Wrap(pr_anom_temp({Amazon_lat_test4(0):Amazon_lat_test4(1)},{Amazon_lon_test4(0):Amazon_lon_test4(1)}),coslat_Amazon_pr4,1.0,0)

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

delete(pr_anom_temp)
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
;--------------  Bowen ratio biases averaged over Amazon -----------

BR_anom_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/BR_processing/"+WADA_labels(imodel)+"_minus_regridded_FLUXNET-MTE_BR_clim_198201-200812.nc","r")
BR_anom_temp = BR_anom_file->BR_clim_minus_MTE

;====== land only -----
lsm  = landsea_mask(lsdata,BR_anom_temp&lat,BR_anom_temp&lon)
BR_anom_temp = mask(BR_anom_temp,lsm.eq.0,False)
;========================

coslat_Amazon_BR1 = cos(BR_anom_file->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad) 
coslat_Amazon_BR2 = cos(BR_anom_file->lat({Amazon_lat_test2(0):Amazon_lat_test2(1)})*rad) 
coslat_Amazon_BR3 = cos(BR_anom_file->lat({Amazon_lat_test3(0):Amazon_lat_test3(1)})*rad) 
coslat_Amazon_BR4 = cos(BR_anom_file->lat({Amazon_lat_test4(0):Amazon_lat_test4(1)})*rad) 

Amazon_ave_BR1 = wgt_areaave_Wrap(BR_anom_temp({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),coslat_Amazon_BR1,1.0,0)
Amazon_ave_BR2 = wgt_areaave_Wrap(BR_anom_temp({Amazon_lat_test2(0):Amazon_lat_test2(1)},{Amazon_lon_test2(0):Amazon_lon_test2(1)}),coslat_Amazon_BR2,1.0,0)
Amazon_ave_BR3 = wgt_areaave_Wrap(BR_anom_temp({Amazon_lat_test3(0):Amazon_lat_test3(1)},{Amazon_lon_test3(0):Amazon_lon_test3(1)}),coslat_Amazon_BR3,1.0,0)
Amazon_ave_BR4 = wgt_areaave_Wrap(BR_anom_temp({Amazon_lat_test4(0):Amazon_lat_test4(1)},{Amazon_lon_test4(0):Amazon_lon_test4(1)}),coslat_Amazon_BR4,1.0,0)

BR_y(imodel) = (Amazon_ave_BR1 * area1_Amazon + Amazon_ave_BR2 * area2_Amazon + Amazon_ave_BR3 * area3_Amazon + Amazon_ave_BR4 * area4_Amazon ) / (area1_Amazon+area2_Amazon+area3_Amazon+area4_Amazon)

delete(BR_anom_temp)
delete(coslat_Amazon_BR1)
delete(coslat_Amazon_BR2)
delete(coslat_Amazon_BR3)
delete(coslat_Amazon_BR4)

end do ; do imodel

precip_diff_x = precip_diff_x * 86400.0 ; from kg/m2/sec to mm/day
precip_diff_x@long_name = "Biases (relative to GPCP) of [precip(Andes) - precip(Amazon)] for a multitude of models"
precip_diff_x@units = "mm/day"
BR_y@long_name = "Biases (relative to FLUXNET-MTE) of Bowen ratio (Amazon) for a multitude of models"
BR_y@units = "W/m2"

print(precip_diff_x)
print(BR_y)

;========== Calculate the correlation coefficient ====
r = escorc(precip_diff_x,BR_y)
n_size = dimsizes(precip_diff_x)

t = r*sqrt((n_size-2)/(1-r^2))      
p = student_t(t, n_size-2)
psig = 0.05                       ; test significance level                     
print("r="+sprintf("%7.3e",r))
print("p="+sprintf("%7.3e",p))            ;

;====================== Plot precip_diff_x VS hfss_y ========
wks_CMIP   = gsn_open_wks ("x11","WADA_CMIP5_9")

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
res_CMIP@tiMainString      = "WADA associated with Bowen ratio"          
res_CMIP@tiXAxisString = "Biases[pr(Andes)-pr(Amazon)], mm/day"
res_CMIP@tiYAxisString = "Biases[BR(Amazon)], unitless"
res_CMIP@xyMarkLineMode    = "Markers"                
res_CMIP@xyMarkers         =  markers(0:dimsizes(WADA_labels)-1)                   
res_CMIP@xyMonoMarkerColor  = False
res_CMIP@xyMarkerColors     = colors(0:dimsizes(WADA_labels)-1) 
res_CMIP@xyMarkerSizeF     = 0.02                    

res_CMIP@gsnLeftString = "correlation="+sprintf("%7.3e",r)
res_CMIP@gsnRightString = "p="+sprintf("%7.3e",p)

res_CMIP@trXMinF = 0.0
res_CMIP@trXMaxF = 9.0
res_CMIP@trYMinF = -4.0
res_CMIP@trYMaxF = 7.0

plot_CMIP  = gsn_csm_xy(wks_CMIP,transpose((/precip_diff_x,precip_diff_x/)),transpose((/BR_y,BR_y/)),res_CMIP)              

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
