;Function: read in GPCP precip data and compute the 197901-200812 climatology;
;Date: 2018 0313

load "/global/homes/h/hongcheq/Programming/NCL_funs_and_procs/funs_and_procs.ncl"

begin

f = addfile("/project/projectdirs/m2840/hongcheq/GPCP/precip.mon.mean.nc","r")
precip = f->precip
pr = precip(0:359,:,:)

printVarSummary(pr)
;print(Calendar(pr&time))

pr_clim_GPCP = dim_avg_n_Wrap(pr,0)
printVarSummary(pr_clim_GPCP)

;========= output as nc files ====
system("rm -f /project/projectdirs/m2840/hongcheq/GPCP/GPCP_197901-200812_clim.nc")
ncdf = addfile("/project/projectdirs/m2840/hongcheq/GPCP/GPCP_197901-200812_clim.nc","c")

filedimdef(ncdf,"time",-1,True)

ncdf->pr_clim_GPCP = pr_clim_GPCP


end
