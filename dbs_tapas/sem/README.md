# README

aponteeduardo@gmail.com
copyright (C) 2015-2017

<<<<<<< HEAD
# Dependencies

tapas/sem depends on 

gsl/1.16


=======
# The SERIA model

The [SERIA model](http://www.biorxiv.org/content/early/2017/06/08/109090)
is a formal statistical model of the probability of a 
pro- or antisaccade and its reaction time. The currente toolbox includes an 
inference method based on the Metropolis-Hasting algorithm implemented in
MATLAB.

After installation (see below), you can run an example using

~~~~
tapas_init();
tapas_sem_example_invesion(1);
~~~~

This will load data and estimate parameters. The data consists
of a list of trials with trial type (pro or antisaccade), the
action performed (pro or antisaccade) and the reaction time. 
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

You can use the file `sem/examples/tapas_sem_example_inversion.m`
as a template to run your analysis.

<<<<<<< HEAD
Sooner can be install as an usual python package using

python setup.py install 

It's dependencies are:

numpy
scipy
Cython
=======
## As a python package

This toolbox can be installed as python package. Although no inference
algorithm is currently implemented, it can be potentially used in combination
with packages implementing maximum likelihood estimators or the 
Metropolis-Hasting algorithm. After installation it can be imported as
~~~~
from tapas.sem.antisaccades import likelihoods as seria
~~~~
This contains all the models described in the original
[SERIA paper](https://doi.org/10.1371/journal.pcbi.1005692).

# Installation
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

## Supported platforms

<<<<<<< HEAD
pip install numpy
pip install scipy
pip install Cython

=======
Mac OSX and linux are supported. We have tested in a variaty of setups
and it has worked so far. If you have any issue please contact us.
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

We do not support Windows but most likely it can be installed as a python 
package.

<<<<<<< HEAD
sudo apt-get install libgsl0-dev 
=======
## Dependencies
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

* gsl/1.16>

<<<<<<< HEAD
brew install gsl
brew install clang-omp 

Currently we do not support openmp as clang doesn't support it. Apparently
it is possible to use openmp with clang. If you manage, then it's only
a matter to modify the setup.py scrip by deleting the darwin case.

We do not support windows but we suppect that it might work. Or not.

## Matlab package

We support the installation of sooner in Linux and Mac. We have tested in a few
platforms and it has always worked. You will need a running matlab 
installation. In particular, the command line matlab should be able
=======
In Ubuntu, it can be install as 
~~~~
sudo apt-get install libgsl0-dev
~~~~
To install in Mac
~~~~
brew install gsl
brew install clang-omp 
~~~~
Or alternatively using mac ports.
~~~~
sudo port install gsl
~~~~

## Matlab package

You will need a running matlab 
installation. In particular, the command line command  `matlab` should be able
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
to trigger matlab. The reason is that matlab is used to find out the 
matlabroot directory during the configuration. Make sure
that matlab can be triggered from the command line AND that it is not an
alias.

### Linux
To install the package it should be enough to go to
<<<<<<< HEAD

src/

and type

./configure && make

The most likely problems you could face are the following:

Something with automake or aclocal. In that case please install automake

sudo apt-get install automake

Then in src type

autoreconf -ifv

Then try again

./configure && make

### Mac

It is possible to compile in mac after installing the gcc compiler that 
supports openmp. In theory it is enough to write 

CC=clang-omp ./configure && make
=======
~~~~
tapas/sem/src/
~~~~
and type
~~~~
./configure && make
~~~~
The most likely problems you could face are the following:

#### Something with automake or aclocal.
In that case please install automake,f.e.,
~~~~
sudo apt-get install automake
~~~~
Then type
~~~~
autoreconf -ifv
~~~~
Then try again
~~~~
configure && make
~~~~

### Mac

This follows the same process than linux.
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

Most likely config will fail for one of the following reasons.

<<<<<<< HEAD
sudo port install gsl

Most likely config will fail for a number of reason. Please check the 
following:

Has config found gls's header? If not type 

export C_INCLUDE_PATH="$C_INCLUDE_PAHT:/opt/local/include"
=======
#### Has config found gls's header? 

Often after installation, the compiler fails to find gsl's headeers.
~~~~
export C_INCLUDE_PATH="$C_INCLUDE_PATH:/opt/local/include"
export CFLAGS="-I:/opt/local/include $CFLAGS"
configure && make
~~~~
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

#### Has config found gls's libraries? 

<<<<<<< HEAD
export LDFLAGS=$LDFLAGS:'-L/opt/local/lib/

Has config found matlab? If not find the path of matlab and type

export PATH=$PATH:/usr/local/MATLAB/R2010b/bin/

This is an example path, please find the right one.
=======
If not type
~~~~
export LDFLAGS="$LDFLAGS -L/opt/local/lib/ -L/usr/local/lib"
configure && make
~~~~
#### Has config found matlab?
If not, find the path of matlab and type
~~~~
export PATH=$PATH:your-matlab-path
configure && make
~~~~
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

## Python Package

This toolbox can be install as an usual python package using
~~~~
sudo python setup.py install 
~~~~
If you lack sudo rights or prefer not install it this way use
~~~~
python setup.py install --user
~~~~
Requirements can be installed using
~~~~
pip install -r requirements.txt
~~~~
