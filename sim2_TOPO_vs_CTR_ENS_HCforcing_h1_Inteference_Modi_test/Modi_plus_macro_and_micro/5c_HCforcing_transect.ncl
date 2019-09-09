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

var_str = (/"HCforcing"/)

var = var_str

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

;do i_lat = 0,95
;do i_lon = 0,143
;var_mean_TOPO(:,:,i_lat,i_lon) = var_mean_TOPO(:,:,i_lat,i_lon) * (-1.0) * (sgh_htfrac(i_lat,i_lon)-1.0)
;end do
;end do

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
;printVarSummary(var_mean_TOPO_pnew&lev_p)

   HCforcing_mean_TOPO = var_mean_TOPO_pnew

DS_mean_TOPO  = HCforcing_mean_TOPO ; meta data
DS_mean_TOPO = DS_mean_TOPO * 24 * 3600 
DS_mean_TOPO@units = "K/day"

;================ plot ===========
;total 6hrs per batch in the TOPOTEST after branching

total_days = 4

lat_t = -10.0

do i_day = 0,total_days-1
 
wks = gsn_open_wks("png","./Figures/5_10S_HCforcing_TOPO_iday_"+tostring(i_day+1))

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

res@gsnLeftString = "TOPO forcing"
plot = gsn_csm_pres_hgt(wks,DS_mean_TOPO(i_day,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;============ panel plot ====

; use 75W as the center, then 
str_LST = (/"20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"/)

pres = True
pres@txString = "TOPO, ENS(9), iday="+tostring(i_day+1) +", lat=" + sprintf("%5.1f",lat_t)

gsn_panel(wks,plot,(/1,1/),pres)

end do ; do i_day 

end
