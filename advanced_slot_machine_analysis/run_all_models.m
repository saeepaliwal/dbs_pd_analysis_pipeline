 function stats = run_all_models(subject_num, stats, subject_type, PAPER,P, TI)

if PAPER
    all_vars = {'allswitch'};
else
    all_vars = {'bet_switch';'betupgam';'bugamcash';'allswitch'};
end


if TI
    run_num = 1;
    stats = run_hhgf(subject_type,run_num,'tapas_softmax_binary_invsig2',stats,P);
    
else
    
    for j = 1:length(all_vars)
        analysis_name = all_vars{j};
        resp_var = 4;
        if PAPER
            % Run models with beta = 1/sigma2
            run_num = 1;
            stats = run_hgf(subject_type,subject_num,run_num,resp_var,'tapas_softmax_binary_invsig2_config', stats,PAPER,P);
        else
            % Run models with constant beta
            run_num = 1;
            stats = run_hgf(subject_type,subject_num,run_num,resp_var,'tapas_softmax_binary_config', stats,PAPER,P);
            
            % Run models with beta = 1/sigma2
            run_num = 2;
            stats = run_hgf(subject_type,subject_num,run_num,resp_var,'tapas_softmax_binary_invsig2_config', stats,PAPER,P);
            
            % Run models with beta = 1/exp(mu3)
            run_num = 3;
            stats = run_hgf(subject_type,subject_num,run_num,resp_var,'tapas_softmax_binary_invexpmu3_config',stats,PAPER,P);
            
            % Run models with x = sigma1, beta = constant
            run_num = 4;
            stats = run_hgf(subject_type,subject_num,run_num,resp_var,'tapas_softmax_binary_sig1_config',stats,PAPER,P);
        end
    end
end