'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch
/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications
MSE.nc LSE.nc DSE.nc
plot time series and figure out the diurnal cycle and which term contributes to the
PTTEND negative over the Andes in the TOPO group
Date: 2019/06/11
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt

data_path = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE_decomp_Andes_Amazon/'
file_names = ['MSE','LSE','DSE']

data_vars = np.zeros((len(file_names),96)) # 6 vars x 96 hours

cases = ['CTR', 'TOPO', 'CTR_TOPO']

for i_case in range(len(cases)):
    for i in range(len(file_names)):
        ds = xr.open_dataset(data_path+file_names[i]+'1000-850.nc', decode_times=False)
        data_vars[i,:] = ds['Andes_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,1,i_case+1)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = file_names[i])
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    plt.ylabel('kJ/kg')
    plt.title(cases[i_case]+', Andes avg, 1000-850hPa')
    plt.grid(True)

#plt.legend(loc = 'best')
plt.legend(bbox_to_anchor=(1.05, 1), loc='best', borderaxespad=0.)
plt.tight_layout()
#plt.show()
plt.savefig('../Figures/CTR_TOPO_Andes_mean_MSE_1000-850hPa_decomp.png')

