;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)
;Note: modified 20181002 for sim2

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

TOPO_dir = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_TOPO_1989_sim2_1989-12-01_HCforcing/atm/hist/Temp/"
TOPO_mean_str = "TEST_1989_h2.nc"

var_str = (/"HCforcing"/)

var = var_str

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

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

printVarSummary(HCforcing_mean_TOPO)

;================ plot ===========
;total 6hrs per batch in the TOPOTEST after branching

total_hrs = 96

do i_hr = 0,total_hrs-1
 
wks = gsn_open_wks("x11","8_EQ_transect_HCforcing_TOPO_ihr_"+tostring(i_hr+1))

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -10.0e-5
res@cnMaxLevelValF =  10.0e-5
res@cnLevelSpacingF = 5.0e-6

;res@tiMainFontHeightF = 0.015

;lat_t = -10.0
lat_t = 0.0
lon_1 = 260.0
lon_2 = 320.0

lev_1 = 300.0
lev_2 = 1000.0

res@gsnLeftString = "TOPO forcing"
res@gsnRightString = "K/s"
res@tiMainString = "ihr="+tostring(i_hr+1)
plot = gsn_csm_pres_hgt(wks,HCforcing_mean_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

end do ; do i_hr

end
