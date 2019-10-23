'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch
/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv
Qt_PTEQ_Qadv.nc (this file is produced by 4_Qdecomp_Lat_X.ncl)

plot time series of 9 variables
(1) partial Q / partial t, i.e. Qt
(2) Q tendency due to physics, i.e. PTEQ
(3) Q tendency due to total advection (horizontal + vertical), i.e. Qadv
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
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/'
file_names = ['Qt_PTEQ_Qadv']

var_names = ['Qt','PTEQ','Qadv']
data_vars = np.zeros((3,95)) # 3 vars x 95 hours

#cases = ['CTR', 'TOPO', 'CTR_TOPO']
cases = ['CTR', 'CTR_TOPO']

#for i_case in range(len(cases)):
#    for i in range(len(var_names)):
#        ds = xr.open_dataset(data_path+file_names[0]+'.new.nc', decode_times=False)
#        data_vars[i,:] = ds[var_names[i]+'_Andes_mean_'+cases[i_case]]
#        print(data_vars[i,:])
#        print('==')
#
#    # change from kg/kg / hr to g/kg /hr
#    data_vars = data_vars * 1000.0
#
#    # Plot the time series
#    #fig = plt.figure()
#    ax1 = plt.subplot(3,2,i_case*2+1)
#    x = np.arange(2,97,1)
#    for i in range(len(data_vars[:,0])):
#        plt.plot(x, data_vars[i,:], label = var_names[i])
#    #plt.ylim([-2.0, 5.0])
#    plt.xlabel('time, hr')
#    #plt.ylabel('Q tendency, kg/kg /hr')
#    plt.ylabel('Q tendency, g/kg /hr')
#    plt.title(cases[i_case]+', Andes avg')
#    plt.grid(True)

for i_case in range(len(cases)):
    for i in range(len(var_names)):
        ds = xr.open_dataset(data_path+file_names[0]+'.new.nc', decode_times=False)
        data_vars[i,:] = ds[var_names[i]+'_Amazon_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # change from kg/kg / hr to g/kg /hr
    data_vars = data_vars * 1000.0

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(2,1,i_case+1)
    x = np.arange(2,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = var_names[i])

    plt.xticks(np.arange(0,101,10))
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    #plt.ylabel('Q tendency, kg/kg /hr')
    plt.ylabel('Q tendency, g/kg /hr')
    plt.title(cases[i_case]+', Amazon avg')
    plt.grid(True)

plt.axhline(y=0,linewidth=1.5,color='k')
#plt.legend(loc = 'best')
#plt.legend(bbox_to_anchor=(1.05, 1), loc='best', borderaxespad=0.)
plt.legend(loc='lower right', fontsize='x-small')
#plt.legend(loc='best')
plt.tight_layout()
#plt.show()
plt.savefig('./Q_vertical_integral_decomp.new.refinement.png')

