;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.Tdecom.nc  under this directory:
;          /lustre/DATA/pritchard/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.Tdecom.nc under /lustre/DATA/pritchard/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/
;Note: modified for decomposing Temperature tendency into Ttend_advect and Ttend_physics

begin

dir_TOPO_in = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/TOPO_TEST/"
dir_CTR_in = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

members = 180

time_array = ispan(0,47,1)
;print(time_array)

do i_time = 0,46

time1 = time_array(i_time)
time2 = time_array(i_time+1)

;====== to avoid memory issues ========

TAP_TOPO = new((/members,2,30,96,144/),double)    ;members x 2 hr x 30lev x 96lat x 144 lon
PTTEND_TOPO = new((/members,30,96,144/),double) 
PS_TOPO = new((/members,96,144/),double)  ; vinth2p next step

TAP_CTR = new((/members,2,30,96,144/),double)    ;members x 2 hr x 30lev x 96lat x 144 lon
PTTEND_CTR = new((/members,30,96,144/),double) 
PS_CTR = new((/members,96,144/),double) 

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

TAP_TOPO(i_file,:,:,:,:) = f_TOPO->TAP(time1:time2,:,:,:)

PTTEND_TOPO(i_file,:,:,:) = f_TOPO->PTTEND(time2,:,:,:)

PS_TOPO(i_file,:,:) = f_TOPO->PS(time2,:,:)

TAP_CTR(i_file,:,:,:,:) = f_CTR->TAP(time1:time2,:,:,:)

PTTEND_CTR(i_file,:,:,:) = f_CTR->PTTEND(time2,:,:,:)

PS_CTR(i_file,:,:) = f_CTR->PS(time2,:,:)

end do  ; do i_fiel

;------ for vint2p next step --
hyam = f_TOPO->hyam
hybm = f_TOPO->hybm

;------
printVarSummary(TAP_TOPO)
printVarSummary(PTTEND_TOPO)
printVarSummary(PS_TOPO)

;-------------------- Ttot_TOPO and Ttot_CTR ---------
Ttot_TOPO = (TAP_TOPO(:,1,:,:,:) - TAP_TOPO(:,0,:,:,:))/3600.0
Ttot_TOPO@long_name = "[TAP(i)-TAP(i-1)]/ 3600"  ; time in hour, it's TAP:I(ntantaneous)
Ttot_TOPO@units = "K/sec"

printVarSummary(Ttot_TOPO) 

Ttot_CTR = (TAP_CTR(:,1,:,:,:) - TAP_CTR(:,0,:,:,:))/3600.0
Ttot_CTR@long_name = "[TAP(i)-TAP(i-1)]/ 3600"
Ttot_CTR@units = "K/sec"
printVarSummary(Ttot_CTR) 

Ttot_TOPO_mean = dim_avg_n_Wrap(Ttot_TOPO,0)
Ttot_TOPO_std = dim_stddev_n_Wrap(Ttot_TOPO,0)
Ttot_CTR_mean = dim_avg_n_Wrap(Ttot_CTR,0)
Ttot_CTR_std = dim_stddev_n_Wrap(Ttot_CTR,0)

printVarSummary(Ttot_TOPO_mean)
printVarSummary(Ttot_TOPO_std)
printVarSummary(Ttot_CTR_mean)
printVarSummary(Ttot_CTR_std)

;----------------------------------------
;-------------------- Tadv_TOPO and Tadv_CTR ---------
Tadv_TOPO = (TAP_TOPO(:,1,:,:,:) - TAP_TOPO(:,0,:,:,:))/3600.0 - PTTEND_TOPO
Tadv_TOPO@long_name = "[TAP(i)-TAP(i-1)]/ 3600 - PTTEND(i)"
Tadv_TOPO@units = "K/sec"
printVarSummary(Tadv_TOPO) 

Tadv_CTR = (TAP_CTR(:,1,:,:,:) - TAP_CTR(:,0,:,:,:))/3600.0 - PTTEND_CTR
Tadv_CTR@long_name = "[TAP(i)-TAP(i-1)]/ 3600 - PTTEND(i)"
Tadv_CTR@units = "K/sec"
printVarSummary(Tadv_CTR) 

Tadv_TOPO_mean = dim_avg_n_Wrap(Tadv_TOPO,0)
Tadv_TOPO_std = dim_stddev_n_Wrap(Tadv_TOPO,0)
Tadv_CTR_mean = dim_avg_n_Wrap(Tadv_CTR,0)
Tadv_CTR_std = dim_stddev_n_Wrap(Tadv_CTR,0)

printVarSummary(Tadv_TOPO_mean)
printVarSummary(Tadv_TOPO_std)
printVarSummary(Tadv_CTR_mean)
printVarSummary(Tadv_CTR_std)
;----------------------------------------

;--------------- PTTEND_TOPO and PTTEND_CTR---------

PTTEND_TOPO_mean = dim_avg_n_Wrap(PTTEND_TOPO,0)
PTTEND_TOPO_std = dim_stddev_n_Wrap(PTTEND_TOPO,0)
PTTEND_CTR_mean = dim_avg_n_Wrap(PTTEND_CTR,0)
PTTEND_CTR_std = dim_stddev_n_Wrap(PTTEND_CTR,0)

printVarSummary(PTTEND_TOPO_mean)
printVarSummary(PTTEND_TOPO_std)

;---------PS ------

PS_TOPO_mean = dim_avg_n_Wrap(PS_TOPO,0)
PS_TOPO_std = dim_stddev_n_Wrap(PS_TOPO,0)
PS_CTR_mean = dim_avg_n_Wrap(PS_CTR,0)
PS_CTR_std = dim_stddev_n_Wrap(PS_CTR,0)

printVarSummary(PS_TOPO_mean)
printVarSummary(PS_TOPO_std)

;------------
copy_VarCoords(PTTEND_TOPO_mean,Ttot_TOPO_mean)
copy_VarCoords(PTTEND_TOPO_mean,Ttot_TOPO_std)
copy_VarCoords(PTTEND_TOPO_mean,Tadv_TOPO_mean)
copy_VarCoords(PTTEND_TOPO_mean,Tadv_TOPO_std)

copy_VarCoords(PTTEND_CTR_mean,Ttot_CTR_mean)
copy_VarCoords(PTTEND_CTR_mean,Ttot_CTR_std)
copy_VarCoords(PTTEND_CTR_mean,Tadv_CTR_mean)
copy_VarCoords(PTTEND_CTR_mean,Tadv_CTR_std)

;====================== output to nc files ======
dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/TOPO_TEST/"
dir_CTR_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.Tdecom."+tostring(time2+1)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.Tdecom."+tostring(time2+1)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->Ttot_mean = Ttot_TOPO_mean
ncdf_TOPO->Ttot_std = Ttot_TOPO_std

ncdf_TOPO->Tadv_mean = Tadv_TOPO_mean
ncdf_TOPO->Tadv_std = Tadv_TOPO_std

ncdf_TOPO->PTTEND_mean = PTTEND_TOPO_mean
ncdf_TOPO->PTTEND_std = PTTEND_TOPO_std

ncdf_TOPO->PS_mean = PS_TOPO_mean
ncdf_TOPO->PS_std = PS_TOPO_std

ncdf_TOPO->hyam = hyam
ncdf_TOPO->hybm = hybm

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.Tdecom."+tostring(time2+1)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.Tdecom."+tostring(time2+1)+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)

ncdf_CTR->Ttot_mean = Ttot_CTR_mean
ncdf_CTR->Ttot_std = Ttot_CTR_std

ncdf_CTR->Tadv_mean = Tadv_CTR_mean
ncdf_CTR->Tadv_std = Tadv_CTR_std

ncdf_CTR->PTTEND_mean = PTTEND_CTR_mean
ncdf_CTR->PTTEND_std = PTTEND_CTR_std

ncdf_CTR->PS_mean = PS_CTR_mean
ncdf_CTR->PS_std = PS_CTR_std

ncdf_CTR->hyam = hyam
ncdf_CTR->hybm = hybm

;------------

delete(Ttot_TOPO_mean)
delete(Ttot_TOPO_std)
delete(Tadv_TOPO_mean)
delete(Tadv_TOPO_std)
delete(PTTEND_TOPO_mean)
delete(PTTEND_TOPO_std)
delete(PS_TOPO_mean)
delete(PS_TOPO_std)

delete(Ttot_CTR_mean)
delete(Ttot_CTR_std)
delete(Tadv_CTR_mean)
delete(Tadv_CTR_std)
delete(PTTEND_CTR_mean)
delete(PTTEND_CTR_std)
delete(PS_CTR_mean)
delete(PS_CTR_std)

delete(hyam)
delete(hybm)

end do ; do i_time


end
