;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)
;Note: modified 20181002 for sim2

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

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

do i_str_time = 0,31
str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
end do

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"

var_str = (/"HCforcing"/)

var = var_str

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$

;printVarSummary(var_mean_TOPO)

;========== hybrid coordinate to pressure coordinate ====
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
pnew = fspan(100.0,1000.0,200)

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

DS_mean_TOPO = DS_mean_TOPO * 3600.0*24.0
DS_mean_TOPO@units = "K/day"

printVarSummary(HCforcing_mean_TOPO)
;--------------selection of critical lat and lon ---
;lat_t = -10.0
lat_t = 0.0
lon_1 = 260.0
lon_2 = 320.0

;lev_1 = 300.0
lev_1 = 100.0
lev_2 = 1000.0

;----------- Add topography ------
f_TOPO = addfile(prefix+"/scratch/hongcheq/NERSC_Cori_WADA_simulation/F_AMIP_CAM5_WADA_TOPO_1998_sim2_1998-12-01_HCforcing/atm/hist/F_AMIP_CAM5_WADA_TOPO_1998_sim2_1998-12-01_HCforcing.cam.h1.1998-12-05-00000.nc","r")
PHIS = f_TOPO->PHIS
hgt = PHIS(0,{lat_t},{lon_1:lon_2})  ; metadata and dimension
hgt = hgt/9.8
hgt@units = "m"   ; gpm
gp = 1013*(1-6.5/288000*hgt)^5.255  ; convert m to hPa using Standard Atmosphere
gp@units = "hPa"
copy_VarCoords(hgt,gp)
printVarSummary(gp)

;================ plot ===========
;total 6hrs per batch in the TOPOTEST after branching

total_hrs = 3

DS_mean_TOPO = -DS_mean_TOPO ; show CTR - TOPO, rather than TOPO

do i_hr = 0,total_hrs-1
 
;wks = gsn_open_wks("png","../Figures/5_EQ_transect_HCforcing_TOPO_ihr_"+tostring(index*3+i_hr+1))
wks = gsn_open_wks("png","../Figures/5_EQ_transect_to100hPa_HCforcing_CTRheat_ihr_"+tostring(index*3+i_hr+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -20.0
res@cnMaxLevelValF =  20.0
res@cnLevelSpacingF = 2.0

;res@tiMainFontHeightF = 0.015

res@gsnLeftString = "forcing_CTRheat"
res@gsnRightString = "K/day"


plot = gsn_csm_pres_hgt(wks,DS_mean_TOPO(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;------add topography ----
mres   = True
mres@gsnLeftString       = " "
mres@gsnRightString      = " "
mres@gsnDraw             = False                ; do not draw the plot
mres@gsnFrame            = False                ; do not advance the frame
mres@xyLineThicknesses   = (/3.0/)              ; make line thicker
mres@xyLineColors        = (/"black"/)          ; change line color

mres@gsnBelowYRefLineColor = (/ "black", "black"/)  
mres@gsnYRefLine           = (/ lev_1 ,lev_2 /)   

plot_topo  = gsn_csm_xy(wks,gp&lon,gp,mres)         ; overlay geopotential 'pressure' line
overlay(plot,plot_topo)
;draw(plot)
;frame(wks)

;============ panel plot ====

; use 75W as the center, then 
str_LST = (/"20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"/)

pres = True
pres@txString = "EQ transect, ENS(180), ihr="+tostring(index*3+i_hr+1) +", LST_75W ("+str_LST(mod(index*3+i_hr,24))+")"

gsn_panel(wks,plot,(/1,1/),pres)

end do ; do i_hr 

end do ; do index
end
