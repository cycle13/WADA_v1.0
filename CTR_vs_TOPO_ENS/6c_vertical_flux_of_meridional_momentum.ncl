;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of OMEGAU.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_str = "ENS.std.mean.TOPOTEST.OMEGAUV.nc"

CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_str = "ENS.std.mean.CTR.OMEGAUV.nc"

;================

f_TOPO = addfile(TOPO_dir+TOPO_str,"r")
;for PS, hyam, hybm
f_TOPO_mean = addfile(TOPO_dir+"Old/ENS.mean.TOPOTEST.nc","r") 

f_CTR = addfile(CTR_dir+CTR_str,"r")
f_CTR_mean = addfile(CTR_dir+"Old/ENS.mean.CTR.nc","r")

OMEGAV_mean_TOPO = f_TOPO->OMEGAV_TOPO_mean
OMEGAV_std_TOPO = f_TOPO->OMEGAV_TOPO_std

OMEGA_mean_TOPO = f_TOPO->OMEGA_TOPO_mean
OMEGA_std_TOPO = f_TOPO->OMEGA_TOPO_std

OMEGAV_mean_CTR = f_CTR->OMEGAV_CTR_mean
OMEGAV_std_CTR = f_CTR->OMEGAV_CTR_std

OMEGA_mean_CTR = f_CTR->OMEGA_CTR_mean
OMEGA_std_CTR = f_CTR->OMEGA_CTR_std


;========== hybrid coordinate to pressure coordinate ====
;======= a compromise here, it's better to vin2p before calculating their mean and std

pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)

P0mb = 1000.0

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

OMEGAV_mean_TOPO_pnew = vinth2p(OMEGAV_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
OMEGAV_mean_TOPO_pnew&lev_p@units = "hPa" 

OMEGAV_std_TOPO_pnew = vinth2p(OMEGAV_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
OMEGAV_std_TOPO_pnew&lev_p@units = "hPa"

OMEGAV_mean_CTR_pnew = vinth2p(OMEGAV_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
OMEGAV_mean_CTR_pnew&lev_p@units = "hPa"

OMEGAV_std_CTR_pnew = vinth2p(OMEGAV_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
OMEGAV_std_CTR_pnew&lev_p@units = "hPa"

OMEGA_mean_TOPO_pnew = vinth2p(OMEGA_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
OMEGA_mean_TOPO_pnew&lev_p@units = "hPa" 

OMEGA_std_TOPO_pnew = vinth2p(OMEGA_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
OMEGA_std_TOPO_pnew&lev_p@units = "hPa"

OMEGA_mean_CTR_pnew = vinth2p(OMEGA_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
OMEGA_mean_CTR_pnew&lev_p@units = "hPa"

OMEGA_std_CTR_pnew = vinth2p(OMEGA_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
OMEGA_std_CTR_pnew&lev_p@units = "hPa"

siglvl = 0.1
indep_sample = 180
;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(OMEGAV_mean_TOPO_pnew,OMEGAV_std_TOPO_pnew^2,indep_sample,OMEGAV_mean_CTR_pnew,OMEGAV_std_CTR_pnew^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = OMEGAV_mean_TOPO_pnew ; metadata
diff_TOPO_CTR = OMEGAV_mean_TOPO_pnew - OMEGAV_mean_CTR_pnew
diff_TOPO_CTR@units = OMEGAV_mean_TOPO@units
diff_TOPO_CTR@long_name = OMEGAV_mean_TOPO@long_name

diff_TOPO_CTR_sig = OMEGAV_mean_TOPO_pnew ; metadata
diff_TOPO_CTR_sig = where(prob .lt. siglvl,OMEGAV_mean_TOPO_pnew - OMEGAV_mean_CTR_pnew,diff_TOPO_CTR@_FillValue)
diff_TOPO_CTR_sig@units = OMEGAV_mean_TOPO@units
diff_TOPO_CTR_sig@long_name = OMEGAV_mean_TOPO@long_name

;------------ For over lay OMEGA
prob2 = ttest(OMEGA_mean_TOPO_pnew,OMEGA_std_TOPO_pnew^2,indep_sample,OMEGA_mean_CTR_pnew,OMEGA_std_CTR_pnew^2,indep_sample,True,False)

diff_TOPO_CTR2 = OMEGA_mean_TOPO_pnew ; metadata
diff_TOPO_CTR2 = OMEGA_mean_TOPO_pnew - OMEGA_mean_CTR_pnew
diff_TOPO_CTR2@units = OMEGA_mean_TOPO@units
diff_TOPO_CTR2@long_name = OMEGA_mean_TOPO@long_name

diff_TOPO_CTR2_sig = OMEGA_mean_TOPO_pnew ; metadata
diff_TOPO_CTR2_sig = where(prob .lt. siglvl,OMEGA_mean_TOPO_pnew - OMEGA_mean_CTR_pnew,diff_TOPO_CTR2@_FillValue)
diff_TOPO_CTR2_sig@units = OMEGA_mean_TOPO@units
diff_TOPO_CTR2_sig@long_name = OMEGA_mean_TOPO@long_name


printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)
printVarSummary(diff_TOPO_CTR2)
printVarSummary(diff_TOPO_CTR2_sig)

;================ plot ===========
;total 12 days in the TOPOTEST after branching

total_days = 7

do i_day = 0,total_days-1
;do i_day = 0,3
 
wks = gsn_open_wks("png","OMEGAV_TOPO_vs_CTR_iday_"+tostring(i_day+1))
wks_sig = gsn_open_wks("png","Sig_OMEGAV_TOPO_vs_CTR_iday_"+tostring(i_day+1))

res = True
;res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.5
res@cnMaxLevelValF = 0.5
res@cnLevelSpacingF = 0.1

;res@tiMainFontHeightF = 0.015

lat_t = -10.0
lon_1 = 260.0
lon_2 = 320.0

res@tiMainString = "OMEGAV, TOPO - CTR, ENS(180), iday="+tostring(i_day+1)

plot = gsn_csm_pres_hgt(wks,diff_TOPO_CTR(i_day,:,{lat_t},{lon_1:lon_2}),res)
plot_sig = gsn_csm_pres_hgt(wks_sig,diff_TOPO_CTR_sig(i_day,:,{lat_t},{lon_1:lon_2}),res)

;------- add OMEGA contour to it
res@cnFillOn = False
res@cnLinesOn = True

res@tiMainString = "" 
res@gsnLeftString = ""
res@gsnRightString = ""

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.7
res@cnMaxLevelValF = 0.7
res@cnLevelSpacingF = 0.02
res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.

plot2 = gsn_csm_pres_hgt(wks,diff_TOPO_CTR2(i_day,:,{lat_t},{lon_1:lon_2}),res)
plot2_sig = gsn_csm_pres_hgt(wks_sig,diff_TOPO_CTR2_sig(i_day,:,{lat_t},{lon_1:lon_2}),res)

;shading when Omega is below zero
opt                  = True
opt@gsnShadeFillType = "pattern"
opt@gsnShadeLow      = 3          ; slashes
plot2 = gsn_contour_shade(plot2,0, 0, opt)
plot2_sig = gsn_contour_shade(plot2_sig,0, 0, opt)

overlay(plot,plot2)
draw(plot)
frame(wks)

overlay(plot_sig,plot2_sig)
draw(plot_sig)
frame(wks_sig)

delete(res@gsnLeftString)
delete(res@gsnRightString)

end do ; do i_day 



end
