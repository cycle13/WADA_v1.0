;Function: Prototype NCL scripts to calculate NGMS (Raymond et al., 2009) from CCSM CMIP5 (AMIP) outputs.
;Date: 200180202
;Date: 20180214, tinkering.
;Note: Finally, you want to redesign this as a function.

;load "/global/homes/h/hongcheq/Programming/NCL_funs_and_procs/funs_and_procs.ncl"
load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

output_file_name = "Vertical_regridding.Test.NGMS.Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

;=============Step 1: Calculate the numerator of  NGMS;
;dir1 = "/global/cscratch1/sd/terai/cmip5/"
dir1 = "/lustre/DATA/pritchard/hongcheq/CMIP5/"

;dir2 = "/project/projectdirs/m2840/hongcheq/CMIP5/"
dir2 = "/lustre/DATA/pritchard/hongcheq/CMIP5/"

hus_fil = "hus/hus_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ta_fil = "ta/ta_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

zg_fil = "zg/zg_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ua_fil = "ua/ua_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
va_fil = "va/va_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
wap_fil = "wap/wap_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

ps_fil = "ps/ps_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

smth9_p = 0.50
smth9_q = 0.25

; test if regridding can help 

lat_reading = addfile(dir2+hus_fil,"r")
;lat_o = lat_reading->lat
;lon_o = fspan(0.0,360.0,361)
;lat_o = fspan(-90.0,90.0,181)
;lat_o = hus_in&lat
;printVarSummary(lat_o)
;printVarSummary(lon_o)

;---------------------
;----Test if vertical gridding to finer grid can help ---------
pout = (/100000.,95000.,92500.,89000.,85000.,78000.,70000.,65000.,60000.,55000.,50000.,45000.,40000.,35000.,30000.,27500.,25000.,22500.,20000.,17500.,15000.,12500.,10000.,8500.,7000., 6000.,5000,4000.,3000,2500.,2000,1500.,1000/)

plev_original = lat_reading->plev
;print(plev_original)

;--------- Note: In your first try, you did the vertical regridding before averaging over time, but the program says "Killed". Is it due to memory issues? ------
;--------  This time, tries averaging first, then vertical regridding ----

;----------------------
hus_in = addfile(dir1+hus_fil,"r")
hus = new(dimsizes(hus_in->hus),double)
hus = hus_in->hus
hus_smth = smth9_Wrap(hus,smth9_p,smth9_q,True)
;hus_regrid =  linint2_Wrap(hus&lon,hus&lat,hus_smth,True,lon_o,lat_o,0)
hus_clim_temp = dim_avg_n_Wrap(hus_smth,0)
hus_clim = int2p_n_Wrap(plev_original,hus_clim_temp,pout,2,0)
;hus_clim = dim_avg_n_Wrap(hus_regrid,0)
;printVarSummary(hus)
printVarSummary(hus_clim)
;print(Calendar(hus&time))

ta_in = addfile(dir1+ta_fil,"r")
ta = new(dimsizes(ta_in->ta),double)
ta = ta_in->ta
ta_smth = smth9_Wrap(ta,smth9_p,smth9_q,True)
;ta_regrid =  linint2_Wrap(ta&lon,ta&lat,ta_smth,True,lon_o,lat_o,0)
ta_clim_temp = dim_avg_n_Wrap(ta_smth,0)
ta_clim = int2p_n_Wrap(plev_original,ta_clim_temp,pout,2,0)
printVarSummary(ta_clim)

;ta_clim = dim_avg_n_Wrap(ta_regrid,0)
;printVarSummary(ta)
;print(Calendar(ta&time))

zg_in = addfile(dir2+zg_fil,"r")
zg = new(dimsizes(zg_in->zg),double)
zg = zg_in->zg
zg_smth = smth9_Wrap(zg,smth9_p,smth9_q,True)
;zg_regrid =  linint2_Wrap(zg&lon,zg&lat,zg_smth,True,lon_o,lat_o,0)
zg_clim_temp = dim_avg_n_Wrap(zg_smth,0)
zg_clim = int2p_n_Wrap(plev_original,zg_clim_temp,pout,2,0)
;zg_clim = dim_avg_n_Wrap(zg_regrid,0)
;printVarSummary(zg)
printVarSummary(zg_clim)

ua_in = addfile(dir2+ua_fil,"r")
ua = new(dimsizes(ua_in->ua),double)
ua = ua_in->ua
ua_smth = smth9_Wrap(ua,smth9_p,smth9_q,True)
;ua_regrid =  linint2_Wrap(ua&lon,ua&lat,ua_smth,True,lon_o,lat_o,0)
ua_clim_temp = dim_avg_n_Wrap(ua_smth,0)
ua_clim = int2p_n_Wrap(plev_original,ua_clim_temp,pout,2,0)
;ua_clim = dim_avg_n_Wrap(ua_regrid,0)
;printVarSummary(ua)
printVarSummary(ua_clim)

va_in = addfile(dir2+va_fil,"r")
va = new(dimsizes(va_in->va),double)
va = va_in->va
va_smth = smth9_Wrap(va,smth9_p,smth9_q,True)
;va_regrid =  linint2_Wrap(va&lon,va&lat,va_smth,True,lon_o,lat_o,0)
va_clim_temp = dim_avg_n_Wrap(va_smth,0)
va_clim = int2p_n_Wrap(plev_original,va_clim_temp,pout,2,0)
;va_clim = dim_avg_n_Wrap(va_regrid,0)
;printVarSummary(va)
printVarSummary(va_clim)

wap_in = addfile(dir2+wap_fil,"r")
wap = new(dimsizes(wap_in->wap),double)
wap = wap_in->wap
wap_smth = smth9_Wrap(wap,smth9_p,smth9_q,True)
;wap_regrid =  linint2_Wrap(wap&lon,wap&lat,wap_smth,True,lon_o,lat_o,0)
wap_clim_temp = dim_avg_n_Wrap(wap_smth,0)
wap_clim = int2p_n_Wrap(plev_original,wap_clim_temp,pout,2,0)
;wap_clim = dim_avg_n_Wrap(wap_regrid,0)
;printVarSummary(wap)
printVarSummary(wap_clim)

ps_in = addfile(dir2+ps_fil,"r")
ps = new(dimsizes(ps_in->ps),double)
ps = ps_in->ps
ps_smth = smth9_Wrap(ps,smth9_p,smth9_q,True)
;ps_regrid =  linint2_Wrap(ps&lon,ps&lat,ps_smth,True,lon_o,lat_o,0)
ps_clim = dim_avg_n_Wrap(ps_smth,0)
;ps_clim = dim_avg_n_Wrap(ps_regrid,0)
;printVarSummary(ps)
printVarSummary(ps_clim)

r = hus / (1.0-hus)   ; from specific humidity to water mixing ratio
copy_VarCoords(hus,r)
r@long_name = "water vapor mixing ratio"
printVarSummary(r)

r_clim = hus_clim / (1.0-hus_clim)   ; from specific humidity to water mixing ratio
copy_VarCoords(hus_clim,r_clim)
r_clim@long_name = "water vapor mixing ratio, climatology"

;====== MSE = Cp x T + g x geopotential height + Lv x r ========
MSE = 1005.7 * ta_clim + 9.8 * zg_clim + 2.501*10^6 * r_clim
copy_VarCoords(hus_clim,MSE)
MSE@long_name = "Moist Static Energy (Cp*T+g*z+Lv*r)"
MSE@units = "J/kg"
printVarSummary(MSE)

;us = ua * MSE
;vs = va * MSE
;copy_VarCoords(hus,us)
;copy_VarCoords(hus,vs)
;;printVarSummary(us)
;;printVarSummary(vs)
;
;div_numerator = uv2dv_cfd(us,vs,us&lat,us&lon,3)
;copy_VarCoords(hus,div_numerator)
;
;;printVarSummary(div_numerator)
;

;-------------- Use advective forms to calculate the numerator and denominator------
;Check if lon is in equal space!
dlon = (MSE&lon(2)-MSE&lon(1))*0.0174533 ; convert to radians
dMSEdx = MSE ; metadata
dMSEdx@long_name = "partile MSE / partial x"
dMSEdx@units = "J/kg/meter"

do ilat=0,dimsizes(MSE&lat)-1                      ; loop over each latitude
   dx = 6378388.*cos(0.0174533*MSE&lat(ilat))*dlon  ; constant at this latitude
   dMSEdx(:,ilat:ilat,:) = center_finite_diff_n(MSE(:,ilat:ilat,:),dx,True,0,2)
end do
printVarSummary(dMSEdx)

dMSEdy = MSE ; metadata
dMSEdy@long_name = "partile MSE / partial y"
dMSEdy@units = "J/kg/meter"

y_meri = 6378388.*(0.0174533*MSE&lat)    ; 
dMSEdy = center_finite_diff_n(MSE,y_meri,False,0,1)    ; not cyclic on different lat lines
printVarSummary(dMSEdy)

dMSEdp = MSE ; metadata
dMSEdp@long_name = "partile MSE / partial p"
dMSEdp@units = "J/kg/Pa"

dMSEdp = center_finite_diff_n(MSE,MSE&PLEV,False,0,0)
printVarSummary(dMSEdp)

MSE_nume = MSE ; meta data
MSE_nume@long_name = "horizontal + vertical advection (in p-coordinate) of MSE"
MSE_nume@units = "J/kg/sec"
MSE_nume = ua_clim*dMSEdx + va_clim*dMSEdy + wap_clim*dMSEdp
printVarSummary(MSE_nume)

MSE_nume_hori = ua_clim*dMSEdx + va_clim*dMSEdy
MSE_nume_vert = wap_clim*dMSEdp

;================Step 2: Calculate the denominator of NGMS;
;ur = ua * r
;vr = va * r
;copy_VarCoords(hus,ur)
;copy_VarCoords(hus,vr)
;;printVarSummary(ur)
;;printVarSummary(vr)
;
;div_denominator = uv2dv_cfd(ur,vr,ur&lat,vr&lon,3)
;copy_VarCoords(hus,div_denominator)
;printVarSummary(div_denominator)
;
drdx = MSE ; metadata
drdx@long_name = "partile r / partial x"
drdx@units = "1/meter"

do ilat=0,dimsizes(r_clim&lat)-1                      ; loop over each latitude
   dx = 6378388.*cos(0.0174533*r_clim&lat(ilat))*dlon  ; constant at this latitude
   drdx(:,ilat:ilat,:) = center_finite_diff_n(r_clim(:,ilat:ilat,:),dx,True,0,2)
end do
printVarSummary(drdx)

drdy = MSE ; metadata
drdy@long_name = "partile r / partial y"
drdy@units = "1/meter"

y_meri = 6378388.*(0.0174533*r_clim&lat)    ; 
drdy = center_finite_diff_n(r_clim,y_meri,False,0,1)    ; not cyclic on different lat lines
printVarSummary(drdy)

drdp = MSE ; metadata
drdp@long_name = "partile r / partial p"
drdp@units = "1/Pa"

drdp = center_finite_diff_n(r_clim,r_clim&PLEV,False,0,0)
printVarSummary(drdp)

r_deno = r_clim ; meta data
r_deno@long_name = "horizontal + vertical advection (in p-coordinate) of r"
r_deno@units = "1/sec"
r_deno = ua_clim*drdx + va_clim*drdy + wap_clim*drdp
printVarSummary(r_deno)

;=======Step 3: Use wgt_vertical_n function to calculate the NGMS, by vertically integral both the numerator and the denominator terms;

plev = MSE&PLEV                
ptop = min(plev)                   
dp = dpres_plevel_Wrap(plev,ps_clim,ptop,0)
printVarSummary(dp)
print(plev)
print(ps_clim(10,10))
print(dp(:,10,10))

;vopt = 1  ; vertically weighted sum
;inte_numerator = wgt_vertical_n(div_numerator,dp,vopt, 1)  ; (time,lat,lon)
;inte_numerator = 300.0 * inte_numerator
;inte_numerator@long_name = "numerator of NGMS, eq 2.3 in Raymond et al., [2009]"
;printVarSummary(inte_numerator)
;
;inte_denominator = wgt_vertical_n(div_denominator,dp,vopt,1)  ; (time,lat,lon)
;inte_denominator = -1.0 * 2.501*10^6 * inte_denominator
;inte_denominator@long_name = "denominator of NGMS, eq 2.3 in Raymond et al., [2009]"
;printVarSummary(inte_denominator)
;
;============= Step 3: Vertical integral 
;============== (wgt_vertical_n requires NO Missing data in the first parameter, so use sum(A * B) instead ====

inte_numerator = MSE_nume(0,:,:)  ; metadata
inte_numerator_hori = MSE_nume(0,:,:)  ; metadata
inte_numerator_vert = MSE_nume(0,:,:)  ; metadata

inte_denominator = r_deno(0,:,:)  ; metadata

;do itime = 0,5
;do itime = 0, dimsizes(div_numerator&time)-1
;print(itime)
   do ilev = 0, dimsizes(MSE_nume&PLEV) -1
      do ilat = 0, dimsizes(MSE_nume&lat) -1
         do ilon = 0, dimsizes(MSE_nume&lon) -1
            inte_numerator(ilat,ilon) = sum(MSE_nume(:,ilat,ilon)*dp(:,ilat,ilon))
            inte_denominator(ilat,ilon) = sum(r_deno(:,ilat,ilon)*dp(:,ilat,ilon))
            inte_numerator_hori(ilat,ilon) = sum(MSE_nume_hori(:,ilat,ilon)*dp(:,ilat,ilon))
            inte_numerator_vert(ilat,ilon) = sum(MSE_nume_vert(:,ilat,ilon)*dp(:,ilat,ilon))

         end do
      end do 
   end do
;end do
inte_numerator = inte_numerator/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_numerator_hori = inte_numerator_hori/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_numerator_vert = inte_numerator_vert/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_denominator = inte_denominator/9.8

inte_numerator@long_name = "vertical integral of (horizontal & vertical advection of MSE) over pressure"
inte_numerator@units = "Watts/m2 / Kelvin"
inte_denominator@long_name = "vertical integral of (horizontal & vertical advection of r) over pressure"
inte_denominator@units = "Watts/m2 / (J/kg)"

printVarSummary(inte_numerator)
printVarSummary(inte_denominator)

;==================Step 4: Finally, calculate the NGMS.
NGMS = inte_numerator ; metadata
NGMS = 300.0 * inte_numerator / (-1.0 * 2.501*10^6 * inte_denominator)
NGMS@long_name = "Normalized Gross Moist Stability, NGMS [Raymond et al., 2009], calculated in advection form, rather than the original flux form"
NGMS@units = "dimensionless"
printVarSummary(NGMS)

Numerator = inte_numerator ; metadata
Numerator = 300.0 * inte_numerator
Numerator@units = "watts/m2"
Denominator = inte_denominator ; metadata
Denominator = -1.0 * 2.501*10^6 * inte_denominator
Denominator@units = "watts/m2"

printVarSummary(Numerator)
printVarSummary(Denominator)

;==================Step 5: Save NGMS(time,lat,lon) as nc file ======
system("rm -f /lustre/DATA/pritchard/hongcheq/WADA/pilot_test/"+output_file_name)
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/WADA/pilot_test/"+output_file_name,"c")
filedimdef(ncdf,"time",-1,True)

ncdf->NGMS = NGMS

ncdf->inte_numerator = inte_numerator
ncdf->inte_numerator_hori = inte_numerator_hori
ncdf->inte_numerator_vert = inte_numerator_vert

ncdf->inte_denominator = inte_denominator

ncdf->Numerator = Numerator
ncdf->Denominator = Denominator


end
