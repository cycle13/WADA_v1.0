"""
Function:
    Read files in this dir: /DFS-L/DATA/pritchard/hongcheq/
    WADA_CTR_TOPO_ENSEMBLE_post-processing/
    Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/
    To generate a figure of 3x1 for CTR, TOPO, CTR-TOPO respectively.
    For six variables: SHFLX, LHFLX, SHFLX+LHFLX, SWCF, LWCF, SWCF+LWCF.
"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr

dire = '/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing\
/Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/'
files = ['SWCF_avg_box_hourly_96hrs.nc',
        'LWCF_avg_box_hourly_96hrs.nc',
        'CF_avg_box_hourly_96hrs.nc',
        'SHFLX_avg_box_hourly_96hrs.nc',
        'LHFLX_avg_box_hourly_96hrs.nc',
        'FLX_avg_box_hourly_96hrs.nc']

Vars = np.zeros((6,3,96))  # # vars x [CTR, TOPO, CTR-TOPO] x 96 hrs

var_str = ['SWCF','LWCF','CF','SHFLX','LHFLX','FLX']

for i_file in range(6):
    ds_X = xr.open_dataset(dire+files[i_file],decode_times=False)
    Vars[i_file,0,:] = ds_X[var_str[i_file]+'_CTR']
    Vars[i_file,1,:] = ds_X[var_str[i_file]+'_TOPO']
    Vars[i_file,2,:] = ds_X[var_str[i_file]+'_CTR_TOPO']

print(Vars)

#------------plot--------------

title_str = ['CTR','TOPO','CTR-TOPO']
fmt_str = ['--y','--r','--k','-y','-r','-k'] # black if not color not denoted

fig, axes = plt.subplots(3, 1, figsize=(9, 9))

for i_fig in range(3):
    for i_var in range(6):
        axes[i_fig].plot(np.arange(96)+1, Vars[i_var,i_fig,:],
                            fmt_str[i_var],label=var_str[i_var])
    axes[i_fig].set_title(title_str[i_fig])
    axes[i_fig].set_ylabel('$ W/m^2 $')
    axes[i_fig].grid(True)

axes[2].legend(loc='upper left')
axes[2].set_xlabel('# hours')

#fig.suptitle('Cloud Radiative Forcing & Surface Fluxes')

plt.subplots_adjust(hspace=.3)
#plt.show()

plt.savefig('../Figures/10_CTR_TOPO_SWCF_LWCF_SHFLX_LHFLX_time_series.png')

