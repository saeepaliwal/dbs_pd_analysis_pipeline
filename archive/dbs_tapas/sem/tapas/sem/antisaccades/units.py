#! /usr/bin/env python

# aponteeduardo@gmail.com
# copyright (C) 2016


''''

Graphical tools

'''


from pdb import set_trace as _
from copy import deepcopy
import numpy as np
from scipy.integrate import cumtrapz
from scipy import stats

import containers
import reparametrize as reparam
import likelihoods 
       
class Units(containers.TimeSeries):
    ''' Abstract class for units, where units refer to the distribution
    of the units. '''

    pass

class UnitsSeri(Units):

    fields = ['p', 'a', 's', 'l']

    def __init__(self, time=None, samples=None):

        if samples is None:
            super(UnitsSeri, self).__init__()
        else:
            results = self.llh(time, samples)
            super(UnitsSeri, self).__init__(results)

        return None

class UnitsSeriInvgamma(UnitsSeri):

    def __init__(self, *args, **kargs):

        super(UnitsSeriInvgamma, self).__init__(*args, **kargs)

        return None

    def llh(self, time, stheta):

        results = {}
        results['time'] = time

        results['p'] = stats.invgamma.logpdf(time, stheta.kp,
            scale=stheta.tp, loc=stheta.t0)

        results['a'] = np.log(stheta.ap) + stats.invgamma.logpdf(time, 
                stheta.ka, scale=stheta.ta, loc=stheta.t0 + stheta.da) 

        results['s'] = stats.invgamma.logpdf(time, stheta.ks, 
            scale=stheta.ts, loc=stheta.t0) 

        results['l'] = np.log(1 - stheta.ap) + results['a'] - \
                np.log(stheta.ap) 

        return results 

class UnitsDora(containers.TimeSeries):

<<<<<<< HEAD
    fields = ['e', 'a', 'i', 'p']
=======
    fields = ['e', 'a', 'i', 'p', 'ns']
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

    def __init__(self, time=None, samples=None):

        if samples is None:
            super(UnitsDora, self).__init__()
        else:
            results = self.llh(time, samples)
            super(UnitsDora, self).__init__(results)

        return

class UnitsDoraMixedgamma(UnitsDora):
    ''' Dora untis with mixed gamma. '''

    def __init__(self, time, samples):
        '''Dora untis with mixedgamma. '''
        super(UnitsDoraMixedgamma, self).__init__(time, samples)

        return None

    def llh(self, time, stheta):

        results = {}
        results['time'] = time

<<<<<<< HEAD
        results['e'] = stats.invgamma.logpdf(time, stheta.kp,
		 scale=stheta.tp, loc=stheta.t0)

        intt = np.linspace(0, 15, 400)
        nc = np.trapz(np.exp(stats.gamma.logpdf(intt, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da) + \
            stats.gamma.logsf(intt, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da)), intt)


        results['a'] = -np.log(nc) + stats.gamma.logpdf(time, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da) + \
            stats.gamma.logsf(time, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da) 


        results['p'] = stats.gamma.logpdf(time, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da) + \
            stats.gamma.logsf(time, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da) 
        results['i'] = stats.invgamma.logpdf(time, stheta.ks,
            scale=stheta.ts, loc=stheta.t0)

=======
        e_lsf = stats.invgamma.logsf(time, stheta.kp, scale=stheta.tp, 
                loc=stheta.t0)
        e_lpdf = stats.invgamma.logpdf(time, stheta.kp, scale=stheta.tp, 
                loc=stheta.t0)
        e_lcdf = stats.invgamma.logcdf(time, stheta.kp, scale=stheta.tp, 
                loc=stheta.t0)

        i_lsf = stats.invgamma.logsf(time, stheta.ks, scale=stheta.ts, 
                loc=stheta.t0)
        i_lcdf = stats.invgamma.logcdf(time, stheta.ks, scale=stheta.ts, 
                loc=stheta.t0)


        a_lpdf = stats.gamma.logpdf(time, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da)
        p_lsf = stats.gamma.logsf(time, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da)

        p_lpdf = stats.gamma.logpdf(time, stheta.kl, 
		scale=stheta.tl, loc=stheta.t0 + stheta.da)
        a_lsf = stats.gamma.logsf(time, stheta.ka, 
                scale=stheta.ta, loc=stheta.t0 + stheta.da)

        results['e'] = e_lpdf #: + i_lsf + p_lsf + a_lsf
        #results['e'] += np.exp(p_lpdf + i_lsf + a_lsf + e_lsf)
        #results['e'] = np.log(results['e'])
        #results['e'] += p_lpdf + i_lsf + a_lsf + e_lsf 
        results['e'] += - np.log(np.trapz(np.exp(results['e']), time))



        results['a'] = a_lpdf + i_lcdf + e_lcdf + p_lsf
        nc =  np.trapz(np.exp(results['a']), time)
        results['a'] -= np.log(nc)
        results['p'] = a_lpdf 
        #-np.log(1 - nc) + p_lpdf + a_lsf
        
        results['i'] = stats.invgamma.logpdf(time, stheta.ks,
            scale=stheta.ts, loc=stheta.t0)

        results['ns'] = results['e'] + stats.invgamma.logsf(time, stheta.ks,
            scale=stheta.ts, loc=stheta.t0)
        results['ns'] = results['ns'] - \
            np.log(np.trapz(np.exp(results['ns']), time))


>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
        return results 

class UnitsDoraInvgamma(UnitsDora):
    ''' Dora units with invgamma. '''

    def __init__(self, time, samples):

        super(UnitsDoraInvgamma, self).__init__(time, samples)

        return None

    def llh(self, time, stheta):

        results = {}
        results['time'] = time

        results['e'] = stats.invgamma.logpdf(time, stheta.kp,
		 scale=stheta.tp, loc=stheta.t0)

        results['a'] = stats.invgamma.logpdf(time, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da) + \
            stats.invgamma.logsf(time, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da) 

        results['p'] = stats.invgamma.logpdf(time, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da) + \
            stats.invgamma.logsf(time, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da) 
        results['i'] = stats.invgamma.logpdf(time, stheta.ks,
            scale=stheta.ts, loc=stheta.t0)

        return results 

class UnitsDoraLognorm(UnitsDora):
    ''' Dora units with invgamma. '''

    def __init__(self, time, samples):

        super(UnitsDoraInvgamma, self).__init__(time, samples)

        return None

    def llh(self, time, stheta):

        results = {}
        results['time'] = time

        results['e'] = stats.lognorm.logpdf(time, stheta.kp,
		 scale=stheta.tp, loc=stheta.t0)

        results['a'] = stats.lognorm.logpdf(time, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da) + \
            stats.lognorm.logsf(time, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da) 

        results['p'] = stats.lognorm.logpdf(time, stheta.kl, 
                scale=stheta.tl, loc=stheta.t0 + stheta.da) + \
            stats.lognorm.logsf(time, stheta.ka, 
		scale=stheta.ta, loc=stheta.t0 + stheta.da) 

        results['i'] = stats.lognorm.logpdf(time, stheta.ks,
            scale=stheta.ts, loc=stheta.t0)

        return results 

if __name__ == '__main__':
    pass    

