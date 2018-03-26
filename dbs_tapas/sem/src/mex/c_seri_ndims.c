/* aponteeduardo@gmail.com */
/* copyright (C) 2015 */

// Returns the codes of the pro and the antisaccades.

#include "antisaccades.h"

void
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *arr;

    if ( nlhs != 1 )
        mexErrMsgIdAndTxt("tapas:sem:codes", "Only one argument supported.");

    if ( nrhs > 0 )
        mexErrMsgIdAndTxt("tapas:sem:codes", "No arguments supported.");
  
 
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    arr = mxGetPr(plhs[0]);

    arr[0] = (double ) DIM_SERI_THETA;

}
