;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.MSE.nc  under this directory:
;          /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.MSE.nc under /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/
;Note: Modified 20181030

begin

dir_TOPO_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_in = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

f_PHIS = addfile("/scratch/hongcheq/NERSC_Cori_WADA_simulation/F_AMIP_CAM5_WADA_TOPO_2008_sim2_2009-02-09_HCforcing/atm/hist/F_AMIP_CAM5_WADA_TOPO_2008_sim2_2009-02-09_HCforcing.cam.h1.2009-02-10-00000.nc","r")
PHIS = f_PHIS->PHIS(0,:,:)

members = 180

num_time = 96
chunk = 32

num1 = new(32,integer)
num2 = new(32,integer)

do i_chunk = 0,chunk-1
num1_temp = i_chunk * num_time/chunk
num2_temp = num1_temp + num_time/chunk - 1

num1(i_chunk) = num1_temp
num2(i_chunk) = num2_temp
end do  ; do i_chunk

;do i_num  = 0, 0
;do i_num  = 0, 7
do i_num  = 0, 31

;======== to avoid memory problem ====

T_TOPO = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
Q_TOPO = new((/members,3,30,96,144/),double) 
Z3_TOPO = new((/members,3,30,96,144/),double) 
T_CTR = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
Q_CTR = new((/members,3,30,96,144/),double) 
Z3_CTR = new((/members,3,30,96,144/),double) 

do i_file = 0, members - 1
;do i_file = 0, 5
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

T_TOPO(i_file,:,:,:,:) = f_TOPO->T(num1(i_num):num2(i_num),:,:,:)
Q_TOPO(i_file,:,:,:,:) = f_TOPO->Q(num1(i_num):num2(i_num),:,:,:)
Z3_TOPO(i_file,:,:,:,:) = f_TOPO->Z3(num1(i_num):num2(i_num),:,:,:)

T_CTR(i_file,:,:,:,:) = f_CTR->T(num1(i_num):num2(i_num),:,:,:)
Q_CTR(i_file,:,:,:,:) = f_CTR->Q(num1(i_num):num2(i_num),:,:,:)
Z3_CTR(i_file,:,:,:,:) = f_CTR->Z3(num1(i_num):num2(i_num),:,:,:)

end do  ; do i_fiel
;printVarSummary(T_TOPO)
;printVarSummary(Q_TOPO)
;printVarSummary(Z3_TOPO)

MSE_TOPO = T_TOPO ; metadata
MSE_TOPO@long_name = "Moist Static Energy calculated by static_energy_atm"
MSE_TOPO@units = "J/kg"
PHIS = PHIS/9.8
PHIS@units = "m"       ; surface geopotential
phis = conform(Z3_TOPO,PHIS,(/3,4/))

Z_TOPO = Z3_TOPO - phis  ; in meter, above surface
copy_VarCoords(Z3_TOPO,Z_TOPO)
SE_TOPO = static_energy_atm(T_TOPO,Q_TOPO,Z_TOPO,(/1,0/))
MSE_TOPO = SE_TOPO[0]
delete(SE_TOPO)
printVarSummary(MSE_TOPO)

MSE_CTR = T_CTR ; metadata
MSE_CTR@long_name = "Moist Static Energy calculated by static_energy_atm"
MSE_CTR@units = "J/kg"

Z_CTR = Z3_CTR - phis  ; in meter, above surface
copy_VarCoords(Z3_CTR,Z_CTR)
SE_CTR = static_energy_atm(T_CTR,Q_CTR,Z_CTR,(/1,0/))
MSE_CTR = SE_CTR[0]
delete(SE_CTR)
printVarSummary(MSE_CTR)

MSE_TOPO_mean = dim_avg_n_Wrap(MSE_TOPO,0)
MSE_TOPO_std = dim_stddev_n_Wrap(MSE_TOPO,0)
MSE_CTR_mean = dim_avg_n_Wrap(MSE_CTR,0)
MSE_CTR_std = dim_stddev_n_Wrap(MSE_CTR,0)

printVarSummary(MSE_TOPO_mean)
printVarSummary(MSE_TOPO_std)
printVarSummary(MSE_CTR_mean)
printVarSummary(MSE_CTR_std)

;====================== output to nc files ======
;dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_TOPO_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.MSE.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.MSE.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->MSE_TOPO_mean = MSE_TOPO_mean
ncdf_TOPO->MSE_TOPO_std = MSE_TOPO_std

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.MSE.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.MSE.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->MSE_CTR_mean = MSE_CTR_mean
ncdf_CTR->MSE_CTR_std = MSE_CTR_std

end do ; do i_num

end
