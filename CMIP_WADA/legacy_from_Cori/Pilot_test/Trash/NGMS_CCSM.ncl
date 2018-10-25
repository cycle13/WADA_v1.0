;Function: Prototype NCL scripts to calculate NGMS (Raymond et al., 2009) from CCSM CMIP5 (AMIP) outputs.
;Date: 20080202
;Note: Finally, you want to reconstruct this as a function.

load "/global/homes/h/hongcheq/Programming/NCL_funs_and_procs/funs_and_procs.ncl"

begin

;Step 1: Calculate the numerator of  NGMS;
dir1 = "/global/cscratch1/sd/terai/cmip5/"

dir2 = "/project/projectdirs/m2840/hongcheq/CMIP5/"

hus_fil = "hus/hus_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ta_fil = "ta/ta_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

zg_fil = "zg/zg_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ua_fil = "ua/ua_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
va_fil = "va/va_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

ps_fil = "ps/ps_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

hus_in = addfile(dir1+hus_fil,"r")
hus = hus_in->hus
;printVarSummary(hus)
;print(Calendar(hus&time))

ta_in = addfile(dir1+ta_fil,"r")
ta = ta_in->ta
;printVarSummary(ta)
;print(Calendar(ta&time))

zg_in = addfile(dir2+zg_fil,"r")
zg = zg_in->zg
;printVarSummary(zg)

ua_in = addfile(dir2+ua_fil,"r")
ua = ua_in->ua
;printVarSummary(ua)

va_in = addfile(dir2+va_fil,"r")
va = va_in->va
;printVarSummary(va)

ps_in = addfile(dir2+ps_fil,"r")
ps = ps_in->ps
;printVarSummary(ps)

r = hus / (1-hus)   ; from specific humidity to water mixing ratio
copy_VarCoords(hus,r)
r@long_name = "water vapor mixing ratio"
;printVarSummary(r)

;====== MSE = Cp x T + g x geopotential height + Lv x r ========
MSE = 1005.7 * ta + 9.8 * zg + 2.5*10^6 * r
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

printVarSummary(div_numerator)

;Step 2: Calculate the denominator of NGMS;

ur = ua * r
vr = va * r
copy_VarCoords(hus,ur)
copy_VarCoords(hus,vr)
;printVarSummary(ur)
;printVarSummary(vr)

div_denominator = uv2dv_cfd(ur,vr,ur&lat,vr&lon,3)
copy_VarCoords(hus,div_denominator)
printVarSummary(div_denominator)

;Step 3: Use wgt_vertical_n function to calculate the NGMS, by vertically integral both the numerator and the denominator terms;

plev = div_numerator&plev                
ptop = min(plev)                   
dp = dpres_plevel_Wrap(plev,ps,ptop,0)
printVarSummary(dp)
if (any(ismissing(dp))) then
print(dp(0,:,0,0))
print("dp contains missing values")

end if
exit

vopt = 1  ; vertically weighted sum
inte_numerator = wgt_vertical_n(div_numerator,dp,vopt, 1)  ; (time,lat,lon)
inte_numerator = 300.0 * inte_numerator
inte_numerator@long_name = "numerator of NGMS, eq 2.3 in Raymond et al., [2009]"
printVarSummary(inte_numerator)

inte_denominator = wgt_vertical_n(div_denominator,dp,vopt,1)  ; (time,lat,lon)
inte_denominator = -1.0 * 2.501*10^6 * inte_denominator
inte_denominator@long_name = "denominator of NGMS, eq 2.3 in Raymond et al., [2009]"
printVarSummary(inte_denominator)

;Step 4: Finally, calculate the NGMS.

;NGMS = 







end
