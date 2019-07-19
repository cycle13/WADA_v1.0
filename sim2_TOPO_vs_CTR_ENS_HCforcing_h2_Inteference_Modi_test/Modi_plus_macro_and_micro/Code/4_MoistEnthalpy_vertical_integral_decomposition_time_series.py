'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch
/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MoistEnthalpy_adv
MEt_MEphy_MEadv.nc (this file is produced by 4_MoistEnthalpy_decomp_Lat_X.ncl)

plot time series of 9 variables
(1) partial ME / partial t, i.e. ME_t
(2) ME tendency due to physics, i.e. ME_phy
(3) ME tendency due to total advection (horizontal + vertical), i.e. ME_adv
Put the three lines into a single figure.
Then for CTR, TOPO, and CTR-TOPO.

Then you have 3 panels for 9 variables. Do it for Amazon and Andes respectively.
Therefore, you have a 6-figure panel.

Date: 2019/07/18
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt

data_path = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MoistEnthalpy_adv/'
file_names = ['MEt_MEphy_MEadv']

var_names = ['ME_t','ME_phy','ME_adv']
data_vars = np.zeros((3,95)) # 3 vars x 95 hours

cases = ['CTR', 'TOPO', 'CTR_TOPO']

for i_case in range(len(cases)):
    for i in range(len(var_names)):
        ds = xr.open_dataset(data_path+file_names[0]+'.nc', decode_times=False)
        data_vars[i,:] = ds[var_names[i]+'_Andes_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,2,i_case*2+1)
    x = np.arange(2,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = var_names[i])
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    #plt.ylabel('Q tendency, kg/kg /hr')
    plt.ylabel('ME tendency, J/kg /hr')
    plt.title(cases[i_case]+', Andes avg')
    plt.grid(True)

for i_case in range(len(cases)):
    for i in range(len(var_names)):
        ds = xr.open_dataset(data_path+file_names[0]+'.nc', decode_times=False)
        data_vars[i,:] = ds[var_names[i]+'_Amazon_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,2,i_case*2+2)
    x = np.arange(2,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = var_names[i])
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    #plt.ylabel('Q tendency, kg/kg /hr')
    plt.ylabel('ME tendency, J/kg /hr')
    plt.title(cases[i_case]+', Amazon avg')
    plt.grid(True)

#plt.legend(loc = 'best')
plt.legend(bbox_to_anchor=(1.05, 1), loc='best', borderaxespad=0.)
plt.tight_layout()
#plt.show()
plt.savefig('../Figures/4_MoistEnthalpy_vertical_integral_decomp.png')

