/* aponteeduardo@gmail.com */
/* copyright (C) 2015 */

#ifndef C_ANTISACCADES
#define C_ANTISACCADES

#ifndef TAPAS_PYTHON

#include <matrix.h>
#include <mex.h>

#endif

#include "includes/sem.h"

#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_sf_erf.h>
#include <gsl/gsl_randist.h>
#include <gsl/gsl_cdf.h>
#include <gsl/gsl_sys.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_integration.h>
#include <gsl/gsl_sf_trig.h>
#include <assert.h>

#define PROSACCADE 0
#define ANTISACCADE 1

// This is used because sometimes functions are not defined at zero.
#define ZERO_DISTS 0.000001
// Absolute error tolerance
#define SEM_TOL 0.00001
// Relative error tolerance
#define SEM_RTOL 0.001
<<<<<<< HEAD
=======
// Maximum shape parameter gamma distribution
#define SEM_GAMMA_MAX_SHAPE 30
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

#define NITER_NGAMMA 15
#define INTSTEP 80

#define DIM_PROSA_THETA 9 
#define DIM_SERI_THETA 11
#define DIM_DORA_THETA 11

#define MAX_INTEGRATION_SIZE 81

#define LOG2PI 1.8378770664093453
#define SQRT2PI 2.5066282746310002 

// THe probability of an outlier that it's an antisaccade 0.0005, that is
// 5 times every 10000 saccades 

#define LN_P_OUTLIER_ANTI -4.6051701859880909
#define LN_P_OUTLIER_PRO -0.010050335853501451

#define LN_P_DORA_EARLY_PRO -0.0010005003335835344
#define LN_P_DORA_EARLY_ANTI -6.9077552789821368

//#define LN_P_LATE_OUTLIER -7.6009024595420822
//#define LN_P_LATE_NOT_OUTLIER -0.0005001250


# define HANDLE_CERROR( err ) {if ( err ) { \
    printf("%s in %s at line %d\n", "Assertion error", \
                    __FILE__, __LINE__ ); \
    mexErrMsgIdAndTxt("tapas:sem:antisaccades:llh", "Error encountered"); \
    }}

# define HANDLE_CERROR_MSG( err, msg ) {if ( err ) { \
    printf("%s in %s at line %d\n", "Assertion error", \
                    __FILE__, __LINE__ ); \
    printf("%s \n", ( msg )); \
    mexErrMsgIdAndTxt("tapas:sem:antisaccades:llh", "Error encountered"); \
    }}


# define SOONER_GSLERROR( err ) {if ( err ) { \
    return GSL_NAN; \
    }}

typedef double (*NESTED_INTEGRAL)(double x0, double x1, double a,
    double b, double c0, double c1);

// Likelihood, log likelihood, etc..
typedef double (*ACCUMULATOR_FUNCTION)(double time, double shape,
        double scale);

// This class contains the definition of a unit
typedef struct
{
    ACCUMULATOR_FUNCTION pdf;
    ACCUMULATOR_FUNCTION lpdf;

    ACCUMULATOR_FUNCTION cdf;
    ACCUMULATOR_FUNCTION lcdf;

    ACCUMULATOR_FUNCTION sf; // Survival function
    ACCUMULATOR_FUNCTION lsf;
} ACCUMULATOR;

typedef struct
{
    double *t;
    double *a;
    double *u;
    double *theta; // Theta
    
    int nt; // Number of data point
    int np; // Number of parameters

} ANTIS_INPUT;

// Parameters type

typedef struct
{
    double t0; // No decision time
    double p0; // Probability of a non decision action

    double kp;
    double tp;
    double ka;
    double ta;
    double ks;
    double ts;

    double da;

    double cumint; // Current value of the cumulative integral.

} PROSA_PARAMETERS;

typedef struct
{
    double t0;
    double p0;

    double kp;
    double tp;
    double ka;
    double ta;
    double ks;
    double ts;
    
    double pp;
    double ap; 
    
    double da;

    double cumint; // Current value of the cumulative integral.
    
} SERI_PARAMETERS;

#define CUMINT_NO_INIT -1

// Double race model
typedef struct
{
    double t0;
    double p0;

    double kp; // Early prossacades
    double tp; // Late prosaccades
    double ka; // Voluntary antisaccade
    double ta; 
    double kl; // Involuntary prosaccade
    double tl;
    double ks; // Stop
    double ts;  
    double da;

    double cumint; // Current value of the cumulative integral.
    
    ACCUMULATOR early;
    ACCUMULATOR stop;
    ACCUMULATOR anti;
    ACCUMULATOR late;

    NESTED_INTEGRAL inhibition_race; 

} DORA_PARAMETERS;

// Likelihood typedef functions

typedef double (*PROSA_LLH)(double t, int a, const PROSA_PARAMETERS params); 

typedef double (*SERI_LLH)(double t, int a, const SERI_PARAMETERS params); 

typedef double (*DORA_LLH)(double t, int a, const DORA_PARAMETERS params); 
<<<<<<< HEAD

// Reparametrization of a function

typedef int (*FILL_PARAMETERS_PROSA)(const double *theta, PROSA_PARAMETERS 
        *parameters);
typedef int (*FILL_PARAMETERS_SERI)(const double *theta, SERI_PARAMETERS 
        *parameters);
typedef int (*FILL_PARAMETERS_DORA)(const double *theta, DORA_PARAMETERS 
        *parameters);


// Place holder for the function arguments

typedef struct
{
    FILL_PARAMETERS_PROSA fill_parameters;
    PROSA_LLH llh;
    NESTED_INTEGRAL nested_integral; // For optimization reasons.
} PROSA_MODEL;

typedef struct
{
    FILL_PARAMETERS_SERI fill_parameters;
    SERI_LLH llh;
    NESTED_INTEGRAL nested_integral; // For optimization reasons.
} SERI_MODEL;

typedef struct
{
    FILL_PARAMETERS_DORA fill_parameters;
    DORA_LLH llh;
    NESTED_INTEGRAL nested_integral; // For optimization reasons.
} DORA_MODEL;
=======
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

// Reparametrization of a function

typedef int (*FILL_PARAMETERS_PROSA)(const double *theta, PROSA_PARAMETERS 
        *parameters);
typedef int (*FILL_PARAMETERS_SERI)(const double *theta, SERI_PARAMETERS 
        *parameters);
typedef int (*FILL_PARAMETERS_DORA)(const double *theta, DORA_PARAMETERS 
        *parameters);


// Place holder for the function arguments

typedef struct
{
    FILL_PARAMETERS_PROSA fill_parameters;
    PROSA_LLH llh;
    NESTED_INTEGRAL nested_integral; // For optimization reasons.
} PROSA_MODEL;

typedef struct
{
    FILL_PARAMETERS_SERI fill_parameters;
    SERI_LLH llh;
    NESTED_INTEGRAL nested_integral; // For optimization reasons.
} SERI_MODEL;

typedef struct
{
    FILL_PARAMETERS_DORA fill_parameters;
    DORA_LLH llh;
    NESTED_INTEGRAL nested_integral; // For optimization reasons.
} DORA_MODEL;

// Other numerical

double
lcosh(double x);
// Logarithm of cosine hyperbolicus of x. Behaves better for large abs(x)

// Populate parameters
int
populate_parameters_prosa(const double *theta, PROSA_PARAMETERS *stheta);
// Populate the DORA parametes using teh array theta, where theta is required
// to have 11 parameters 
// theta        -- Array of parameters
// stheta       -- Structure to be populated

int
populate_parameters_seri(const double *theta, SERI_PARAMETERS *stheta);
// Populate the SERI parametes using teh array theta, where theta is required
// to have 11 parameters 
// theta        -- Array of parameters
// stheta       -- Structure to be populated

int
populate_parameters_dora(const double *theta, DORA_PARAMETERS *stheta);
// Populate the DORA parametes using teh array theta, where theta is required
// to have 11 parameters 
// theta        -- Array of parameters
// stheta       -- Structure to be populated


// Likelihoods: Compute the likelihood of a single trial

// Prosa model

double
prosa_llh_gamma(double t, int a, PROSA_PARAMETERS params);

double
prosa_llh_invgamma(double t, int a, PROSA_PARAMETERS params);

double
prosa_llh_mixedgamma(double t, int a, PROSA_PARAMETERS params);

double
prosa_llh_lognorm(double t, int a, PROSA_PARAMETERS params);

double
prosa_llh_later(double t, int a, PROSA_PARAMETERS params);

double
prosa_llh_wald(double t, int a, PROSA_PARAMETERS params);

// Seri model

double
seri_llh_gamma(double t, int a, SERI_PARAMETERS params);

double
seri_llh_invgamma(double t, int a, SERI_PARAMETERS params);

double
seri_llh_invgamma_optimized(double t, int a, SERI_PARAMETERS params);

double
seri_llh_mixedgamma(double t, int a, SERI_PARAMETERS params);

double
seri_llh_lognorm(double t, int a, SERI_PARAMETERS params);

double
seri_llh_later(double t, int a, SERI_PARAMETERS params);

double
seri_llh_wald(double t, int a, SERI_PARAMETERS params);

// Dora model

double
dora_llh_gamma(double t, int a, DORA_PARAMETERS params);

double
dora_llh_invgamma(double t, int a, DORA_PARAMETERS params);

double
dora_llh_mixedgamma(double t, int a, DORA_PARAMETERS params);

//TODO
double
dora_llh_lognorm(double t, int a, DORA_PARAMETERS params);

//TODO
double
dora_llh_later(double t, int a, DORA_PARAMETERS params);

//TODO
double
dora_llh_wald(double t, int a, DORA_PARAMETERS params);

// Models

// Computation of the likelihood in parallel assuming a differnt set of 
// parameters for each trial.
// svals    -- Input to the likelihoods
// fllh     -- Function for the trial wise likelihood
// llh      -- Double array of the size svals.np. 


int
prosa_model_trial_by_trial(ANTIS_INPUT svals, PROSA_MODEL model, double *llh);
<<<<<<< HEAD

int
prosa_model_two_states(ANTIS_INPUT svals, PROSA_MODEL model, double *llh);

int
prosa_model_two_states_optimized(ANTIS_INPUT svals, PROSA_MODEL model,
       double *llh);

int
dora_model_trial_by_trial(ANTIS_INPUT svals, DORA_MODEL model, double *llh);

int
dora_model_two_states(ANTIS_INPUT svals, DORA_MODEL model, double *llh);

int
dora_model_two_states_optimized(ANTIS_INPUT svals, DORA_MODEL model, 
        double *llh);

int
seri_model_trial_by_trial(ANTIS_INPUT svals, SERI_MODEL model, double *llh);

int
seri_model_two_states(ANTIS_INPUT svals, SERI_MODEL model, double *llh);

int
=======

int
prosa_model_two_states(ANTIS_INPUT svals, PROSA_MODEL model, double *llh);

int
prosa_model_two_states_optimized(ANTIS_INPUT svals, PROSA_MODEL model,
       double *llh);

int
dora_model_trial_by_trial(ANTIS_INPUT svals, DORA_MODEL model, double *llh);

int
dora_model_two_states(ANTIS_INPUT svals, DORA_MODEL model, double *llh);

int
dora_model_two_states_optimized(ANTIS_INPUT svals, DORA_MODEL model, 
        double *llh);

int
seri_model_trial_by_trial(ANTIS_INPUT svals, SERI_MODEL model, double *llh);

int
seri_model_two_states(ANTIS_INPUT svals, SERI_MODEL model, double *llh);

int
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
seri_model_two_states_optimized(ANTIS_INPUT svals, SERI_MODEL model, 
        double *llh);

// Numericals

double gamma_lpdf(double x, double k, double t);
// Gamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double gamma_cdf(double x, double k, double t);
// Gamma cdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double gamma_lcdf(double x, double k, double t);
// Gamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double gamma_sf(double x, double k, double t);
// Gamma survival function
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double gamma_lsf(double x, double k, double t);
// Gamma log survival fuction
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double invgamma_lpdf(double x, double k, double t);
// Invgamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double invgamma_cdf(double x, double k, double t);
// Invgamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double invgamma_lcdf(double x, double k, double t);
// Invgamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double invgamma_sf(double x, double k, double t);
// Invgamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double invgamma_lsf(double x, double k, double t);
// Invgamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.


double lognorm_lpdf(double x, double mu, double sigma);
// Invgamma log pdf
// x        Time.
// k        Shape parameter.
// t        Scale parameter.

double lognorm_cdf(double x, double mu, double sigma);
// Pdf of the lognorm likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double lognorm_lcdf(double x, double mu, double sigma);
// Pdf of the lognorm likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double lognorm_sf(double x, double mu, double sigma);
// Pdf of the lognorm likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double lognorm_lsf(double x, double mu, double sigma);
// Pdf of the lognorm likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double later_lpdf(double x, double mu, double sigma);
// Log pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double later_pdf(double x, double mu, double sigma);
// Pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double later_cdf(double x, double mu, double sigma);
// Pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double later_lcdf(double x, double mu, double sigma);
// Pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double later_sf(double x, double mu, double sigma);
// Pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double later_lsf(double x, double mu, double sigma);
// Pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian



double wald_lpdf(double x, double mu, double sigma);
// Log pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Wald distribution
// sigma    Scale of the corresponding sigma parameter

// Probability density functions

<<<<<<< HEAD
=======

double wald_pdf(double x, double mu, double lambda);
// Pdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204

double wald_cdf(double x, double mu, double sigma);
// cdf of the wald likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double wald_sf(double x, double mu, double sigma);
// Survival function of the wald likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double wald_lsf(double x, double mu, double sigma);
// Survival function of the wald likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

<<<<<<< HEAD
=======

>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
// Cumulative density functions

double later_cdf(double x, double mu, double sigma);
// cdf of the later likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double later_sf(double x, double mu, double sigma);
// Survival function (1-cdf) of the later likelihood
<<<<<<< HEAD
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian


double wald_cdf(double x, double mu, double sigma);
// cdf of the wald likelihood
=======
>>>>>>> b35fcea53cd6cb9f150a09e1dea997b64bffe204
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian

double wald_sf(double x, double mu, double sigma);
// Survival function of the wald likelihood
// x        Time
// mu       Location parameter of the corresponding Gaussian
// sigma    Scale of the corresponding Gaussian


double ngamma(double x, double a, double b, double c0, double c1);
// Unnormalized nested incomplete gamma function.
// x    -- Integration boundary
// a    -- Parameters of the outer gamma function.
// b    -- Parameters of the inter gamma function.
// c0   -- Coefficient associated with a.
// c1   -- Coefficient associated with b.
//
// See Aponte et al. 2016

double ninvgamma(double x, double a, double b, double c0, double c1);
// Unnormalized nested incomplete gamma function.
// x    -- Integration boundary
// a    -- Parameters of the outer gamma function.
// b    -- Parameters of the inter gamma function.
// c0   -- Coefficient associated with a.
// c1   -- Coefficient associated with b.
//
// See Aponte et al. 2016


double ngamma_lexp(double x, double a, double b, double c0, double c1);
// Unnormalized nested incomplete gamma function.
// x    -- Integration boundary
// a    -- Parameters of the outer gamma function.
// b    -- Parameters of the inter gamma function.
// c0   -- Coefficient associated with a.
// c1   -- Coefficient associated with b.
//
// Slow but safe.

double ngamma_gslint(double t0, double x, double a, double b, double c0,
       double c1);
// Unnormalized nested incomplete gamma function.
// t0       -- Left boundary
// x        -- Integration boundary
// a        -- Parameters of the outer gamma function.
// b        -- Parameters of the inter gamma function.
// c0       -- Coefficient associated with a.
// c1       -- Coefficient associated with b.
//
// Uses gsl


double ninvgamma_gslint(double x0, double x1, double a, double b, double c0,
    double c1);
// Unnormalized nested incomplete gamma function.
// x0       -- Left integration boundary
// x1       -- right integration boundary
// a        -- Parameters of the outer gamma function.
// b        -- Parameters of the inter gamma function.
// c0       -- Coefficient associated with a.
// c1       -- Coefficient associated with b.
//
// Uses gls integrator.


double ninvgamma_lexp(double x, double a, double b, double c0, double c1);
// Unnormalized nested incomplete gamma function.
// x        -- Integration boundary
// a        -- Parameters of the outer gamma function.
// b        -- Parameters of the inter gamma function.
// c0       -- Coefficient associated with a.
// c1       -- Coefficient associated with b.
//
// Slow but safe.

double
nlognorm_gslint(double t0, double x, double mu1, double mu2, double sig1, 
        double sig2);
// Unnormalized nested incomplete gamma function.
// t0       -- Left bounday
// x        -- Integration boundary
// mu1      -- Location parameter of the outer lognormal function.
// mu2      -- Location parameter of the inner lognormal function.
// sig1     -- Scale parameter of the outer lognormal function.
// sig2     -- Scale parameter of the inner lognormal function.
//
// Uses gsldouble


double nlater_gslint(double t0, double x, double mu1, double mu2, double sig1,
       double sig2);
// Nested Integral for Gaussian Rates
// t0       -- Left boundary of integration 
// x        -- Right boundary of integration boundary
// mu1      -- Location parameter of the outer lognormal function.
// mu2      -- Location parameter of the inner lognormal function.
// sig1     -- Scale parameter of the outer lognormal function.
// sig2     -- Scale parameter of the inner lognormal function.
//
// Uses gsl

double nwald_gslint(double t0, double x, double mu1, double mu2, double sig1,
        double sig2);
// Nested Integral for Walt rt
// t0       -- Lower integration boundary
// x        -- Integration boundary
// mu1      -- Location parameter of the outer lognormal function.
// mu2      -- Location parameter of the inner lognormal function.
// sig1     -- Scale parameter of the outer lognormal function.
// sig2     -- Scale parameter of the inner lognormal function.
//
// Uses gsl


// Reparametrize

int
reparametrize_seri_gamma(const double *theta, SERI_PARAMETERS *stheta);

int
reparametrize_seri_invgamma(const double *theta, SERI_PARAMETERS *stheta);

int
reparametrize_seri_wald(const double *theta, SERI_PARAMETERS *stheta);

int
reparametrize_seri_mixedgamma(const double *theta, SERI_PARAMETERS *stheta);

int
reparametrize_seri_lognorm(const double *theta, SERI_PARAMETERS *stheta);

int
reparametrize_seri_later(const double *theta, SERI_PARAMETERS *stheta);

//

int
reparametrize_dora_gamma(const double *theta, DORA_PARAMETERS *stheta);

int
reparametrize_dora_invgamma(const double *theta, DORA_PARAMETERS *stheta);

int
reparametrize_dora_wald(const double *theta, DORA_PARAMETERS *stheta);

int
reparametrize_dora_mixedgamma(const double *theta, DORA_PARAMETERS *stheta);

int
reparametrize_dora_lognorm(const double *theta, DORA_PARAMETERS *stheta);

int
reparametrize_dora_later(const double *theta, DORA_PARAMETERS *stheta);

//

int
reparametrize_prosa_gamma(const double *theta, PROSA_PARAMETERS *stheta);

int
reparametrize_prosa_invgamma(const double *theta, PROSA_PARAMETERS *stheta);

int
reparametrize_prosa_wald(const double *theta, PROSA_PARAMETERS *stheta);

int
reparametrize_prosa_mixedgamma(const double *theta, PROSA_PARAMETERS *stheta);

int
reparametrize_prosa_lognorm(const double *theta, PROSA_PARAMETERS *stheta);

int
reparametrize_prosa_later(const double *theta, PROSA_PARAMETERS *stheta);



#endif
