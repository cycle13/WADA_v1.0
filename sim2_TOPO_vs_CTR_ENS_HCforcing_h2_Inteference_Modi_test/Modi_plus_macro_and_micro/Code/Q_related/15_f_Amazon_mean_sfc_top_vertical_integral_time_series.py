'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch/
hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE_decomp_Andes_Amazon
MSE.nc LSE.nc DSE.nc
Date: 2019/06/17
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt

data_path = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Qadv/'
file_names = ['var_adv','var_div','var_vert_adv','var_vert_gra']

Qadv_acc_file = 'Qt_PTEQ_Qadv'

data_vars = np.zeros((4,96)) # 4+1 vars x 96 hours

#cases = ['CTR', 'TOPO', 'CTR_TOPO']
cases = ['CTR', 'CTR_TOPO']

for i_case in range(len(cases)):
    for i in range(len(file_names)):
        ds = xr.open_dataset(data_path+file_names[i]+'.MF.nc', decode_times=False)
        data_vars[i,:] = ds['Amazon_mean_'+cases[i_case]]
        sum_temp = np.sum(data_vars,axis=0)
        print(sum_temp)
        print(data_vars[i,:])
        print('==')

    ds2 = xr.open_dataset(data_path+'Qt_PTEQ_Qadv.new.nc', decode_times=False)
    Qadv = ds2['Qadv_Amazon_mean_'+cases[i_case]]
    Qadv = Qadv * 1000.0 # from kg/kg/hr to g/kg/hr

    # Plot the time series
    #fig = plt.figure()
    plt.subplot(2,1,i_case+1)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = file_names[i])
    plt.plot(x, sum_temp, label = 'SUM')
    plt.plot(x[1:96],Qadv, label = 'Qadv_accurate')
    # plot Qadv inferred from (QAP(n)-QAP(n-1)) /time interval - PTEQ

    plt.xticks(np.arange(0,101,10))
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    plt.ylabel('g/kg/hr')
    plt.title(cases[i_case]+', Amazon avg, sfc_top')
    plt.grid(True)

plt.axhline(y=0,linewidth=1.5,color='k')
#plt.legend(loc = 'best')
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0.)
plt.tight_layout()
plt.show()
#plt.savefig('./Modi_midlevel_CTR_TOPO_Amazon_mean_Q_bugdet_MF_sfc_top_decomp.png',dpi=500)

