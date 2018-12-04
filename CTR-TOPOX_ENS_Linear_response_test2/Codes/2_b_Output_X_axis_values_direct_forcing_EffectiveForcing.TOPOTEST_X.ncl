;Function: vertically integrated (HCDEEP + HCSHALLOW) forcing in the  TOPOTEST ensemble, output mean and std of ENS.
;Date: 20181004
;Date: 20181128

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;============READ SGH30 ======
f_SGH30 = addfile("/DFS-L/DATA/pritchard/hongcheq/Topography/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
SGH30 = f_SGH30->SGH30

SGH30m = SGH30
SGH30m = SGH30@_FillValue
SGH30m({-40:10},{270:300}) = SGH30({-40:10},{270:300})

do ilat = 0,95
   do ilon = 0,143
      if (.not. ismissing(SGH30m(ilat,ilon)) .and. SGH30m(ilat,ilon) .lt. 200.0) then
          SGH30m(ilat,ilon) = SGH30m@_FillValue
      end if
   end do
end do
printVarSummary(SGH30m)

;=======================

;str_PCT = (/"00","20","40","60","80"/)
str_PCT = (/"00","20","40","60"/)

;do i_PCT = 0,4
do i_PCT = 1,3

PCT = str_PCT(i_PCT)

dir_TOPO_in = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST"+PCT+"/"
f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.PRECT.TOPOTEST"+PCT+".nc")

dir_CTR_in = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.PRECT.CTR.nc")

members = 180

HCforcing_TOPO = new((/members,30,96,144/),double)    ;members x 30lev x 96lat x 144 lon, to hold day 3-7 average
PS_TOPO = new((/members,96,144/),double)

PRECT_TOPO = new((/members,96,144/),double)
PRECT_CTR = new((/members,96,144/),double)

HCforcing_TOPO!0 = "members"
HCforcing_TOPO&members = ispan(1,180,1)

PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,180,1)

PRECT_TOPO!0 = "members"
PRECT_TOPO&members = ispan(1,180,1)

PRECT_CTR!0 = "members"
PRECT_CTR&members = ispan(1,180,1)

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
;averaged from day 3 - day 7, during which the precip WADA pattern become stable
HCforcing_TOPO(i_file,:,:,:) = dim_avg_n_Wrap(f_TOPO->HCforcing(2:6,:,:,:),0)
PS_TOPO(i_file,:,:) = dim_avg_n_Wrap(f_TOPO->PS(2:6,:,:),0)
PRECT_TOPO(i_file,:,:) = dim_avg_n_Wrap(f_TOPO->PRECT(2:6,:,:),0)

f_CTR = addfile(f_CTR_str(i_file),"r")
PRECT_CTR(i_file,:,:) = dim_avg_n_Wrap(f_CTR->PRECT(2:6,:,:),0)

end do  ; do i_file

;-------------

printVarSummary(HCforcing_TOPO)
printVarSummary(PS_TOPO)
printVarSummary(PRECT_TOPO)
printVarSummary(PRECT_CTR)

;------------------------
hyam = f_TOPO->hyam
hybm = f_TOPO->hybm 
p0   = 100000. 
pbot = 101300.   
ptop = 30000.    ; upper level, 300 hPa ; integral from 101300 Pa to 30000 Pa.
g = 9.8

;---------------  ------

pm_TOPO   = HCforcing_TOPO       ;(members,time,lev,lat,lon); metadata
pm_TOPO   = pres_hybrid_ccm(PS_TOPO, p0, hyam, hybm)  
;pm(ntim,klvl,nlat,mlon) top-to-bottom
pm_TOPO@long_name = "pressure"
pm_TOPO@units     = "Pa"
                ; create array with appropriate metadata
forcing_TOPO = HCforcing_TOPO ;
printVarSummary(forcing_TOPO)

;----------------------

vint_forcing_TOPO = forcing_TOPO(members|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_forcing_TOPO = vibeta(pm_TOPO(members|:,lat|:,lon|:,lev|::-1), forcing_TOPO(members|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_forcing_TOPO = vint_forcing_TOPO / g
vint_forcing_TOPO@long_name = "1/g * integral {TOPO_forcing]} dp"
vint_forcing_TOPO@units = "(Kelvin * kg)/(sec * meter^2)"

printVarSummary(vint_forcing_TOPO)

;------------ Andean averaged vint_HCforcing ------
Andes_vint_forcing_TOPO = vint_forcing_TOPO(:,0,0) ; metadata
;adjustment term
Andes_PRECT_AJ = PRECT_TOPO(:,0,0) ; metadata ; ajustment after direct forcing

do i_member = 0, 179 
    Andes_vint_forcing_TOPO(i_member) = avg(where(.not.ismissing(SGH30m),vint_forcing_TOPO(i_member,:,:),vint_forcing_TOPO@_FillValue))

    Andes_PRECT_AJ(i_member) = avg(where(.not.ismissing(SGH30m),PRECT_CTR(i_member,:,:),PRECT_CTR@_FillValue)) - avg(where(.not.ismissing(SGH30m),PRECT_TOPO(i_member,:,:),PRECT_TOPO@_FillValue))
end do ; i_member
printVarSummary(Andes_vint_forcing_TOPO)
printVarSummary(Andes_PRECT_AJ)

;------save memory-----
delete(HCforcing_TOPO)
delete(forcing_TOPO)

;------Calculating the direct forcing and the adjustment term as represented by PRECT

Lw = 2260000.0 ; J/kg ; latent heat of vaporization
Cpair=1004.0  ; J/(kg*K)

convert_factor = Cpair*3600*24/Lw
; variableX * convert_factor, units changes from [Kelvin*kg/(sec*m2)] to mm/day

; make sure that Andes_PRECT_AJ has the same units as the Andes_vint_forcing_TOPO
; so that those two terms can be added together.
Andes_PRECT_AJ = Andes_PRECT_AJ * 24*3600*1000.0/convert_factor
Andes_PRECT_AJ@units = "Kelvin*kg/(sec*m2)"

;The EffectiveForcing term is the adjustment effect of condensational heat release felt 
; by Amazon in the CTR simulation relative to TOPO_X, therefore the negative sign of 
; the Andes_vint_forcing_TOPO
Andes_EF = (-Andes_vint_forcing_TOPO) + Andes_PRECT_AJ
Andes_EF@units = "Kelvin*kg/(sec*m2)"

Andes_EF = Andes_EF * Cpair
Andes_EF@units = "W/m2"
;---------- change the Andes_vint_forcing_TOPO to represent CTR relative to TOPOX
;--------- and change its units from "Kelvin*kg/(sec*m2)" to "W/m2"
Andes_vint_forcing_CTR_TOPO = (-Andes_vint_forcing_TOPO)*Cpair
Andes_vint_forcing_CTR_TOPO@units = "W/m2"
Andes_vint_forcing_CTR_TOPO@long_name = "Andes vint_forcing, CTR - TOPO_X, PCT"+PCT

;--------------Calculate the mean and std ----------

Andes_vint_forcing_CTR_TOPO_mean = dim_avg_n_Wrap(Andes_vint_forcing_CTR_TOPO,0)
Andes_vint_forcing_CTR_TOPO_std = dim_stddev_n_Wrap(Andes_vint_forcing_CTR_TOPO,0)

Andes_EF_mean = dim_avg_n_Wrap(Andes_EF,0)
Andes_EF_std = dim_stddev_n_Wrap(Andes_EF,0)

printVarSummary(Andes_vint_forcing_CTR_TOPO_mean)
printVarSummary(Andes_vint_forcing_CTR_TOPO_std)

printVarSummary(Andes_EF_mean)
printVarSummary(Andes_EF_std)

;------- Calculate Confidence interval CI95 ----

n_total = 180
t_c = abs(cdft_t(0.025,n_total - 1))    ; t_{alpha/2} (n-1) value
CI95_vf = Andes_vint_forcing_CTR_TOPO_std/sqrt(n_total) * t_c   ; assuming normal distribution

CI95_EF = Andes_EF_std/sqrt(n_total) * t_c   ; assuming normal distribution

;--------------- save memory -------
delete(vint_forcing_TOPO)

;---------------------output variables ----------
diro_TOPO = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/" ; Output directory
filo_TOPO = "Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO"+PCT+".nc"             ; Output file
system("rm -f "+diro_TOPO+filo_TOPO)
ncdf_TOPO = addfile(diro_TOPO+filo_TOPO,"c")

filedimdef(ncdf_TOPO,"time",-1,True)

ncdf_TOPO->Andes_vint_forcing_CTR_TOPO_mean = Andes_vint_forcing_CTR_TOPO_mean
ncdf_TOPO->Andes_vint_forcing_CTR_TOPO_std = Andes_vint_forcing_CTR_TOPO_std
ncdf_TOPO->Andes_vint_forcing_CTR_TOPO_CI95 = CI95_vf

ncdf_TOPO->Andes_EF_mean = Andes_EF_mean
ncdf_TOPO->Andes_EF_std = Andes_EF_std
ncdf_TOPO->Andes_EF_CI95 = CI95_EF

end do ; do i_PCT

end
