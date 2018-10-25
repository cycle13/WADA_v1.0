;Function: 1. Illustrate the area of the Andes and the Amazon where the areal average will be computed;
;          2. Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [hfss(Amazon)]
;Note: Modified 20180307
;Note: modified 20180313 for non-rectangular Andes and calculation of correlation coefficient. 
;Note: modifed 20180313, so that non-rectangular regions over the Andes and correlation coefficient added.

begin

;======= Step 1. draw a map with two boxes for the Andes and the Amazon ==== 
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

Amazon_lon_test = (/288.0,310.0/)
Amazon_lat_test = (/-11.0,4.0/)

;------------ Draw a map
wks  = gsn_open_wks("x11","5_WADA_illustration")

res                             = True
res@gsnDraw = False
res@gsnFrame = False
res@mpFillOn                    = False        ; turn off gray fill
res@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
res@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines

res@mpMaxLatF                   = 30          ; choose subregion           
res@mpMinLatF                   = -50
res@mpMaxLonF                   = 340
res@mpMinLonF                   = 260

plot = gsn_csm_map(wks,res)                 ; draw map

;----------- Add polygons ---------
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

 xpts_Amazon_test = (/Amazon_lon_test(0),Amazon_lon_test(1),Amazon_lon_test(1),Amazon_lon_test(0),Amazon_lon_test(0)/)
 ypts_Amazon_test = (/Amazon_lat_test(0),Amazon_lat_test(0),Amazon_lat_test(1),Amazon_lat_test(1),Amazon_lat_test(0)/)

; add the box
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "red"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines

dum_Andes1 = new(4,graphic)  
dum_Andes2 = new(4,graphic)  
dum_Andes3 = new(4,graphic)  
dum_Andes4 = new(4,graphic)  
dum_Andes5 = new(4,graphic)  
dum_Andes6 = new(4,graphic)  

dum_Amazon = new(4,graphic)

do i = 0 , 3
  dum_Andes1(i)=gsn_add_polyline(wks,plot,xpts_Andes_test1(i:i+1),ypts_Andes_test1(i:i+1),resp)      
  dum_Andes2(i)=gsn_add_polyline(wks,plot,xpts_Andes_test2(i:i+1),ypts_Andes_test2(i:i+1),resp)      
  dum_Andes3(i)=gsn_add_polyline(wks,plot,xpts_Andes_test3(i:i+1),ypts_Andes_test3(i:i+1),resp)      
  dum_Andes4(i)=gsn_add_polyline(wks,plot,xpts_Andes_test4(i:i+1),ypts_Andes_test4(i:i+1),resp)      
  dum_Andes5(i)=gsn_add_polyline(wks,plot,xpts_Andes_test5(i:i+1),ypts_Andes_test5(i:i+1),resp)      
  dum_Andes6(i)=gsn_add_polyline(wks,plot,xpts_Andes_test6(i:i+1),ypts_Andes_test6(i:i+1),resp)      

  dum_Amazon(i)=gsn_add_polyline(wks,plot,xpts_Amazon_test(i:i+1),ypts_Amazon_test(i:i+1),resp)      
end do 

draw(plot)
frame(wks)

;=================== Step 2. Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [hfss(Amazon)]
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

rad  = 4.*atan(1.)/180.    ;

;do imodel = 0,3
;do imodel = 5,dimsizes(WADA_labels) -1
do imodel = 0,dimsizes(WADA_labels) -1
;do imodel = 0,dimsizes(WADA_labels) - 1

;------------ Diff of precip ----------
pr_clim_file = addfile(precip_models(imodel),"r")
pr_clim_temp = pr_clim_file->pr_clim

coslat_Andes_pr1 = cos(pr_clim_file->lat({Andes_lat_test1(0):Andes_lat_test1(1)})*rad)
coslat_Andes_pr2 = cos(pr_clim_file->lat({Andes_lat_test2(0):Andes_lat_test2(1)})*rad)
coslat_Andes_pr3 = cos(pr_clim_file->lat({Andes_lat_test3(0):Andes_lat_test3(1)})*rad)
coslat_Andes_pr4 = cos(pr_clim_file->lat({Andes_lat_test4(0):Andes_lat_test4(1)})*rad)
coslat_Andes_pr5 = cos(pr_clim_file->lat({Andes_lat_test5(0):Andes_lat_test5(1)})*rad)
coslat_Andes_pr6 = cos(pr_clim_file->lat({Andes_lat_test6(0):Andes_lat_test6(1)})*rad)

coslat_Amazon_pr = cos(pr_clim_file->lat({Amazon_lat_test(0):Amazon_lat_test(1)})*rad)

Andes_ave1 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test1(0):Andes_lat_test1(1)},{Andes_lon_test1(0):Andes_lon_test1(1)}),coslat_Andes_pr1,1.0,0)
Andes_ave2 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test2(0):Andes_lat_test2(1)},{Andes_lon_test2(0):Andes_lon_test2(1)}),coslat_Andes_pr2,1.0,0)
Andes_ave3 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test3(0):Andes_lat_test3(1)},{Andes_lon_test3(0):Andes_lon_test3(1)}),coslat_Andes_pr3,1.0,0)
Andes_ave4 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test4(0):Andes_lat_test4(1)},{Andes_lon_test4(0):Andes_lon_test4(1)}),coslat_Andes_pr4,1.0,0)
Andes_ave5 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test5(0):Andes_lat_test5(1)},{Andes_lon_test5(0):Andes_lon_test5(1)}),coslat_Andes_pr5,1.0,0)
Andes_ave6 = wgt_areaave_Wrap(pr_clim_temp({Andes_lat_test6(0):Andes_lat_test6(1)},{Andes_lon_test6(0):Andes_lon_test6(1)}),coslat_Andes_pr6,1.0,0)

;------- area weighted average across all the boxes over the Andes
rsph = 1.0   ; the result of area_poly_sphere then times radius squared can be in km2 

qorder     = gc_clkwise(ypts_Andes_test1(::-1), xpts_Andes_test1(::-1))   ; (lat,lon)
;print(qorder)

area1 = area_poly_sphere(ypts_Andes_test1(::-1),xpts_Andes_test1(::-1),1.0)
area2 = area_poly_sphere(ypts_Andes_test2(::-1),xpts_Andes_test2(::-1),1.0)
area3 = area_poly_sphere(ypts_Andes_test3(::-1),xpts_Andes_test3(::-1),1.0)
area4 = area_poly_sphere(ypts_Andes_test4(::-1),xpts_Andes_test4(::-1),1.0)
area5 = area_poly_sphere(ypts_Andes_test5(::-1),xpts_Andes_test5(::-1),1.0)
area6 = area_poly_sphere(ypts_Andes_test6(::-1),xpts_Andes_test6(::-1),1.0)

;print(area1)
;print(area2)
;print(area3)
;print(area4)
;print(area5)
;print(area6)

Andes_ave = (Andes_ave1 * area1 + Andes_ave2 * area2 + Andes_ave3 * area3 + Andes_ave4 * area4 + Andes_ave5 * area5 + Andes_ave6 * area6) / (area1+area2+area3+area4+area5+area6)

Amazon_ave = wgt_areaave_Wrap(pr_clim_temp({Amazon_lat_test(0):Amazon_lat_test(1)},{Amazon_lon_test(0):Amazon_lon_test(1)}),coslat_Amazon_pr,1.0,0)

precip_diff_x(imodel) = Andes_ave - Amazon_ave

delete(pr_clim_temp)
delete(coslat_Andes_pr1)
delete(coslat_Andes_pr2)
delete(coslat_Andes_pr3)
delete(coslat_Andes_pr4)
delete(coslat_Andes_pr5)
delete(coslat_Andes_pr6)
delete(coslat_Amazon_pr)

;-------------- hfss over Amazon -----------

hfss_clim_file = addfile(hfss_models(imodel),"r")
hfss_clim_temp = hfss_clim_file->hfss_clim

coslat_Amazon_hfss = cos(hfss_clim_file->lat({Amazon_lat_test(0):Amazon_lat_test(1)})*rad) 

hfss_y(imodel) = wgt_areaave_Wrap(hfss_clim_temp({Amazon_lat_test(0):Amazon_lat_test(1)},{Amazon_lon_test(0):Amazon_lon_test(1)}),coslat_Amazon_hfss,1.0,0) 

delete(hfss_clim_temp)
delete(coslat_Amazon_hfss)

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
wks_CMIP   = gsn_open_wks ("x11","5_WADA_CMIP5")

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
res_CMIP@tiMainString      = "WADA associated with SH over Amazon"          
res_CMIP@tiXAxisString = "pr(Andes) - pr(Amazon), mm/day"
;res_CMIP@tiYAxisString = "hfss(Amazon) - hfss(Andes), W/m2"
res_CMIP@tiYAxisString = "hfss(Amazon), W/m2"
res_CMIP@xyMarkLineMode    = "Markers"                
res_CMIP@xyMarkers         =  markers(0:dimsizes(WADA_labels)-1)                   
res_CMIP@xyMonoMarkerColor  = False
res_CMIP@xyMarkerColors     = colors(0:dimsizes(WADA_labels)-1) 
res_CMIP@xyMarkerSizeF     = 0.02                    

res_CMIP@gsnLeftString = "correlation="+sprintf("%7.3e",r)
res_CMIP@gsnRightString = "p="+sprintf("%7.3e",p)

res_CMIP@trXMinF = -5.0
res_CMIP@trXMaxF = 5.0
res_CMIP@trYMinF = 0.0
res_CMIP@trYMaxF = 110

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
