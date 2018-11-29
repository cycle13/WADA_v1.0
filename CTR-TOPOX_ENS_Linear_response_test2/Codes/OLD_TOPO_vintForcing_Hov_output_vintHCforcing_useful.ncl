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
PCT = "00"
dir_TOPO_in = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST"+PCT+"/"
f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.PRECT.TOPOTEST"+PCT+".nc")

members = 180

HCforcing_TOPO = new((/members,30,96,144/),double)    ;members x 30lev x 96lat x 144 lon, to hold day 3-7 average
PS_TOPO = new((/members,96,144/),double)

HCforcing_TOPO!0 = "members"
HCforcing_TOPO&members = ispan(1,180,1)

PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,180,1)

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
;averaged from day 3 - day 7, during which the precip WADA pattern become stable
HCforcing_TOPO(i_file,:,:,:) = dim_avg_n_Wrap(f_TOPO->HCforcing(2:6,:,:,:),0)
PS_TOPO(i_file,:,:) = dim_avg_n_Wrap(f_TOPO->PS(2:6,:,:),0)

end do  ; do i_file

;-------------

printVarSummary(HCforcing_TOPO)
printVarSummary(PS_TOPO)

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
do i_member = 0, 179 
    Andes_vint_forcing_TOPO(i_member) = avg(where(.not.ismissing(SGH30m),vint_forcing_TOPO(i_member,:,:),vint_forcing_TOPO@_FillValue))

end do ; i_member
printVarSummary(Andes_vint_forcing_TOPO)

;------save memory-----
delete(HCforcing_TOPO)
delete(forcing_TOPO)

;--------------Calculate the mean and std ----------

Andes_vint_forcing_TOPO_mean = dim_avg_n_Wrap(Andes_vint_forcing_TOPO,0)
Andes_vint_forcing_TOPO_std = dim_stddev_n_Wrap(Andes_vint_forcing_TOPO,0)

printVarSummary(Andes_vint_forcing_TOPO_mean)
printVarSummary(Andes_vint_forcing_TOPO_std)
;------- Calculate Confidence interval CI95 ----

n_total = 180
t_c = abs(cdft_t(0.025,n_total - 1))    ; t_{alpha/2} (n-1) value
CI95 = Andes_vint_forcing_TOPO_std/sqrt(n_total) * t_c   ; assuming normal distribution

;--------------- save memory -------
delete(vint_forcing_TOPO)

;---------------------output variables ----------
diro_TOPO = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/" ; Output directory
filo_TOPO = "Andes_TEST_vint_forcing.mean_std.avg_day3-7.TOPO"+PCT+".nc"             ; Output file
system("rm -f "+diro_TOPO+filo_TOPO)
ncdf_TOPO = addfile(diro_TOPO+filo_TOPO,"c")

filedimdef(ncdf_TOPO,"time",-1,True)

ncdf_TOPO->Andes_vint_forcing_TOPO_mean = Andes_vint_forcing_TOPO_mean
ncdf_TOPO->Andes_vint_forcing_TOPO_std = Andes_vint_forcing_TOPO_std
ncdf_TOPO->Andes_vint_forcing_TOPO_CI95 = CI95


end
