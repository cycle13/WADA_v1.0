"""
Function:
    Read files in this dir: /DFS-L/DATA/pritchard/hongcheq/
    WADA_CTR_TOPO_ENSEMBLE_post-processing/
    Vertical_growth_of_temperature_anomaly/CAPE_CIN/
    To generate a figure of 3x1 for CTR, TOPO, CTR-TOPO respectively.
    For two variables: CAPE, CIN.
"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr

dire = '/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing\
/Vertical_growth_of_temperature_anomaly/CAPE_CIN/'
files = 'CAPE_CIN_avg_box_hourly_96hrs.nc'

Vars = np.zeros((2,3,96))  # # vars x [CTR, TOPO, CTR-TOPO] x 96 hrs

var_str = ['CAPE','CIN']

ds_X = xr.open_dataset(dire+files,decode_times=False)
for i_file in range(2):
    Vars[i_file,0,:] = ds_X[var_str[i_file]+'_CTR_EastFlank']
    Vars[i_file,1,:] = ds_X[var_str[i_file]+'_TOPO_EastFlank']
    Vars[i_file,2,:] = ds_X[var_str[i_file]+'_CTR_TOPO_EastFlank']

print(Vars)

#------------plot--------------

title_str = ['CTR','TOPO','CTR-TOPO']
fmt_str = ['--r','--b']

fig, axes = plt.subplots(3, 1, figsize=(9, 9))

for i_fig in range(3):
    for i_var in range(2):
        axes[i_fig].plot(np.arange(96)+1, Vars[i_var,i_fig,:],
                            fmt_str[i_var],label=var_str[i_var])
    axes[i_fig].set_title(title_str[i_fig])
    axes[i_fig].set_ylabel('$ J/kg $')
    axes[i_fig].grid(True)

axes[2].legend(loc='upper left')
axes[2].set_xlabel('# hours')


plt.subplots_adjust(hspace=.3)
#plt.show()

plt.savefig('../Figures/13_b_CTR_TOPO_CAPE_CIN_time_series.png')
plt.savefig('../Figures/13_b_CTR_TOPO_CAPE_CIN_time_series.pdf')

