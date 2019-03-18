# README

aponteeduardo@gmail.com
copyright (C) 2017

This are mostly hierarchical priors design to be combines with different 
models.

## dlinear

This is a hierarchical prior that only models the population mean assuming
a precision matrix of the form p\*I. This uses the standar Gamma gaussian
model.

## mdlinear

This is a multivariate hierarchical prior that models linear effects. Every
parameters is assumend to have its own precision. Thus for a model with 
parameter gamma:

gamma = X\*b + e

Where the variance of e is of the for p\*I.

 
