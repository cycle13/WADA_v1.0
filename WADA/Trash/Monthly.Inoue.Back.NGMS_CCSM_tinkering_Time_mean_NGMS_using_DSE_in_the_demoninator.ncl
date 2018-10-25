;Function: Prototype NCL scripts to calculate NGMS (Inoue and Back, 2015) from CCSM CMIP5 (AMIP) outputs.
;Date: 200180202
;Date: 20180214, tinkering.
;Date: 20180219, refinements.
;Note: Finally, you want to redesign this as a function or procedure.

begin

hus_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/hus/hus_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ta_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/ta/ta_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
zg_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/zg/zg_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ps_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/ps/ps_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ua_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/ua/ua_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
va_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/va/va_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
wap_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/wap/wap_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

file_output ="/lustre/DATA/pritchard/hongcheq/WADA/pilot_test/Monthly.Inoue_Back.NGMS.Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

;=============Step 1: Read in hus, ta, zg, ps, ua, va, wap files

hus_in = addfile(hus_file,"r")
hus = new(dimsizes(hus_in->hus),double)
hus = hus_in->hus
;hus_clim = dim_avg_n_Wrap(hus,0)
;printVarSummary(hus_clim)

ta_in = addfile(ta_file,"r")
ta = new(dimsizes(ta_in->ta),double)
ta = ta_in->ta
;ta_clim = dim_avg_n_Wrap(ta,0)
;printVarSummary(ta_clim)

zg_in = addfile(zg_file,"r")
zg = new(dimsizes(zg_in->zg),double)
zg = zg_in->zg
;zg_clim = dim_avg_n_Wrap(zg,0)
;printVarSummary(zg_clim)

ps_in = addfile(ps_file,"r")
ps = new(dimsizes(ps_in->ps),double)
ps = ps_in->ps
;ps_clim = dim_avg_n_Wrap(ps,0)
;printVarSummary(ps_clim)

ua_in = addfile(ua_file,"r")
ua = new(dimsizes(ua_in->ua),double)
ua = ua_in->ua
;ua_clim = dim_avg_n_Wrap(ua,0)
;printVarSummary(ua_clim)

va_in = addfile(va_file,"r")
va = new(dimsizes(va_in->va),double)
va = va_in->va
;va_clim = dim_avg_n_Wrap(va,0)
;printVarSummary(va_clim)

wap_in = addfile(wap_file,"r")
wap = new(dimsizes(wap_in->wap),double)
wap = wap_in->wap
;wap_clim = dim_avg_n_Wrap(wap,0)
;printVarSummary(wap_clim)

;==================== Step 2:  Calculate the numerator of NGMS. as used in eq. (2) in Inoue and Back 2015======

r = hus / (1.0-hus)   ; from specific humidity to water mixing ratio
copy_VarCoords(hus,r)
r@long_name = "water vapor mixing ratio"
printVarSummary(r)

;====== MSE = Cp x T + g x geopotential height + Lv x r ========
MSE = 1005.7 * ta + 9.8 * zg + 2.501*10^6 * r
copy_VarCoords(hus,MSE)
MSE@long_name = "Moist Static Energy (Cp*T+g*z+Lv*r)"
MSE@units = "J/kg"
printVarSummary(MSE)

DSE =  1005.7 * ta + 9.8 * zg
copy_VarCoords(MSE,DSE)
DSE@long_name = "Dry Static Energy (Cp*T+g*z)"
DSE@units = "J/kg"
printVarSummary(DSE)

;-------------- Use advective forms to calculate the numerator and denominator------
;Check if lon is in equal space!
dlon = (MSE&lon(2)-MSE&lon(1))*0.0174533 ; convert to radians
dMSEdx = MSE ; metadata
dMSEdx@long_name = "partile MSE / partial x"
dMSEdx@units = "J/kg/meter"

do ilat=0,dimsizes(MSE&lat)-1                      ; loop over each latitude
   dx = 6378388.*cos(0.0174533*MSE&lat(ilat))*dlon  ; constant at this latitude
   dMSEdx(:,:,ilat:ilat,:) = center_finite_diff_n(MSE(:,:,ilat:ilat,:),dx,True,0,2)
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

;================Step 3: Calculate the denominator of NGMS;

dDSEdx = MSE ; metadata
dDSEdx@long_name = "partile DSE / partial x"
dDSEdx@units = "J/kg/meter"

do ilat=0,dimsizes(DSE&lat)-1                      ; loop over each latitude
   dx = 6378388.*cos(0.0174533*DSE&lat(ilat))*dlon  ; constant at this latitude
   dDSEdx(:,:,ilat:ilat,:) = center_finite_diff_n(DSE(:,:,ilat:ilat,:),dx,True,0,2)
end do
printVarSummary(dDSEdx)

dDSEdy = MSE ; metadata
dDSEdy@long_name = "partile DSE / partial y"
dDSEdy@units = "J/kg/meter"

y_meri = 6378388.*(0.0174533*DSE&lat)    ; 
dDSEdy = center_finite_diff_n(DSE,y_meri,False,0,1)    ; not cyclic on different lat lines
printVarSummary(dDSEdy)

dDSEdp = MSE ; metadata
dDSEdp@long_name = "partile DSE / partial p"
dDSEdp@units = "J/kg/Pa"

dDSEdp = center_finite_diff_n(DSE,DSE&plev,False,0,0)
printVarSummary(dDSEdp)

DSE_deno = DSE ; meta data
DSE_deno@long_name = "horizontal + vertical advection (in p-coordinate) of DSE"
DSE_deno@units = "J/kg/sec"
DSE_deno = ua*dDSEdx + va*dDSEdy + wap*dDSEdp
printVarSummary(DSE_deno)

;============= Step 4: Vertical integral ================= 
;============== (wgt_vertical_n requires NO Missing data in the first parameter, so use sum(A * B) instead ====
plev = MSE&plev                
ptop = min(plev)                   
dp = dpres_plevel_Wrap(plev,ps,ptop,0)
printVarSummary(dp)
print(plev)
print(ps(10,10,10))
print(dp(10,:,10,10))
;-------------

inte_numerator = MSE_nume(:,0,:,:)  ; metadata
inte_numerator_hori = MSE_nume(:,0,:,:)  ; metadata
inte_numerator_vert = MSE_nume(:,0,:,:)  ; metadata

inte_denominator = DSE_deno(:,0,:,:)  ; metadata

MSE_column_test = MSE(:,0,:,:) ; metadata and test if the you are calculating the column MSE correctly. 
do itime = 0, dimsizes(MSE_nume&time) -1
   do ilev = 0, dimsizes(MSE_nume&plev) -1
      do ilat = 0, dimsizes(MSE_nume&lat) -1
         do ilon = 0, dimsizes(MSE_nume&lon) -1
            inte_numerator(itime,ilat,ilon) = sum(MSE_nume(itime,:,ilat,ilon)*dp(itime,:,ilat,ilon))
            inte_denominator(itime,ilat,ilon) = sum(DSE_deno(itime,:,ilat,ilon)*dp(itime,:,ilat,ilon))
            inte_numerator_hori(itime,ilat,ilon) = sum(MSE_nume_hori(itime,:,ilat,ilon)*dp(itime,:,ilat,ilon))
            inte_numerator_vert(itime,ilat,ilon) = sum(MSE_nume_vert(itime,:,ilat,ilon)*dp(itime,:,ilat,ilon))
            MSE_column_test(itime,ilat,ilon) = sum(MSE(itime,:,ilat,ilon)*dp(itime,:,ilat,ilon))
         end do
      end do 
   end do
end do

inte_numerator = inte_numerator/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_numerator@long_name = "vertical integral of (horizontal & vertical advection of MSE) over pressure"
inte_numerator@units = "Watts/m2"

inte_numerator_hori = inte_numerator_hori/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_numerator_hori@long_name = "vertical integral of horizontal advection of MSE"
inte_numerator_hori@units = "watts/m2"

inte_numerator_vert = inte_numerator_vert/9.8   ; hydrostratic balance: integral of (X) over pressure / g is equalavent to kg/m2 or mass-weighted integral
inte_numerator_vert@long_name = "vertical integral of vertical advection of MSE in p-coordinate"
inte_numerator_vert@units = "watts/m2"

inte_denominator = inte_denominator/9.8
inte_denominator@long_name = "vertical integral of (horizontal & vertical advection of DSE) over pressure"
inte_denominator@units = "Watts/m2"

MSE_column_test = MSE_column_test/9.8
MSE_column_test@long_name = "Column MSE"
MSE_column_test@units = "J/m2"

printVarSummary(inte_numerator)
printVarSummary(inte_denominator)

;==================Step 5: Finally, calculate the NGMS.

NGMS = inte_numerator ; metadata
NGMS = where(abs(inte_denominator) .gt. 10.0, inte_numerator / inte_denominator,inte_numerator@_FillValue) ; omit points where abs(denominator) <= 10 to avoid too large NGMS values
NGMS@long_name = "Normalized Gross Moist Stability, as in Inoue and Back [2015]. (set to missing where abs(denominator)<=10 watts/m2)"
NGMS@units = "dimensionless"
printVarSummary(NGMS)

;==================Step 6: Save NGMS(lat,lon) as nc file ======
system("rm -f "+file_output)
ncdf = addfile(file_output,"c")
filedimdef(ncdf,"time",-1,True)

ncdf->NGMS = NGMS

ncdf->MSE = MSE
ncdf->MSE_column_test = MSE_column_test

ncdf->Numerator = inte_numerator
ncdf->Denominator = inte_denominator

ncdf->inte_numerator_hori = inte_numerator_hori
ncdf->inte_numerator_vert = inte_numerator_vert

end
