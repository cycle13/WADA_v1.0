;Function: Prototype NCL scripts to calculate NGMS (Raymond et al., 2009) from CCSM CMIP5 (AMIP) outputs.
;Date: 200180202
;Note: Finally, you want to redesign this as a function.

;load "/global/homes/h/hongcheq/Programming/NCL_funs_and_procs/funs_and_procs.ncl"
load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

output_file_name = "NGMS.Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

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

ps_fil = "ps/ps_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

hus_in = addfile(dir1+hus_fil,"r")
hus = new(dimsizes(hus_in->hus),double)
hus = hus_in->hus
;printVarSummary(hus)
;print(Calendar(hus&time))

ta_in = addfile(dir1+ta_fil,"r")
ta = new(dimsizes(ta_in->ta),double)
ta = ta_in->ta
;printVarSummary(ta)
;print(Calendar(ta&time))

zg_in = addfile(dir2+zg_fil,"r")
zg = new(dimsizes(zg_in->zg),double)
zg = zg_in->zg
;printVarSummary(zg)

ua_in = addfile(dir2+ua_fil,"r")
ua = new(dimsizes(ua_in->ua),double)
ua = ua_in->ua
;printVarSummary(ua)

va_in = addfile(dir2+va_fil,"r")
va = new(dimsizes(va_in->va),double)
va = va_in->va
;printVarSummary(va)

ps_in = addfile(dir2+ps_fil,"r")
ps = new(dimsizes(ps_in->ps),double)
ps = ps_in->ps
;printVarSummary(ps)

r = hus / (1.0-hus)   ; from specific humidity to water mixing ratio
copy_VarCoords(hus,r)
r@long_name = "water vapor mixing ratio"
;printVarSummary(r)

;====== MSE = Cp x T + g x geopotential height + Lv x r ========
MSE = 1005.7 * ta + 9.8 * zg + 2.501*10^6 * r
copy_VarCoords(hus,MSE)
MSE@long_name = "Moist Static Energy (Cp*T+g*z+Lv*r)"
MSE@units = "J/kg"
;printVarSummary(MSE)

us = ua * MSE
vs = va * MSE
copy_VarCoords(hus,us)
copy_VarCoords(hus,vs)
;printVarSummary(us)
;printVarSummary(vs)

div_numerator = uv2dv_cfd(us,vs,us&lat,us&lon,3)
copy_VarCoords(hus,div_numerator)

;printVarSummary(div_numerator)

;================Step 2: Calculate the denominator of NGMS;
ur = ua * r
vr = va * r
copy_VarCoords(hus,ur)
copy_VarCoords(hus,vr)
;printVarSummary(ur)
;printVarSummary(vr)

div_denominator = uv2dv_cfd(ur,vr,ur&lat,vr&lon,3)
copy_VarCoords(hus,div_denominator)
printVarSummary(div_denominator)

;=======Step 3: Use wgt_vertical_n function to calculate the NGMS, by vertically integral both the numerator and the denominator terms;

plev = div_numerator&plev                
ptop = min(plev)                   
dp = dpres_plevel_Wrap(plev,ps,ptop,0)
printVarSummary(dp)
print(plev)
print(ps(10,10,10))
print(dp(10,:,10,10))

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

inte_numerator = div_numerator(:,0,:,:)  ; metadata
printVarSummary(inte_numerator)
inte_denominator = div_denominator(:,0,:,:)  ; metadata
printVarSummary(inte_denominator)

do itime = 0,11
;do itime = 0, dimsizes(div_numerator&time)-1
print(itime)
   do ilev = 0, dimsizes(div_numerator&plev) -1
      do ilat = 0, dimsizes(div_numerator&lat) -1
         do ilon = 0, dimsizes(div_numerator&lon) -1
            inte_numerator(itime,ilat,ilon) = sum(div_numerator(itime,:,ilat,ilon)*dp(itime,:,ilat,ilon))
            inte_denominator(itime,ilat,ilon) = sum(div_denominator(itime,:,ilat,ilon)*dp(itime,:,ilat,ilon))
         end do
      end do 
   end do
end do
printVarSummary(inte_numerator)
printVarSummary(inte_denominator)

;==================Step 4: Finally, calculate the NGMS.
NGMS = inte_numerator ; metadata
NGMS = 300.0 * inte_numerator / (-1.0 * 2.501*10^6 * inte_denominator)
NGMS@long_name = "Normalized Gross Moist Stability, NGMS [Raymond et al., 2009]"
NGMS@units = "dimensionless"
printVarSummary(NGMS)

NGMS_clim_mon = clmMonTLL(NGMS)
NGMS_clim_mon@long_name = "NGMS, monthly climatology"
NGMS_clim_ann = dim_avg_n_Wrap(NGMS,0)
NGMS_clim_ann@long_name = "NGMS, multi-year annual mean"

Numerator = inte_numerator ; metadata
Numerator = 300.0 * inte_numerator
Denominator = inte_denominator ; metadata
Denominator = -1.0 * 2.501*10^6 * inte_denominator

printVarSummary(Numerator)
printVarSummary(Denominator)

;==================Step 5: Save NGMS(time,lat,lon) as nc file ======
system("rm -f /lustre/DATA/pritchard/hongcheq/WADA/pilot_test/"+output_file_name)
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/WADA/pilot_test/"+output_file_name,"c")
filedimdef(ncdf,"time",-1,True)

ncdf->NGMS = NGMS
ncdf->NGMS_clim_mon = NGMS_clim_mon
ncdf->NGMS_clim_ann = NGMS_clim_ann

ncdf->inte_numerator = inte_numerator
ncdf->inte_denominator = inte_denominator

ncdf->Numerator = Numerator
ncdf->Denominator = Denominator


end
