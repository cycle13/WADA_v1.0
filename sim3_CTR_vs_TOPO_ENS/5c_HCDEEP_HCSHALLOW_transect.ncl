;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)
;Note: modified 20181002 for sim2

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;------------ As a correction to HCDEEP and HCSHALLOW --------
;------------- the real TOPO forcing are HCDEEP * (-1) * (sgh_hgfrac(i) -1)
f_SGH30 = addfile("/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
sgh30 = f_SGH30->SGH30

sgh_htfrac = new((/96,144/),float)

do i=0,95
do j=0,143
    if (sgh30(i,j) .lt. 100.0) then
           sgh_htfrac(i,j) = 1.0
    else if (sgh30(i,j) .lt. 200.0) then
            sgh_htfrac(i,j) = 1.0 - ((tofloat(sgh30(i,j)) - 100.0) / 100.0)
           sgh_htfrac(i,j) = -0.01 * tofloat(sgh30(i,j)) + 2.0
    else
           sgh_htfrac(i,j) = 0.0
    end if
    end if
end do
end do
printVarSummary(sgh_htfrac)

;===================================

str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,7

TOPO_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"

var_str = (/"HCDEEP","HCSHALLOW"/)

do i_var = 0, dimsizes(var_str)-1
var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

do i_lat = 0,95
do i_lon = 0,143
var_mean_TOPO(:,:,i_lat,i_lon) = var_mean_TOPO(:,:,i_lat,i_lon) * (-1.0) * (sgh_htfrac(i_lat,i_lon)-1.0)
end do
end do

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

if (i_var .eq. 0) then
   HCDEEP_mean_TOPO = var_mean_TOPO_pnew
else
   HCSHALLOW_mean_TOPO = var_mean_TOPO_pnew 
end if

end do ; do ivar

DS_mean_TOPO  = HCDEEP_mean_TOPO ; meta data
DS_mean_TOPO = HCDEEP_mean_TOPO + HCSHALLOW_mean_TOPO

printVarSummary(HCDEEP_mean_TOPO)
printVarSummary(HCSHALLOW_mean_TOPO)
printVarSummary(DS_mean_TOPO)

;================ plot ===========
;total 6hrs per batch in the TOPOTEST after branching

total_hrs = 6

plot = new(3,graphic)

do i_hr = 0,total_hrs-1
 
wks = gsn_open_wks("png","5_HCDEEP_HCSHALLOW_TOPO_ihr_"+tostring(index*6+i_hr+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -10.0e-5
res@cnMaxLevelValF =  10.0e-5
res@cnLevelSpacingF = 5.0e-6

;res@tiMainFontHeightF = 0.015

lat_t = -10.0
lon_1 = 260.0
lon_2 = 320.0

lev_1 = 300.0
lev_2 = 1000.0

res@gsnLeftString = "DEEP forcing"
res@gsnRightString = "K/s"
plot(0) = gsn_csm_pres_hgt(wks,HCDEEP_mean_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@gsnLeftString = "SHALLOW forcing"
res@gsnRightString = "K/s"
plot(1) = gsn_csm_pres_hgt(wks,HCSHALLOW_mean_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

res@gsnLeftString = "DEEP+SHALLOW forcing"
res@gsnRightString = "K/s"
plot(2) = gsn_csm_pres_hgt(wks,DS_mean_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;============ panel plot ====

; use 75W as the center, then 
str_LST = (/"20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"/)

pres = True
pres@txString = "TOPO, ENS(180), ihr="+tostring(index*6+i_hr+1) +", LST_75W ("+str_LST(mod(index*6+i_hr,24))+")"

gsn_panel(wks,plot,(/1,3/),pres)

end do ; do i_hr 

end do ; do index
end
