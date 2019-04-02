;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.MSE.nc  under this directory:
;          /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.MSE.nc under /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/
;Note: Modified 20181030
;Note: modified 20190401
begin

prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD/"

dir_TOPO_in = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_in = prefix+"/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

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
;do i_num  = 0, 3
do i_num  = 0, 31
;do i_num  = 21, 31

;======== to avoid memory problem ====

T_TOPO = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
Z3_TOPO = new((/members,3,30,96,144/),double) 
PS_TOPO = new((/members,3,96,144/),double)

T_CTR = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
Z3_CTR = new((/members,3,30,96,144/),double) 
PS_CTR = new((/members,3,96,144/),double)

do i_file = 0, members - 1
;do i_file = 0, 5
print(i_file)
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

hyam = f_TOPO->hyam
hybm = f_TOPO->hybm

T_TOPO(i_file,:,:,:,:) = f_TOPO->T(num1(i_num):num2(i_num),:,:,:)
Z3_TOPO(i_file,:,:,:,:) = f_TOPO->Z3(num1(i_num):num2(i_num),:,:,:)
PS_TOPO(i_file,:,:,:) = f_TOPO->PS(num1(i_num):num2(i_num),:,:)

T_CTR(i_file,:,:,:,:) = f_CTR->T(num1(i_num):num2(i_num),:,:,:)
Z3_CTR(i_file,:,:,:,:) = f_CTR->Z3(num1(i_num):num2(i_num),:,:,:)
PS_CTR(i_file,:,:,:) = f_CTR->PS(num1(i_num):num2(i_num),:,:)

end do  ; do i_file
;printVarSummary(T_TOPO)
;printVarSummary(Q_TOPO)
;printVarSummary(Z3_TOPO)

;------------------------

P0 = 100000.0
pm_TOPO = pres_hybrid_ccm(PS_TOPO,P0,hyam,hybm)
pm_CTR = pres_hybrid_ccm(PS_CTR,P0,hyam,hybm)
pm_TOPO@units = "Pa"
pm_CTR@units = "Pa"
printVarSummary(pm_TOPO)
printVarSummary(pm_CTR)

;--calculate potential temperature---
PT_TOPO = pot_temp(pm_TOPO,T_TOPO,2,False)
PT_CTR = pot_temp(pm_CTR,T_CTR,2,False)
printVarSummary(PT_TOPO)
printVarSummary(PT_CTR)

;--- calculate Brunt-Vaisala frequency --
;BV_TOPO = brunt_vaisala_atm(PT_TOPO,Z3_TOPO,0,2)
BV_TOPO = brunt_vaisala_atm(PT_TOPO,Z3_TOPO,1,2)

BV_TOPO_fre = BV_TOPO[0]
BV_TOPO_fre = where(BV_TOPO_fre .lt. 0 , 0, BV_TOPO_fre)
BV_TOPO_dtheta_dz = BV_TOPO[1]
copy_VarCoords(BV_TOPO_fre, BV_TOPO_dtheta_dz)

;BV_CTR = brunt_vaisala_atm(PT_CTR,Z3_CTR,0,2)
BV_CTR = brunt_vaisala_atm(PT_CTR,Z3_CTR,1,2)

BV_CTR_fre = BV_CTR[0]
BV_CTR_fre = where(BV_CTR_fre .lt. 0 , 0, BV_CTR_fre)
BV_CTR_dtheta_dz = BV_CTR[1]
copy_VarCoords(BV_CTR_fre, BV_CTR_dtheta_dz)

printVarSummary(BV_TOPO_fre)
printVarSummary(BV_TOPO_dtheta_dz)
printVarSummary(BV_CTR_fre)
printVarSummary(BV_CTR_dtheta_dz)

;------------------------

BV_TOPO_fre_mean = dim_avg_n_Wrap(BV_TOPO_fre,0)
BV_TOPO_fre_std = dim_stddev_n_Wrap(BV_TOPO_fre,0)
BV_TOPO_dtheta_dz_mean = dim_avg_n_Wrap(BV_TOPO_dtheta_dz,0)
BV_TOPO_dtheta_dz_std = dim_stddev_n_Wrap(BV_TOPO_dtheta_dz,0)

PS_TOPO_mean = dim_avg_n_Wrap(PS_TOPO,0)
PS_TOPO_std = dim_stddev_n_Wrap(PS_TOPO,0)

BV_CTR_fre_mean = dim_avg_n_Wrap(BV_CTR_fre,0)
BV_CTR_fre_std = dim_stddev_n_Wrap(BV_CTR_fre,0)
BV_CTR_dtheta_dz_mean = dim_avg_n_Wrap(BV_CTR_dtheta_dz,0)
BV_CTR_dtheta_dz_std = dim_stddev_n_Wrap(BV_CTR_dtheta_dz,0)

PS_CTR_mean = dim_avg_n_Wrap(PS_CTR,0)
PS_CTR_std = dim_stddev_n_Wrap(PS_CTR,0)

printVarSummary(BV_TOPO_fre_mean)
printVarSummary(BV_TOPO_fre_std)
printVarSummary(BV_TOPO_dtheta_dz_mean)
printVarSummary(BV_TOPO_dtheta_dz_std)

printVarSummary(BV_CTR_fre_mean)
printVarSummary(BV_CTR_fre_std)
printVarSummary(BV_CTR_dtheta_dz_mean)
printVarSummary(BV_CTR_dtheta_dz_std)

;====================== output to nc files ======
;dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_TOPO_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_BruntVaisala/TOPO_TEST/"
dir_CTR_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_BruntVaisala/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.BruntVaisala.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.BruntVaisala.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->BV_TOPO_fre_mean = BV_TOPO_fre_mean
ncdf_TOPO->BV_TOPO_fre_std = BV_TOPO_fre_std
ncdf_TOPO->BV_TOPO_dtheta_dz_mean = BV_TOPO_dtheta_dz_mean
ncdf_TOPO->BV_TOPO_dtheta_dz_std = BV_TOPO_dtheta_dz_std

ncdf_TOPO->PS_TOPO_mean = PS_TOPO_mean
ncdf_TOPO->PS_TOPO_std = PS_TOPO_std

ncdf_TOPO->hyam = f_TOPO->hyam
ncdf_TOPO->hybm = f_TOPO->hybm

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.BruntVaisala.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.BruntVaisala.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->BV_CTR_fre_mean = BV_CTR_fre_mean
ncdf_CTR->BV_CTR_fre_std = BV_CTR_fre_std
ncdf_CTR->BV_CTR_dtheta_dz_mean = BV_CTR_dtheta_dz_mean
ncdf_CTR->BV_CTR_dtheta_dz_std = BV_CTR_dtheta_dz_std

ncdf_CTR->PS_CTR_mean = PS_CTR_mean
ncdf_CTR->PS_CTR_std = PS_CTR_std

ncdf_CTR->hyam = f_CTR->hyam
ncdf_CTR->hybm = f_CTR->hybm

end do ; do i_num

end
