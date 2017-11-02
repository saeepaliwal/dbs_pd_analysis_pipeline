function stats = run_all_models_HHGF(stats, subject_type,P)
% Double HGF on response models
resp_models = {'tapas_softmax_binary'; 'tapas_softmax_binary_invsig2'};

stats = run_hhgf(subject_type,resp_models,stats,P);
stats{subject_type}.response_models = resp_models;

