;Function: 1. Illustrate the area of the Andes and the Amazon where the areal average will be computed;
;          2. Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [NGMS(Amazon) - NGMS(Andes)]
;Date: 20180219


begin

;======= Step 1. draw a map with two boxes for the Andes and the Amazon ==== 
Andes_lon1 = 280.0
Andes_lon2 = 290.0
Andes_lat1 = -15.0
Andes_lat2 = 5.0

Amazon_lon1 = 290.0
Amazon_lon2 = 310.0
Amazon_lat1 = -15.0
Amazon_lat2 = 5.0

;------------ Draw a map
wks  = gsn_open_wks("pdf","WADA_illustration")           ; send graphics to PNG file
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
 xpts_Andes = (/Andes_lon1,Andes_lon2,Andes_lon2,Andes_lon1,Andes_lon1/)
 ypts_Andes = (/Andes_lat1,Andes_lat1,Andes_lat2,Andes_lat2,Andes_lat1/)
 xpts_Amazon = (/Amazon_lon1,Amazon_lon2,Amazon_lon2,Amazon_lon1,Amazon_lon1/)
 ypts_Amazon = (/Amazon_lat1,Amazon_lat1,Amazon_lat2,Amazon_lat2,Amazon_lat1/)

; add the box
resp                  = True                      ; polyline mods desired
resp@gsLineColor      = "red"                     ; color of lines
resp@gsLineThicknessF = 2.0                       ; thickness of lines

dum_Andes = new(4,graphic)  
dum_Amazon = new(4,graphic)
do i = 0 , 3
  dum_Andes(i)=gsn_add_polyline(wks,plot,xpts_Andes(i:i+1),ypts_Andes(i:i+1),resp)      
  dum_Amazon(i)=gsn_add_polyline(wks,plot,xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),resp)      
end do 

draw(plot)
frame(wks)

;=================== Step 2. Magnitude of [precip(Andes) - precip(Amazon)  VS Magnitude of [NGMS(Amazon) - NGMS(Andes)]
pr_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/pr/"
NGMS_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/Post-processing/NGMS/"

WADA_labels = (/"CCSM4","CanAM4","ACCESS1-3","CNRM-CM5","NorESM1-M","IPSL-CM5A-LR","HadGEM2-A"/)
precip_diff_x = new(dimsizes(WADA_labels),double)
NGMS_y = new(dimsizes(WADA_labels),double)

precip_models = (/pr_dir_name+"pr.ncl.clim.Amon_CCSM4_amip_r1i1p1_197901-201012.nc",\
                 pr_dir_name+"pr.ncl.clim.Amon_CanAM4_amip_r1i1p1_195001-200912.nc",\
                 pr_dir_name+"pr.ncl.clim.Amon_ACCESS1-3_amip_r1i1p1_197801-200812.nc",\
                 pr_dir_name+"pr.ncl.clim.Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc",\
                 pr_dir_name+"pr.ncl.clim.Amon_NorESM1-M_amip_r1i1p1_197901-200812.nc",\
                 pr_dir_name+"pr.ncl.clim.Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200912.nc",\
                 pr_dir_name+"pr.ncl.clim.Amon_HadGEM2-A_amip_r1i1p1_197809-200812.nc"/)
NGMS_models = (/NGMS_dir_name+"NGMS_Amon_CCSM4_amip_r1i1p1_197901-201012_clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CanAM4_amip_r1i1p1_195001-200912_clim.nc",\
                NGMS_dir_name+"NGMS_Amon_ACCESS1-3_amip_r1i1p1_197801-200812_clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CNRM-CM5_amip_r1i1p1_197901-200812_clim.nc",\
                NGMS_dir_name+"NGMS_Amon_NorESM1-M_amip_r1i1p1.197901-200812_clim.nc",\
                NGMS_dir_name+"NGMS_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200912_clim.nc",\
                NGMS_dir_name+"NGMS_Amon_HadGEM2-A_amip_r1i1p1.197809-200812_clim.nc"/)

rad  = 4.*atan(1.)/180.    ;

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
NGMS_clim_file = addfile(NGMS_models(imodel),"r")
NGMS_clim_temp = NGMS_clim_file->NGMS

coslat_Andes_NGMS = cos(NGMS_clim_file->lat({Andes_lat1:Andes_lat2})*rad) 
coslat_Amazon_NGMS = cos(NGMS_clim_file->lat({Amazon_lat1:Amazon_lat2})*rad) 

;NGMS_diff_y(imodel) = wgt_areaave_Wrap(NGMS_clim_temp({Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}),coslat_Amazon_NGMS,1.0,0) - wgt_areaave_Wrap(NGMS_clim_temp({Andes_lat1:Andes_lat2},{Andes_lon1:Andes_lon2}),coslat_Andes_NGMS,1.0,0)
NGMS_y(imodel) = wgt_areaave_Wrap(NGMS_clim_temp({Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}),coslat_Amazon_NGMS,1.0,0) 

delete(NGMS_clim_temp)
delete(coslat_Andes_NGMS)
delete(coslat_Amazon_NGMS)

end do ; do imodel

precip_diff_x = precip_diff_x * 86400.0 ; from kg/m2/sec to mm/day
precip_diff_x@long_name = "precip(Andes) - precip(Amazon) for a multitude of models"
precip_diff_x@units = "mm/day"
;NGMS_diff_y@long_name = "NGMS(Amazon) - NGMS(Andes) for a multitude of models"
NGMS_y@long_name = "NGMS(Amazon) for a multitude of models"
NGMS_y@units = "unitless"

print(precip_diff_x)
print(NGMS_y)

;====================== Plot precip_diff_x VS NGMS_y ========
wks_CMIP   = gsn_open_wks ("pdf","WADA_CMIP5")           ; send graphics to PNG file

colors  = (/"wheat4","dodgerblue2","firebrick","forestgreen","thistle3",\
            "tomato","deeppink2","darkorange2","purple","turquoise",\
            "turquoise4","violet","violetred","yellow","yellowgreen",\
            "darkorchid","darksalmon","deepskyblue","firebrick4","deepskyblue3"/)
markers = (/0,2,3,4,5,6,\
            7,8,9,10,11,\
            12,13,14,15,16/)

res_CMIP                   = True                    
res_CMIP@gsnFrame = False
res_CMIP@gsnDraw = False
;res_CMIP@gsnMaximize       = True                     
res_CMIP@tiMainString      = "WADA associated with NGMS difference"          
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
  txres@txFontHeightF = 0.01
  txres@txJust        = "CenterLeft"

do i = 0,4
     mkres@gsMarkerThicknessF = 3.5
     mkres@gsMarkerSizeF      = 0.01
     mkres@gsMarkerIndex      = markers(i)
     mkres@gsMarkerColor  = colors(i)
     gsn_polymarker_ndc(wks_CMIP,xpos_marker1(i),0.78,mkres)
     gsn_text_ndc      (wks_CMIP,WADA_labels(i),xpos_text1(i),0.78,txres)
end do
;--- Start from another line
do i = 5,dimsizes(WADA_labels)-1
     mkres@gsMarkerIndex  = markers(i)
     mkres@gsMarkerColor  = colors(i)
     gsn_polymarker_ndc(wks_CMIP,xpos_marker1(i-5),0.76,mkres)
     gsn_text_ndc      (wks_CMIP,WADA_labels(i),xpos_text1(i-5),0.76,txres)
end do


draw(plot_CMIP)
frame(wks_CMIP)

end
