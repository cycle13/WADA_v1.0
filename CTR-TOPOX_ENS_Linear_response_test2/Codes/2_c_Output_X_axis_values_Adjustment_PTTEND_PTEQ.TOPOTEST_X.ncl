;Function: vertically integrated (Cpair*PTTEND) and (Cpair*PTTEND+Lv*PTEQ) forcing in the CTR and TOPOTEST ensemble, output mean and std of ENS.
;Date: 20181004
;Date: 20181128
;Date: 20181223

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;============READ SGH30 ======
f_SGH30 = addfile("/DFS-L/DATA/pritchard/hongcheq/Topography/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
SGH30 = f_SGH30->SGH30

SGH30m = SGH30
SGH30m = SGH30@_FillValue
SGH30m({-40:10},{270:300}) = SGH30({-40:10},{270:300})

do ilat = 0,95
   do ilon = 0,143
      if (.not. ismissing(SGH30m(ilat,ilon)) .and. SGH30m(ilat,ilon) .lt. 200.0) then
          SGH30m(ilat,ilon) = SGH30m@_FillValue
      end if
   end do
end do
printVarSummary(SGH30m)

;=======================

;-------- useful constants for unit changes------
Lw = 2260000.0 ; J/kg ; latent heat of vaporization
Cpair=1004.0  ; J/(kg*K)
;-------------------------

;str_PCT = (/"00","20","40","60","80"/)
str_PCT = (/"40"/)

;do i_PCT = 0,4
;do i_PCT = 1,3
do i_PCT = 0,0

PCT = str_PCT(i_PCT)

dir_TOPO_in = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST"+PCT+"/"
f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.PRECT.TOPOTEST"+PCT+".nc")

dir_CTR_in = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.PRECT.CTR.nc")

;-------set a smaller number for faster code testing -------
members = 180
;members = 20

PTTEND_TOPO = new((/members,30,96,144/),double)    ;members x 30lev x 96lat x 144 lon, to hold day 3-7 average
PTEQ_TOPO = new((/members,30,96,144/),double)
PS_TOPO = new((/members,96,144/),double)

PTTEND_CTR = new((/members,30,96,144/),double)    ;members x 30lev x 96lat x 144 lon, to hold day 3-7 average
PTEQ_CTR = new((/members,30,96,144/),double)
PS_CTR = new((/members,96,144/),double)

PTTEND_TOPO!0 = "members"
PTTEND_TOPO&members = ispan(1,members,1)
PTEQ_TOPO!0 = "members"
PTEQ_TOPO&members = ispan(1,members,1)
PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,members,1)

PTTEND_CTR!0 = "members"
PTTEND_CTR&members = ispan(1,members,1)
PTEQ_CTR!0 = "members"
PTEQ_CTR&members = ispan(1,members,1)
PS_CTR!0 = "members"
PS_CTR&members = ispan(1,members,1)

do i_file = 0, members - 1
print("i_file=")
print(i_file)
print("========")
f_TOPO = addfile(f_TOPO_str(i_file),"r")
;averaged from day 3 - day 7, during which the precip WADA pattern become stable
PTTEND_TOPO(i_file,:,:,:) = dim_avg_n_Wrap(f_TOPO->PTTEND(2:6,:,:,:),0)
PTEQ_TOPO(i_file,:,:,:) = dim_avg_n_Wrap(f_TOPO->PTEQ(2:6,:,:,:),0)
PS_TOPO(i_file,:,:) = dim_avg_n_Wrap(f_TOPO->PS(2:6,:,:),0)

f_CTR = addfile(f_CTR_str(i_file),"r")
PTTEND_CTR(i_file,:,:,:) = dim_avg_n_Wrap(f_CTR->PTTEND(2:6,:,:,:),0)
PTEQ_CTR(i_file,:,:,:) = dim_avg_n_Wrap(f_CTR->PTEQ(2:6,:,:,:),0)
PS_CTR(i_file,:,:) = dim_avg_n_Wrap(f_CTR->PS(2:6,:,:),0)

end do  ; do i_file

;-------------

printVarSummary(PTTEND_TOPO)  ; in K/sec
printVarSummary(PTEQ_TOPO)  ; in K/sec
printVarSummary(PS_TOPO)
;------------------------
hyam = f_TOPO->hyam
hybm = f_TOPO->hybm 
p0   = 100000. 
pbot = 101300.   
ptop = 30000.    ; upper level, 300 hPa ; integral from 101300 Pa to 30000 Pa.
g = 9.8

;---------------  ------
;--------------TOPO vint_PTTEND_CTR, vint_PTEQ_CTR-----
pm_TOPO   = PTTEND_TOPO       ;(members,time,lev,lat,lon); metadata
pm_TOPO   = pres_hybrid_ccm(PS_TOPO, p0, hyam, hybm)  
;pm(ntim,klvl,nlat,mlon) top-to-bottom
pm_TOPO@long_name = "pressure"
pm_TOPO@units     = "Pa"
                ; create array with appropriate metadata
;forcing_TOPO = PTTEND_TOPO ;
;printVarSummary(forcing_TOPO)

;----------------------
vint_PTTEND_TOPO = PTTEND_TOPO(members|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_PTTEND_TOPO = vibeta(pm_TOPO(members|:,lat|:,lon|:,lev|::-1), PTTEND_TOPO(members|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_PTTEND_TOPO = vint_PTTEND_TOPO / g * Cpair
vint_PTTEND_TOPO@long_name = "Cpair / g * integral {PTTEND]} dp"
vint_PTTEND_TOPO@units = "W/m2"
printVarSummary(vint_PTTEND_TOPO)

vint_PTEQ_TOPO = PTEQ_TOPO(members|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_PTEQ_TOPO = vibeta(pm_TOPO(members|:,lat|:,lon|:,lev|::-1), PTEQ_TOPO(members|:,lat|:,lon|:,lev|::-1),1,PS_TOPO,pbot,ptop)

vint_PTEQ_TOPO = vint_PTEQ_TOPO / g * Lw
vint_PTEQ_TOPO@long_name = "Lw/g * integral {PTEQ]} dp"
vint_PTEQ_TOPO@units = "W/m2"
printVarSummary(vint_PTEQ_TOPO)

;---------------------
;---------------CTR vint_PTTEND_CTR, vint_PTEQ_CTR  ------
pm_CTR   = PTTEND_CTR       ;(members,time,lev,lat,lon); metadata
pm_CTR   = pres_hybrid_ccm(PS_CTR, p0, hyam, hybm)  
;pm(ntim,klvl,nlat,mlon) top-to-bottom
pm_CTR@long_name = "pressure"
pm_CTR@units     = "Pa"
                ; create array with appropriate metadata

;----------------------
vint_PTTEND_CTR = PTTEND_CTR(members|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_PTTEND_CTR = vibeta(pm_CTR(members|:,lat|:,lon|:,lev|::-1), PTTEND_CTR(members|:,lat|:,lon|:,lev|::-1),1,PS_CTR,pbot,ptop)

vint_PTTEND_CTR = vint_PTTEND_CTR / g * Cpair
vint_PTTEND_CTR@long_name = "Cpair/g * integral {PTTEND]} dp"
vint_PTTEND_CTR@units = "W/m2"
printVarSummary(vint_PTTEND_CTR)

vint_PTEQ_CTR = PTEQ_CTR(members|:,lat|:,lon|:,lev|0)  ; create a variable with metadata
                                    ; reverse pressure order via ::-1 syntax
                                    ; pm and Q_TOPO_temp will span bottom-to-top
vint_PTEQ_CTR = vibeta(pm_CTR(members|:,lat|:,lon|:,lev|::-1), PTEQ_CTR(members|:,lat|:,lon|:,lev|::-1),1,PS_CTR,pbot,ptop)

vint_PTEQ_CTR = vint_PTEQ_CTR / g * Lw
vint_PTEQ_CTR@long_name = "Lw/g * integral {PTEQ]} dp"
vint_PTEQ_CTR@units = "W/m2"
printVarSummary(vint_PTEQ_CTR)
;-----------------------------------------

;------------ Andean averaged vint_PTTEND_TOPO, vint_PTEQ_TOPO, 
;------------ and vint_PTTEND_CTR, vint_PTEQ_CTR  ----

Andes_vint_PTTEND_TOPO = vint_PTTEND_TOPO(:,0,0) ; metadata
Andes_vint_PTEQ_TOPO = vint_PTEQ_TOPO(:,0,0) ; metadata
Andes_vint_PTTEND_CTR = vint_PTTEND_CTR(:,0,0) ; metadata
Andes_vint_PTEQ_CTR = vint_PTEQ_CTR(:,0,0) ; metadata

do i_member = 0, members-1 
    Andes_vint_PTTEND_TOPO(i_member) = avg(where(.not.ismissing(SGH30m),vint_PTTEND_TOPO(i_member,:,:),vint_PTTEND_TOPO@_FillValue))
    Andes_vint_PTEQ_TOPO(i_member) = avg(where(.not.ismissing(SGH30m),vint_PTEQ_TOPO(i_member,:,:),vint_PTEQ_TOPO@_FillValue))
    Andes_vint_PTTEND_CTR(i_member) = avg(where(.not.ismissing(SGH30m),vint_PTTEND_CTR(i_member,:,:),vint_PTTEND_CTR@_FillValue))
    Andes_vint_PTEQ_CTR(i_member) = avg(where(.not.ismissing(SGH30m),vint_PTEQ_CTR(i_member,:,:),vint_PTEQ_CTR@_FillValue))

end do ; i_member
printVarSummary(Andes_vint_PTTEND_TOPO)
printVarSummary(Andes_vint_PTEQ_TOPO)
printVarSummary(Andes_vint_PTTEND_CTR)
printVarSummary(Andes_vint_PTEQ_CTR)

;------save memory-----
delete(PTTEND_TOPO)
delete(PTEQ_TOPO)
delete(PTTEND_CTR)
delete(PTEQ_CTR)

;------ Calculate CTR - TOPO for the PTTEND, and Cpair*PTTEND + Lw*PTEQ term ---------
Andes_vint_PTTEND_CTR_TOPO = Andes_vint_PTTEND_CTR - Andes_vint_PTTEND_TOPO
Andes_vint_PTTEND_CTR_TOPO@units = "W/m2"
Andes_vint_PTTEND_CTR_TOPO@long_name = "Andes vint_(Cpair*PTTEND), CTR - TOPO_X, PCT"+PCT

Andes_vint_PTTEND_PTEQ_CTR_TOPO = (Andes_vint_PTTEND_CTR - Andes_vint_PTTEND_TOPO) + (Andes_vint_PTEQ_CTR - Andes_vint_PTEQ_TOPO)
Andes_vint_PTTEND_PTEQ_CTR_TOPO@units = "W/m2"
Andes_vint_PTTEND_PTEQ_CTR_TOPO@long_name = "Andes vint_(Cpair*PTTEND + Lw*PTEQ), CTR - TOPO_X, PCT"+PCT

;--------------Calculate the mean and std ----------

Andes_vint_PTTEND_CTR_TOPO_mean = dim_avg_n_Wrap(Andes_vint_PTTEND_CTR_TOPO,0)
Andes_vint_PTTEND_CTR_TOPO_std = dim_stddev_n_Wrap(Andes_vint_PTTEND_CTR_TOPO,0)

Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean = dim_avg_n_Wrap(Andes_vint_PTTEND_PTEQ_CTR_TOPO,0)
Andes_vint_PTTEND_PTEQ_CTR_TOPO_std = dim_stddev_n_Wrap(Andes_vint_PTTEND_PTEQ_CTR_TOPO,0)

printVarSummary(Andes_vint_PTTEND_CTR_TOPO_mean)
printVarSummary(Andes_vint_PTTEND_CTR_TOPO_std)

printVarSummary(Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean)
printVarSummary(Andes_vint_PTTEND_PTEQ_CTR_TOPO_std)

;------- Calculate Confidence interval CI95 ----

n_total = members
t_c = abs(cdft_t(0.025,n_total - 1))    ; t_{alpha/2} (n-1) value
CI95_PTTEND = Andes_vint_PTTEND_CTR_TOPO_std/sqrt(n_total) * t_c   ; assuming normal distribution
CI95_PTTEND_PTEQ = Andes_vint_PTTEND_PTEQ_CTR_TOPO_std/sqrt(n_total) * t_c   ; assuming normal distribution

;--------------- save memory -------
delete(vint_PTTEND_TOPO)
delete(vint_PTEQ_TOPO)
delete(vint_PTTEND_CTR)
delete(vint_PTEQ_CTR)

;---------------------output variables ----------
;diro_TOPO = "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/" ; Output directory
diro_TOPO = "/gdata/pritchard/hongcheq/WetAndesDryAmazon/WADA_CTR_TOPO_Linear_Test_data/" ; Output directory

filo_TOPO = "Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO"+PCT+".nc"             ; Output file
system("rm -f "+diro_TOPO+filo_TOPO)
ncdf_TOPO = addfile(diro_TOPO+filo_TOPO,"c")

filedimdef(ncdf_TOPO,"time",-1,True)

ncdf_TOPO->Andes_vint_PTTEND_CTR_TOPO_mean = Andes_vint_PTTEND_CTR_TOPO_mean
ncdf_TOPO->Andes_vint_PTTEND_CTR_TOPO_std = Andes_vint_PTTEND_CTR_TOPO_std
ncdf_TOPO->Andes_vint_PTTEND_CTR_TOPO_CI95 = CI95_PTTEND

ncdf_TOPO->Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean = Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean
ncdf_TOPO->Andes_vint_PTTEND_PTEQ_CTR_TOPO_std = Andes_vint_PTTEND_PTEQ_CTR_TOPO_std
ncdf_TOPO->Andes_vint_PTTEND_PTEQ_CTR_TOPO_CI95 = CI95_PTTEND_PTEQ


end do ; do i_PCT

end
