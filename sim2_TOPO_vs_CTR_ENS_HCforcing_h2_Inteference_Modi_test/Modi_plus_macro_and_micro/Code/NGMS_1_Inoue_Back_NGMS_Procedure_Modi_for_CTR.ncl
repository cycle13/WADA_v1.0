;Function: Prototype NCL scripts to calculate NGMS (Inoue and Back, 2015) from CTR and TOPO outputs for the WADA project.
;Note: 20190711

;;;undef("Inoue_Back_NGMS_Procedure")
;;;procedure Inoue_Back_NGMS_Procedure_Modi_for_CTR_TOPO(file_input:string,file_output:string)

begin

prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

;--------------
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

do index = 0, 31

CTR_dir = prefix + "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"

file_input = CTR_dir+CTR_mean_str

file_output = CTR_dir + "ENS.mean.CTR.time"+str_time(index)+".NGMS.new.nc"

;=============Step 1: Read in hus, ta, zg, ps, ua, va, wap files

f_input = addfile(file_input,"r")

Q = new(dimsizes(f_input->Q),double)
Q = f_input->Q

;========== hybrid coordinate to pressure coordinate ====
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
;pnew = (/3.64346569404006, 7.59481964632869, 14.3566322512925,\
;    24.6122200042009, 38.2682997733355, 54.5954797416925, 72.0124505460262,\
;    87.8212302923203, 103.317126631737, 121.547240763903, 142.994038760662,\
;    168.225079774857, 197.908086702228, 232.828618958592, 273.910816758871,\
;    322.241902351379, 379.100903868675, 445.992574095726, 524.687174707651,\
;    609.778694808483, 691.389430314302, 763.404481112957, 820.858368650079,\
;    859.53476652503, 887.020248919725, 912.644546944648, 936.198398470879,\
;    957.485479535535, 976.325407391414, 992.556095123291 /)

;pnew = fspan(100.0,1000.0,200)

;P0mb = 1000.0
;
hyam = f_input->hyam
hybm = f_input->hybm
printVarSummary(hyam)
printVarSummary(hybm)
;
;Q_pnew = vinth2p(Q,hyam,hybm,pnew,f_input->PS,1,P0mb,1,False)
;Q_pnew&lev_p@units = "hPa"
;printVarSummary(Q_pnew)

;-----------------------
T = new(dimsizes(f_input->T),double)
T = f_input->T

;T_pnew = vinth2p(T,hyam,hybm,pnew,f_input->PS,1,P0mb,1,False)
;T_pnew&lev_p@units = "hPa"
;printVarSummary(T_pnew)

;-----------------
Z3 = new(dimsizes(f_input->Z3),double)
Z3 = f_input->Z3

;Z3_pnew = vinth2p(Z3,hyam,hybm,pnew,f_input->PS,1,P0mb,1,False)
;Z3_pnew&lev_p@units = "hPa"
;printVarSummary(Z3_pnew)

;----------------
PS = new(dimsizes(f_input->PS),double)
PS = f_input->PS
;PS does not have lev dimension, and does not need to vertical interpolation
printVarSummary(PS)

;-----------------
U = new(dimsizes(f_input->U),double)
U = f_input->U

;U_pnew = vinth2p(U,hyam,hybm,pnew,f_input->PS,1,P0mb,1,False)
;U_pnew&lev_p@units = "hPa"
;printVarSummary(U_pnew)

;---------------------
V = new(dimsizes(f_input->V),double)
V = f_input->V

;V_pnew = vinth2p(V,hyam,hybm,pnew,f_input->PS,1,P0mb,1,False)
;V_pnew&lev_p@units = "hPa"
;printVarSummary(V_pnew)

;------------------------
OMEGA = new(dimsizes(f_input->OMEGA),double)
OMEGA = f_input->OMEGA

;OMEGA_pnew = vinth2p(OMEGA,hyam,hybm,pnew,f_input->PS,1,P0mb,1,False)
;OMEGA_pnew&lev_p@units = "hPa"
;printVarSummary(OMEGA_pnew)

;==================== Step 2:  Calculate the numerator of NGMS. as used in eq. (2) in Inoue and Back 2015======

;r_pnew = Q_pnew / (1.0-Q_pnew)   ; from specific humidity to water mixing ratio
;copy_VarCoords(Q_pnew,r_pnew)
;r_pnew@long_name = "water vapor mixing ratio"
;printVarSummary(r_pnew)

r = Q / (1.0-Q)   ; from specific humidity to water mixing ratio
copy_VarCoords(Q,r)
r@long_name = "water vapor mixing ratio"
printVarSummary(r)

;====== MSE = Cp x T + g x geopotential height + Lv x r ========
MSE = 1005.7 * T + 9.8 * Z3 + 2.501*10^6 * r
copy_VarCoords(Q,MSE)
MSE@long_name = "Moist Static Energy (Cp*T+g*z+Lv*r)"
MSE@units = "J/kg"
printVarSummary(MSE)

DSE =  1005.7 * T + 9.8 * Z3
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
   dMSEdx(:,:,ilat:ilat,:) = center_finite_diff_n(MSE(:,:,ilat:ilat,:),dx,True,0,3)
end do
printVarSummary(dMSEdx)

dMSEdy = MSE ; metadata
dMSEdy@long_name = "partile MSE / partial y"
dMSEdy@units = "J/kg/meter"

y_meri = 6378388.*(0.0174533*MSE&lat)    ; 
dMSEdy = center_finite_diff_n(MSE,y_meri,False,0,2)    ; not cyclic on different lat lines
printVarSummary(dMSEdy)

p_hybrid = pres_hybrid_ccm(PS,100000.0,hyam,hybm)
p_hybrid@units = "Pa"

dMSEdp = MSE ; metadata
dMSEdp@long_name = "partile MSE / partial p"
dMSEdp@units = "J/kg/Pa"

dMSEdp = center_finite_diff_n(MSE,p_hybrid,False,0,1)   ; p_hybrid in  Pa

printVarSummary(dMSEdp)

MSE_nume = MSE ; meta data
MSE_nume@long_name = "horizontal + vertical advection (in p-coordinate) of MSE"
MSE_nume@units = "J/kg/sec"
MSE_nume = U*dMSEdx + V*dMSEdy + OMEGA*dMSEdp
printVarSummary(MSE_nume)

MSE_nume_hori = U*dMSEdx + V*dMSEdy
MSE_nume_vert = OMEGA*dMSEdp

;================Step 3: Calculate the denominator of NGMS;

dDSEdx = MSE ; metadata
dDSEdx@long_name = "partile DSE / partial x"
dDSEdx@units = "J/kg/meter"

do ilat=0,dimsizes(DSE&lat)-1                      ; loop over each latitude
   dx = 6378388.*cos(0.0174533*DSE&lat(ilat))*dlon  ; constant at this latitude
   dDSEdx(:,:,ilat:ilat,:) = center_finite_diff_n(DSE(:,:,ilat:ilat,:),dx,True,0,3)
end do
printVarSummary(dDSEdx)

dDSEdy = MSE ; metadata
dDSEdy@long_name = "partile DSE / partial y"
dDSEdy@units = "J/kg/meter"

y_meri = 6378388.*(0.0174533*DSE&lat)    ; 
dDSEdy = center_finite_diff_n(DSE,y_meri,False,0,2)    ; not cyclic on different lat lines
printVarSummary(dDSEdy)

dDSEdp = MSE ; metadata
dDSEdp@long_name = "partile DSE / partial p"
dDSEdp@units = "J/kg/Pa"

dDSEdp = center_finite_diff_n(DSE,p_hybrid,False,0,1)  ; p_hybrid in  Pa
printVarSummary(dDSEdp)

DSE_deno = DSE ; meta data
DSE_deno@long_name = "horizontal + vertical advection (in p-coordinate) of DSE"
DSE_deno@units = "J/kg/sec"
DSE_deno = U*dDSEdx + V*dDSEdy + OMEGA*dDSEdp
printVarSummary(DSE_deno)

;============= Step 4: Vertical integral ================= 
;============== (wgt_vertical_n requires NO Missing data in the first parameter, so use sum(A * B) instead ====

hyai = f_input->hyai
hybi = f_input->hybi

dp = dpres_hybrid_ccm(PS,100000.0,hyai,hybi)
printVarSummary(dp)
;print(dp)
print(PS(0,10,10))
;print(dp(0,:,10,10))
;-------------

inte_numerator = MSE_nume(:,0,:,:)  ; metadata
inte_numerator_hori = MSE_nume(:,0,:,:)  ; metadata
inte_numerator_vert = MSE_nume(:,0,:,:)  ; metadata

inte_denominator = DSE_deno(:,0,:,:)  ; metadata

MSE_column_test = MSE(:,0,:,:) ; metadata and test if the you are calculating the column MSE correctly. 

do itime = 0, dimsizes(MSE_nume&time) - 1
   do ilev = 0, dimsizes(MSE_nume&lev) -1
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
;NGMS = inte_numerator / inte_denominator
;Note: when calculating Multi-model-mean of NGMS,  only very limited area have values,no values over the Andes and the majority of Amazon. (one _FillValue in a model will appear as missing in the multi-model-mean)
;Note: Therefore, remove this criterion here and see the effect.

NGMS@long_name = "Normalized Gross Moist Stability, as in Inoue and Back [2015]. (set to missing where abs(denominator)<=10 watts/m2)"
;NGMS@long_name = "Normalized Gross Moist Stability, as in Inoue and Back [2015]. (criteria of abs(denominator)<= 10 watts/m2 have been removed)"

NGMS@units = "dimensionless"
printVarSummary(NGMS)

;==================Step 6: Save NGMS(lat,lon) as nc file ======
system("rm -f "+file_output)
ncdf = addfile(file_output,"c")
filedimdef(ncdf,"time",-1,True)

ncdf->NGMS = NGMS

;ncdf->MSE = MSE
;ncdf->MSE_column_test = MSE_column_test

ncdf->Numerator = inte_numerator
ncdf->Denominator = inte_denominator

ncdf->inte_numerator_hori = inte_numerator_hori
ncdf->inte_numerator_vert = inte_numerator_vert

end do ; do index
end
