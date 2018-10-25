;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.OMEGAUV.nc  under this directory:
;          /lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.OMEGAUV.nc under /lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/


begin

dir_TOPO_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

members = 180

U_TOPO = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_TOPO = new((/members,12,30,96,144/),double) 
OMEGA_TOPO = new((/members,12,30,96,144/),double) 

U_CTR = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_CTR = new((/members,12,30,96,144/),double) 
OMEGA_CTR = new((/members,12,30,96,144/),double) 

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

U_TOPO(i_file,:,:,:,:) = f_TOPO->U
V_TOPO(i_file,:,:,:,:) = f_TOPO->V
OMEGA_TOPO(i_file,:,:,:,:) = f_TOPO->OMEGA

U_CTR(i_file,:,:,:,:) = f_CTR->U
V_CTR(i_file,:,:,:,:) = f_CTR->V
OMEGA_CTR(i_file,:,:,:,:) = f_CTR->OMEGA

end do  ; do i_fiel
;printVarSummary(U_TOPO)
;printVarSummary(V_TOPO)

OMEGAU_TOPO = U_TOPO ; metadata
OMEGAU_TOPO@long_name = "Vertical flux of zonal momentum"
OMEGAU_TOPO@units = "m Pa/s2"
OMEGAU_TOPO = OMEGA_TOPO * U_TOPO
printVarSummary(OMEGAU_TOPO)

OMEGAU_CTR = U_CTR ; metadata
OMEGAU_CTR@long_name = "Vertical flux of zonal momentum"
OMEGAU_CTR@units = "m Pa/s2"
OMEGAU_CTR = OMEGA_CTR * U_CTR
printVarSummary(OMEGAU_CTR)

OMEGAU_TOPO_mean = dim_avg_n_Wrap(OMEGAU_TOPO,0)
OMEGAU_TOPO_std = dim_stddev_n_Wrap(OMEGAU_TOPO,0)
OMEGAU_CTR_mean = dim_avg_n_Wrap(OMEGAU_CTR,0)
OMEGAU_CTR_std = dim_stddev_n_Wrap(OMEGAU_CTR,0)

printVarSummary(OMEGAU_TOPO_mean)
printVarSummary(OMEGAU_TOPO_std)
printVarSummary(OMEGAU_CTR_mean)
printVarSummary(OMEGAU_CTR_std)

OMEGAV_TOPO = V_TOPO ; metadata
OMEGAV_TOPO@long_name = "Vertical flux of meridional momentum"
OMEGAV_TOPO@units = "m Pa/s2"
OMEGAV_TOPO = OMEGA_TOPO * V_TOPO
printVarSummary(OMEGAV_TOPO)

OMEGAV_CTR = V_CTR ; metadata
OMEGAV_CTR@long_name = "Vertical flux of meridional momentum"
OMEGAV_CTR@units = "m Pa/s2"
OMEGAV_CTR = OMEGA_CTR * V_CTR
printVarSummary(OMEGAV_CTR)

OMEGAV_TOPO_mean = dim_avg_n_Wrap(OMEGAV_TOPO,0)
OMEGAV_TOPO_std = dim_stddev_n_Wrap(OMEGAV_TOPO,0)
OMEGAV_CTR_mean = dim_avg_n_Wrap(OMEGAV_CTR,0)
OMEGAV_CTR_std = dim_stddev_n_Wrap(OMEGAV_CTR,0)

printVarSummary(OMEGAV_TOPO_mean)
printVarSummary(OMEGAV_TOPO_std)
printVarSummary(OMEGAV_CTR_mean)
printVarSummary(OMEGAV_CTR_std)

OMEGA_TOPO_mean = dim_avg_n_Wrap(OMEGA_TOPO,0)
OMEGA_TOPO_std = dim_stddev_n_Wrap(OMEGA_TOPO,0)
OMEGA_CTR_mean = dim_avg_n_Wrap(OMEGA_CTR,0)
OMEGA_CTR_std = dim_stddev_n_Wrap(OMEGA_CTR,0)

printVarSummary(OMEGA_TOPO_mean)
printVarSummary(OMEGA_TOPO_std)
printVarSummary(OMEGA_CTR_mean)
printVarSummary(OMEGA_CTR_std)

;====================== output to nc files ======
dir_TOPO_out = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_out = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.OMEGAUV.nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.OMEGAUV.nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->OMEGAU_TOPO_mean = OMEGAU_TOPO_mean
ncdf_TOPO->OMEGAV_TOPO_mean = OMEGAV_TOPO_mean
ncdf_TOPO->OMEGA_TOPO_mean = OMEGA_TOPO_mean

ncdf_TOPO->OMEGAU_TOPO_std = OMEGAU_TOPO_std
ncdf_TOPO->OMEGAV_TOPO_std = OMEGAV_TOPO_std
ncdf_TOPO->OMEGA_TOPO_std = OMEGA_TOPO_std

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.OMEGAUV.nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.OMEGAUV.nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->OMEGAU_CTR_mean = OMEGAU_CTR_mean
ncdf_CTR->OMEGAV_CTR_mean = OMEGAV_CTR_mean
ncdf_CTR->OMEGA_CTR_mean = OMEGA_CTR_mean

ncdf_CTR->OMEGAU_CTR_std = OMEGAU_CTR_std
ncdf_CTR->OMEGAV_CTR_std = OMEGAV_CTR_std
ncdf_CTR->OMEGA_CTR_std = OMEGA_CTR_std


end
