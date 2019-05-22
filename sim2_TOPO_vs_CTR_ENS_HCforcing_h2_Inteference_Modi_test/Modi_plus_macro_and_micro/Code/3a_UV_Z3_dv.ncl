;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

U_diff_TOPO_CTR = new((/96,13,96,144/),double)
U_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)
V_diff_TOPO_CTR = new((/96,13,96,144/),double)
V_diff_TOPO_CTR_sig = new((/96,13,96,144/),double) 
Z3_diff_TOPO_CTR = new((/96,13,96,144/),double)
Z3_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)
div_diff_TOPO_CTR = new((/96,13,96,144/),double)
div_diff_TOPO_CTR_sig = new((/96,13,96,144/),double)

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

TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(itime)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST."+str_time(itime)+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR."+str_time(itime)+".nc"
CTR_std_str = "ENS.std.CTR."+str_time(itime)+".nc"

var_str = (/"U","V","Z3","dv"/)

do i_var = 0, 3

var = var_str(i_var)

if (i_var .le. 2) then

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

else
f_TOPO_div = addfile(TOPO_dir+"ENS.std.mean.TOPOTEST.div."+str_time(itime)+".nc","r")
f_CTR_div = addfile(CTR_dir+"ENS.std.mean.CTR.div."+str_time(itime)+".nc","r")

var_mean_TOPO = tofloat(f_TOPO_div->div_TOPO_mean)
var_std_TOPO = tofloat(f_TOPO_div->div_TOPO_std)

var_mean_CTR = tofloat(f_CTR_div->div_CTR_mean)
var_std_CTR = tofloat(f_CTR_div->div_CTR_std)

end if ; if (i_var .le. 2)

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
indep_sample = 180
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
   U_diff_TOPO_CTR(itime*3:itime*3+2,:,:,:) = diff_TOPO_CTR
   U_diff_TOPO_CTR_sig(itime*3:itime*3+2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 1) then
   V_diff_TOPO_CTR(itime*3:itime*3+2,:,:,:)  = diff_TOPO_CTR
   V_diff_TOPO_CTR_sig(itime*3:itime*3+2,:,:,:)  = diff_TOPO_CTR_sig
else if (i_var .eq. 2) then
   Z3_diff_TOPO_CTR(itime*3:itime*3+2,:,:,:)  = diff_TOPO_CTR
   Z3_diff_TOPO_CTR_sig(itime*3:itime*3+2,:,:,:)  = diff_TOPO_CTR_sig
else
   div_diff_TOPO_CTR(itime*3:itime*3+2,:,:,:)  = diff_TOPO_CTR
   div_diff_TOPO_CTR_sig(itime*3:itime*3+2,:,:,:) = diff_TOPO_CTR_sig
end if
end if
end if

end do ; do ivar


end do ; do itime

printVarSummary(U_diff_TOPO_CTR)
printVarSummary(U_diff_TOPO_CTR_sig)
printVarSummary(V_diff_TOPO_CTR)
printVarSummary(V_diff_TOPO_CTR_sig)
printVarSummary(Z3_diff_TOPO_CTR)
printVarSummary(Z3_diff_TOPO_CTR_sig)
printVarSummary(div_diff_TOPO_CTR)
printVarSummary(div_diff_TOPO_CTR_sig)
;

;================ plot ===========

pr_levels = (/200,850,700/)
;pr_levels = (/850/)

;total_hrs = 48
total_hrs = 96

do i_pr = 0,dimsizes(pr_levels) - 1

do i_hr = 0,total_hrs-1
;do i_day = 0,3
 
wks = gsn_open_wks("pdf","../Figures/3_Regional_U_V_Z3_dv_TOPO_vs_CTR_ihr_"+tostring(pr_levels(i_pr))+"hPa_"+tostring(i_hr+1))
wks_sig = gsn_open_wks("pdf","../Figures/3_Sig_Regional_U_V_Z3_dv_TOPO_vs_CTR_ihr_"+tostring(pr_levels(i_pr))+"hPa_"+tostring(i_hr+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -20.0
res@cnMaxLevelValF = 20.0
res@cnLevelSpacingF = 1.0
res@gsnContourNegLineDashPattern = 1

res@gsnAddCyclic = True

res@pmLabelBarWidthF  = 0.4
res@pmLabelBarHeightF = 0.06
res@pmLabelBarOrthogonalPosF = 0.15
res@lbLabelAngleF      = 45
res@lbLabelFontHeightF = 0.01

res_vc = True
res_vc@gsnFrame = False
res_vc@gsnDraw = False
res_vc@vcGlyphStyle               = "LineArrow"
res_vc@vcLineArrowThicknessF      = 3
;res_vc@vcMinDistanceF             = 0.02
res_vc@vcMinDistanceF             = 0.01

res_vc@vcRefLengthF               = 0.03

res_vc@vcRefAnnoOn               = True
;res_vc@vcRefMagnitudeF           = 4 
;res_vc@vcRefAnnoString1          = "4"
res_vc@vcRefMagnitudeF           = 2 
res_vc@vcRefAnnoString1          = "2"

res_vc@vcRefAnnoSide             = "Top"
res_vc@vcRefAnnoString2On        = False
res_vc@vcRefAnnoPerimOn          = False
res_vc@vcRefAnnoOrthogonalPosF   = -0.12
res_vc@vcRefAnnoParallelPosF     = 0.999
res_vc@vcRefAnnoBackgroundColor  = "Purple"
res_vc@vcVectorDrawOrder         = "PostDraw"

res_vc@gsnRightString            = "Wind"
res_vc@gsnLeftString = ""
res_vc@gsnRightString = ""

;res@tiMainString = "U,V (m/sec); Z3 (m); divergence (/sec) @"+tostring(pr_levels(i_pr))+"hPa, TOPO - CTR, ENS(180), ihr="+tostring(i_hr+1)
res@tiMainString = "U,V (m/sec); Z3 (m); divergence (/sec) @"+tostring(pr_levels(i_pr))+"hPa, CTR - TOPO, ENS(180), ihr="+tostring(i_hr+1)
res@tiMainFontHeightF = 0.015
res@gsnLeftString = ""
res@gsnRightString = ""

plot_Z3 = gsn_csm_contour(wks,Z3_diff_TOPO_CTR(i_hr,{pr_levels(i_pr)},:,:),res)
plot_Z3_sig = gsn_csm_contour(wks_sig,Z3_diff_TOPO_CTR_sig(i_hr,{pr_levels(i_pr)},:,:),res)

plot_UV = gsn_csm_vector(wks,U_diff_TOPO_CTR(i_hr,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR(i_hr,{pr_levels(i_pr)},:,:),res_vc)
plot_UV_sig = gsn_csm_vector(wks_sig,U_diff_TOPO_CTR_sig(i_hr,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR_sig(i_hr,{pr_levels(i_pr)},:,:),res_vc)

res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True
res@cnLevelSelectionMode = "ManualLevels"

if (pr_levels(i_pr) .eq. 200) then
res@cnMinLevelValF = -1.0e-5
res@cnMaxLevelValF = 1.0e-5
res@cnLevelSpacingF = 0.1e-5
else if (pr_levels(i_pr) .eq. 700) then
res@cnMinLevelValF = -4.0e-6
res@cnMaxLevelValF = 4.0e-6
res@cnLevelSpacingF = 0.4e-6
else            ; 850hPa
res@cnMinLevelValF = -4.0e-6
res@cnMaxLevelValF = 4.0e-6
res@cnLevelSpacingF = 0.4e-6
end if

end if

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0

printVarSummary(f_TOPO_mean->lat)
printVarSummary(f_TOPO_mean->lon)

;plot_dv = gsn_csm_contour_map(wks,uv2dvF_Wrap(U_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),f_TOPO_mean->lat,f_TOPO_mean->lon,3),res)

plot_dv = gsn_csm_contour_map(wks,div_diff_TOPO_CTR(i_hr,{pr_levels(i_pr)},:,:),res)
plot_dv_sig = gsn_csm_contour_map(wks_sig,div_diff_TOPO_CTR_sig(i_hr,{pr_levels(i_pr)},:,:),res)
;;;plot_dv = gsn_csm_contour_map(wks,uv2dv_cfd(U_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR(i_day,{pr_levels(i_pr)},:,:),f_TOPO_mean->lat,f_TOPO_mean->lon,3),res)
;;;plot_dv_sig = gsn_csm_contour_map(wks_sig,uv2dv_cfd(U_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),V_diff_TOPO_CTR_sig(i_day,{pr_levels(i_pr)},:,:),f_TOPO_mean->lat,f_TOPO_mean->lon,3),res)

;Note: please put the shading plot as the base for the overlay (the first plot) so that the contour of plot_Z3 will not be swallowed.
overlay(plot_dv,plot_Z3)
overlay(plot_dv,plot_UV)
draw(plot_dv)
frame(wks)

overlay(plot_dv_sig,plot_Z3_sig)
overlay(plot_dv_sig,plot_UV_sig)
draw(plot_dv_sig)
frame(wks_sig)


end do ; do i_hr 

end do ; do i_pr


end
