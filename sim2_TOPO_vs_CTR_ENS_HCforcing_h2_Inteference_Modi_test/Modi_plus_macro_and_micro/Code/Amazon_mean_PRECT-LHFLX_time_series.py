'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch
/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications
LHFLX
Date: 2019/06/11
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt


data_path = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/PTTEND_budget/'
file_names1 = ['PRECT']
file_names2 = ['LHFLX']

data_vars = np.zeros((1,96)) # 1 vars x 96 hours

cases = ['CTR', 'TOPO', 'CTR_TOPO']

for i_case in range(len(cases)):
    ds1 = xr.open_dataset(data_path+file_names1[0]+'.nc', decode_times=False)
    ds2 = xr.open_dataset(data_path+file_names2[0]+'.nc', decode_times=False)
    data_vars[0,:] = ds1['Amazon_mean_'+cases[i_case]] - ds2['Amazon_mean_'+cases[i_case]]
    print(data_vars[0,:])
    print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,1,i_case+1)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = 'P-E')
    if i_case <= 1:
        plt.ylim([0.0, 5.0])
    else:
        plt.ylim([-2.0, 2.0])
    plt.xlabel('time, hr')
    plt.ylabel('PRECT-ET, mm/day')
    plt.title(cases[i_case]+', Amazon avg')
    plt.grid(True)

#plt.legend(loc = 'best')
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0.)
plt.tight_layout()
#plt.show()
plt.savefig('../Figures/CTR_TOPO_Amazon_mean_PRECT-LHFLX.png',dpi=400)

