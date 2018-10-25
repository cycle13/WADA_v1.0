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

time1 = time_array(0)
time2 = time_array(1)

;====== to avoid memory issues ========

TAP_TOPO = new((/members,2,30,96,144/),double)    ;members x 2 hr x 30lev x 96lat x 144 lon
PTTEND_TOPO = new((/members,30,96,144/),double) 

TAP_CTR = new((/members,2,30,96,144/),double)    ;members x 2 hr x 30lev x 96lat x 144 lon
PTTEND_CTR = new((/members,30,96,144/),double) 

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

TAP_TOPO(i_file,:,:,:,:) = f_TOPO->TAP(time1:time2,:,:,:)

PTTEND_TOPO(i_file,:,:,:) = f_TOPO->PTTEND(time2,:,:,:)

TAP_CTR(i_file,:,:,:,:) = f_CTR->TAP(time1:time2,:,:,:)

PTTEND_CTR(i_file,:,:,:) = f_CTR->PTTEND(time2,:,:,:)

end do  ; do i_fiel

printVarSummary(TAP_TOPO)
printVarSummary(PTTEND_TOPO)

exit

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
exit

;====================== output to nc files ======
dir_TOPO_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/TOPO_TEST/"
dir_CTR_out = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/CTR/"

system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.Tdecom."+time2+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.Tdecom."+time2+".nc","c")
filedimdef(ncdf_TOPO,"time",-1,True)
ncdf_TOPO->Ttot_TOPO_mean = Ttot_TOPO_mean
ncdf_TOPO->Ttot_TOPO_std = Ttot_TOPO_std

ncdf_TOPO->Tadv_TOPO_mean = Tadv_TOPO_mean
ncdf_TOPO->Tadv_TOPO_std = Tadv_TOPO_std

ncdf_TOPO->PTTEND_TOPO_mean = PTTEND_TOPO_mean
ncdf_TOPO->PTTEND_TOPO_std = PTTEND_TOPO_std

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.Tdecom."+time2+".nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.Tdecom."+time2+".nc","c")
filedimdef(ncdf_CTR,"time",-1,True)

ncdf_CTR->Ttot_CTR_mean = Ttot_CTR_mean
ncdf_CTR->Ttot_CTR_std = Ttot_CTR_std

ncdf_CTR->Tadv_CTR_mean = Tadv_CTR_mean
ncdf_CTR->Tadv_CTR_std = Tadv_CTR_std

ncdf_CTR->PTTEND_CTR_mean = PTTEND_CTR_mean
ncdf_CTR->PTTEND_CTR_std = PTTEND_CTR_std


end
