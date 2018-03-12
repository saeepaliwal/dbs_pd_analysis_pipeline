function stats = BMS_analysis(stats, subject_type, TI)

if TI
    binFEgrid = stats{subject_type}.llh;
else
    binFEgrid = squeeze(stats{subject_type}.binFEgrid)';
end

[bms.alpha,bms.exp_r,bms.xp,bms.pxp,bms.bor] = spm_BMS(binFEgrid);

stats{subject_type}.bms_results = bms;