;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.MSE.nc  under this directory:
;          /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.MSE.nc under /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/
;Note: Modified 20181030
;Note: modified 20181130

begin

dir_TOPO_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/TOPO_TEST/"
dir_CTR_in="/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/CTR/"

;dir_TOPO_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;dir_CTR_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;dir_TOPO_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;dir_CTR_in = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

members = 180

;num_time = 4   ; 4 days
num_time = 96   ; 96 hrs

chunk = 1

SHFLX_TOPO = new((/members,num_time,96,144/),double)    ;members x 96 hr x 30lev x 96lat x 144 lon
LHFLX_TOPO = new((/members,num_time,96,144/),double) 
SWCF_TOPO = new((/members,num_time,96,144/),double) 
LWCF_TOPO = new((/members,num_time,96,144/),double) 

SHFLX_CTR = new((/members,num_time,96,144/),double)    ;members x 96 hr x 30lev x 96lat x 144 lon
LHFLX_CTR = new((/members,num_time,96,144/),double) 
SWCF_CTR = new((/members,num_time,96,144/),double) 
LWCF_CTR = new((/members,num_time,96,144/),double) 

;do i_num  = 0, 0
;do i_num  = 0, 7

do i_file = 0, members - 1
;do i_file = 0, 5
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

SHFLX_TOPO(i_file,:,:,:) = f_TOPO->SHFLX(:,:,:)
LHFLX_TOPO(i_file,:,:,:) = f_TOPO->LHFLX(:,:,:)
SWCF_TOPO(i_file,:,:,:) = f_TOPO->SWCF(:,:,:)
LWCF_TOPO(i_file,:,:,:) = f_TOPO->LWCF(:,:,:)

SHFLX_CTR(i_file,:,:,:) = f_CTR->SHFLX(:,:,:)
LHFLX_CTR(i_file,:,:,:) = f_CTR->LHFLX(:,:,:)
SWCF_CTR(i_file,:,:,:) = f_CTR->SWCF(:,:,:)
LWCF_CTR(i_file,:,:,:) = f_CTR->LWCF(:,:,:)

end do  ; do i_fiel
;printVarSummary(T_TOPO)
;printVarSummary(Q_TOPO)
;printVarSummary(Z3_TOPO)

FLX_TOPO = SHFLX_TOPO ; metadata
FLX_TOPO@long_name = "SHFLX+LHFLX"
FLX_TOPO = SHFLX_TOPO + LHFLX_TOPO
printVarSummary(FLX_TOPO)

CF_TOPO = SWCF_TOPO ; metadata
CF_TOPO@long_name = "SWCF+LWCF"
CF_TOPO = SWCF_TOPO + LWCF_TOPO
printVarSummary(CF_TOPO)

FLX_CTR = SHFLX_CTR ; metadata
FLX_CTR@long_name = "SHFLX+LHFLX"
FLX_CTR = SHFLX_CTR + LHFLX_CTR
printVarSummary(FLX_CTR)

CF_CTR = SWCF_CTR ; metadata
CF_CTR@long_name = "SWCF+LWCF"
CF_CTR = SWCF_CTR + LWCF_CTR
printVarSummary(CF_CTR)

FLX_TOPO_mean = dim_avg_n_Wrap(FLX_TOPO,0)
FLX_TOPO_std = dim_stddev_n_Wrap(FLX_TOPO,0)

CF_TOPO_mean = dim_avg_n_Wrap(CF_TOPO,0)
CF_TOPO_std = dim_stddev_n_Wrap(CF_TOPO,0)

FLX_CTR_mean = dim_avg_n_Wrap(FLX_CTR,0)
FLX_CTR_std = dim_stddev_n_Wrap(FLX_CTR,0)

CF_CTR_mean = dim_avg_n_Wrap(CF_CTR,0)
CF_CTR_std = dim_stddev_n_Wrap(CF_CTR,0)

printVarSummary(FLX_TOPO_mean)
printVarSummary(FLX_TOPO_std)
printVarSummary(CF_CTR_mean)
printVarSummary(CF_CTR_std)

;====================== output to nc files ======
dir_TOPO_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/TOPO_TEST/"
dir_CTR_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_SHFLX_LHFLX_SWCF_LWCF/CTR/"

;dir_TOPO_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;dir_CTR_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;dir_TOPO_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;dir_CTR_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.FLX.CF.nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.FLX.CF.nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->FLX_TOPO_mean = FLX_TOPO_mean
ncdf_TOPO->FLX_TOPO_std = FLX_TOPO_std

ncdf_TOPO->CF_TOPO_mean = CF_TOPO_mean
ncdf_TOPO->CF_TOPO_std = CF_TOPO_std

ncdf_TOPO->hyam = f_TOPO->hyam
ncdf_TOPO->hybm = f_TOPO->hybm

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.FLX.CF.nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.FLX.CF.nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->FLX_CTR_mean = FLX_CTR_mean
ncdf_CTR->FLX_CTR_std = FLX_CTR_std

ncdf_CTR->CF_CTR_mean = CF_CTR_mean
ncdf_CTR->CF_CTR_std = CF_CTR_std

ncdf_CTR->hyam = f_CTR->hyam
ncdf_CTR->hybm = f_CTR->hybm


end
