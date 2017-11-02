% This is the workflow for all tables/statistics/figures in the gambling
% Variables you will need to specify in your workspace:
%       1. ANALYSIS_NAME := what you would like to call your analysis
%
%       2. LIST_OF_SUBJECT_DIRECTORIES := where your subject-specific raw data
%       is stored (also please make sure this ends in a slash)
%
%       3. PATH_TO_RESULTS_FOLDER := where you would like to store your
%       results that do not contain sensitive patient data
%       (again, please make sure this ends in a slash)
%
% Optional additions:
%
%       4. QUESTIONNAIRE_STRUCT := full path to questionnaire struct
% If your raw data has already been processed into a struct, you must speficy
%       5. STATS_STRUCT := full path to stats struct
%
% Finally, if you want to run the winning model from Paliwal, Petzschner et
% al, set:
%
%       6. PAPER = 1;
%
% The questionnaire struct is subject-specific questionnaire values
% The questionnaire struct must have a labels field, which should be the same
% as the stats{subject_type}.labels field, to ensure subject-to-questionnaire matching
% If you want to only run the winning model from the paper, set the PAPER flag to 1

% Make the results folder if it does not exist
if ~exist(PATH_TO_RESULTS_FOLDER)
    mkdir(PATH_TO_RESULTS_FOLDER);
end

%% Reproduce best model from paper

% Specify which steps (as labelled) need to be done:
% 1 is done, 0 is to be done
done(1) = 1;
done(2) = 0;
done(3) = 1;
done(4) = 1;
done(5) = 1;
done(6) = 1;
done(7) = 1;
done(8) = 1;

% Specify the following variables in your matlab environment
analysis_name = ANALYSIS_NAME;
results_dir = PATH_TO_RESULTS_FOLDER;

if ~exist('STATS_STRUCT')
    if ~iscell(LIST_OF_SUBJECT_DIRECTORIES)
        subject_dir = {LIST_OF_SUBJECT_DIRECTORIES};
    else
        subject_dir = LIST_OF_SUBJECT_DIRECTORIES;
    end
    
    subject_type = 1:length(subject_dir);
else
    stats_struct = STATS_STRUCT;
    load(stats_struct);
    subject_type = length(stats);
end

% Pull in final game trace
load game_trace.mat

%% Step 1: Pull behavioral information and run behavioral ANOVAs
% N.B: stats struct has the following structure: stats{subject_type}.fields
if ~done(1)
    if ~exist('STATS_STRUCT')
        
        stats = {};
        for i = 1:length(subject_dir)
            stats{i} = output2mat(subject_dir{i})
        end
    end
    if exist('QUESTIONNAIRE_STRUCT')
        questionnaire_struct = QUESTIONNAIRE_STRUCT;
        qval = load(QUESTIONNAIRE_STRUCT);
        tmp = fieldnames(qval);
        qline = ['getfield(qval,''' sprintf('%s',tmp{:}) ''')'];
        qstruct = eval(qline);
        for j = 1:length(subject_type)
            if length(qstruct)< j
                continue;
            else
                if sum(strcmp(stats{j}.labels, qstruct{j}.labels) == 0)>0
                    error('Labels don''t match up! Check your label order. Remember that all data must be re-orderd as well.');
                else
                    names = fieldnames(qstruct)
                    for f = 1:length(names)
                        if strfind(names(i),'BIS');
                            bis_field = names(i);
                        end
                    end
                    if iscell(getfield(qstruct,bis_field))
                        stats{j}.BIS_Total = cell2mat(getfield(qstruct,bis_field));
                    else
                        stats{j}.BIS_Total = getfield(qstruct,bis_field);
                    end
                end
            end
        end
    end
    data_name = [results_dir 'stats_' analysis_name];
    save(data_name,'stats');
else
    load(stats_struct)
end


%% Step 2: Run all models:
if ~done(2)
    for g = subject_type
        if isfield(stats{g},'hgf')
            stats{g} = rmfield(stats{g},'hgf');
        end
        if isfield(stats{g},'rw')
            stats{g} = rmfield(stats{g},'rw');
        end
        if HHGF
            P = game_trace(1:length(stats{g}.data{1}.performance));
            stats = run_all_models(i,stats, subject_type(g), PAPER,P,HHGF);
            data_name = ['stats_DoubleHGF_' analysis_name];
            
        else
            for i = 1:length(stats{g}.labels)
                P = game_trace(1:length(stats{g}.data{i}.performance));
                stats = run_all_models(i,stats, subject_type(g), PAPER,P,HHGF);
            end
            data_name = ['stats_' analysis_name];
        end
    end
    save(data_name,'stats');
end



%% Step 3: Collect all model info
if ~done(3)

    if HHGF
        kappa_all = {};
        omega_all = {};
        theta_all = {};
        beta_all = {};

        s = 1;
        [binFEgrid,llh_all, kappa_all, omega_all, theta_all, beta_all] = collect_model_info_TI(s, stats);
        pars.kappa = kappa_all(:,2);
        pars.omega = omega_all(:,2);
        pars.theta = theta_all(:,2);
        pars.beta_all = beta_all(:,2);
        pars.FE = binFEgrid;
        
    else
        for s = subject_type
            [kappa_all,omega_all,theta_all,beta_all,binFEgrid] = collect_model_info(s,stats, PAPER);
            pars.kappa = kappa_all;
            pars.omega = omega_all;
            pars.theta = theta_all;
            pars.beta_all = beta_all;
            pars.FE = binFEgrid;
        end
    end
    

    if PAPER & ~HHGF
        parameter_workspace = [results_dir 'parameter_workspace_winning_' analysis_name];
    elseif HHGF
        parameter_workspace = [results_dir 'parameter_workspace_hhgf'];
    else
        parameter_workspace = [results_dir 'parameter_workspace'];
    end
    save(parameter_workspace,'pars');
end


%% Step 4: Run all BMS analysis
if ~done(4) & ~HHGF
    % Run model comparison
    
    BMS_analysis(results_dir,analysis_name,1);
    winningmodel = pick_best_pars(results_dir,analysis_name, subject_type, PAPER);
    winningmodel

end
%% Step 5: Run all regressions on best model pars
questionnaires_to_test = {'BIS_Total'};
if ~done(5)
    regs = {};
    for q = 1:length(questionnaires_to_test);
        questionnaire = questionnaires_to_test{q};
        regs{q} = all_regressions(printbeta,questionnaire,subject_type,stats, PAPER, parameter_workspace);
    end
    data_name = [results_dir 'regs_' analysis_name];
    save(data_name,'regs');
end
%% Step 6: Print all tables:

if ~done(6)
    printtable(analysis_name,printbeta);
end

%% Step 7: Print all figures from paper:

if ~done(7)
    all_figures
end

%% Step 8: Run a pdf of all tables

if ~done(7)
    !pdflatex alltables.tex
    !open -a Preview alltables.pdf
    copyfile('./alltables.pdf',[PATH_TO_RESULTS_FOLDER sprintf('%s',analysis_name) '/' sprintf('%s',analysis_name) '.pdf']);
end


