
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

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.std.mean.TOPOTEST.MSE.3term."+str_time(index)+".nc"
PS_mean_TOPO_str = "ENS.std.mean.TOPOTEST.MSE.3term."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.std.mean.CTR.MSE.3term."+str_time(index)+".nc"
PS_mean_CTR_str = "ENS.std.mean.CTR.MSE.3term."+str_time(index)+".nc"

hybrid_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
hybrid_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"

f_hybrid = addfile(hybrid_dir + hybrid_str,"r")

var_str = (/"LH_mean","DE_mean","PE_mean"/)

do i_var = 0, dimsizes(var_str) -1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_PS_mean_TOPO = addfile(TOPO_dir+PS_mean_TOPO_str,"r")
f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_PS_mean_CTR = addfile(CTR_dir+PS_mean_CTR_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
printVarSummary(var_mean_TOPO)

var_mean_CTR = f_CTR_mean->$var$
printVarSummary(var_mean_CTR)

;------------- 
hyai = f_hybrid->hyai
hybi = f_hybrid->hybi

PS_TOPO = f_PS_mean_TOPO->PS_mean
P0 = 100000.0 ; Pa
dph_TOPO = dpres_hybrid_ccm(PS_TOPO,P0,hyai,hybi)
printVarSummary(PS_TOPO)
printVarSummary(dph_TOPO)
;print(f_TOPO_mean->lev)
;print(dph_TOPO(2,:,50,80))

PS_CTR = f_PS_mean_CTR->PS_mean
dph_CTR = dpres_hybrid_ccm(PS_CTR,P0,hyai,hybi)

;------ lowest five layers ------
lowest_lev = 5

var_mean_TOPO_inte = dim_sum_n_Wrap(var_mean_TOPO(:,30-lowest_lev:29,:,:) * dph_TOPO(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_TOPO(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_TOPO,var_mean_TOPO_inte)
printVarSummary(var_mean_TOPO_inte)

var_mean_CTR_inte = dim_sum_n_Wrap(var_mean_CTR(:,30-lowest_lev:29,:,:) * dph_CTR(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_CTR(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_CTR,var_mean_CTR_inte)
printVarSummary(var_mean_CTR_inte)

diff_CTR_TOPO_inte = var_mean_CTR_inte ; metadata
diff_CTR_TOPO_inte = var_mean_CTR_inte - var_mean_TOPO_inte
printVarSummary(diff_CTR_TOPO_inte)


;---------------------------
if (i_var .eq. 0) then
LH_CTR_inte = var_mean_CTR_inte ; metadata
LH_CTR_inte = var_mean_CTR_inte / 1000.0 ; metadata
LH_CTR_inte@units = "kJ/kg"

LH_TOPO_inte = var_mean_TOPO_inte; metadata
LH_TOPO_inte = var_mean_TOPO_inte / 1000.0; metadata
LH_TOPO_inte@units = "kJ/kg"

LH_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
LH_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte / 1000.0 ; metadata
LH_TOPO_inte@units = "kJ/kg"
end if

if (i_var .eq. 1) then
DE_CTR_inte = var_mean_CTR_inte ; metadata
DE_CTR_inte = var_mean_CTR_inte /1000.0; metadata
DE_CTR_inte@units = "kJ/kg"

DE_TOPO_inte = var_mean_TOPO_inte ; metadata
DE_TOPO_inte = var_mean_TOPO_inte /1000.0; metadata
DE_TOPO_inte@units = "kJ/kg"

DE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
DE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte / 1000.0 ; metadata
DE_diff_CTR_TOPO_inte@units = "kJ/kg"

end if

if (i_var .eq. 2) then
PE_CTR_inte = var_mean_CTR_inte ; metadata
PE_CTR_inte = var_mean_CTR_inte /1000.0; metadata
PE_CTR_inte@units = "kJ/kg"

PE_TOPO_inte = var_mean_TOPO_inte ; metadata
PE_TOPO_inte = var_mean_TOPO_inte /1000.0 ; metadata
PE_TOPO_inte@units = "kJ/kg"

PE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte ; metadata
PE_diff_CTR_TOPO_inte = diff_CTR_TOPO_inte / 1000.0 ; metadata
PE_diff_CTR_TOPO_inte@units = "kJ/kg"

end if

end do ; do ivar

;printVarSummary(f_TOPO_mean->PS)
;printVarSummary(f_CTR_mean->PS)
;print(V_diff_TOPO_CTR&lev_p)

;-------- output nc files -------
dir_TOPO_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/TOPO_TEST/"
dir_CTR_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/CTR/"
system("rm "+dir_TOPO_out+"LH_DE_PE.TOPOTEST.L5.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_TOPO = addfile(dir_TOPO_out+"LH_DE_PE.TOPOTEST.L5.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_TOPO,"time",-1, True)
ncdf_TOPO->LH_inte = LH_TOPO_inte
ncdf_TOPO->DE_inte = DE_TOPO_inte
ncdf_TOPO->PE_inte = PE_TOPO_inte

system("rm "+dir_CTR_out+"LH_DE_PE.CTR.L5.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc")
ncdf_CTR = addfile(dir_CTR_out+"LH_DE_PE.CTR.L5.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","c")
filedimdef(ncdf_CTR,"time",-1, True)
ncdf_CTR->LH_inte = LH_CTR_inte
ncdf_CTR->DE_inte = DE_CTR_inte
ncdf_CTR->PE_inte = PE_CTR_inte

end do ; do index

end
