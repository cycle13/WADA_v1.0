"""
Function:
    Read files in this dir: /DFS-L/DATA/pritchard/hongcheq/
    WADA_CTR_TOPO_ENSEMBLE_post-processing/
    Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/
    Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/
    To generate a figure of 3x1 for CTR, TOPO, CTR-TOPO respectively.
    For variable MSE.
"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr

dire = '/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing\
/Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/'
files = 'MSE_avg_box_hourly_96hrs.nc'

Vars = np.zeros((3,96,13))  # [CTR, TOPO, CTR-TOPO] x 96 hrs x 13 lvl

ds_X = xr.open_dataset(dire+files,decode_times=False)
print(ds_X)

Vars[0,:,:] = ds_X['MSE_CTR']/1000.0  # from J/kg to kJ/kg
Vars[1,:,:] = ds_X['MSE_TOPO']/1000.0 # from J/kg to kJ/kg
Vars[2,:,:] = ds_X['MSE_CTR_TOPO']/1000.0  # from J/kg to kJ/kg
unit_str = 'kJ/kg'

#------------plot--------------
x = np.arange(1,97,1)
y = ds_X['lev_p']

print(y)

X, Y = np.meshgrid(x, y)

title_str = ['MSE, CTR','MSE, TOPO','MSE, CTR-TOPO']

fig, axes = plt.subplots(3, 1, figsize=(9, 9))

cset0 = axes[0].contourf(x, y, np.transpose(Vars[0,:,:]), cmap='Reds',
                         levels=np.linspace(310.0,410.0,11))
axes[0].set_title(title_str[0])
axes[0].set_ylabel('Level (hPa)')
axes[0].invert_yaxis()
cbar0 = fig.colorbar(cset0,ax=axes[0])
cbar0.set_label(unit_str)

cset1 = axes[1].contourf(X, Y, np.transpose(Vars[1,:,:]), cmap='Reds',
                         levels=np.linspace(310.0,410.0,11))
axes[1].set_title(title_str[1])
axes[1].set_ylabel('Level (hPa)')
axes[1].invert_yaxis()
cbar1 = fig.colorbar(cset1,ax=axes[1])
cbar1.set_label(unit_str)

cset2 = axes[2].contourf(X, Y, np.transpose(Vars[2,:,:]), cmap='bwr',
                         levels=np.linspace(-1.5,1.5,11))
axes[2].set_title(title_str[2])
axes[2].set_ylabel('Level (hPa)')
axes[2].invert_yaxis()
cbar2 = fig.colorbar(cset2,ax=axes[2])
cbar2.set_label(unit_str)

axes[2].set_xlabel('# hours')
#axes[2].set_yscale("log")

plt.subplots_adjust(hspace=.3)
#plt.show()
#plt.savefig('../Figures/12_b_MSE_Height_time_96hr.pdf')
plt.savefig('../Figures/12_b_MSE_Height_time_96hr.png')


