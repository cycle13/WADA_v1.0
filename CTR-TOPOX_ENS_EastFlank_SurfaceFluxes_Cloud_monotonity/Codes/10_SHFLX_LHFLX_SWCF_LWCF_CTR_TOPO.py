"""
Function:
    Read files in this dir: /scratch/hongcheq/
    HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h1_tapes_SHFLX_LHFLX_SWCF_LWCF
    /TOPO00
    To generate a figure of 3x1 for CTR, TOPO, CTR-TOPO respectively.
    For six variables: SHFLX, LHFLX, SHFLX+LHFLX, SWCF, LWCF, SWCF+LWCF.
"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr

#PCT = 'TOPO00'
#PCT = 'TOPO20'
#PCT = 'TOPO40'
#PCT = 'TOPO60'
PCT = 'TOPO80'

dire = '/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-\
processing_h1_tapes_SHFLX_LHFLX_SWCF_LWCF/'+PCT+'/'
files = ['SWCF_avg_box_daily.nc',
        'LWCF_avg_box_daily.nc',
        'CF_avg_box_daily.nc',
        'SHFLX_avg_box_daily.nc',
        'LHFLX_avg_box_daily.nc',
        'FLX_avg_box_daily.nc']

Vars = np.zeros((6,3,8))  # # vars x [CTR, TOPO, CTR-TOPO] x 8 days

var_str = ['SWCF','LWCF','CF','SHFLX','LHFLX','FLX']

for i_file in range(6):
    ds_X = xr.open_dataset(dire+files[i_file],decode_times=False)
    Vars[i_file,0,:] = ds_X[var_str[i_file]+'_CTR']
    Vars[i_file,1,:] = ds_X[var_str[i_file]+'_TOPO']
    Vars[i_file,2,:] = ds_X[var_str[i_file]+'_CTR_TOPO']

print(Vars)

#------------plot--------------

title_str = ['CTR',PCT,'CTR-'+PCT]
fmt_str = ['--y','--r','--k','-y','-r','-k'] # black if not color not denoted

fig, axes = plt.subplots(3, 1, figsize=(9, 9))

for i_fig in range(3):
    for i_var in range(6):
        axes[i_fig].plot(np.arange(8)+1, Vars[i_var,i_fig,:],
                            fmt_str[i_var],label=var_str[i_var])
    axes[i_fig].set_title(title_str[i_fig])
    axes[i_fig].set_ylabel('$ W/m^2 $')
    axes[i_fig].grid(True)

axes[0].set_ylim(-170.,150)
axes[1].set_ylim(-170.,150)
axes[2].set_ylim(-20.,30)

axes[2].legend(loc='upper left')
axes[2].set_xlabel('# days')

#fig.suptitle('Cloud Radiative Forcing & Surface Fluxes')

plt.subplots_adjust(hspace=.3)
#plt.show()

plt.savefig('../Figures/10_'+PCT+'CTR_TOPO_SWCF_LWCF_SHFLX_LHFLX_time_series.png')
#plt.savefig('../Figures/10_'+PCT+'CTR_TOPO_SWCF_LWCF_SHFLX_LHFLX_time_series.pdf')

# output SWCF, LWCF, CF, SHFLX, LHFLX, FLX average day 3-7 for CTR-TOPOX for
# further usage
# Note that (1) index starting from 0 and slide(2,7) does not include the last
# 7
SWCF_avg = xr.DataArray(np.mean(Vars[0,2,2:7]))
SWCF_avg.name = 'SWCF'
SWCF_avg.attrs['units'] = 'W/m2'

LWCF_avg = xr.DataArray(np.mean(Vars[1,2,2:7]))
LWCF_avg.name = 'LWCF'
LWCF_avg['units'] = 'W/m2'

CF_avg = xr.DataArray(np.mean(Vars[2,2,2:7]))
CF_avg.name = 'CF'
CF_avg['units'] = 'W/m2'

SHFLX_avg = xr.DataArray(np.mean(Vars[3,2,2:7]))
SHFLX_avg.name = 'SHFLX'
SHFLX_avg['units'] = 'W/m2'

LHFLX_avg = xr.DataArray(np.mean(Vars[4,2,2:7]))
LHFLX_avg.name = 'LHFLX'
LHFLX_avg['units'] = 'W/m2'

FLX_avg = xr.DataArray(np.mean(Vars[5,2,2:7]))
FLX_avg.name = 'FLX'
FLX_avg['units'] = 'W/m2'

# save to netcdf file
myds = xr.merge([SWCF_avg, LWCF_avg, CF_avg, SHFLX_avg, LHFLX_avg, FLX_avg])
myds.to_netcdf('/gdata/pritchard/hongcheq/WetAndesDryAmazon/Linear_Monotonicity_TEST/CF_FLX_'+PCT+'.nc')
print(myds)



