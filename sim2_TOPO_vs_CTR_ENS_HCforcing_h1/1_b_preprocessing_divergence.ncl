;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.div.nc  under this directory:
;          /lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.div.nc under /lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/


begin
dir_TOPO_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
dir_CTR_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"

;dir_TOPO_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;dir_CTR_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

members = 180

U_TOPO = new((/members,4,30,96,144/),double)    ;members x 4day x 30lev x 96lat x 144 lon
V_TOPO = new((/members,4,30,96,144/),double) 
U_CTR = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_CTR = new((/members,12,30,96,144/),double) 

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

U_TOPO(i_file,:,:,:,:) = f_TOPO->U
V_TOPO(i_file,:,:,:,:) = f_TOPO->V

U_CTR(i_file,:,:,:,:) = f_CTR->U
V_CTR(i_file,:,:,:,:) = f_CTR->V

end do  ; do i_fiel
;printVarSummary(U_TOPO)
;printVarSummary(V_TOPO)

div_TOPO = U_TOPO ; metadata
div_TOPO@long_name = "divergence calculated by uv2dv_cfd"
div_TOPO@units = "1/sec"
div_TOPO = uv2dv_cfd(U_TOPO,V_TOPO,f_TOPO->lat,f_TOPO->lon,3)
printVarSummary(div_TOPO)

div_CTR = U_CTR ; metadata
div_CTR@long_name = "divergence calculated by uv2dv_cfd"
div_CTR@units = "1/sec"
div_CTR = uv2dv_cfd(U_CTR,V_CTR,f_CTR->lat,f_CTR->lon,3)
printVarSummary(div_CTR)

div_TOPO_mean = dim_avg_n_Wrap(div_TOPO,0)
div_TOPO_std = dim_stddev_n_Wrap(div_TOPO,0)
div_CTR_mean = dim_avg_n_Wrap(div_CTR,0)
div_CTR_std = dim_stddev_n_Wrap(div_CTR,0)

printVarSummary(div_TOPO_mean)
printVarSummary(div_TOPO_std)
printVarSummary(div_CTR_mean)
printVarSummary(div_CTR_std)

;====================== output to nc files ======
dir_TOPO_out =  "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
dir_CTR_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/CTR/"
;dir_TOPO_out = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;dir_CTR_out = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.div.nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.div.nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->div_TOPO_mean = div_TOPO_mean
ncdf_TOPO->div_TOPO_std = div_TOPO_std

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.div.nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.div.nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->div_CTR_mean = div_CTR_mean
ncdf_CTR->div_CTR_std = div_CTR_std


end
