addpath('~/Dropbox/Doctorate/tools/tapas/HGF');

ANALYSES= {'PRE_DBS';'POST_DBS'};
load all_patients

for k = 1:length(ANALYSES)
    ANALYSIS_NAME = ANALYSES{k};
    STATS_STRUCT = ['~/polybox/Projects/BreakspearCollab/results/' ANALYSIS_NAME '/stats_' ANALYSIS_NAME '.mat'];
    load(STATS_STRUCT);

    load ./game_trace.mat

    all_pars = {}
    converge_fail= [];
    for i = 1:length(stats{1}.labels)

        P = game_trace(1:length(stats{1}.data{i}.performance));

        final_idx = length(stats{1}.data{i}.performance);
        if strcmp(ANALYSIS_NAME,'PRE_DBS') && i == 28
            final_idx = 42;
        elseif strcmp(ANALYSIS_NAME,'PRE_DBS') && i == 25
            final_idx = 42;
        elseif strcmp(ANALYSIS_NAME,'PRE_DBS') && i == 16
            final_idx = 29;
        end
        
        % Continuous bet size response variable:
        u = double(stats{1}.data{i}.performance(1:final_idx));
        u = u';
        
        pars = tapas_fitModel([], u, 'tapas_hgf_config', 'tapas_bayes_optimal_config', 'tapas_quasinewton_optim_config');
        all_pars{i} = pars;

        out = regexp(stats{1}.labels(i),'\d*','Match');
        num = str2double(out{:});
        
        idx = find(all_patients == num);

        kappa(idx,k) = all_pars{i}.p_prc.ka;
        omega(idx,k) = all_pars{i}.p_prc.om(:,1);
        theta(idx,k) = all_pars{i}.p_prc.om(:,2);
        fe(idx,k) = all_pars{i}.optim.LME;
    end
end
save('~/polybox/Projects/BreakspearCollab/results/co_hgf_workspace','kappa','omega','theta','all_pars');
%% Plot Omega, Theta
figure(201);
for i = 1:length(all_patients)
    
    subplot(6,6,i)
    bar(omega(i,:));
    title(all_patients(i));
    
end

figure(202);
for i = 1:length(all_patients)
    
    subplot(6,6,i)
    bar(theta(i,:));
    title(all_patients(i));
    
end




