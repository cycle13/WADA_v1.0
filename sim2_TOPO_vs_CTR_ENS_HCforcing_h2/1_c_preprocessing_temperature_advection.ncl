;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.div.nc  under this directory:
;          /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.div.nc under /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/
;Note: Modified 20181001
;Note: modified for temperature advection on 20181023

begin

dir_TOPO_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_in = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

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
;do i_num  = 0, 7
do i_num  = 0, 31

;======== to avoid memory problem ====

U_TOPO = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
V_TOPO = new((/members,3,30,96,144/),double) 
T_TOPO = new((/members,3,30,96,144/),double) 

U_CTR = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
V_CTR = new((/members,3,30,96,144/),double) 
T_CTR = new((/members,3,30,96,144/),double) 

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

U_TOPO(i_file,:,:,:,:) = f_TOPO->U(num1(i_num):num2(i_num),:,:,:)
V_TOPO(i_file,:,:,:,:) = f_TOPO->V(num1(i_num):num2(i_num),:,:,:)
T_TOPO(i_file,:,:,:,:) = f_TOPO->T(num1(i_num):num2(i_num),:,:,:)

U_CTR(i_file,:,:,:,:) = f_CTR->U(num1(i_num):num2(i_num),:,:,:)
V_CTR(i_file,:,:,:,:) = f_CTR->V(num1(i_num):num2(i_num),:,:,:)
T_CTR(i_file,:,:,:,:) = f_CTR->T(num1(i_num):num2(i_num),:,:,:)

end do  ; do i_fiel
;printVarSummary(U_TOPO)
;printVarSummary(V_TOPO)

;------------
Tadv_TOPO = advect_variable(U_TOPO,V_TOPO,T_TOPO,0,"temperature advection","K/s",0)
printVarSummary(Tadv_TOPO)  
Tadv_CTR = advect_variable(U_CTR,V_CTR,T_CTR,0,"temperature advection","K/s",0)
printVarSummary(Tadv_CTR)
;--------

Tadv_TOPO_mean = dim_avg_n_Wrap(Tadv_TOPO,0)
Tadv_TOPO_std = dim_stddev_n_Wrap(Tadv_TOPO,0)
Tadv_CTR_mean = dim_avg_n_Wrap(Tadv_CTR,0)
Tadv_CTR_std = dim_stddev_n_Wrap(Tadv_CTR,0)

printVarSummary(Tadv_TOPO_mean)
printVarSummary(Tadv_TOPO_std)
printVarSummary(Tadv_CTR_mean)
printVarSummary(Tadv_CTR_std)

;====================== output to nc files ======
;dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_TOPO_out = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.Tadv.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.Tadv.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->Tadv_TOPO_mean = Tadv_TOPO_mean
ncdf_TOPO->Tadv_TOPO_std = Tadv_TOPO_std

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.Tadv.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.Tadv.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->Tadv_CTR_mean = Tadv_CTR_mean
ncdf_CTR->Tadv_CTR_std = Tadv_CTR_std

end do ; do i_num

end
