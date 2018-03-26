function [llh] = tapas_dcm_fmri_llh(data, theta, ptheta)
%% Compute the likelihood function of a model.
%
% Input
%       
% Output
%       

% aponteeduardo@gmail.com
% copyright (C) 2016
%

y = data.y;
u = data.u;
theta = tapas_mpdcm_fmri_set_parameters(theta.y, ptheta.theta0, ptheta);
ny = tapas_mpdcm_fmri_int(u, theta, ptheta);

llh = tapas_mpdcm_fmri_llh(y, u, theta, ptheta, ny);


end

