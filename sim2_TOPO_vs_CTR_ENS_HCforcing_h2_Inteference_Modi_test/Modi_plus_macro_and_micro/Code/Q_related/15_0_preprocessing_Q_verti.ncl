
begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

dir_TOPO_in = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
dir_CTR_in = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

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

;======== to avoid memory problem ====

OMEGA_TOPO = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
var_TOPO = new((/members,3,30,96,144/),double) 
dph_TOPO = new((/members,3,30,96,144/),double) 

OMEGA_CTR = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
var_CTR = new((/members,3,30,96,144/),double) 
dph_CTR = new((/members,3,30,96,144/),double) 

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

OMEGA_TOPO(i_file,:,:,:,:) = f_TOPO->OMEGA(num1(i_num):num2(i_num),:,:,:)
var_TOPO(i_file,:,:,:,:) = f_TOPO->Q(num1(i_num):num2(i_num),:,:,:)

OMEGA_CTR(i_file,:,:,:,:) = f_CTR->OMEGA(num1(i_num):num2(i_num),:,:,:)
var_CTR(i_file,:,:,:,:) = f_CTR->Q(num1(i_num):num2(i_num),:,:,:)

;printVarSummary(U_TOPO)
;printVarSummary(V_TOPO)

;------------
hyai = f_TOPO->hyai ; read from a file the interface hybrid coefficients
hybi = f_TOPO->hybi ; read from a file
P0  = 100000.0 ; since ps is in Pa 

dph_TOPO(i_file,:,:,:,:) = dpres_hybrid_ccm(f_TOPO->PS(num1(i_num):num2(i_num),:,:),P0,hyai,hybi) 
dph_CTR(i_file,:,:,:,:) = dpres_hybrid_ccm(f_CTR->PS(num1(i_num):num2(i_num),:,:),P0,hyai,hybi) 
printVarSummary(dph_CTR)

end do  ; do i_fiel

;-----------
d_var_TOPO = var_TOPO(:,:,1:29,:,:) - var_TOPO(:,:,0:28,:,:)
var_adv_TOPO = OMEGA_TOPO(:,:,1:29,:,:) * d_var_TOPO / dph_TOPO(:,:,1:29,:,:)  ; kg/kg / sec 
printVarSummary(var_adv_TOPO)  

d_var_CTR = var_CTR(:,:,1:29,:,:) - var_CTR(:,:,0:28,:,:)
var_adv_CTR = OMEGA_CTR(:,:,1:29,:,:) * d_var_CTR / dph_CTR(:,:,1:29,:,:)  ; kg/kg / sec 
printVarSummary(var_adv_CTR)

d_omega_TOPO = OMEGA_TOPO(:,:,1:29,:,:) - OMEGA_TOPO(:,:,0:28,:,:)
q_dOmega_dp_TOPO = var_TOPO(:,:,1:29,:,:) * d_omega_TOPO / dph_TOPO(:,:,1:29,:,:)
printVarSummary(q_dOmega_dp_TOPO)

d_omega_CTR = OMEGA_CTR(:,:,1:29,:,:) - OMEGA_CTR(:,:,0:28,:,:)
q_dOmega_dp_CTR = var_CTR(:,:,1:29,:,:) * d_omega_CTR / dph_CTR(:,:,1:29,:,:)
printVarSummary(q_dOmega_dp_CTR)

;--------

var_vert_adv_TOPO_mean = dim_avg_n_Wrap(var_adv_TOPO,0)
var_vert_adv_TOPO_std = dim_stddev_n_Wrap(var_adv_TOPO,0)
var_vert_adv_CTR_mean = dim_avg_n_Wrap(var_adv_CTR,0)
var_vert_adv_CTR_std = dim_stddev_n_Wrap(var_adv_CTR,0) 

var_vert_gra_TOPO_mean = dim_avg_n_Wrap(q_dOmega_dp_TOPO,0)
var_vert_gra_TOPO_std = dim_stddev_n_Wrap(q_dOmega_dp_TOPO,0)
var_vert_gra_CTR_mean = dim_avg_n_Wrap(q_dOmega_dp_CTR,0)
var_vert_gra_CTR_std = dim_stddev_n_Wrap(q_dOmega_dp_CTR,0) 

var_vert_adv_TOPO_mean!0 = "time"
var_vert_adv_TOPO_mean&time = f_TOPO->time(num1(i_num):num2(i_num))
var_vert_adv_TOPO_mean!1 = "lev"
var_vert_adv_TOPO_mean&lev = f_TOPO->lev(1:29)
var_vert_adv_TOPO_mean!2 = "lat"
var_vert_adv_TOPO_mean&lat = f_TOPO->lat
var_vert_adv_TOPO_mean!3 = "lon"
var_vert_adv_TOPO_mean&lon = f_TOPO->lon

var_vert_adv_CTR_mean!0 = "time"
var_vert_adv_CTR_mean&time = f_CTR->time(num1(i_num):num2(i_num))
var_vert_adv_CTR_mean!1 = "lev"
var_vert_adv_CTR_mean&lev = f_CTR->lev(1:29)
var_vert_adv_CTR_mean!2 = "lat"
var_vert_adv_CTR_mean&lat = f_CTR->lat
var_vert_adv_CTR_mean!3 = "lon"
var_vert_adv_CTR_mean&lon = f_CTR->lon

var_vert_gra_TOPO_mean!0 = "time"
var_vert_gra_TOPO_mean&time = f_TOPO->time(num1(i_num):num2(i_num))
var_vert_gra_TOPO_mean!1 = "lev"
var_vert_gra_TOPO_mean&lev = f_TOPO->lev(1:29)
var_vert_gra_TOPO_mean!2 = "lat"
var_vert_gra_TOPO_mean&lat = f_TOPO->lat
var_vert_gra_TOPO_mean!3 = "lon"
var_vert_gra_TOPO_mean&lon = f_TOPO->lon

var_vert_gra_CTR_mean!0 = "time"
var_vert_gra_CTR_mean&time = f_CTR->time(num1(i_num):num2(i_num))
var_vert_gra_CTR_mean!1 = "lev"
var_vert_gra_CTR_mean&lev = f_CTR->lev(1:29)
var_vert_gra_CTR_mean!2 = "lat"
var_vert_gra_CTR_mean&lat = f_CTR->lat
var_vert_gra_CTR_mean!3 = "lon"
var_vert_gra_CTR_mean&lon = f_CTR->lon

printVarSummary(var_vert_adv_TOPO_mean)
printVarSummary(var_vert_adv_TOPO_std)
printVarSummary(var_vert_adv_CTR_mean)
printVarSummary(var_vert_adv_CTR_std)

printVarSummary(var_vert_gra_TOPO_mean)
printVarSummary(var_vert_gra_TOPO_std)
printVarSummary(var_vert_gra_CTR_mean)
printVarSummary(var_vert_gra_CTR_std)

;====================== output to nc files ======
;dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_TOPO_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/TOPO_TEST/"
dir_CTR_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.Q_vert_adv.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.Q_vert_adv.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->var_vert_adv_TOPO_mean = var_vert_adv_TOPO_mean
ncdf_TOPO->var_vert_adv_TOPO_std = var_vert_adv_TOPO_std

ncdf_TOPO->var_vert_gra_TOPO_mean = var_vert_gra_TOPO_mean
ncdf_TOPO->var_vert_gra_TOPO_std = var_vert_gra_TOPO_std

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.Q_vert_adv.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.Q_vert_adv.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->var_vert_adv_CTR_mean = var_vert_adv_CTR_mean
ncdf_CTR->var_vert_adv_CTR_std = var_vert_adv_CTR_std

ncdf_CTR->var_vert_gra_CTR_mean = var_vert_gra_CTR_mean
ncdf_CTR->var_vert_gra_CTR_std = var_vert_gra_CTR_std

end do ; do i_num

end
