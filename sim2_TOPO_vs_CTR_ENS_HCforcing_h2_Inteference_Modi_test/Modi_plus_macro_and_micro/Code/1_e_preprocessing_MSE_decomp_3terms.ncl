;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.MSE.nc  under this directory:
;          /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.MSE.nc under /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/
;Note: Modified 20181030
;Note: modified 20190530 for New Interference

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"
dir_TOPO_in = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
dir_CTR_in = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

f_PHIS = addfile(prefix+"/scratch/hongcheq/NERSC_Cori_WADA_simulation/F_AMIP_CAM5_WADA_TOPO_2008_sim2_2009-02-09_HCforcing/atm/hist/F_AMIP_CAM5_WADA_TOPO_2008_sim2_2009-02-09_HCforcing.cam.h1.2009-02-10-00000.nc","r")
PHIS = f_PHIS->PHIS(0,:,:)

;members = 180
members = 9

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
;do i_num  = 21, 31

;======== to avoid memory problem ====

T_TOPO = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
Q_TOPO = new((/members,3,30,96,144/),double) 
Z3_TOPO = new((/members,3,30,96,144/),double) 
PS_TOPO = new((/members,3,96,144/),double)

T_CTR = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
Q_CTR = new((/members,3,30,96,144/),double) 
Z3_CTR = new((/members,3,30,96,144/),double) 
PS_CTR = new((/members,3,96,144/),double)

do i_file = 0, members - 1
;do i_file = 0, 5
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

T_TOPO(i_file,:,:,:,:) = f_TOPO->T(num1(i_num):num2(i_num),:,:,:)
Q_TOPO(i_file,:,:,:,:) = f_TOPO->Q(num1(i_num):num2(i_num),:,:,:)
Z3_TOPO(i_file,:,:,:,:) = f_TOPO->Z3(num1(i_num):num2(i_num),:,:,:)
PS_TOPO(i_file,:,:,:) = f_TOPO->PS(num1(i_num):num2(i_num),:,:)

T_CTR(i_file,:,:,:,:) = f_CTR->T(num1(i_num):num2(i_num),:,:,:)
Q_CTR(i_file,:,:,:,:) = f_CTR->Q(num1(i_num):num2(i_num),:,:,:)
Z3_CTR(i_file,:,:,:,:) = f_CTR->Z3(num1(i_num):num2(i_num),:,:,:)
PS_CTR(i_file,:,:,:) = f_CTR->PS(num1(i_num):num2(i_num),:,:)

end do  ; do i_fiel
;printVarSummary(T_TOPO)
;printVarSummary(Q_TOPO)
;printVarSummary(Z3_TOPO)

;---- some constants are useful -----
Lv = 2257000.0 ; J/kg latent heat of vaporization
Cp = 1006.0 ; J/(kg*Kelvin) specific heat capacity of dry air at constant pressure
grav = 9.8 ; m/sec2 or N/kg, gravitational acceleration

LH_TOPO = T_TOPO ; metadata
LH_TOPO@long_name = "Lv*q"
LH_TOPO@units = "J/kg"

DE_TOPO = T_TOPO ; metadata  ; Dry Air Enthalpy
DE_TOPO@long_name = "Cp*T"
DE_TOPO@units = "J/kg"

PE_TOPO = T_TOPO ; metadata
PE_TOPO@long_name = "gz"
PE_TOPO@units = "J/kg"

PHIS = PHIS/9.8
PHIS@units = "m"       ; surface geopotential
phis = conform(Z3_TOPO,PHIS,(/3,4/))

Z_TOPO = Z3_TOPO - phis  ; in meter, above surface
copy_VarCoords(Z3_TOPO,Z_TOPO)
;;SE_TOPO = static_energy_atm(T_TOPO,Q_TOPO,Z_TOPO,(/1,0/))
LH_TOPO = Lv * Q_TOPO 
DE_TOPO = Cp * T_TOPO
PE_TOPO = grav * Z_TOPO

;delete(SE_TOPO)
printVarSummary(LH_TOPO)

LH_CTR = T_CTR ; metadata
LH_CTR@long_name = "Lv*q"
LH_CTR@units = "J/kg"

DE_CTR = T_TOPO ; metadata
DE_CTR@long_name = "Cp*T"
DE_CTR@units = "J/kg"

PE_CTR = T_TOPO ; metadata
PE_CTR@long_name = "gz"
PE_CTR@units = "J/kg"

Z_CTR = Z3_CTR - phis  ; in meter, above surface
copy_VarCoords(Z3_CTR,Z_CTR)
;;SE_CTR = static_energy_atm(T_CTR,Q_CTR,Z_CTR,(/1,0/))
LH_CTR = Lv * Q_CTR
DE_CTR = Cp * T_CTR
PE_CTR = grav * Z_CTR

;delete(SE_CTR)
printVarSummary(LH_CTR)

LH_TOPO_mean = dim_avg_n_Wrap(LH_TOPO,0)
LH_TOPO_std = dim_stddev_n_Wrap(LH_TOPO,0)
DE_TOPO_mean = dim_avg_n_Wrap(DE_TOPO,0)
DE_TOPO_std = dim_stddev_n_Wrap(DE_TOPO,0)
PE_TOPO_mean = dim_avg_n_Wrap(PE_TOPO,0)
PE_TOPO_std = dim_stddev_n_Wrap(PE_TOPO,0)

PS_TOPO_mean = dim_avg_n_Wrap(PS_TOPO,0)
PS_TOPO_std = dim_stddev_n_Wrap(PS_TOPO,0)

LH_CTR_mean = dim_avg_n_Wrap(LH_CTR,0)
LH_CTR_std = dim_stddev_n_Wrap(LH_CTR,0)
DE_CTR_mean = dim_avg_n_Wrap(DE_CTR,0)
DE_CTR_std = dim_stddev_n_Wrap(DE_CTR,0)
PE_CTR_mean = dim_avg_n_Wrap(PE_CTR,0)
PE_CTR_std = dim_stddev_n_Wrap(PE_CTR,0)

PS_CTR_mean = dim_avg_n_Wrap(PS_CTR,0)
PS_CTR_std = dim_stddev_n_Wrap(PS_CTR,0)

printVarSummary(LH_TOPO_mean)
printVarSummary(LH_TOPO_std)
printVarSummary(LH_CTR_mean)
printVarSummary(LH_CTR_std)

;====================== output to nc files ======
;dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_TOPO_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
dir_CTR_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.MSE.3term.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.MSE.3term.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->LH_mean = LH_TOPO_mean
ncdf_TOPO->LH_std = LH_TOPO_std
ncdf_TOPO->DE_mean = DE_TOPO_mean
ncdf_TOPO->DE_std = DE_TOPO_std
ncdf_TOPO->PE_mean = PE_TOPO_mean
ncdf_TOPO->PE_std = PE_TOPO_std

ncdf_TOPO->PS_mean = PS_TOPO_mean
ncdf_TOPO->PS_std = PS_TOPO_std

ncdf_TOPO->hyam = f_TOPO->hyam
ncdf_TOPO->hybm = f_TOPO->hybm


system("rm "+dir_CTR_out+"ENS.std.mean.CTR.MSE.3term.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.MSE.3term.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->LH_mean = LH_CTR_mean
ncdf_CTR->LH_std = LH_CTR_std
ncdf_CTR->DE_mean = DE_CTR_mean
ncdf_CTR->DE_std = DE_CTR_std
ncdf_CTR->PE_mean = PE_CTR_mean
ncdf_CTR->PE_std = PE_CTR_std

ncdf_CTR->PS_mean = PS_CTR_mean
ncdf_CTR->PS_std = PS_CTR_std

ncdf_CTR->hyam = f_CTR->hyam
ncdf_CTR->hybm = f_CTR->hybm

end do ; do i_num

end
