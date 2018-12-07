"""
Function:
    Read files in this dir: /DFS-L/DATA/pritchard/hongcheq/
    WADA_CTR_TOPO_ENSEMBLE_post-processing/
    Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/
    Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/
    To generate a figure of 3x1 for CTR, TOPO, CTR-TOPO respectively.
    For variable CLOUD.
"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr

dire = '/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing\
/Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/'
files = 'CLOUD_avg_box_hourly_96hrs.nc'

Vars = np.zeros((3,96,13))  # [CTR, TOPO, CTR-TOPO] x 96 hrs x 13 lvl

ds_X = xr.open_dataset(dire+files,decode_times=False)
print(ds_X)

Vars[0,:,:] = ds_X['CLOUD_CTR']
Vars[1,:,:] = ds_X['CLOUD_TOPO']
Vars[2,:,:] = ds_X['CLOUD_CTR_TOPO']

#print(Vars)

#------------plot--------------
x = np.arange(1,97,1)
y = ds_X['lev_p']

print(y)

X, Y = np.meshgrid(x, y)

title_str = ['CTR','TOPO','CTR-TOPO']

fig, axes = plt.subplots(3, 1, figsize=(9, 9))

cset0 = axes[0].contourf(x, y, np.transpose(Vars[0,:,:]), cmap='Blues',
                         levels=np.linspace(0.0,0.8,11))
axes[0].set_title(title_str[0])
axes[0].set_ylabel('Level (hPa)')
axes[0].invert_yaxis()
fig.colorbar(cset0,ax=axes[0])

cset1 = axes[1].contourf(X, Y, np.transpose(Vars[1,:,:]), cmap='Blues',
                         levels=np.linspace(0.0,0.8,11))
axes[1].set_title(title_str[1])
axes[1].set_ylabel('Level (hPa)')
axes[1].invert_yaxis()
fig.colorbar(cset1,ax=axes[1])

cset2 = axes[2].contourf(X, Y, np.transpose(Vars[2,:,:]), cmap='RdBu',
                         levels=np.linspace(-0.2,0.2,11))
axes[2].set_title(title_str[2])
axes[2].set_ylabel('Level (hPa)')
axes[2].invert_yaxis()
fig.colorbar(cset2,ax=axes[2])

axes[2].set_xlabel('# hours')

plt.subplots_adjust(hspace=.3)
#plt.show()
plt.savefig('../Figures/11_b_CLOUD_Height_time_96hr.pdf')
plt.savefig('../Figures/11_b_CLOUD_Height_time_96hr.png')


