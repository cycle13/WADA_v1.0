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

;---------4D variables: U200, U850, OMEGA500
hyam = f_CTR->hyam(0,:) ; all the same across different realizations
hybm = f_CTR->hybm(0,:)
PS_CTR = dim_avg_n_Wrap(f_CTR->PS(:,:,{latS:latN},:),0)
PS_TOPO = dim_avg_n_Wrap(f_TOPO->PS(:,:,{latS:latN},:),0)
P0 = 1000.

;printVarSummary(hyam)
;printVarSummary(hybm)

lev_p = (/100, 200, 300, 400, 500, 600, 700, 850, 925, 1000/)
lev_p!0 = "lev_p"
lev_p&lev_p = lev_p
lev_p@long_name = "pressure"
lev_p@units = "hPa"
lev_p@positive = "down"

U_CTR = dim_avg_n_Wrap(f_CTR->U(:,:,:,{latS:latN},:),0)
OMEGA_CTR = dim_avg_n_Wrap(f_CTR->OMEGA(:,:,:,{latS:latN},:),0)

U_TOPO = dim_avg_n_Wrap(f_TOPO->U(:,:,:,{latS:latN},:),0)
OMEGA_TOPO = dim_avg_n_Wrap(f_TOPO->OMEGA(:,:,:,{latS:latN},:),0)

U_new_CTR = vinth2p(U_CTR, hyam, hybm, lev_p, PS_CTR, 1, P0, 1, True)  ; True because the wkSpaceTime FFTs do not allow missing values
OMEGA_new_CTR = vinth2p(OMEGA_CTR, hyam, hybm, lev_p, PS_CTR, 1, P0, 1, True)

U_new_TOPO = vinth2p(U_TOPO, hyam, hybm, lev_p, PS_TOPO, 1, P0, 1, True)  ; True because the wkSpaceTime FFTs do not allow missing values
OMEGA_new_TOPO = vinth2p(OMEGA_TOPO, hyam, hybm, lev_p, PS_TOPO, 1, P0, 1, True)

U_new = U_new_CTR ; metadata
U_new = U_new_CTR - U_new_TOPO
OMEGA_new = OMEGA_new_CTR 
OMEGA_new = OMEGA_new_CTR- OMEGA_new_TOPO

varName_4D = (/"U200","U850","OMEGA500"/)
U200 = U_new(:,{200},:,:)
U850 = U_new(:,{850},:,:)
OMEGA500 = OMEGA_new(:,{500},:,:)

printVarSummary(U200)
printVarSummary(U850)
printVarSummary(OMEGA500)

wkSpaceTime(U200, diro, case, "U200", latN, spd, nDayWin, nDaySkip, opt)
wkSpaceTime(U850, diro, case, "U850", latN, spd, nDayWin, nDaySkip, opt)
wkSpaceTime(OMEGA500, diro, case, "OMEGA500", latN, spd, nDayWin, nDaySkip, opt)


end
