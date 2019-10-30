;Function: vertically integrated (HCDEEP + HCSHALLOW) forcing in the  TOPOTEST ensemble, output mean and std of ENS.
;Date: 20181004


load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

;=========================

dir_TOPO_in = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")

;members = 180
members = 9

;i_step = x means x * 6 hr 

chunk = 32
num_time = 96

num1 = new(32,integer)
num2 = new(32,integer)

do i_chunk = 0,chunk-1
num1_temp = i_chunk * num_time/chunk
num2_temp = num1_temp + num_time/chunk - 1

num1(i_chunk) = num1_temp
num2(i_chunk) = num2_temp
end do  ; do i_chunk

;-------------
str_time = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
end do

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47",\
;             "48-53","54-59","60-65","66-71","72-77","78-83","84-89","90-95"/)

do i_step = 0,31
;do i_step = 0,15
;do i_step = 0,7
;do i_step = 8,15

HCforcing_TOPO = new((/members,3,30,96,144/),double)    ;members x 3hr x 30lev x 96lat x 144 lon
PS_TOPO = new((/members,3,96,144/),double)

HCforcing_TOPO!0 = "members"
HCforcing_TOPO&members = ispan(1,members,1)

PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,members,1)

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")

HCforcing_TOPO(i_file,:,:,:,:) = f_TOPO->HCforcing(i_step*3:i_step*3+2,:,:,:)
PS_TOPO(i_file,:,:,:) = f_TOPO->PS(i_step*3:i_step*3+2,:,:)

end do  ; do i_fiel

;-------------

printVarSummary(HCforcing_TOPO)
printVarSummary(PS_TOPO)

;------------------------
hyam = f_TOPO->hyam
hybm = f_TOPO->hybm 
p0   = 100000. 
pbot = 100000.   
ptop = 10000.    ; upper level, 300 hPa ; integral from 100000 Pa to 10000 Pa.
g = 9.8

;--------------- calculate [div(u,v) * Q ] first, then vertical integral ------

pm_TOPO   = HCforcing_TOPO       ;(members,time,lev,lat,lon); metadata
pm_TOPO   = pres_hybrid_ccm(PS_TOPO, p0, hyam, hybm)  
;pm(ntim,klvl,nlat,mlon) top-to-bottom
pm_TOPO@long_name = "pressure"
pm_TOPO@units     = "Pa"
                ; create array with appropriate metadata
forcing_TOPO = HCforcing_TOPO ;
printVarSummary(forcing_TOPO)

;----------------------

vint_forcing_TOPO = forcing_TOPO(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_forcing_TOPO = vibeta(pm_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1), forcing_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_forcing_TOPO = vint_forcing_TOPO / g
vint_forcing_TOPO@long_name = "1/g * integral {TOPO_forcing]} dp"
vint_forcing_TOPO@units = "(Kelvin * kg)/(sec * meter^2)"

printVarSummary(vint_forcing_TOPO)

;------save memory-----
delete(HCforcing_TOPO)
delete(forcing_TOPO)

;--------------Calculate the mean and std ----------

vint_forcing_TOPO_mean = dim_avg_n_Wrap(vint_forcing_TOPO,0)
vint_forcing_TOPO_std = dim_stddev_n_Wrap(vint_forcing_TOPO,0)

printVarSummary(vint_forcing_TOPO_mean)
printVarSummary(vint_forcing_TOPO_std)

;--------------- save memory -------
delete(vint_forcing_TOPO)

;---------------------output variables QU_TOPO_mean, QU_TOPO_std, QV_TOPO_mean, QV_TOPO_std ----------
diro_TOPO = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/vint_forcing"                     ; Output directory
filo_TOPO = "vint_forcing.mean_std.TOPO."+str_time(i_step)+".nc"             ; Output file
system("rm -f "+diro_TOPO+filo_TOPO)
ncdf_TOPO = addfile(diro_TOPO+filo_TOPO,"c")

filedimdef(ncdf_TOPO,"time",-1,True)

ncdf_TOPO->vint_forcing_TOPO_mean = vint_forcing_TOPO_mean
ncdf_TOPO->vint_forcing_TOPO_std = vint_forcing_TOPO_std

end do ; do i_step

end
