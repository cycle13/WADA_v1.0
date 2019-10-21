'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch
/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Raymond/
Raymond_numerator.nc (this file is produced by 1_a_Raymond_Numerator_diabatic_term.ncl)

plot time series of 15 variables
SHFLX_Andes_mean_CTR
SHFLX_Andes_mean_TOPO
SHFLX_Andes_mean_CTR_TOPO

LHFLX_Andes_mean_CTR
LHFLX_Andes_mean_TOPO
LHFLX_Andes_mean_CTR_TOPO

QRS_Andes_mean_CTR
QRS_Andes_mean_TOPO
QRS_Andes_mean_CTR_TOPO

QRL_Andes_mean_CTR
QRL_Andes_mean_TOPO
QRL_Andes_mean_CTR_TOPO

DH_Andes_mean_CTR
DH_Andes_mean_TOPO
DH_Andes_mean_CTR_TOPO

Put the five lines into a single figure.
Then for CTR, TOPO, and CTR-TOPO.

Do it for Amazon and Andes respectively.
Therefore, you have a 6-figure panel.

Date: 2019/07/29
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt

data_path = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Raymond/'
file_names = ['Raymond_numerator']

var_names = ['SHFLX','LHFLX','QRS','QRL','DH']
data_vars = np.zeros((5,96)) # 3 vars x 95 hours

cases = ['CTR', 'TOPO', 'CTR_TOPO']

for i_case in range(len(cases)):
    for i in range(len(var_names)):
        #ds = xr.open_dataset(data_path+file_names[0]+'.nc', decode_times=False)
        ds = xr.open_dataset(data_path+file_names[0]+'.new.nc', decode_times=False)
        data_vars[i,:] = ds[var_names[i]+'_Andes_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,2,i_case*2+1)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = var_names[i])
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    #plt.ylabel('Q tendency, kg/kg /hr')
    plt.ylabel('Heating, watt/m2')
    plt.title(cases[i_case]+', Andes avg')
    plt.grid(True)

for i_case in range(len(cases)):
    for i in range(len(var_names)):
        #ds = xr.open_dataset(data_path+file_names[0]+'.nc', decode_times=False)
        ds = xr.open_dataset(data_path+file_names[0]+'.new.nc', decode_times=False)
        data_vars[i,:] = ds[var_names[i]+'_Amazon_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,2,i_case*2+2)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = var_names[i])
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    plt.ylabel('Heating, watt/m2')
    plt.title(cases[i_case]+', Amazon avg')
    plt.grid(True)

#plt.legend(loc = 'best')
plt.legend(bbox_to_anchor=(1.05, 1), loc='best', borderaxespad=0.)
plt.tight_layout()
plt.show()
#plt.savefig('../Figures/1_Raymond_Diabatic_heating_numerator_vertical_integral_decomp.new.png',dpi=400)
