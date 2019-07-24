;Function: calculate Fs - R term, or Fs + R (where R is negative) in equation 2.4 of Raymond 2009 paper.
;Date: 20190724

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;======= Step 1. read files ========
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

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
;time_label = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = "time"+tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
;time_label(i_str_time) = "time"+str_time(i_str_time)
end do

QRS_mean_CTR = new((/96, 30, 96, 144/),double)
QRS_mean_TOPO = new((/96, 30, 96, 144/),double)
QRS_diff_CTR_TOPO = new((/96, 30, 96, 144/),double)

QRL_mean_CTR = new((/96, 30, 96, 144/),double)
QRL_mean_TOPO = new((/96, 30, 96, 144/),double)
QRL_diff_CTR_TOPO = new((/96, 30, 96, 144/),double)

SHFLX_mean_CTR = new((/96, 96, 144/),double)  
SHFLX_mean_TOPO = new((/96, 96, 144/),double)
SHFLX_diff_CTR_TOPO = new((/96, 96, 144/),double)

LHFLX_mean_CTR = new((/96, 96, 144/),double)  
LHFLX_mean_TOPO = new((/96, 96, 144/),double)
LHFLX_diff_CTR_TOPO = new((/96, 96, 144/),double)

; to calculate vertical integral
PS_mean_CTR = new((/96, 96, 144/),double)  ;
PS_mean_TOPO = new((/96, 96, 144/),double)

; to prepare for Andean average calculation
;============== ======
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

total_times = 96

QRS_Andes_mean_CTR = new(total_times,double)
QRS_Andes_mean_TOPO = new(total_times,double)
QRS_Andes_mean_CTR_TOPO = new(total_times,double)

QRS_Amazon_mean_CTR = new(total_times,double)
QRS_Amazon_mean_TOPO = new(total_times,double)
QRS_Amazon_mean_CTR_TOPO = new(total_times,double)

QRL_Andes_mean_CTR = new(total_times,double)
QRL_Andes_mean_TOPO = new(total_times,double)
QRL_Andes_mean_CTR_TOPO = new(total_times,double)

QRL_Amazon_mean_CTR = new(total_times,double)
QRL_Amazon_mean_TOPO = new(total_times,double)
QRL_Amazon_mean_CTR_TOPO = new(total_times,double)

SHFLX_Andes_mean_CTR = new(total_times,double)
SHFLX_Andes_mean_TOPO = new(total_times,double)
SHFLX_Andes_mean_CTR_TOPO = new(total_times,double)

SHFLX_Amazon_mean_CTR = new(total_times,double)
SHFLX_Amazon_mean_TOPO = new(total_times,double)
SHFLX_Amazon_mean_CTR_TOPO = new(total_times,double)

LHFLX_Andes_mean_CTR = new(total_times,double)
LHFLX_Andes_mean_TOPO = new(total_times,double)
LHFLX_Andes_mean_CTR_TOPO = new(total_times,double)

LHFLX_Amazon_mean_CTR = new(total_times,double)
LHFLX_Amazon_mean_TOPO = new(total_times,double)
LHFLX_Amazon_mean_CTR_TOPO = new(total_times,double)

Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)

do index = 0,31
;do index = 10,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/CTR/"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"

var_str = (/"QRS","QRL","SHFLX","LHFLX","PS"/)

do i_var = 0, dimsizes(var_str)-1
;do i_var = 5, dimsizes(var_str)-1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)

;========== hybrid coordinate to pressure coordinate ====
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
pnew = (/3.64346569404006, 7.59481964632869, 14.3566322512925,\
    24.6122200042009, 38.2682997733355, 54.5954797416925, 72.0124505460262,\
    87.8212302923203, 103.317126631737, 121.547240763903, 142.994038760662,\
    168.225079774857, 197.908086702228, 232.828618958592, 273.910816758871,\
    322.241902351379, 379.100903868675, 445.992574095726, 524.687174707651,\
    609.778694808483, 691.389430314302, 763.404481112957, 820.858368650079,\
    859.53476652503, 887.020248919725, 912.644546944648, 936.198398470879,\
    957.485479535535, 976.325407391414, 992.556095123291 /)

;pnew = fspan(100.0,1000.0,200)

P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

if (i_var .eq. 0 .or. i_var .eq. 1) then

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
var_mean_TOPO_pnew&lev_p@units = "hPa"
;printVarSummary(var_mean_TOPO_pnew&lev_p)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev_p@units = "hPa"
;printVarSummary(var_mean_CTR_pnew)
end if

diff_CTR_TOPO = var_mean_TOPO_pnew ; metadata
;diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew
diff_CTR_TOPO = var_mean_CTR_pnew - var_mean_TOPO_pnew
diff_CTR_TOPO@units = var_mean_TOPO@units
diff_CTR_TOPO@long_name = var_mean_TOPO@long_name

if (i_var .eq. 0) then
   QRS_mean_CTR(index*3:index*3+2,:,:,:) = var_mean_CTR_pnew
   QRS_mean_TOPO(index*3:index*3+2,:,:,:) = var_mean_TOPO_pnew
   QRS_diff_CTR_TOPO(index*3:index*3+2,:,:,:) = diff_CTR_TOPO
end if
if (i_var .eq. 1) then
   QRL_mean_CTR(index*3:index*3+2,:,:,:) = var_mean_CTR_pnew
   QRL_mean_TOPO(index*3:index*3+2,:,:,:) = var_mean_TOPO_pnew
   QRL_diff_CTR_TOPO(index*3:index*3+2,:,:,:) = diff_CTR_TOPO
end if
if (i_var .eq. 2) then
   SHFLX_mean_CTR(index*3:index*3+2,:,:) = var_mean_CTR
   SHFLX_mean_TOPO(index*3:index*3+2,:,:) = var_mean_TOPO
   SHFLX_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR ; metadata
   SHFLX_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR - var_mean_TOPO
end if
if (i_var .eq. 3) then
   LHFLX_mean_CTR(index*3:index*3+2,:,:) = var_mean_CTR
   LHFLX_mean_TOPO(index*3:index*3+2,:,:) = var_mean_TOPO
   LHFLX_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR
   LHFLX_diff_CTR_TOPO(index*3:index*3+2,:,:) = var_mean_CTR - var_mean_TOPO
end if
if (i_var .eq. 4) then
   PS_mean_CTR(index*3:index*3+2,:,:) = var_mean_CTR
   PS_mean_TOPO(index*3:index*3+2,:,:) = var_mean_TOPO
end if

delete(var_mean_TOPO)
delete(var_mean_CTR)

end do ; do ivar

end do ; do index

printVarSummary(QRS_mean_CTR)
printVarSummary(QRS_mean_TOPO)
printVarSummary(QRS_diff_CTR_TOPO)

printVarSummary(QRL_mean_CTR)
printVarSummary(QRL_mean_TOPO)
printVarSummary(QRL_diff_CTR_TOPO)
;====== Step 2. calculate Fs term (SHFLX, LHFLX),  R term (QRL, QRS) =========





;======= Step 3. Calculate Fs_Andes, Fs_Amazon, R_Andes, R_Amazon, average over the Andes, Amazon =======






;======= Step 4. output to nc files =========






end
