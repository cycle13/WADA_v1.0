
load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

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

str_time = new(32,string)
;time_label = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = "time"+tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
;time_label(i_str_time) = "time"+str_time(i_str_time)
end do


do index = 0,31

hybrid_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
hybrid_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"

f_hybrid = addfile(hybrid_dir + hybrid_str,"r")

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
;TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
;TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST."+str_time(index)+".nc"

PS_TOPO_str = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
PS_mean_TOPO_str = "ENS.std.mean.TOPOTEST.MSE.3term."+str_time(index)+".nc"

TOPO_mean_std_Qadv_dir = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/TOPO_TEST/"
TOPO_mean_std_Qadv = "ENS.std.mean.TOPOTEST.Qadv."+str_time(index)+".nc"
TOPO_mean_std_Q_vert_adv = "ENS.std.mean.TOPOTEST.Q_vert_adv."+str_time(index)+".nc"

;CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/CTR/"
;CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
;CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR."+str_time(index)+".nc"

PS_CTR_str = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
PS_mean_CTR_str = "ENS.std.mean.CTR.MSE.3term."+str_time(index)+".nc"

CTR_mean_std_Qadv_dir = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/CTR/"
CTR_mean_std_Qadv = "ENS.std.mean.CTR.Qadv."+str_time(index)+".nc"
CTR_mean_std_Q_vert_adv = "ENS.std.mean.CTR.Q_vert_adv."+str_time(index)+".nc"

;var_str = (/"var_hori_adv","var_div","var_vert_adv","var_vert_gra"/)
var_str = (/"var_hori_adv","var_div","helper_holder"/)

do i_var = 0, dimsizes(var_str) -1

if (i_var .le. 1) then
;----------- var_hori_adv and var_div are On pressure levels ----------
var = var_str(i_var)

;f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_PS_mean_TOPO = addfile(PS_TOPO_str+PS_mean_TOPO_str,"r")
;f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_PS_mean_CTR = addfile(PS_CTR_str+PS_mean_CTR_str,"r")
;
;var_mean_TOPO = f_TOPO_mean->$var$ * 3600.0 * 1000.0  ; from kg/kg/sec to g/kg/hr
;var_mean_TOPO@units = "g/kg/hr"
;printVarSummary(var_mean_TOPO)
;
;var_mean_CTR = f_CTR_mean->$var$ * 3600.0 * 1000.0
;var_mean_CTR@units = "g/kg/hr"
;printVarSummary(var_mean_CTR)
;
;;-----------

f_TOPO_Qadv = addfile(TOPO_mean_std_Qadv_dir+TOPO_mean_std_Qadv,"r")
f_CTR_Qadv = addfile(CTR_mean_std_Qadv_dir+CTR_mean_std_Qadv,"r")

hyai = f_hybrid->hyai
hybi = f_hybrid->hybi
hyam = f_hybrid->hyam
hybm = f_hybrid->hybm

PS_TOPO = f_PS_mean_TOPO->PS_mean
P0 = 100000.0 ; Pa

plev_TOPO = f_TOPO_Qadv->lev
plev_TOPO = plev_TOPO * 100.0
plev_TOPO@untis = "Pa"

;dph_TOPO_hori = dpres_plevel(plev_TOPO,PS_TOPO,0,0)
dph_TOPO_hori = dpres_plevel(plev_TOPO,PS_TOPO,min(plev_TOPO),0)
pres_TOPO_vert = pres_hybrid_ccm(PS_TOPO,P0,hyam,hybm)
dph_TOPO_vert = pres_TOPO_vert(:,2:29,:,:) - pres_TOPO_vert(:,0:27,:,:) 
printVarSummary(pres_TOPO_vert)
printVarSummary(PS_TOPO)
printVarSummary(dph_TOPO_hori)

PS_CTR = f_PS_mean_CTR->PS_mean

plev_CTR = f_CTR_Qadv->lev
plev_CTR = plev_CTR * 100.0
plev_CTR@untis = "Pa"

;dph_CTR_hori = dpres_plevel(plev_CTR,PS_CTR,0,0)
dph_CTR_hori = dpres_plevel(plev_CTR,PS_CTR,min(plev_CTR),0)
pres_CTR_vert = pres_hybrid_ccm(PS_CTR,P0,hyam,hybm)
dph_CTR_vert = pres_CTR_vert(:,2:29,:,:) - pres_CTR_vert(:,0:27,:,:)

;;------ all layers ------
lowest_lev = 30

var_adv_mean_TOPO = - tofloat(f_TOPO_Qadv->var_adv_TOPO_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
; for advection, you want to that become - (U*(dX)/dlon + V*(dY)/dlat)
copy_VarMeta(f_TOPO_Qadv->var_adv_TOPO_mean,var_adv_mean_TOPO)
var_adv_mean_TOPO@units = "(g/kg)/hr"
printVarSummary(var_adv_mean_TOPO)

var_div_mean_TOPO = - tofloat(f_TOPO_Qadv->var_div_TOPO_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
; for advection, you want to that become - (U*(dX)/dlon + V*(dY)/dlat)
copy_VarMeta(f_TOPO_Qadv->var_div_TOPO_mean,var_div_mean_TOPO)
var_div_mean_TOPO@units = "(g/kg)/hr"
printVarSummary(var_div_mean_TOPO)

var_adv_mean_CTR = - tofloat(f_CTR_Qadv->var_adv_CTR_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
copy_VarMeta(f_CTR_Qadv->var_adv_CTR_mean,var_adv_mean_CTR)
var_adv_mean_CTR@units = "(g/kg)/hr"
printVarSummary(var_adv_mean_CTR)

var_div_mean_CTR = - tofloat(f_CTR_Qadv->var_div_CTR_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
copy_VarMeta(f_CTR_Qadv->var_div_CTR_mean,var_div_mean_CTR)
var_div_mean_CTR@units = "(g/kg)/hr"
printVarSummary(var_div_mean_CTR)

;---------- vertical integral ---
var_adv_mean_TOPO_inte = dim_sum_n_Wrap(var_adv_mean_TOPO(:,30-lowest_lev:29,:,:) * dph_TOPO_hori(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_TOPO_hori(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_TOPO,var_adv_mean_TOPO_inte)
printVarSummary(var_adv_mean_TOPO_inte)
var_adv_mean_CTR_inte = dim_sum_n_Wrap(var_adv_mean_CTR(:,30-lowest_lev:29,:,:) * dph_CTR_hori(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_CTR_hori(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_CTR,var_adv_mean_CTR_inte)
printVarSummary(var_adv_mean_CTR_inte)
var_adv_diff_CTR_TOPO_inte = var_adv_mean_CTR_inte ; metadata
var_adv_diff_CTR_TOPO_inte = var_adv_mean_CTR_inte - var_adv_mean_TOPO_inte
printVarSummary(var_adv_diff_CTR_TOPO_inte)

var_div_mean_TOPO_inte = dim_sum_n_Wrap(var_div_mean_TOPO(:,30-lowest_lev:29,:,:) * dph_TOPO_hori(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_TOPO_hori(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_TOPO,var_div_mean_TOPO_inte)
printVarSummary(var_div_mean_TOPO_inte)
var_div_mean_CTR_inte = dim_sum_n_Wrap(var_div_mean_CTR(:,30-lowest_lev:29,:,:) * dph_CTR_hori(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_CTR_hori(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_CTR,var_div_mean_CTR_inte)
printVarSummary(var_div_mean_CTR_inte)
var_div_diff_CTR_TOPO_inte = var_div_mean_CTR_inte ; metadata
var_div_diff_CTR_TOPO_inte = var_div_mean_CTR_inte - var_div_mean_TOPO_inte
printVarSummary(var_div_diff_CTR_TOPO_inte)

else
;-------- var_vert_adv and var_vert_gra are on hybrid levels -----

f_TOPO_Q_vert_adv = addfile(TOPO_mean_std_Qadv_dir+TOPO_mean_std_Q_vert_adv,"r")
f_CTR_Q_vert_adv = addfile(CTR_mean_std_Qadv_dir+CTR_mean_std_Q_vert_adv,"r")

var_vert_adv_mean_TOPO = - tofloat(f_TOPO_Q_vert_adv->var_vert_adv_TOPO_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
; for vertical advection, you want to OMEGA*dQ/dp to become -OMEGA*(dQ)/dp
copy_VarMeta(f_TOPO_Q_vert_adv->var_vert_adv_TOPO_mean,var_vert_adv_mean_TOPO)
var_vert_adv_mean_TOPO@units = "(g/kg)/hr"
printVarSummary(var_vert_adv_mean_TOPO)

var_vert_gra_mean_TOPO = - tofloat(f_TOPO_Q_vert_adv->var_vert_gra_TOPO_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
; for vertical advection, you want to OMEGA*dQ/dp to become -OMEGA*(dQ)/dp
copy_VarMeta(f_TOPO_Q_vert_adv->var_vert_gra_TOPO_mean,var_vert_gra_mean_TOPO)
var_vert_gra_mean_TOPO@units = "(g/kg)/hr"
printVarSummary(var_vert_gra_mean_TOPO)

var_vert_adv_mean_CTR = - tofloat(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
copy_VarMeta(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean,var_vert_adv_mean_CTR)
var_vert_adv_mean_CTR@units = "(g/kg)/hr"
printVarSummary(var_vert_adv_mean_CTR)

var_vert_gra_mean_CTR = - tofloat(f_CTR_Q_vert_adv->var_vert_gra_CTR_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
copy_VarMeta(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean,var_vert_gra_mean_CTR)
var_vert_gra_mean_CTR@units = "(g/kg)/hr"
printVarSummary(var_vert_gra_mean_CTR)

;--------------------
OMEGA_TOPO_mean = - tofloat(f_CTR_Q_vert_adv->OMEGA_TOPO_mean) * 3600.0 * 1000.0 ; from kg/kg/sec to g/kg/hr, you don't have to convert downstream
OMEGA_CTR_mean = -tofloat(f_CTR_Q_vert_adv->OMEGA_CTR_mean) * 3600.0 * 1000.0

dq_dp_TOPO_mean = f_CTR_Q_vert_adv->dq_dp_TOPO_mean
dq_dp_CTR_mean = f_CTR_Q_vert_adv->dq_dp_CTR_mean

;
;copy_VarMeta(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean,term1_mean)
;term1_mean@units = "(g/kg)/hr"
;printVarSummary(term1_mean)
;
;term2_mean = - tofloat(f_CTR_Q_vert_adv->term2_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
;copy_VarMeta(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean,term2_mean)
;term2_mean@units = "(g/kg)/hr"
;printVarSummary(term2_mean)
;
;term3_mean = - tofloat(f_CTR_Q_vert_adv->term3_mean) * 3600.0  * 1000.0 ; from (kg/kg)/sec to (g/kg)/hr
;copy_VarMeta(f_CTR_Q_vert_adv->var_vert_adv_CTR_mean,term3_mean)
;term3_mean@units = "(g/kg)/hr"
;printVarSummary(term3_mean)

;------- vertical integral ----------

;var_vert_adv_mean_TOPO_inte = dim_sum_n_Wrap(var_vert_adv_mean_TOPO(:,30-lowest_lev:28,:,:) * dph_TOPO_vert(:,30-lowest_lev:28,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,30-lowest_lev:28,:,:),1)
var_vert_adv_mean_TOPO_inte = dim_sum_n_Wrap(var_vert_adv_mean_TOPO(:,30-lowest_lev:27,:,:) * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
copy_VarCoords(PS_TOPO,var_vert_adv_mean_TOPO_inte)
printVarSummary(var_vert_adv_mean_TOPO_inte)
;var_vert_adv_mean_CTR_inte = dim_sum_n_Wrap(var_vert_adv_mean_CTR(:,30-lowest_lev:28,:,:) * dph_CTR_vert(:,30-lowest_lev:28,:,:), 1)/dim_sum_n(dph_CTR_vert(:,30-lowest_lev:28,:,:),1)
var_vert_adv_mean_CTR_inte = dim_sum_n_Wrap(var_vert_adv_mean_CTR(:,30-lowest_lev:27,:,:) * dph_CTR_vert(:,:,:,:), 1)/dim_sum_n(dph_CTR_vert(:,:,:,:),1)
copy_VarCoords(PS_CTR,var_vert_adv_mean_CTR_inte)
printVarSummary(var_vert_adv_mean_CTR_inte)
var_vert_adv_diff_CTR_TOPO_inte = var_vert_adv_mean_CTR_inte ; metadata
var_vert_adv_diff_CTR_TOPO_inte = var_vert_adv_mean_CTR_inte - var_vert_adv_mean_TOPO_inte
printVarSummary(var_vert_adv_diff_CTR_TOPO_inte)

;var_vert_gra_mean_TOPO_inte = dim_sum_n_Wrap(var_vert_gra_mean_TOPO(:,30-lowest_lev:28,:,:) * dph_TOPO_vert(:,30-lowest_lev:28,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,30-lowest_lev:28,:,:),1)
var_vert_gra_mean_TOPO_inte = dim_sum_n_Wrap(var_vert_gra_mean_TOPO(:,30-lowest_lev:27,:,:) * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
copy_VarCoords(PS_TOPO,var_vert_gra_mean_TOPO_inte)
printVarSummary(var_vert_gra_mean_TOPO_inte)
;var_vert_gra_mean_CTR_inte = dim_sum_n_Wrap(var_vert_gra_mean_CTR(:,30-lowest_lev:28,:,:) * dph_CTR_vert(:,30-lowest_lev:28,:,:), 1)/dim_sum_n(dph_CTR_vert(:,30-lowest_lev:28,:,:),1)
var_vert_gra_mean_CTR_inte = dim_sum_n_Wrap(var_vert_gra_mean_CTR(:,30-lowest_lev:27,:,:) * dph_CTR_vert(:,:,:,:), 1)/dim_sum_n(dph_CTR_vert(:,:,:,:),1)
copy_VarCoords(PS_CTR,var_vert_gra_mean_CTR_inte)
printVarSummary(var_vert_gra_mean_CTR_inte)
var_vert_gra_diff_CTR_TOPO_inte = var_vert_gra_mean_CTR_inte ; metadata
var_vert_gra_diff_CTR_TOPO_inte = var_vert_gra_mean_CTR_inte - var_vert_gra_mean_TOPO_inte
printVarSummary(var_vert_gra_diff_CTR_TOPO_inte)

;------- term1, term2, term3 -------
term1_mean_inte_a = dim_sum_n_Wrap(OMEGA_TOPO_mean * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
term1_mean_inte_b = dim_sum_n_Wrap(dq_dp_CTR_mean * dph_CTR_vert(:,:,:,:), 1)/dim_sum_n(dph_CTR_vert(:,:,:,:),1)
term1_mean_inte_c = dim_sum_n_Wrap(dq_dp_TOPO_mean * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
term1_mean_inte = term1_mean_inte_a * (term1_mean_inte_b - term1_mean_inte_c)
copy_VarCoords(PS_CTR,term1_mean_inte)
printVarSummary(term1_mean_inte)

term2_mean_inte_a = dim_sum_n_Wrap(OMEGA_CTR_mean * dph_CTR_vert(:,:,:,:), 1)/dim_sum_n(dph_CTR_vert(:,:,:,:),1)
term2_mean_inte_b = dim_sum_n_Wrap(OMEGA_TOPO_mean * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
term2_mean_inte_c = dim_sum_n_Wrap(dq_dp_TOPO_mean * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
term2_mean_inte = (term2_mean_inte_a - term2_mean_inte_b) * term2_mean_inte_c
copy_VarCoords(PS_CTR,term2_mean_inte)
printVarSummary(term2_mean_inte)

term3_mean_inte_a = dim_sum_n_Wrap(OMEGA_CTR_mean * dph_CTR_vert(:,:,:,:), 1)/dim_sum_n(dph_CTR_vert(:,:,:,:),1)
term3_mean_inte_b = dim_sum_n_Wrap(OMEGA_TOPO_mean * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
term3_mean_inte_c = dim_sum_n_Wrap(dq_dp_CTR_mean * dph_CTR_vert(:,:,:,:), 1)/dim_sum_n(dph_CTR_vert(:,:,:,:),1)
term3_mean_inte_d = dim_sum_n_Wrap(dq_dp_TOPO_mean * dph_TOPO_vert(:,:,:,:), 1)/dim_sum_n(dph_TOPO_vert(:,:,:,:),1)
term3_mean_inte = ( term3_mean_inte_a - term3_mean_inte_b ) * (term3_mean_inte_c - term3_mean_inte_d)
copy_VarCoords(PS_CTR,term3_mean_inte)
printVarSummary(term3_mean_inte)

end if


end do ; do i_var

;-------- output nc files -------
dir_TOPO_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/TOPO_TEST/"
dir_CTR_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/CTR/"
system("rm "+dir_TOPO_out+"Q_MF_hori_vert.TOPOTEST.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"Q_MF_hori_vert.TOPOTEST.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1, True)
ncdf_TOPO->var_adv_mean_TOPO_inte = var_adv_mean_TOPO_inte 
ncdf_TOPO->var_div_mean_TOPO_inte = var_div_mean_TOPO_inte
ncdf_TOPO->var_vert_adv_mean_TOPO_inte = var_vert_adv_mean_TOPO_inte
ncdf_TOPO->var_vert_gra_mean_TOPO_inte = var_vert_gra_mean_TOPO_inte

system("rm "+dir_CTR_out+"Q_MF_hori_vert.CTR.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"Q_MF_hori_vert.CTR.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_CTR,"time",-1, True)
ncdf_CTR->var_adv_mean_CTR_inte = var_adv_mean_CTR_inte
ncdf_CTR->var_div_mean_CTR_inte = var_div_mean_CTR_inte 
ncdf_CTR->var_vert_adv_mean_CTR_inte = var_vert_adv_mean_CTR_inte
ncdf_CTR->var_vert_gra_mean_CTR_inte = var_vert_gra_mean_CTR_inte

ncdf_CTR->term1_mean_inte = term1_mean_inte
ncdf_CTR->term2_mean_inte = term2_mean_inte
ncdf_CTR->term3_mean_inte = term3_mean_inte

end do ; do index

end
