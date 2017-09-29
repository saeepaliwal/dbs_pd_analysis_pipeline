function BMS_analysis(results_dir,analysis_name, subject_type)
home = pwd;
cd(results_dir)
load('parameter_workspace.mat')
cd(home);

%% BMS analysis
%{
for i = percept
	allbinFE = squeeze(binFEgrid(i,:,:))';
	[allBMS{1},allBMS{2},allBMS{3}] = spm_BMS([allbinFE]);
end


%}

FE_grid = squeeze(pars.FE);
FE_grid = FE_grid';
[allBMS{1},allBMS{2},allBMS{3}] = spm_BMS(FE_grid);

save ([results_dir 'bms_results_' sprintf('%d',subject_type)], 'allBMS');