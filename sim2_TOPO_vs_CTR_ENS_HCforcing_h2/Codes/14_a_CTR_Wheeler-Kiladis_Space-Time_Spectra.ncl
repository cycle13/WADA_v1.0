;Function: Explore if 96hr dada could be used to generate the Wheeler-Kiladis Space-Time Spectra
;Date: 20190503

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl"

begin

case = "CTR"
diro = "../Figures/"

latN = 20
latS = -latN

nDayWin = 4
nDaySkip = -2

opt = True
opt@debug = True
opt@pltType = "ps" ; allowed "ps", "eps", "x11", "ncgm", default: "ps"

;--------3D variables----
varName = "PRECT"
spd = 24  ; 24 samples per day; hourly data

diri = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
fili = "ENS.CTR.nc"

f = addfile(diri+fili, "r")
var = dim_avg_n_Wrap(f->$varName$(:,:,{latS:latN},:), 0)   ; average across realizations
wkSpaceTime(var, diro, case, varName, latN, spd, nDayWin, nDaySkip, opt)

;---------4D variables: U200, U850, OMEGA500
hyam = f->hyam(0,:) ; all the same across different realizations
hybm = f->hybm(0,:)
PS = dim_avg_n_Wrap(f->PS(:,:,{latS:latN},:),0)
P0 = 1000.

;printVarSummary(hyam)
;printVarSummary(hybm)

lev_p = (/100, 200, 300, 400, 500, 600, 700, 850, 925, 1000/)
lev_p!0 = "lev_p"
lev_p&lev_p = lev_p
lev_p@long_name = "pressure"
lev_p@units = "hPa"
lev_p@positive = "down"

U = dim_avg_n_Wrap(f->U(:,:,:,{latS:latN},:),0)
OMEGA = dim_avg_n_Wrap(f->OMEGA(:,:,:,{latS:latN},:),0)

U_new = vinth2p(U, hyam, hybm, lev_p, PS, 1, P0, 1, True)  ; True because the wkSpaceTime FFTs do not allow missing values
;printVarSummary(U_new)
OMEGA_new = vinth2p(OMEGA, hyam, hybm, lev_p, PS, 1, P0, 1, True)
;printVarSummary(OMEGA_new)

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
