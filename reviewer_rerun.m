function reviewer_rerun(stats, param_type)


addpath(genpath('./advanced_slot_machine_analysis'));
addpath(genpath('./tools'));
addpath(genpath('./dbs_tapas/'));

if ~strcmp(param_type,'none')
    stats = get_model_parameters(stats, param_type)
end

for p  = {'omega','theta','beta'}

    for i = 1:2
        fprintf('%s%d: %0.3f (%0.3f, %0.3f-%0.3f)\n',p{:},i,mean(log(stats{i}.(p{:}))), ...
            std(log(stats{i}.(p{:}))),min(log(stats{i}.(p{:}))), max(log(stats{i}.(p{:}))))
    end
    [h, pval, ci, s] = ttest(log(stats{1}.(p{:})),log(stats{2}.(p{:})));
    fprintf('\nTtest %s: %0.3f (%0.3f)\n',p{:}, s.tstat,pval);

end

parameter_regressions(stats)


%plot_figure_4('./BIS_parameter_relatonships_Median', stats);