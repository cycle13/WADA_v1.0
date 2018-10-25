;Function: vertically integrated (HCDEEP + HCSHALLOW) forcing in the  TOPOTEST ensemble, output mean and std of ENS.
;Date: 20181004


load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;======= you need this fix before new simulations are done =======
 
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

;=========================

dir_TOPO_in = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")

members = 180

;i_step = x means x * 6 hr 

str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47",\
             "48-53","54-59","60-65","66-71","72-77","78-83","84-89","90-95"/)

;do i_step = 0,15
;do i_step = 0,7
do i_step = 8,15

HCDEEP_TOPO = new((/members,6,30,96,144/),double)    ;members x 6hr x 30lev x 96lat x 144 lon
HCSHALLOW_TOPO = new((/members,6,30,96,144/),double)
PS_TOPO = new((/members,6,96,144/),double)

HCDEEP_TOPO!0 = "members"
HCDEEP_TOPO&members = ispan(1,180,1)
HCSHALLOW_TOPO!0 = "members"
HCSHALLOW_TOPO&members = ispan(1,180,1)

PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,180,1)

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")

HCDEEP_TOPO(i_file,:,:,:,:) = f_TOPO->HCDEEP(i_step*6:i_step*6+5,:,:,:)
HCSHALLOW_TOPO(i_file,:,:,:,:) = f_TOPO->HCSHALLOW(i_step*6:i_step*6+5,:,:,:)
PS_TOPO(i_file,:,:,:) = f_TOPO->PS(i_step*6:i_step*6+5,:,:)

end do  ; do i_fiel

;-------------You do not need this after the new simulations is done---------
do i_lat = 0,95
do i_lon = 0,143

HCDEEP_TOPO(:,:,:,i_lat,i_lon) = HCDEEP_TOPO(:,:,:,i_lat,i_lon) * (-1.0) * (sgh_htfrac(i_lat,i_lon)-1.0)
HCSHALLOW_TOPO(:,:,:,i_lat,i_lon) = HCDEEP_TOPO(:,:,:,i_lat,i_lon) * (-1.0) * (sgh_htfrac(i_lat,i_lon)-1.0)

end do
end do
;-------------

printVarSummary(HCDEEP_TOPO)
printVarSummary(HCSHALLOW_TOPO)
printVarSummary(PS_TOPO)

;------------------------
hyam = f_TOPO->hyam
hybm = f_TOPO->hybm 
p0   = 100000. 
pbot = 101300.   
ptop = 30000.    ; upper level, 300 hPa ; integral from 101300 Pa to 30000 Pa.
g = 9.8

;--------------- calculate [div(u,v) * Q ] first, then vertical integral ------

pm_TOPO   = HCDEEP_TOPO       ;(members,time,lev,lat,lon); metadata
pm_TOPO   = pres_hybrid_ccm(PS_TOPO, p0, hyam, hybm)  
;pm(ntim,klvl,nlat,mlon) top-to-bottom
pm_TOPO@long_name = "pressure"
pm_TOPO@units     = "Pa"
                ; create array with appropriate metadata
forcing_TOPO = HCDEEP_TOPO ; metadata
focing_TOPO = HCDEEP_TOPO + HCSHALLOW_TOPO
printVarSummary(forcing_TOPO)

;----------------------

vint_forcing_TOPO = forcing_TOPO(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_forcing_TOPO = vibeta(pm_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1), forcing_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_forcing_TOPO = vint_forcing_TOPO / g
vint_forcing_TOPO@long_name = "1/g * integral {TOPO_forcing]} dp"
vint_forcing_TOPO@units = "(Kelvin * kg)/(sec * meter^2)"

printVarSummary(vint_forcing_TOPO)

;------save memory-----
delete(HCDEEP_TOPO)
delete(HCSHALLOW_TOPO)
delete(forcing_TOPO)

;--------------Calculate the mean and std ----------

vint_forcing_TOPO_mean = dim_avg_n_Wrap(vint_forcing_TOPO,0)
vint_forcing_TOPO_std = dim_stddev_n_Wrap(vint_forcing_TOPO,0)

printVarSummary(vint_forcing_TOPO_mean)
printVarSummary(vint_forcing_TOPO_std)

;--------------- save memory -------
delete(vint_forcing_TOPO)

;---------------------output variables QU_TOPO_mean, QU_TOPO_std, QV_TOPO_mean, QV_TOPO_std ----------
diro_TOPO = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"                     ; Output directory
filo_TOPO = "vint_forcing.mean_std.TOPO."+str_time(i_step)+".nc"             ; Output file
system("rm -f "+diro_TOPO+filo_TOPO)
ncdf_TOPO = addfile(diro_TOPO+filo_TOPO,"c")

filedimdef(ncdf_TOPO,"time",-1,True)

ncdf_TOPO->vint_forcing_TOPO_mean = vint_forcing_TOPO_mean
ncdf_TOPO->vint_forcing_TOPO_std = vint_forcing_TOPO_std

end do ; do i_step

end
