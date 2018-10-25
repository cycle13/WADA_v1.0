;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

Ttot_diff_TOPO_CTR = new((/47,13,96,144/),double)
Ttot_diff_TOPO_CTR_sig = new((/47,13,96,144/),double)

Tadv_diff_TOPO_CTR = new((/47,13,96,144/),double)
Tadv_diff_TOPO_CTR_sig = new((/47,13,96,144/),double)

PTTEND_diff_TOPO_CTR = new((/47,13,96,144/),double)
PTTEND_diff_TOPO_CTR_sig = new((/47,13,96,144/),double)


do index = 2,48

TOPO_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/TOPO_TEST/"
TOPO_str = "ENS.std.mean.TOPOTEST.Tdecom."+index+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/CTR/"
CTR_str = "ENS.std.mean.CTR.Tdecom."+index+".nc"


var_str1 = (/"Ttot_mean","Tadv_mean","PTTEND_mean"/)
var_str2 = (/"Ttot_std","Tadv_std","PTTEND_std"/)

do i_var = 0, dimsizes(var_str1)-1
var1 = var_str1(i_var)
var2 = var_str2(i_var)

f_TOPO = addfile(TOPO_dir+TOPO_str,"r")

f_CTR = addfile(CTR_dir+CTR_str,"r")

var_mean_TOPO = f_TOPO->$var1$
printVarSummary(var_mean_TOPO)
var_std_TOPO = f_TOPO->$var2$
printVarSummary(var_std_TOPO)

var_mean_CTR = f_CTR->$var1$
printVarSummary(var_mean_CTR)
var_std_CTR = f_CTR->$var2$
printVarSummary(var_std_CTR)

;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)

P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO->hyam
hybm = f_TOPO->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO->PS_mean,1,P0mb,1,False)
var_mean_TOPO_pnew&lev_p@units = "hPa" 
;printVarSummary(var_mean_TOPO_pnew&lev_p)

var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO->PS_mean,1,P0mb,1,False)
var_std_TOPO_pnew&lev_p@units = "hPa"
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR->PS_mean,1,P0mb,1,False)
var_mean_CTR_pnew&lev_p@units = "hPa"
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR->PS_mean,1,P0mb,1,False)
var_std_CTR_pnew&lev_p@units = "hPa"
;printVarSummary(var_std_CTR_pnew)


siglvl = 0.1
indep_sample = 180
;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_TOPO_CTR@units = var_mean_TOPO@units
diff_TOPO_CTR@long_name = var_mean_TOPO@long_name

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig@units = var_mean_TOPO@units
diff_TOPO_CTR_sig@long_name = var_mean_TOPO@long_name

;printVarSummary(diff_TOPO_CTR)
;printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   Ttot_diff_TOPO_CTR(index-2,:,:,:) = diff_TOPO_CTR
   Ttot_diff_TOPO_CTR_sig(index-2,:,:,:) = diff_TOPO_CTR_sig
else if (i_var .eq. 1) then
   Tadv_diff_TOPO_CTR(index-2,:,:,:) = diff_TOPO_CTR
   Tadv_diff_TOPO_CTR_sig(index-2,:,:,:) = diff_TOPO_CTR_sig
else 
   PTTEND_diff_TOPO_CTR(index-2,:,:,:) = diff_TOPO_CTR
   PTTEND_diff_TOPO_CTR_sig(index-2,:,:,:) = diff_TOPO_CTR_sig
   
end if
end if

end do ; do ivar

end do ; do index


printVarSummary(Ttot_diff_TOPO_CTR)
printVarSummary(Ttot_diff_TOPO_CTR_sig)
printVarSummary(Tadv_diff_TOPO_CTR)
printVarSummary(Tadv_diff_TOPO_CTR_sig)
printVarSummary(PTTEND_diff_TOPO_CTR)
printVarSummary(PTTEND_diff_TOPO_CTR_sig)

;=================Restart here ========
;=================================

;================ plot ===========
;total 6 hrs in the TOPOTEST after branching


plot = new(3,graphic)
plot_sig = new(3,graphic)

total_hrs = 47
do i_hr = 0,total_hrs-1
;do i_day = 0,3
 
wks = gsn_open_wks("png","7_Ttot_Tadv_PTTEND_TOPO_vs_CTR_ihr_"+tostring(i_hr+2))
wks_sig = gsn_open_wks("png","7_Sig_Ttot_Tadv_PTTEND_TOPO_vs_CTR_ihr_"+tostring(i_hr+2))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -6.0e-5
res@cnMaxLevelValF = 6.0e-5
res@cnLevelSpacingF = 1.0e-5

;res@tiMainFontHeightF = 0.015

lat_t = -10.0
lon_1 = 260.0
lon_2 = 320.0

lev_1 = 300.0
lev_2 = 1000.0

res@tiMainString = "Ttot"

plot(0) = gsn_csm_pres_hgt(wks,Ttot_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
plot_sig(0) = gsn_csm_pres_hgt(wks_sig,Ttot_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "Tadv"

plot(1) = gsn_csm_pres_hgt(wks,Tadv_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
plot_sig(1) = gsn_csm_pres_hgt(wks_sig,Tadv_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@tiMainString = "PTTEND"
plot(2) = gsn_csm_pres_hgt(wks,PTTEND_diff_TOPO_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)
plot_sig(2) = gsn_csm_pres_hgt(wks_sig,PTTEND_diff_TOPO_CTR_sig(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)


;============ panel plot ====

str_LST = (/"21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00"/)

pres = True
pres@txString = "TOPO - CTR, ENS(180), ihr="+tostring(i_hr+2)+", LST_75W ("+str_LST(mod(i_hr,24))+")"

gsn_panel(wks,plot,(/1,3/),pres)

gsn_panel(wks_sig,plot_sig,(/1,3/),pres)


end do ; do i_hr


end
