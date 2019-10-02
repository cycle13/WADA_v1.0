;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.div.nc  under this directory:
;          /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.div.nc under /scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/
;Note: Modified 20181001
;Note: modified for temperature advection on 20181023

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

U_TOPO = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
V_TOPO = new((/members,3,30,96,144/),double) 
var_TOPO = new((/members,3,30,96,144/),double) 
PS_TOPO = new((/members,3,96,144/),double) 

U_CTR = new((/members,3,30,96,144/),double)    ;members x 3 hrs x 30lev x 96lat x 144 lon
V_CTR = new((/members,3,30,96,144/),double) 
var_CTR = new((/members,3,30,96,144/),double) 
PS_CTR = new((/members,3,96,144/),double) 

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

U_TOPO(i_file,:,:,:,:) = f_TOPO->U(num1(i_num):num2(i_num),:,:,:)
V_TOPO(i_file,:,:,:,:) = f_TOPO->V(num1(i_num):num2(i_num),:,:,:)
var_TOPO(i_file,:,:,:,:) = f_TOPO->Q(num1(i_num):num2(i_num),:,:,:)
PS_TOPO(i_file,:,:,:) = f_TOPO->PS(num1(i_num):num2(i_num),:,:)

U_CTR(i_file,:,:,:,:) = f_CTR->U(num1(i_num):num2(i_num),:,:,:)
V_CTR(i_file,:,:,:,:) = f_CTR->V(num1(i_num):num2(i_num),:,:,:)
var_CTR(i_file,:,:,:,:) = f_CTR->Q(num1(i_num):num2(i_num),:,:,:)
PS_CTR(i_file,:,:,:) = f_CTR->PS(num1(i_num):num2(i_num),:,:)

end do  ; do i_fiel
;printVarSummary(U_TOPO)
;printVarSummary(V_TOPO)

;-------------------- Mike: for horizontal gradient terms, you want to interpolate to high-reso pressure levels first
pnew = f_CTR->lev
P0mb = 1000.0
hyam = f_CTR->hyam
hybm = f_CTR->hybm

var_CTR_pnew = vinth2p(var_CTR,hyam,hybm,pnew,PS_CTR,1,P0mb,1,False)
var_CTR_pnew&lev@units = "hPa" 
U_CTR_pnew = vinth2p(U_CTR,hyam,hybm,pnew,PS_CTR,1,P0mb,1,False)
U_CTR_pnew&lev@units = "hPa" 
V_CTR_pnew = vinth2p(V_CTR,hyam,hybm,pnew,PS_CTR,1,P0mb,1,False)
V_CTR_pnew&lev@units = "hPa" 
printVarSummary(var_CTR_pnew)
printVarSummary(U_CTR_pnew)
printVarSummary(V_CTR_pnew)

var_TOPO_pnew = vinth2p(var_TOPO,hyam,hybm,pnew,PS_TOPO,1,P0mb,1,False)
var_TOPO_pnew&lev@units = "hPa" 
U_TOPO_pnew = vinth2p(U_TOPO,hyam,hybm,pnew,PS_TOPO,1,P0mb,1,False)
U_TOPO_pnew&lev@units = "hPa" 
V_TOPO_pnew = vinth2p(V_TOPO,hyam,hybm,pnew,PS_TOPO,1,P0mb,1,False)
V_TOPO_pnew&lev@units = "hPa" 
printVarSummary(var_TOPO_pnew)
printVarSummary(U_TOPO_pnew)
printVarSummary(V_TOPO_pnew)

;------------
;----- U * partial_Q/partial_x + V * partial_Q/partial_y , you need to time (-1) in the downstream file to make it advection form
var_adv_TOPO = advect_variable(U_TOPO_pnew,V_TOPO_pnew,var_TOPO_pnew,0,"Q advection","1/s",0)
printVarSummary(var_adv_TOPO)  
var_adv_CTR = advect_variable(U_CTR_pnew,V_CTR_pnew,var_CTR_pnew,0,"Q advection","1/s",0)
printVarSummary(var_adv_CTR)

;------ calculate Q * (partial U/partial x + partial V/partial y)
var_div_TOPO = var_TOPO * uv2dvG(U_TOPO,V_TOPO)
copy_VarCoords(var_adv_TOPO,var_div_TOPO)
printVarSummary(var_div_TOPO)
var_div_CTR = var_CTR * uv2dvG(U_CTR,V_CTR)
copy_VarCoords(var_adv_CTR,var_div_CTR)
printVarSummary(var_div_CTR)

;--------

var_adv_TOPO_mean = dim_avg_n_Wrap(var_adv_TOPO,0)
var_adv_TOPO_std = dim_stddev_n_Wrap(var_adv_TOPO,0)
var_adv_CTR_mean = dim_avg_n_Wrap(var_adv_CTR,0)
var_adv_CTR_std = dim_stddev_n_Wrap(var_adv_CTR,0)

var_div_TOPO_mean = dim_avg_n_Wrap(var_div_TOPO,0)
var_div_TOPO_std = dim_stddev_n_Wrap(var_div_TOPO,0)
var_div_CTR_mean = dim_avg_n_Wrap(var_div_CTR,0)
var_div_CTR_std = dim_stddev_n_Wrap(var_div_CTR,0)

printVarSummary(var_adv_TOPO_mean)
printVarSummary(var_adv_TOPO_std)
printVarSummary(var_adv_CTR_mean)
printVarSummary(var_adv_CTR_std)

printVarSummary(var_div_TOPO_mean)
printVarSummary(var_div_TOPO_std)
printVarSummary(var_div_CTR_mean)
printVarSummary(var_div_CTR_std)

;====================== output to nc files ======
;dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_TOPO_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/TOPO_TEST/"
dir_CTR_out = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.Qadv.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.Qadv.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->var_adv_TOPO_mean = var_adv_TOPO_mean
ncdf_TOPO->var_adv_TOPO_std = var_adv_TOPO_std
ncdf_TOPO->var_div_TOPO_mean = var_div_TOPO_mean
ncdf_TOPO->var_div_TOPO_std = var_div_TOPO_std

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.Qadv.time"+num1(i_num)+"-"+num2(i_num)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.Qadv.time"+num1(i_num)+"-"+num2(i_num)+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)
ncdf_CTR->var_adv_CTR_mean = var_adv_CTR_mean
ncdf_CTR->var_adv_CTR_std = var_adv_CTR_std
ncdf_CTR->var_div_CTR_mean = var_div_CTR_mean
ncdf_CTR->var_div_CTR_std = var_div_CTR_std

end do ; do i_num

end
