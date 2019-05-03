;Function: Explore if 96hr dada could be used to generate the Wheeler-Kiladis Space-Time Spectra
;Date: 20190503

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl"

begin

case = "TOPO"
diro = "../Figures/"

latN = 20
latS = -latN

nDayWin = 4
nDaySkip = -2

opt = True
opt@debug = True
opt@pltType = "ps" ; allowed "ps", "eps", "x11", "ncgm", default: "ps"

varName = "PRECT"
spd = 24  ; 24 samples per day; hourly data

prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"
diri = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/" 
fili = "ENS.TOPOTEST.nc"

f = addfile(diri+fili, "r")
var = dim_avg_n_Wrap(f->PRECT(:,:,{latS:latN},:), 0)   ; average across realizations

wkSpaceTime(var, diro, case, varName, latN, spd, nDayWin, nDaySkip, opt)









end
