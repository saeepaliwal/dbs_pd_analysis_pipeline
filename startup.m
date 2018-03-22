function startup()
%% 
%
% Input
%
% Output
%

% aponteeduardo@gmail.com
% copyright (C) 2018
%

addpath('~/software/spm12')

home = pwd;
cd('./tapas/tapas/')
tapas_init();
cd(home)


addpath(genpath('./advanced_slot_machine_analysis'));
addpath(genpath('./tools'));



end
