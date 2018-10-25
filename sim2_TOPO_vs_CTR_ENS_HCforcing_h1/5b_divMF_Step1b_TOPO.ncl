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

dir_TOPO_in = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"

;dir_TOPO_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;dir_CTR_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
;f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

members = 180

U_TOPO = new((/members,4,30,96,144/),double)    ;members x 4day x 30lev x 96lat x 144 lon
V_TOPO = new((/members,4,30,96,144/),double)
Q_TOPO = new((/members,4,30,96,144/),double)
PS_TOPO = new((/members,4,96,144/),double)

U_TOPO!0 = "members"
U_TOPO&members = ispan(1,180,1)
V_TOPO!0 = "members"
V_TOPO&members = ispan(1,180,1)
Q_TOPO!0 = "members"
Q_TOPO&members = ispan(1,180,1)

PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,180,1)

do i_file = 0, members - 1
f_TOPO = addfile(f_TOPO_str(i_file),"r")

printVarSummary(f_TOPO->V)

U_TOPO(i_file,:,:,:,:) = f_TOPO->U
V_TOPO(i_file,:,:,:,:) = f_TOPO->V
Q_TOPO(i_file,:,:,:,:) = f_TOPO->Q
PS_TOPO(i_file,:,:,:) = f_TOPO->PS

end do  ; do i_fiel

printVarSummary(U_TOPO)
printVarSummary(V_TOPO)
printVarSummary(Q_TOPO)
printVarSummary(PS_TOPO)

;------------------------
hyam = f_TOPO->hyam
hybm = f_TOPO->hybm 
p0   = 100000. 
pbot = 101300.   
ptop = 30000.    ; upper level, 300 hPa ; integral from 101300 Pa to 30000 Pa.
g = 9.8

;--------------- calculate [div(u,v) * Q ] first, then vertical integral ------

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

divMF_TOPO = Q_TOPO        ; metadata 
divMF_TOPO = uv2dv_cfd(Q_U_TOPO,Q_V_TOPO,f_TOPO->lat,f_TOPO->lon,3)
divMF_TOPO@long_name = "div((u,v) dot Q)"
divMF_TOPO@units = "1/sec"

;----------------------

vint_divMF_TOPO = Q_TOPO(members|:,time|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_divMF_TOPO = vibeta(pm_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1), divMF_TOPO(members|:,time|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_divMF_TOPO = vint_divMF_TOPO / g
vint_divMF_TOPO@long_name = "1/g * integral {div[(u,v) dot q]} dp"
vint_divMF_TOPO@units = "kg/(meter^2 * sec)"

printVarSummary(vint_divMF_TOPO)

;------save memory-----
delete(Q_TOPO)
delete(U_TOPO)
delete(V_TOPO)
delete(PS_TOPO)
delete(pm_TOPO)
delete(Q_U_TOPO)
delete(Q_V_TOPO)

delete(divMF_TOPO)

;--------------Calculate the mean and std ----------

vint_divMF_TOPO_mean = dim_avg_n_Wrap(vint_divMF_TOPO,0)
vint_divMF_TOPO_std = dim_stddev_n_Wrap(vint_divMF_TOPO,0)

printVarSummary(vint_divMF_TOPO_mean)
printVarSummary(vint_divMF_TOPO_std)

;--------------- save memory -------
delete(vint_divMF_TOPO)

;---------------------output variables QU_TOPO_mean, QU_TOPO_std, QV_TOPO_mean, QV_TOPO_std ----------
diro_TOPO = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes/TOPO_TEST/"
;diro_TOPO = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"                     ; Output directory
filo_TOPO = "vint_divMF.mean_std.TOPO.nc"             ; Output file
system("rm -f "+diro_TOPO+filo_TOPO)
ncdf_TOPO = addfile(diro_TOPO+filo_TOPO,"c")

filedimdef(ncdf_TOPO,"time",-1,True)

ncdf_TOPO->vint_divMF_TOPO_mean = vint_divMF_TOPO_mean
ncdf_TOPO->vint_divMF_TOPO_std = vint_divMF_TOPO_std



end
