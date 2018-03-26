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
<<<<<<< HEAD

import containers
import reparametrize as reparam
import likelihoods 
       
class Fits(containers.TimeSeries):
    ''' An object containing the fits. '''

    fields = ['pp', 'pa', 'ap', 'aa']

    def __init__(self, *args, **kargs):

        super(Fits, self).__init__(*args, **kargs)

        return


    def scale(self, nnp, nna):
        '''Scale only by trial type. '''

        nobj = deepcopy(self)

        nobj.pp = self.pp * nnp
        nobj.ap = self.ap * nna
        nobj.pa = self.pa * nnp
        nobj.aa = self.aa * nna

        return nobj

def gen_llh(theta, model, maxt=8.0, ns=100):
    ''' Generate the likelihood of a model. 
    
    theta       -- Array of double
    model       -- likelihood function
    maxt        -- Limit of integration
    ns          -- Grid size


    '''
=======

import containers
import reparametrize as reparam
import likelihoods 
       
class Fits(containers.TimeSeries):
    ''' An object containing the fits. '''

    fields = ['pp', 'pa', 'ap', 'aa']
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

    def __init__(self, *args, **kargs):

        super(Fits, self).__init__(*args, **kargs)

        return


    def scale(self, nnp, nna):
        '''Scale only by trial type. '''

        nobj = deepcopy(self)

        nobj.pp = self.pp * nnp
        nobj.ap = self.ap * nna
        nobj.pa = self.pa * nnp
        nobj.aa = self.aa * nna

        return nobj

def generate_llh_no_outliers(theta, model, time, t0):
    ''' Generate the likelihood of a model but zero everything below t0. 
    
    theta       -- Array of double
    model       -- likelihood function
    time        -- A vector of time points. 

    '''

    results = generate_llh(theta, model, time)
    v = time < t0

    results['aa'][v] = -np.inf
    results['ap'][v] = -np.inf
    results['pp'][v] = -np.inf
    results['pa'][v] = -np.inf


    return Fits(results)


def generate_llh(theta, model, time):
    ''' Generate the likelihood of a model. 
    
    theta       -- Array of double
    model       -- likelihood function
    time        -- A vector of time points. 


    '''

    ns = len(time)

    a = np.zeros((ns, 1))
    tt = np.zeros((ns, 1)) 

<<<<<<< HEAD
    results = {'time': t}

    # Prosaccades in prosaccade trial
    results['pp'] = model(t, a, tt, theta)
=======
    results = {'time': time}

    # Prosaccades in prosaccade trial
    results['pp'] = model(time, a, tt, theta)
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
        
    # Prosaccade in antisccade trial
    tt[:] = 1
    results['ap'] = model(time, a, tt, theta)

    # Antisaccade in prosaccade trial
    
    a[:] = 1
    tt[:] = 0
    
    results['pa'] = model(time, a, tt, theta)

    # Antisaccad in antisaccade trial

    a[:] = 1
    tt[:] = 1

    results['aa'] = model(time, a, tt, theta)

    return results

<<<<<<< HEAD
    return results
    
=======


def gen_llh(theta, model, maxt=8.0, ns=100):
    ''' Generate the likelihood of a model. 
    
    theta       -- Array of double
    model       -- likelihood function
    maxt        -- Limit of integration
    ns          -- Grid size


    '''

    # Time offset
    
    t = np.linspace(0.0, maxt, ns)
 
    return generate_llh(theta, model, t)
    
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
def generate_fits(theta, model, maxt=8.0, ns=100):

    results = gen_llh(theta, model, maxt, ns)

    return Fits(results)


if __name__ == '__main__':
    pass    

