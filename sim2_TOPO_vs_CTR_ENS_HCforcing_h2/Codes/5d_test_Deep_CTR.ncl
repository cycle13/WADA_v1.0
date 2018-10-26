;Function:  difference between TOPOTEST ensemble and CTR ensemble, vertical profile of U.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718 for ENS(90)
;Note: modified 20180725 for ENS(180)
;Note: modified 20181002 for sim2

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;chunk = 32
;num_time = 96

chunk = 1
num_time = 4

num1 = new(chunk,integer)
num2 = new(chunk,integer)

do i_chunk = 0,chunk-1
num1_temp = i_chunk * num_time/chunk
num2_temp = num1_temp + num_time/chunk - 1

num1(i_chunk) = num1_temp
num2(i_chunk) = num2_temp
end do  ; do i_chunk

;-------------
str_time = new(chunk,string)

do i_str_time = 0,chunk-1
str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
end do

;str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,chunk-1

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR_DEEP_SHALLOW/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"

;TOPO_dir = "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"

;var_str = (/"HCforcing"/)
;var_str = (/"CMFDT"/)

;var = var_str

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")

;var_mean_CTR = f_CTR_mean->$var$
var_mean_CTR = f_CTR_mean->ZMDT ; metadata
var_mean_CTR = f_CTR_mean->ZMDT + f_CTR_mean->EVAPTZM + f_CTR_mean->ZMMTT

;printVarSummary(var_mean_TOPO)

;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)

P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_CTR_mean->hyam
hybm = f_CTR_mean->hybm

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
var_mean_CTR_pnew&lev_p@units = "hPa" 
;printVarSummary(var_mean_TOPO_pnew&lev_p)

   HCforcing_mean_CTR = var_mean_CTR_pnew


DS_mean_CTR  = HCforcing_mean_CTR ; meta data

printVarSummary(HCforcing_mean_CTR)

;================ plot ===========
;total 6hrs per batch in the TOPOTEST after branching

;total_hrs = 3
total_hrs = 4

do i_hr = 0,total_hrs-1
 
wks = gsn_open_wks("png","5_EQ_transect_ZMDT_EVAPZTZM_ZMMTT_CTR_iday_"+tostring(index*3+i_hr+1))

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -10.0e-5
res@cnMaxLevelValF =  10.0e-5
res@cnLevelSpacingF = 5.0e-6

;res@tiMainFontHeightF = 0.015

;lat_t = -10.0
lat_t = 0.0
lon_1 = 260.0
lon_2 = 320.0

lev_1 = 300.0
lev_2 = 1000.0

res@gsnLeftString = "ZMDT+EVAPTZM+ZMMTT"
res@gsnRightString = "K/s"
plot = gsn_csm_pres_hgt(wks,DS_mean_CTR(i_hr,{lev_1:lev_2},{lat_t},{lon_1:lon_2}),res)

;============ panel plot ====

; use 75W as the center, then 
str_LST = (/"20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"/)

pres = True
;pres@txString = "EQ transect, TOPO, ENS(180), ihr="+tostring(index*3+i_hr+1) +", LST_75W ("+str_LST(mod(index*3+i_hr,24))+")"

pres@txString = "EQ transect, CTR, ENS(180), iday="+tostring(i_hr+1)

gsn_panel(wks,plot,(/1,1/),pres)

end do ; do i_hr 

end do ; do index
end
