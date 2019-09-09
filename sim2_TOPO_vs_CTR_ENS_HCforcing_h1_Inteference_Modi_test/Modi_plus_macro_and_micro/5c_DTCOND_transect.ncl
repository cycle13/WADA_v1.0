;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)
;Note: modified 20181002 for sim2

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD/"

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes_EVAPPREC/TOPO00/"
TOPO_mean_str = "ENS.mean.TOPOTEST.nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes_EVAPPREC/CTR/"
CTR_mean_str = "ENS.mean.CTR.nc"

var_str = (/"DTCOND"/)

var = var_str

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
var_mean_TOPO = f_TOPO_mean->$var$

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
var_mean_CTR = f_CTR_mean->$var$

;printVarSummary(var_mean_TOPO)

;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)

P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_mean_TOPO_pnew&lev_p@units = "hPa" 

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev_p@units = "hPa" 


DS_mean_TOPO  = var_mean_TOPO_pnew ; meta data
DS_mean_TOPO = DS_mean_TOPO * 24 * 3600  
DS_mean_TOPO@units = "K/day"

DS_mean_CTR  = var_mean_CTR_pnew ; meta data
DS_mean_CTR = DS_mean_CTR * 24 * 3600
DS_mean_CTR@units = "K/day"

printVarSummary(DS_mean_TOPO)
printVarSummary(DS_mean_CTR)

TOPO_CTR_diff = DS_mean_TOPO ; metadata
TOPO_CTR_diff = DS_mean_TOPO - DS_mean_CTR(0:3,:,:,:) ; CTR has 12 days, but TOPO only has 4 days.

;================ plot ===========
;total 6hrs per batch in the TOPOTEST after branching

total_days = 4

lat_t = -10.0

plot = new(3,graphic)

do i_day = 0,total_days-1
 
wks = gsn_open_wks("png","./Figures/5_10S_DTCOND_iday_"+tostring(i_day+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -40.
res@cnMaxLevelValF =  40.
res@cnLevelSpacingF = 4.0

;res@tiMainFontHeightF = 0.015

lon_1 = 260.0
lon_2 = 320.0

lev_1 = 100.0
lev_2 = 1000.0

res@gsnLeftString = "TOPO DTCOND"
plot(0) = gsn_csm_pres_hgt(wks,DS_mean_TOPO(i_day,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@gsnLeftString = "CTR DTCOND"
plot(1) = gsn_csm_pres_hgt(wks,DS_mean_CTR(i_day,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@gsnLeftString = "TOPO-CTR DTCOND"
plot(2) = gsn_csm_pres_hgt(wks,TOPO_CTR_diff(i_day,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;============ panel plot ====

pres = True
pres@txString = "ENS(9), iday="+tostring(i_day+1) +", lat=" + sprintf("%5.1f",lat_t)

gsn_panel(wks,plot,(/3,1/),pres)

end do ; do i_day 

end
