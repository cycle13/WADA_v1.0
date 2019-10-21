;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"      ; These four libraries are automatically
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"       ; loaded from NCL V6.4.0 onward.
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   ; No need for user to explicitly load.
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

OMEGA_diff_TOPO_CTR = new((/96,13,96,144/),double)
OMEGA_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)
Q_diff_TOPO_CTR = new((/96,13,96,144/),double)
Q_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)

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
;time_label = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = "time"+tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
;time_label(i_str_time) = "time"+str_time(i_str_time)
end do

;time_label = (/"time0-5","time6-11","time12-17","time18-23","time24-29","time30-35","time36-41","time42-47"/)

do itime = 0,31

;str_time = time_label(itime)
;print(str_time)

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(itime)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST."+str_time(itime)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.mean.CTR."+str_time(itime)+".nc"
CTR_std_str = "ENS.std.CTR."+str_time(itime)+".nc"

var_str = (/"OMEGA","Q"/)

do i_var = 0, 1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_CTR)

;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_TOPO_pnew)
var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_CTR_pnew)

siglvl = 0.1
;indep_sample = 180
indep_sample = 9
;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_TOPO_CTR = var_mean_CTR_pnew - var_mean_TOPO_pnew

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR_sig@_FillValue)
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_CTR_pnew - var_mean_TOPO_pnew,diff_TOPO_CTR_sig@_FillValue)

;printVarSummary(diff_TOPO_CTR)
;printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   OMEGA_diff_TOPO_CTR(itime*3:itime*3+2,:,:,:) = diff_TOPO_CTR
   OMEGA_diff_TOPO_CTR_sig(itime*3:itime*3+2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 1) then
   Q_diff_TOPO_CTR(itime*3:itime*3+2,:,:,:)  = diff_TOPO_CTR
   Q_diff_TOPO_CTR_sig(itime*3:itime*3+2,:,:,:)  = diff_TOPO_CTR_sig
end if
end if

end do ; do ivar


end do ; do itime

printVarSummary(OMEGA_diff_TOPO_CTR)
printVarSummary(OMEGA_diff_TOPO_CTR_sig)
printVarSummary(Q_diff_TOPO_CTR)
printVarSummary(Q_diff_TOPO_CTR_sig)
;
;================ plot ===========

Amazon_lon_test1 = (/286.0,293.0/)
Amazon_lat_test1 = (/-8.0,0.0/)

Amazon_lon_test2 = (/293.0,306.0/)
Amazon_lat_test2 = (/-12.0,4.0/)

 xpts_Amazon_test1 = (/Amazon_lon_test1(0),Amazon_lon_test1(1),Amazon_lon_test1(1),Amazon_lon_test1(0),Amazon_lon_test1(0)/)
 ypts_Amazon_test1 = (/Amazon_lat_test1(0),Amazon_lat_test1(0),Amazon_lat_test1(1),Amazon_lat_test1(1),Amazon_lat_test1(0)/) 

 xpts_Amazon_test2 = (/Amazon_lon_test2(0),Amazon_lon_test2(1),Amazon_lon_test2(1),Amazon_lon_test2(0),Amazon_lon_test2(0)/)
 ypts_Amazon_test2 = (/Amazon_lat_test2(0),Amazon_lat_test2(0),Amazon_lat_test2(1),Amazon_lat_test2(1),Amazon_lat_test2(0)/) 
;-------

;pr_levels = (/850.0/)
pr_levels = (/500.0/)

;total_hrs = 48
total_hrs = 96

OMEGA_diff_TOPO_CTR = OMEGA_diff_TOPO_CTR - 0.02 ; so that only the 0.02 line will be plot as the magenta line.

color_strings = (/"red","brown","orange","yellow","green","blue","cyan","purple"/) ; for hour=4~11

i_pr = 0

plot = new(8,graphic)
 
wks = gsn_open_wks("png","../Figures/3_Regional_OMEGA_rainbow_TOPO_vs_CTR_"+tostring(pr_levels(i_pr))+"hPa")
;wks_sig = gsn_open_wks("x11","../Figures/3_Sig_Regional_OMEGA_Q_T_TOPO_vs_CTR_ihr_"+tostring(pr_levels(i_pr))+"hPa_"+tostring(i_hr+1))


res = True
res@gsnDraw = False
res@gsnFrame = False
;res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = False

;res@mpMaxLatF = 60.0
;res@mpMinLatF = -60.0
;res@mpMaxLonF = 350.0
;res@mpMinLonF = 230.0

res@mpMaxLatF = Amazon_lat_test2(1)+5.0
res@mpMinLatF = Amazon_lat_test2(0)-5.0
res@mpMaxLonF = Amazon_lon_test2(1)+5.0
res@mpMinLonF = Amazon_lon_test2(0)-15.0

;res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF = -0.02
;res@cnMaxLevelValF = 0.02
;res@cnLevelSpacingF = 0.02   ; only plot 0.02 contour line ( minus 0.02 has been done in the above )
res@gsnContourZeroLineThicknessF = 0.8

res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
res@cnLevels    = (/ 0.0/)   ; set levels

;res@gsnContourNegLineDashPattern = 1

;res@gsnAddCyclic = True
i_hr = 3
res@gsnCenterString = "OMEGA, 0.02 Pa/s contour, "+ "CTR-TOPO, time=4-11hr, "+tostring(sprintf("%5.2f",pr_levels(i_pr)))+"hPa" 
res@cnMonoLineColor = True
res@cnLineColor = color_strings(i_hr-3)
plot_base = gsn_csm_contour_map(wks,OMEGA_diff_TOPO_CTR(3,{pr_levels(i_pr)},:,:),res)
;plot_base = ColorNegDashZeroPosContour(plot_base,"grey",color_strings(i_hr-3),"grey")  ; zero line uses magenta, negative, positive uses black

delete(res@gsnCenterString)

do i_hr = 4,10
res@cnLineColor = color_strings(i_hr-3)
plot(i_hr-4) = gsn_csm_contour(wks,OMEGA_diff_TOPO_CTR(i_hr,{pr_levels(i_pr)},:,:),res)

;plot(i_hr-4) = ColorNegDashZeroPosContour(plot(i_hr-4),"grey",color_strings(i_hr-4),"grey")  ; zero line uses magenta, negative, positive uses black

overlay(plot_base,plot(i_hr-4))

end do ; do i_hr 

;------- add box -----
dum_Amazon_pr_MMM1 = new(4,graphic)
dum_Amazon_pr_MMM2 = new(4,graphic)
dum_Amazon_pr_MMM3 = new(4,graphic)
dum_Amazon_pr_MMM4 = new(4,graphic)

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 2.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon_pr_MMM1(i)=gsn_add_polyline(wks,plot_base,xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
end do 

do i = 0 , 3
  dum_Amazon_pr_MMM2(i)=gsn_add_polyline(wks,plot_base,xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
end do 

;------- add some legend ---------
  gres = True
  gres@YPosPercent = 95.    ; expressed as %, 0->100, sets position of top border of legend 
                            ;  when gres@Position is set to its default setting of "Top" (Default = 95.)
  gres@XPosPercent = 5.      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)

  lineres = True
  lineres@lgLineColors = color_strings ; line colors

  textres = True
  textres@lgLabels = (/"hr=4","hr=5","hr=6","hr=7","hr=8","hr=9","hr=10","hr=11"/)  ; legend labels (required)

  plot = simple_legend(wks,plot_base,gres,lineres,textres)

draw(plot_base)
frame(wks)
;----------------
;
;;res@cnLinesOn = False
;;res@cnLineLabelsOn = False
;;res@cnFillOn = True
;;res@cnLevelSelectionMode = "ManualLevels"
;;
;res@cnMinLevelValF = -0.001
;res@cnMaxLevelValF = 0.001
;res@cnLevelSpacingF = 0.0001
;;
;res@gsnCenterString = "Q"
;plot(1) = gsn_csm_contour_map(wks,Q_diff_TOPO_CTR(i_hr,{pr_levels(i_pr)},:,:),res)
;plot(1) = ColorNegDashZeroPosContour(plot(1),"red","magenta","blue")
;
;do i = 0 , 3
;  dum_Amazon_pr_MMM3(i)=gsn_add_polyline(wks,plot(1),xpts_Amazon_test1(i:i+1),ypts_Amazon_test1(i:i+1),respoly)      
;end do 
;do i = 0 , 3
;  dum_Amazon_pr_MMM4(i)=gsn_add_polyline(wks,plot(1),xpts_Amazon_test2(i:i+1),ypts_Amazon_test2(i:i+1),respoly)      
;end do 
;
;
;printVarSummary(f_TOPO_mean->lat)
;printVarSummary(f_TOPO_mean->lon)


;resP                     = True                ; modify the panel plot
;;resP@gsnPanelMainString = "CTR-TOPO, ihr="+tostring(i_hr+1)
;resP@txString = "CTR-TOPO, ihr="+tostring(i_hr+1)+", @ "+tostring(sprintf("%5.2f",pr_levels(i_pr)))+"hPa"
;;resP@gsnPanelLabelBar    = True                ; add common colorbar
;resP@lbLabelFontHeightF  = 0.007               ; make labels smaller
;
;gsn_panel(wks,plot(0),(/1,1/),resP)               ; now draw as one plot
;;



end
