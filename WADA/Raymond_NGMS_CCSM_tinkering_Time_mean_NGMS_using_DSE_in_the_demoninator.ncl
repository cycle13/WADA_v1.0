;Function: Prototype NCL scripts to calculate NGMS (Raymond et al., 2009) from CCSM CMIP5 (AMIP) outputs.
;Date: 200180202
;Date: 20180214, tinkering.
;Note: Finally, you want to redesign this as a function.

;load "/global/homes/h/hongcheq/Programming/NCL_funs_and_procs/funs_and_procs.ncl"
load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

output_file_name = "Raymond.NGMS.Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

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

;---------------------
hus_in = addfile(dir1+hus_fil,"r")
hus = new(dimsizes(hus_in->hus),double)
hus = hus_in->hus
hus_clim = dim_avg_n_Wrap(hus,0)          ; Use specific humidity to approximate water mixing ratio

;hus_smth = smth9_Wrap(hus,smth9_p,smth9_q,True)
;hus_clim = dim_avg_n_Wrap(hus_smth,0)

;printVarSummary(hus)
printVarSummary(hus_clim)
;print(Calendar(hus&time))

ta_in = addfile(dir1+ta_fil,"r")
ta = new(dimsizes(ta_in->ta),double)
ta = ta_in->ta
ta_clim = dim_avg_n_Wrap(ta,0)
;ta_smth = smth9_Wrap(ta,smth9_p,smth9_q,True)
;ta_clim = dim_avg_n_Wrap(ta_smth,0)
;printVarSummary(ta)
;print(Calendar(ta&time))

zg_in = addfile(dir2+zg_fil,"r")
zg = new(dimsizes(zg_in->zg),double)
zg = zg_in->zg
zg_clim = dim_avg_n_Wrap(zg,0)
;zg_smth = smth9_Wrap(zg,smth9_p,smth9_q,True)
;zg_clim = dim_avg_n_Wrap(zg_smth,0)
;printVarSummary(zg)

ua_in = addfile(dir2+ua_fil,"r")
ua = new(dimsizes(ua_in->ua),double)
ua = ua_in->ua
ua_clim = dim_avg_n_Wrap(ua,0)
;ua_smth = smth9_Wrap(ua,smth9_p,smth9_q,True)
;ua_clim = dim_avg_n_Wrap(ua_smth,0)
;printVarSummary(ua)

va_in = addfile(dir2+va_fil,"r")
va = new(dimsizes(va_in->va),double)
va = va_in->va
va_clim = dim_avg_n_Wrap(va,0)
;va_smth = smth9_Wrap(va,smth9_p,smth9_q,True)
;va_clim = dim_avg_n_Wrap(va_smth,0)
;printVarSummary(va)

wap_in = addfile(dir2+wap_fil,"r")
wap = new(dimsizes(wap_in->wap),double)
wap = wap_in->wap
wap_clim = dim_avg_n_Wrap(wap,0)
;wap_smth = smth9_Wrap(wap,smth9_p,smth9_q,True)
;wap_clim = dim_avg_n_Wrap(wap_smth,0)
;printVarSummary(wap)

ps_in = addfile(dir2+ps_fil,"r")
ps = new(dimsizes(ps_in->ps),double)
ps = ps_in->ps
ps_clim = dim_avg_n_Wrap(ps,0)
;ps_smth = smth9_Wrap(ps,smth9_p,smth9_q,True)
;ps_clim = dim_avg_n_Wrap(ps_smth,0)
;printVarSummary(ps)

;====== MSE = Cp x T + g x geopotential height + Lv x r ========
MSE = 1005.7 * ta_clim + 9.8 * zg_clim + 2.501*10^6 * hus_clim

copy_VarCoords(hus_clim,MSE)
MSE@long_name = "Moist Static Energy (Cp*T+g*z+Lv*r)"
MSE@units = "J/kg"
printVarSummary(MSE)

;DSE =  1005.7 * ta_clim + 9.8 * zg_clim
;copy_VarCoords(MSE,DSE)
;DSE@long_name = "Dry Static Energy (Cp*T+g*z)"
;DSE@units = "J/kg"
;printVarSummary(DSE)

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

dMSEdp = center_finite_diff_n(MSE,MSE&plev,False,0,0)
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

dqdx = MSE ; metadata
dqdx@long_name = "partile q / partial x"
dqdx@units = "1/meter"

do ilat=0,dimsizes(MSE&lat)-1                      ; loop over each latitude
   dx = 6378388.*cos(0.0174533*MSE&lat(ilat))*dlon  ; constant at this latitude
   dqdx(:,ilat:ilat,:) = center_finite_diff_n(hus_clim(:,ilat:ilat,:),dx,True,0,2)
end do
printVarSummary(dqdx)

dqdy = MSE ; metadata
dqdy@long_name = "partile q / partial y"
dqdy@units = "1/meter"

y_meri = 6378388.*(0.0174533*hus_clim&lat)    ; 
dqdy = center_finite_diff_n(hus_clim,y_meri,False,0,1)    ; not cyclic on different lat lines
printVarSummary(dqdy)

dqdp = MSE ; metadata
dqdp@long_name = "partile q / partial p"
dqdp@units = "1/Pa"

dqdp = center_finite_diff_n(hus_clim,hus_clim&plev,False,0,0)
printVarSummary(dqdp)

q_deno = hus_clim ; meta data
q_deno@long_name = "horizontal + vertical advection (in p-coordinate) of q"
q_deno@units = "1/sec"
q_deno = ua_clim*dqdx + va_clim*dqdy + wap_clim*dqdp
printVarSummary(q_deno)

;=======Step 3: Use wgt_vertical_n function to calculate the NGMS, by vertically integral both the numerator and the denominator terms;

plev = MSE&plev                
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

inte_denominator = q_deno(0,:,:)  ; metadata

MSE_column_test = MSE(0,:,:) ; metadata and test if the you are calculating the column MSE correctly. 

;do itime = 0,5
;do itime = 0, dimsizes(div_numerator&time)-1
;print(itime)
   do ilev = 0, dimsizes(MSE_nume&plev) -1
      do ilat = 0, dimsizes(MSE_nume&lat) -1
         do ilon = 0, dimsizes(MSE_nume&lon) -1
            inte_numerator(ilat,ilon) = sum(MSE_nume(:,ilat,ilon)*dp(:,ilat,ilon))
            inte_denominator(ilat,ilon) = sum(q_deno(:,ilat,ilon)*dp(:,ilat,ilon))
            inte_numerator_hori(ilat,ilon) = sum(MSE_nume_hori(:,ilat,ilon)*dp(:,ilat,ilon))
            inte_numerator_vert(ilat,ilon) = sum(MSE_nume_vert(:,ilat,ilon)*dp(:,ilat,ilon))
            MSE_column_test(ilat,ilon) = sum(MSE(:,ilat,ilon)*dp(:,ilat,ilon))
         end do
      end do 
   end do
;end do
inte_numerator = inte_numerator/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_numerator_hori = inte_numerator_hori/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_numerator_vert = inte_numerator_vert/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_denominator = inte_denominator/9.8
MSE_column_test = MSE_column_test/9.8
MSE_column_test@long_name = "Column MSE"
MSE_column_test@units = "J/m2"

inte_numerator@long_name = "vertical integral of (horizontal & vertical advection of MSE) over pressure"
inte_numerator@units = "Watts/m2 / Kelvin"
inte_denominator@long_name = "vertical integral of (horizontal & vertical advection of q) over pressure"
inte_denominator@units = "Watts/m2 / (J/kg)"

printVarSummary(inte_numerator)
printVarSummary(inte_denominator)

;==================Step 4: Finally, calculate the NGMS.
NGMS = inte_numerator ; metadata
;NGMS = inte_numerator / inte_denominator

Numerator = inte_numerator ; 
;Numerator = 300.0 * inte_numerator  ; Raymond reference temperature = 300 K?
Numerator@units = "watts/m2"
Denominator = inte_denominator ;
Denominator = -1.0 * 2.501*10^6 * inte_denominator ;
Denominator@units = "watts/m2"

printVarSummary(Numerator)
printVarSummary(Denominator)

NGMS = Numerator / Denominator

NGMS@long_name = "Normalized Gross Moist Stability, as in Raymond [2009]"
NGMS@units = "dimensionless"
printVarSummary(NGMS)

;==================Step 5: Save NGMS(time,lat,lon) as nc file ======
system("rm -f /lustre/DATA/pritchard/hongcheq/WADA/pilot_test/"+output_file_name)
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/WADA/pilot_test/"+output_file_name,"c")
filedimdef(ncdf,"time",-1,True)

ncdf->NGMS = NGMS

ncdf->MSE = MSE
ncdf->MSE_column_test = MSE_column_test

ncdf->Numerator = Numerator
ncdf->Denominator = Denominator

ncdf->inte_numerator_hori = inte_numerator_hori
ncdf->inte_numerator_vert = inte_numerator_vert

end
