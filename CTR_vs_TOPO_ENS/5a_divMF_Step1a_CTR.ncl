;Function: Moisture Flux difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180726
;Ref
;Payne, A. E., and G. Magnusdottir (2014), Dynamics of Landfalling Atmospheric Rivers over the North Pacific in 30 Years of MERRA Reanalysis, JOURNAL OF CLIMATE, 27(18), 7133-7150, doi: 10.1175/JCLI-D-14-00034.1.
;Payne, A. E., and G. Magnusdottir (2015), An evaluation of atmospheric rivers over the North Pacific in CMIP5 and their response to warming under RCP 8.5, Journal of Geophysical Research: Atmospheres, 120(21), 2015JD023586-022015JD023586, doi: 10.1002/2015JD023586.
;Lavers, D. A., G. Villarini, R. P. Allan, E. F. Wood, and A. J. Wade (2012), The detection of atmospheric rivers in atmospheric reanalyses and their links to British winter floods and the large-scale climatic circulation, Journal of Geophysical Research-Atmospheres, 117.
;Note: Moisture Flux Divergence in CTR (one file for writing CTR, the other for writing TOPO to avoid memory issues)

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;===================== Part I: Calculate the mean and std of Moisture Flux for TOPO and CTR =======================
;========== "vibeta"===
dir_TOPO_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
print(f_TOPO_str)

members = 180

U_CTR = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_CTR = new((/members,12,30,96,144/),double)
Q_CTR = new((/members,12,30,96,144/),double)
PS_CTR = new((/members,12,96,144/),double)

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

U_CTR(i_file,:,:,:,:) = f_CTR->U
V_CTR(i_file,:,:,:,:) = f_CTR->V
Q_CTR(i_file,:,:,:,:) = f_CTR->Q
PS_CTR(i_file,:,:,:) = f_CTR->PS

end do  ; do i_fiel

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

;------------- calculate div((u,v) * Q) first, then vertical integral------

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

divMF_CTR = Q_CTR        ; metadata 
divMF_CTR = uv2dv_cfd(Q_U_CTR,Q_V_CTR,f_CTR->lat,f_CTR->lon,3)
divMF_CTR@long_name = "div((u,v) dot Q)"
divMF_CTR@units = "1/sec"

;------------------

vint_divMF_CTR = Q_CTR(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_divMF_CTR = vibeta(pm_CTR(members|:,time|:,lat|:,lon|:,lev|::-1), divMF_CTR(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_CTR,pbot,ptop)

vint_divMF_CTR = vint_divMF_CTR / g
vint_divMF_CTR@long_name = "1/g * integral {div[(u,v) dot q]} dp"
vint_divMF_CTR@units = "kg/(meter^2 * sec)"

printVarSummary(vint_divMF_CTR)

;------save memory-----
delete(Q_CTR)
delete(U_CTR)
delete(V_CTR)
delete(PS_CTR)
delete(pm_CTR)
delete(Q_U_CTR)
delete(Q_V_CTR)

delete(divMF_CTR)

;--------------Calculate the mean and std ----------

vint_divMF_CTR_mean = dim_avg_n_Wrap(vint_divMF_CTR,0)
vint_divMF_CTR_std = dim_stddev_n_Wrap(vint_divMF_CTR,0)

printVarSummary(vint_divMF_CTR_mean)
printVarSummary(vint_divMF_CTR_std)

;----------save memory-------
delete(vint_divMF_CTR)
;
;--------------------output variables QU_CTR_mean, QU_CTR_std, QV_CTR_mean, QV_CTR_std --------------
diro_CTR = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"                     ; Output directory
filo_CTR = "vint_divMF.mean_std.CTR.nc"             ; Output file
system("rm -f "+diro_CTR+filo_CTR)
ncdf_CTR = addfile(diro_CTR+filo_CTR,"c")

filedimdef(ncdf_CTR,"time",-1,True)

ncdf_CTR->vint_divMF_CTR_mean = vint_divMF_CTR_mean
ncdf_CTR->vint_divMF_CTR_std = vint_divMF_CTR_std



end
