;Function: Explore if 96hr dada could be used to generate the Wheeler-Kiladis Space-Time Spectra
;Date: 20190503

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl"

begin

case = "CTR-TOPO"
diro = "../Figures/"

latN = 20
latS = -latN

nDayWin = 4
nDaySkip = -2

opt = True
opt@debug = True
opt@pltType = "ps" ; allowed "ps", "eps", "x11", "ncgm", default: "ps"
;;opt@Fig_3a      = fspan( 1,2,15)
;;opt@Fig_3b      = (/1.0,1.5,2,3,4,5,6,7,8,9,10,11,13,15,17/)  ; unequal

varName = "PRECT"
spd = 24  ; 24 samples per day; hourly data

prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"
diri_TOPO = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/" 
fili_TOPO = "ENS.TOPOTEST.nc"
f_TOPO = addfile(diri_TOPO+fili_TOPO, "r")
var_TOPO = dim_avg_n_Wrap(f_TOPO->PRECT(:,:,{latS:latN},:), 0)   ; average across realizations

diri_CTR = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
fili_CTR = "ENS.CTR.nc"
f_CTR = addfile(diri_CTR+fili_CTR, "r")
var_CTR = dim_avg_n_Wrap(f_CTR->PRECT(:,:,{latS:latN},:), 0)   ; average across realizations

var = var_CTR ; metadata, dimension etc.
var = var_CTR - var_TOPO
printVarSummary(var)

wkSpaceTime(var, diro, case, varName, latN, spd, nDayWin, nDaySkip, opt)









end
