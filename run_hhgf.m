function stats = run_hhgf(stats, resp_models)
% Double HGF on response models

for iSubType = 1:length(stats)
    for r = 1:length(resp_models)
        resp_model = resp_models{r};
 
        if isfield(stats{iSubType},'hhgf_est')
            stats{iSubType} = rmfield(stats{iSubType},'hhgf_est');
        end
        if isfield(stats{iSubType},'rw_est')
            stats{iSubType} = rmfield(stats{iSubType},'rw_est');
        end
        
        %% Run perceptual variables
        num_subjects = length(stats{iSubType}.labels);
        
        fprintf('Now running hhgf using response model: %s on subject type %d\n',...
            resp_model, iSubType);
        
        which('tapas_h2gf_estimate')
        
        for i = 1:num_subjects
            % This constructs the binary response variable from performance
            y = construct_response_variable(iSubType, i,stats);
            subjects(i,1).y = y{:};
            
            % This constructs the binary perceptual variable from performance
            u = construct_perceptual_variable(iSubType, i, stats);
            subjects(i,1).u = u{:}(1:length(subjects(i,1).y));
            
            subjects(i,1).ign = [];
            subjects(i,1).irr = [];
        end
        
        % Set number of chains:
        nchains = 1;
        
        [hhgf, rw, pars, inference] = get_hhgf_settings(resp_model, nchains);
        
        % Get HHGF parameters
        if strcmp(resp_model,'tapas_softmax_binary') || strcmp(resp_model,'tapas_softmax_binary_invsig2')
            fprintf('Setting up hhgf run with nchains: %d\n',nchains);
            
            estimate = tapas_h2gf_estimate(subjects, hhgf, inference, pars);
            stats{iSubType}.hhgf_est{r} = estimate;
        elseif strcmp(resp_model,'rescorla_wagner')
            [rw, pars, inference] = get_rw_parameters(resp_model, nchains);
            estimate = tapas_h2gf_estimate(subjects, rw, inference, pars);
            stats{iSubType}.rw_est = estimate;
        end
        
        fprintf(1, '%s - Fe=%0.2f\n', resp_model, estimate.fe);
    end
    stats{iSubType}.response_models = resp_models;
end

for i = 1:length(stats{1}.labels)
    if ~strcmp(stats{1}.labels{i}(1:end-4), ...
            stats{2}.labels{i}(1:end-5))
        error('Labels are not aligned correctly!');
    end
end
