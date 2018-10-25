;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.nc"
TOPO_std_str = "ENS.std.TOPOTEST.nc"

CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.nc"
CTR_std_str = "ENS.std.CTR.nc"

var_str = (/"U","V","OMEGA","T","Q"/)

do i_var = 0, dimsizes(var_str)-1
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
var_mean_TOPO_pnew&lev_p@units = "hPa" 
;printVarSummary(var_mean_TOPO_pnew&lev_p)

var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_std_TOPO_pnew&lev_p@units = "hPa"
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev_p@units = "hPa"
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
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
   U_diff_TOPO_CTR = diff_TOPO_CTR
   U_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else if (i_var .eq. 1) then
   V_diff_TOPO_CTR = diff_TOPO_CTR
   V_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else if (i_var .eq. 2) then
   OMEGA_diff_TOPO_CTR = diff_TOPO_CTR
   OMEGA_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else if (i_var .eq. 3) then
   T_diff_TOPO_CTR = diff_TOPO_CTR
   T_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
else if (i_var .eq. 4) then
   Q_diff_TOPO_CTR = diff_TOPO_CTR
   Q_diff_TOPO_CTR_sig = diff_TOPO_CTR_sig
   
end if
end if
end if
end if
end if

end do ; do ivar

printVarSummary(U_diff_TOPO_CTR)
;printVarSummary(U_diff_TOPO_CTR_sig)
printVarSummary(V_diff_TOPO_CTR)
;printVarSummary(V_diff_TOPO_CTR_sig)
printVarSummary(OMEGA_diff_TOPO_CTR)
;printVarSummary(OMEGA_diff_TOPO_CTR_sig)
printVarSummary(T_diff_TOPO_CTR)
printVarSummary(Q_diff_TOPO_CTR)

;================ plot ===========
;total 12 days in the TOPOTEST after branching

total_days = 12

plot = new(5,graphic)
plot_sig = new(5,graphic)

do i_day = 0,total_days-1
;do i_day = 0,3
 
wks = gsn_open_wks("png","U_V_OMEGA_T_Q_TOPO_vs_CTR_iday_"+tostring(i_day+1))
wks_sig = gsn_open_wks("png","Sig_U_V_OMEGA_T_Q_TOPO_vs_CTR_iday_"+tostring(i_day+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -4.0
res@cnMaxLevelValF = 4.0
res@cnLevelSpacingF = 1.0

;res@tiMainFontHeightF = 0.015

lat_t = -10.0
lon_1 = 260.0
lon_2 = 320.0

plot(0) = gsn_csm_pres_hgt(wks,U_diff_TOPO_CTR(i_day,:,{lat_t},{lon_1:lon_2}),res)
plot_sig(0) = gsn_csm_pres_hgt(wks_sig,U_diff_TOPO_CTR_sig(i_day,:,{lat_t},{lon_1:lon_2}),res)

plot(1) = gsn_csm_pres_hgt(wks,V_diff_TOPO_CTR(i_day,:,{lat_t},{lon_1:lon_2}),res)
plot_sig(1) = gsn_csm_pres_hgt(wks_sig,V_diff_TOPO_CTR_sig(i_day,:,{lat_t},{lon_1:lon_2}),res)

res@cnMinLevelValF = -0.1
res@cnMaxLevelValF = 0.1
res@cnLevelSpacingF = 0.02

plot(2) = gsn_csm_pres_hgt(wks,OMEGA_diff_TOPO_CTR(i_day,:,{lat_t},{lon_1:lon_2}),res)
plot_sig(2) = gsn_csm_pres_hgt(wks_sig,OMEGA_diff_TOPO_CTR_sig(i_day,:,{lat_t},{lon_1:lon_2}),res)

res@cnMinLevelValF = -1.0
res@cnMaxLevelValF = 1.0
res@cnLevelSpacingF = 0.2
plot(3) = gsn_csm_pres_hgt(wks,T_diff_TOPO_CTR(i_day,:,{lat_t},{lon_1:lon_2}),res)
plot_sig(3) = gsn_csm_pres_hgt(wks_sig,T_diff_TOPO_CTR_sig(i_day,:,{lat_t},{lon_1:lon_2}),res)

res@cnMinLevelValF = -0.0006
res@cnMaxLevelValF = 0.0006
res@cnLevelSpacingF = 0.0002
plot(4) = gsn_csm_pres_hgt(wks,Q_diff_TOPO_CTR(i_day,:,{lat_t},{lon_1:lon_2}),res)
plot_sig(4) = gsn_csm_pres_hgt(wks_sig,Q_diff_TOPO_CTR_sig(i_day,:,{lat_t},{lon_1:lon_2}),res)

;============ panel plot ====

pres = True
pres@txString = "TOPO - CTR, ENS(180), iday="+tostring(i_day+1)

gsn_panel(wks,plot,(/3,2/),pres)

gsn_panel(wks_sig,plot_sig,(/3,2/),pres)


end do ; do i_day 

end
