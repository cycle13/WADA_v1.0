;Function: Moisture Flux difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180726
;Ref
;Payne, A. E., and G. Magnusdottir (2014), Dynamics of Landfalling Atmospheric Rivers over the North Pacific in 30 Years of MERRA Reanalysis, JOURNAL OF CLIMATE, 27(18), 7133-7150, doi: 10.1175/JCLI-D-14-00034.1.
;Payne, A. E., and G. Magnusdottir (2015), An evaluation of atmospheric rivers over the North Pacific in CMIP5 and their response to warming under RCP 8.5, Journal of Geophysical Research: Atmospheres, 120(21), 2015JD023586-022015JD023586, doi: 10.1002/2015JD023586.
;Lavers, D. A., G. Villarini, R. P. Allan, E. F. Wood, and A. J. Wade (2012), The detection of atmospheric rivers in atmospheric reanalyses and their links to British winter floods and the large-scale climatic circulation, Journal of Geophysical Research-Atmospheres, 117.

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;===================== Part I: Calculate the mean and std of Moisture Flux for TOPO and CTR =======================
;========== "vibeta"===
dir_TOPO_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

members = 180

U_TOPO = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_TOPO = new((/members,12,30,96,144/),double)
Q_TOPO = new((/members,12,30,96,144/),double)
PS_TOPO = new((/members,12,96,144/),double)

U_CTR = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_CTR = new((/members,12,30,96,144/),double)
Q_CTR = new((/members,12,30,96,144/),double)
PS_CTR = new((/members,12,96,144/),double)

U_TOPO!0 = "members"
U_TOPO&members = ispan(1,180,1)
V_TOPO!0 = "members"
V_TOPO&members = ispan(1,180,1)
Q_TOPO!0 = "members"
Q_TOPO&members = ispan(1,180,1)

PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,180,1)

U_CTR!0 = "members"
U_CTR&members = ispan(1,180,1)
V_CTR!0 = "members"
V_CTR&members = ispan(1,180,1)
Q_CTR!0 = "members"
Q_CTR&members = ispan(1,180,1)

PS_CTR!0 = "members"
PS_CTR&members = ispan(1,180,1)

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

U_TOPO(i_file,:,:,:,:) = f_TOPO->U
V_TOPO(i_file,:,:,:,:) = f_TOPO->V
Q_TOPO(i_file,:,:,:,:) = f_TOPO->Q
PS_TOPO(i_file,:,:,:) = f_TOPO->PS

U_CTR(i_file,:,:,:,:) = f_CTR->U
V_CTR(i_file,:,:,:,:) = f_CTR->V
Q_CTR(i_file,:,:,:,:) = f_CTR->Q
PS_CTR(i_file,:,:,:) = f_CTR->PS

end do  ; do i_fiel

printVarSummary(U_TOPO)
printVarSummary(V_TOPO)
printVarSummary(Q_TOPO)
printVarSummary(PS_TOPO)
printVarSummary(U_CTR)
printVarSummary(V_CTR)
printVarSummary(Q_CTR)
printVarSummary(PS_CTR)


;------------------------
hyam = f_TOPO->hyam
hybm = f_TOPO->hybm 
p0   = 100000. 
pbot = 101300.   
ptop = 30000.    ; upper level, 300 hPa ; integral from 101300 Pa to 30000 Pa.
g = 9.8

;----------Calculate vint_QU_TOPO, and vint_QV_TOPO---------------
pm_TOPO   = Q_TOPO       ;(members,time,lev,lat,lon); metadata
pm_TOPO   = pres_hybrid_ccm(PS_TOPO, p0, hyam, hybm)  
;pm(ntim,klvl,nlat,mlon) top-to-bottom
pm_TOPO@long_name = "pressure"
pm_TOPO@units     = "Pa"
                ; create array with appropriate metadata
Q_U_TOPO = Q_TOPO ; metadata
Q_V_TOPO = Q_TOPO ; metadata

Q_U_TOPO = Q_TOPO * U_TOPO
Q_V_TOPO = Q_TOPO * V_TOPO

printVarSummary(Q_U_TOPO)
printVarSummary(Q_V_TOPO)
;

vint_QU_TOPO = Q_TOPO(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_QU_TOPO = vibeta(pm_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1), Q_U_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_QV_TOPO = Q_TOPO(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
vint_QV_TOPO = vibeta(pm_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1), Q_V_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_QU_TOPO = vint_QU_TOPO / g
vint_QU_TOPO@long_name = "1/g * integral (Q*U) dp"
vint_QU_TOPO@units = "kg/(meter*sec)"
vint_QV_TOPO = vint_QV_TOPO / g
vint_QV_TOPO@long_name = "1/g * integral (Q*V) dp"
vint_QV_TOPO@units = "kg/(meter*sec)"

IVT_TOPO = sqrt(vint_QU_TOPO^2+vint_QV_TOPO^2)
IVT_TOPO@long_name = "Integrated Vapor Transport "
IVT_TOPO@units = "kg/(meter*sec)"

printVarSummary(vint_QU_TOPO)
printVarSummary(vint_QV_TOPO)
printVarSummary(IVT_TOPO)

;------save memory-----
delete(Q_TOPO)
delete(U_TOPO)
delete(V_TOPO)
delete(PS_TOPO)
delete(pm_TOPO)
delete(Q_U_TOPO)
delete(Q_V_TOPO)

;-------- Calculate vint_QU_CTR and vint_QV_CTR---
pm_CTR   = Q_CTR       ;(members,time,lev,lat,lon); metadata
pm_CTR   = pres_hybrid_ccm(PS_CTR, p0, hyam, hybm)  
;pm(ntim,klvl,nlat,mlon) top-to-bottom
pm_CTR@long_name = "pressure"
pm_CTR@units     = "Pa"
                ; create array with appropriate metadata
Q_U_CTR = Q_CTR ; metadata
Q_V_CTR = Q_CTR ; metadata

Q_U_CTR = Q_CTR * U_CTR
Q_V_CTR = Q_CTR * V_CTR

printVarSummary(Q_U_CTR)
printVarSummary(Q_V_CTR)

vint_QU_CTR = Q_CTR(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_QU_CTR = vibeta(pm_CTR(members|:,time|:,lat|:,lon|:,lev|::-1), Q_U_CTR(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_CTR,pbot,ptop)

vint_QV_CTR = Q_CTR(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
vint_QV_CTR = vibeta(pm_CTR(members|:,time|:,lat|:,lon|:,lev|::-1), Q_V_CTR(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_CTR,pbot,ptop)

vint_QU_CTR = vint_QU_CTR / g
vint_QU_CTR@long_name = "1/g * integral (Q*U) dp"
vint_QU_CTR@units = "kg/(meter*sec)"
vint_QV_CTR = vint_QV_CTR / g
vint_QV_CTR@long_name = "1/g * integral (Q*V) dp"
vint_QV_CTR@units = "kg/(meter*sec)"

IVT_CTR = sqrt(vint_QU_CTR^2+vint_QV_CTR^2)
IVT_CTR@long_name = "Integraetd Vapor Transport "
IVT_CTR@units = "kg/(meter*sec)"
   
printVarSummary(vint_QU_CTR)
printVarSummary(vint_QV_CTR)
printVarSummary(IVT_CTR)

;------save memory-----
delete(Q_CTR)
delete(U_CTR)
delete(V_CTR)
delete(PS_CTR)
delete(pm_CTR)
delete(Q_U_CTR)
delete(Q_V_CTR)

;--------------Calculate the mean and std ----------

QU_TOPO_mean = dim_avg_n_Wrap(vint_QU_TOPO,0)
QU_TOPO_std = dim_stddev_n_Wrap(vint_QU_TOPO,0)
QV_TOPO_mean = dim_avg_n_Wrap(vint_QV_TOPO,0)
QV_TOPO_std = dim_stddev_n_Wrap(vint_QV_TOPO,0)
IVT_TOPO_mean = dim_avg_n_Wrap(IVT_TOPO,0)
IVT_TOPO_std = dim_stddev_n_Wrap(IVT_TOPO,0)

QU_CTR_mean = dim_avg_n_Wrap(vint_QU_CTR,0)
QU_CTR_std = dim_stddev_n_Wrap(vint_QU_CTR,0)
QV_CTR_mean = dim_avg_n_Wrap(vint_QV_CTR,0)
QV_CTR_std = dim_stddev_n_Wrap(vint_QV_CTR,0)
IVT_CTR_mean = dim_avg_n_Wrap(IVT_CTR,0)
IVT_CTR_std = dim_stddev_n_Wrap(IVT_CTR,0)

printVarSummary(QU_TOPO_mean)
printVarSummary(QU_TOPO_std)
printVarSummary(QV_TOPO_mean)
printVarSummary(QV_TOPO_std)
printVarSummary(IVT_TOPO_mean)
printVarSummary(IVT_TOPO_std)

printVarSummary(QU_CTR_mean)
printVarSummary(QU_CTR_std)
printVarSummary(QV_CTR_mean)
printVarSummary(QV_CTR_std)
printVarSummary(IVT_CTR_mean)
printVarSummary(IVT_CTR_std)

;---------------------output variables QU_TOPO_mean, QU_TOPO_std, QV_TOPO_mean, QV_TOPO_std ----------
diro_TOPO = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"                     ; Output directory
filo_TOPO = "QU_QV_IVT.mean_std.TOPO.nc"             ; Output file
system("rm -f "+diro_TOPO+filo_TOPO)
ncdf_TOPO = addfile(diro_TOPO+filo_TOPO,"c")

filedimdef(ncdf_TOPO,"time",-1,True)

ncdf_TOPO->QU_TOPO_mean = QU_TOPO_mean
ncdf_TOPO->QU_TOPO_std = QU_TOPO_std
ncdf_TOPO->QV_TOPO_mean = QV_TOPO_mean
ncdf_TOPO->QV_TOPO_std = QV_TOPO_std
ncdf_TOPO->IVT_TOPO_mean = IVT_TOPO_mean
ncdf_TOPO->IVT_TOPO_std = IVT_TOPO_std

;--------------------output variables QU_CTR_mean, QU_CTR_std, QV_CTR_mean, QV_CTR_std --------------
diro_CTR = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"                     ; Output directory
filo_CTR = "QU_QV_IVT.mean_std.CTR.nc"             ; Output file
system("rm -f "+diro_CTR+filo_CTR)
ncdf_CTR = addfile(diro_CTR+filo_CTR,"c")

filedimdef(ncdf_CTR,"time",-1,True)

ncdf_CTR->QU_CTR_mean = QU_CTR_mean
ncdf_CTR->QU_CTR_std = QU_CTR_std
ncdf_CTR->QV_CTR_mean = QV_CTR_mean
ncdf_CTR->QV_CTR_std = QV_CTR_std
ncdf_CTR->IVT_CTR_mean = IVT_CTR_mean
ncdf_CTR->IVT_CTR_std = IVT_CTR_std

end
