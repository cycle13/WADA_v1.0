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


Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)
xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/)

;----------- plot precipitation multi-model-mean --------

wks = gsn_open_wks("x11","Precip_MMM_GPCP_WADA_index")

gsn_reverse_colormap(wks)

plot = new(5,graphic)

precip_clim_MMM_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/pr/Multi-Model-Mean_regrid_pr_clim_198201-200812.nc","r")

f_SGH30 = addfile("/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
SGH30 = f_SGH30->SGH30

SGH30m = SGH30
SGH30m = SGH30@_FillValue 
SGH30m({-40:10},{270:300}) = SGH30({-40:10},{270:300})

do ilat = 0,95
   do ilon = 0,143
      if (.not. ismissing(SGH30m(ilat,ilon)) .and. SGH30m(ilat,ilon) .lt. 200) then
          SGH30m(ilat,ilon) = SGH30m@_FillValue
      end if
   end do
end do
printVarSummary(SGH30m)

;pr_MMM_temp = linint2_Wrap(precip_clim_MMM_file->lon,precip_clim_MMM_file->lat,precip_clim_MMM_file->pr_MMM,True,SGH30&lon,SGH30&lat,0)
pr_mon_MMM_temp = linint2_Wrap(precip_clim_MMM_file->lon,precip_clim_MMM_file->lat,precip_clim_MMM_file->pr_mon_MMM,True,SGH30&lon,SGH30&lat,0)
pr_MMM_temp = dim_avg_n_Wrap(pr_mon_MMM_temp,0)

printVarSummary(pr_MMM_temp)
printVarSummary(pr_mon_MMM_temp)

pr_MMM = pr_MMM_temp
pr_mon_MMM = pr_mon_MMM_temp

;pr_MMM = precip_clim_MMM_file->pr_MMM
;pr_mon_MMM = precip_clim_MMM_file->pr_mon_MMM

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

res@lbLabelBarOn = True

;=======================
;----------GPCP regridded already --------

GPCP_file  = (/"/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_198201-200812_clim.regrid.288x192.nc"/)
f_GPCP = addfile(GPCP_file,"r")

;pr_clim_GPCP_temp = linint2_Wrap(f_GPCP->lon,f_GPCP->lat,f_GPCP->pr_clim_GPCP,True,SGH30&lon,SGH30&lat,0)
pr_mon_clim_GPCP_temp = linint2_Wrap(f_GPCP->lon,f_GPCP->lat,f_GPCP->pr_mon_clim_GPCP,True,SGH30&lon,SGH30&lat,0)
pr_clim_GPCP_temp = dim_avg_n_Wrap(pr_mon_clim_GPCP_temp,0)

printVarSummary(pr_clim_GPCP_temp)
printVarSummary(pr_mon_clim_GPCP_temp)

pr_clim_GPCP = pr_clim_GPCP_temp
pr_mon_clim_GPCP = pr_mon_clim_GPCP_temp

;-------------- Add Multi-model-mean minus GPCP ----------------

diff_pr_MMM_GPCP = pr_MMM  ; meta data
diff_pr_MMM_GPCP = pr_MMM - pr_clim_GPCP
printVarSummary(diff_pr_MMM_GPCP)

;---------- plot this precipitation Multi-Model-Mean minus GPCP climatology ---

;---------- Add the value of WADA index ------
WADA_index = avg(where(.not.ismissing(SGH30m),diff_pr_MMM_GPCP,diff_pr_MMM_GPCP@_FillValue))  \
        - avg(diff_pr_MMM_GPCP({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

;--------

res@gsnCenterString = ""
res@gsnLeftString = "pr_MMM - GPCP"
res@tiMainString = "MMM minus GPCP, annual"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

;change resources for this temp plot
;res@gsnDraw = True
;res@gsnFrame = True

res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index)

res@tiMainString = "r1i1p1_MMM - GPCP, 198201-200812"
res@gsnLeftString = ""
plot(0) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP,res)

dum_Amazon_pr_MMM_GPCP1 = new(4,graphic)

;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 4.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon_pr_MMM_GPCP1(i)=gsn_add_polyline(wks,plot(0),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do

;---------

res2 = True
res2@gsnDraw = False
res2@gsnFrame = False
res2@cnFillOn = True
res2@cnFillPattern      = 16  
res2@gsnLeftString = ""
res2@gsnRightString = "" ; unit in meter
res2@lbLabelBarOn = False

plot_SGHm_0 = gsn_csm_contour(wks,SGH30m,res2)

overlay(plot(0),plot_SGHm_0)


;============================= Multi Model Mean (MMM) precip DJF clim ========
MMM_DJF = pr_mon_MMM(0,:,:) ; metadata
MMM_DJF = (pr_mon_MMM(0,:,:) + pr_mon_MMM(1,:,:) + pr_mon_MMM(11,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_DJF)

;=============================  GPCP precip DJF clim ===========

GPCP_DJF = pr_mon_clim_GPCP(0,:,:) ; metadata
GPCP_DJF = (pr_mon_clim_GPCP(0,:,:) + pr_mon_MMM(1,:,:) + pr_mon_MMM(11,:,:)) / 3.0
printVarSummary(GPCP_DJF)

;============================== MMM DJF clim minus GPCP DJF clim 

diff_pr_MMM_GPCP_DJF = MMM_DJF  ; meta data
diff_pr_MMM_GPCP_DJF = MMM_DJF - GPCP_DJF
printVarSummary(diff_pr_MMM_GPCP_DJF)

WADA_index = avg(where(.not.ismissing(SGH30m),diff_pr_MMM_GPCP_DJF,diff_pr_MMM_GPCP@_FillValue))  \
             - avg(diff_pr_MMM_GPCP_DJF({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

;---------- plot this precipitation Multi-Model-Mean minus GPCP DJF climatology ---

res@gsnCenterString = ""
res@gsnLeftString = ""

res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index)
res@tiMainString = "MMM minus GPCP, DJF"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(1) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_DJF,res)

dum_Amazon_pr_MMM_GPCP_DJF1 = new(4,graphic)

do i = 0 , 3
  dum_Amazon_pr_MMM_GPCP_DJF1(i)=gsn_add_polyline(wks,plot(1),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do

plot_SGHm_1 = gsn_csm_contour(wks,SGH30m,res2)
overlay(plot(1),plot_SGHm_1)

;============================= Multi Model Mean (MMM) precip MAM clim ========
MMM_MAM = pr_mon_MMM(2,:,:) ; metadata
MMM_MAM = (pr_mon_MMM(2,:,:) + pr_mon_MMM(3,:,:) + pr_mon_MMM(4,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_MAM)

;=============================  GPCP precip MAM clim ===========

GPCP_MAM = pr_mon_clim_GPCP(2,:,:) ; metadata
GPCP_MAM = (pr_mon_clim_GPCP(2,:,:) + pr_mon_MMM(3,:,:) + pr_mon_MMM(4,:,:)) / 3.0
printVarSummary(GPCP_MAM)
;============================== MMM MAM clim minus GPCP MAM clim 

diff_pr_MMM_GPCP_MAM = MMM_MAM  ; meta data
diff_pr_MMM_GPCP_MAM = MMM_MAM - GPCP_MAM
printVarSummary(diff_pr_MMM_GPCP_MAM)

WADA_index = avg(where(.not.ismissing(SGH30m),diff_pr_MMM_GPCP_MAM,diff_pr_MMM_GPCP@_FillValue)) \
            - avg(diff_pr_MMM_GPCP_MAM({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

;---------- plot this precipitation Multi-Model-Mean minus GPCP MAM climatology ---

res@gsnCenterString = ""
res@gsnLeftString = ""
res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index)
res@tiMainString = "MMM minus GPCP, MAM"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(2) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_MAM,res)

dum_Amazon_pr_MMM_GPCP_MAM1 = new(4,graphic)

do i = 0 , 3
  dum_Amazon_pr_MMM_GPCP_MAM1(i)=gsn_add_polyline(wks,plot(2),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do

plot_SGHm_2 = gsn_csm_contour(wks,SGH30m,res2)
overlay(plot(2),plot_SGHm_2)

;============================= Multi Model Mean (MMM) precip JJA clim ========
MMM_JJA = pr_mon_MMM(5,:,:) ; metadata
MMM_JJA = (pr_mon_MMM(5,:,:) + pr_mon_MMM(6,:,:) + pr_mon_MMM(7,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_JJA)

;=============================  GPCP precip JJA clim ===========

GPCP_JJA = pr_mon_clim_GPCP(5,:,:) ; metadata
GPCP_JJA = (pr_mon_clim_GPCP(5,:,:) + pr_mon_MMM(6,:,:) + pr_mon_MMM(7,:,:)) / 3.0
printVarSummary(GPCP_JJA)

;============================== MMM JJA clim minus GPCP JJA clim 

diff_pr_MMM_GPCP_JJA = MMM_JJA  ; meta data
diff_pr_MMM_GPCP_JJA = MMM_JJA - GPCP_JJA
printVarSummary(diff_pr_MMM_GPCP_JJA)

WADA_index = avg(where(.not.ismissing(SGH30m),diff_pr_MMM_GPCP_JJA,diff_pr_MMM_GPCP@_FillValue)) \
            - avg(diff_pr_MMM_GPCP_JJA({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))
;---------- plot this precipitation Multi-Model-Mean minus GPCP JJA climatology ---

res@gsnCenterString = ""
res@gsnLeftString = ""
res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index)
res@tiMainString = "MMM minus GPCP, JJA"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(3) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_JJA,res)

dum_Amazon_pr_MMM_GPCP_JJA1 = new(4,graphic)

do i = 0 , 3
  dum_Amazon_pr_MMM_GPCP_JJA1(i)=gsn_add_polyline(wks,plot(3),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do
plot_SGHm_3 = gsn_csm_contour(wks,SGH30m,res2)
overlay(plot(3),plot_SGHm_3)

;============================= Multi Model Mean (MMM) precip SON clim ========
MMM_SON = pr_mon_MMM(8,:,:) ; metadata
MMM_SON = (pr_mon_MMM(8,:,:) + pr_mon_MMM(9,:,:) + pr_mon_MMM(10,:,:)) / 3.0   ; DJF average
printVarSummary(MMM_SON)

;=============================  GPCP precip SON clim ===========

GPCP_SON = pr_mon_clim_GPCP(8,:,:) ; metadata
GPCP_SON = (pr_mon_clim_GPCP(8,:,:) + pr_mon_MMM(9,:,:) + pr_mon_MMM(10,:,:)) / 3.0
printVarSummary(GPCP_SON)

;============================== MMM SON clim minus GPCP SON clim 

diff_pr_MMM_GPCP_SON = MMM_SON  ; meta data
diff_pr_MMM_GPCP_SON = MMM_SON - GPCP_SON
printVarSummary(diff_pr_MMM_GPCP_SON)

WADA_index = avg(where(.not.ismissing(SGH30m),diff_pr_MMM_GPCP_SON,diff_pr_MMM_GPCP@_FillValue)) \
           - avg(diff_pr_MMM_GPCP_SON({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

;---------- plot this precipitation Multi-Model-Mean minus GPCP JJA climatology ---

res@gsnCenterString = ""
res@gsnLeftString = ""
res@gsnCenterString = "WADAi="+sprintf("%5.2f",WADA_index)
res@tiMainString = "MMM minus GPCP, SON"

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -3.0
res@cnMaxLevelValF = 3.0
res@cnLevelSpacingF = 0.5

plot(4) = gsn_csm_contour_map(wks,diff_pr_MMM_GPCP_SON,res)

dum_Amazon_pr_MMM_GPCP_SON1 = new(4,graphic)

do i = 0 , 3
  dum_Amazon_pr_MMM_GPCP_SON1(i)=gsn_add_polyline(wks,plot(4),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)
end do
plot_SGHm_4 = gsn_csm_contour(wks,SGH30m,res2)
overlay(plot(4),plot_SGHm_4)

;============= Panel plot =========
resP = True
resP@txString = "r1i1p1 MMM vs GPCP, annual vs seasonal, 198201-200812"
resP@lbLabelFontHeightF = 0.007

gsn_panel(wks,plot,(/2,3/),resP)


end           
