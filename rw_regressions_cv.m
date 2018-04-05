function rw_regressions_cv(stats)

%% Pull out RW parameters
subject_type = 1; % Pre-DBS parameters
hh = stats{subject_type}.rw_est;
for m = 1:length(stats{subject_type}.labels)
    clear pars_distro llh
    for i = 1:length(hh.samples_theta)
        pars_distro(i,:) = hh.samples_theta{i}{m};
        llh(i) = hh.llh{1}(m,end,i);
    end
    idx = find(llh==max(llh));
    alpha_param(m,1) = exp(pars_distro(idx(1),1));
    beta_param(m,1) = exp(pars_distro(idx(1),2));
    
    llh_avg = mean(hh.llh{1},3);
    llh_all(m,1) = trapz(hh.T(1,:),llh_avg(m,:));
end

 
%% Pre predicting max  change
fprintf('\n%s\n\n','PRE-DBS predicting max diff');
depvar = {'omega';'theta';'beta'};
fields = {'BIS_MaxIncrease'};
X = [log(alpha_param) log(beta_param) stats{1}.BDI']; 
stage = 'Param Pre';
for f = 1:length(fields)
    y = stats{1}.(fields{f}); % It's the same in stats{1} and stats{2}
    r = regstats(y,X,'linear');
    r.y = y;
    r.X = X;
    reg_vals(r,'Pre predicting post',fields{f});
end
keyboard

nice_colors

%% Shuffled model SSE
for t = 1
    X = [log(alpha_param) log(beta_param) stats{1}.BDI'];
    y = stats{2}.BIS_MaxIncrease';
    
    
    for i = 1:100000
        residuals = [];
%         if t == 1
% 
%             X(:, 2) = X(randperm(38), 2);
% 
%         elseif t == 2
%             y = y(randperm(38)); 
%         end

        y = y(randperm(38)); 
        
        for j = 1:38
            
            x_test = X(j, :);
            x_train = X;
            x_train(j,:)  = [];
            
            
            mean_X = mean(x_train, 1);
            x_train  = [ones(37,1) (x_train - repmat(mean_X,37,1))];
            
            x_test =  [1 (X(j,:) - mean_X)];
            
            y_test = y(j);
            
            y_train = y;
            y_train(j) = [];
            
            r.beta = regress(y_train, x_train);
            
            pred_y = x_test * r.beta;
            
            residuals(j) = (y_test - pred_y)^2;
        end
        sum_resid(i, t) = sum(residuals);
    end
end

%% True model SSE OOS
X = [log(alpha_param) log(beta_param) stats{1}.BDI'];
y = stats{2}.BIS_MaxIncrease';

for i = 1:38
    train_X = X;
    train_X(i,:) = [];
    
    mean_X = mean(train_X, 1);
    train_X  = [ones(37,1) (train_X - repmat(mean_X, 37, 1))];
    
    test_X =  [1 (X(i,:) - mean_X)];
    
    train_y = y;
    train_y(i) = [];
    test_y = y(i);
    
    r.beta = regress(train_y, train_X);
    cv_pred = test_X * r.beta;
    
    y_pred(i) = cv_pred;
    
    oos_cv(i) = (test_y - cv_pred)^2;
end


%% Get p-values of distributions
predictive_residuals = sum(oos_cv);

permutation_test = {'whole model'};

for i = 1
    fprintf('Permutation test: %s\n', permutation_test{i});
    fprintf(['Predicted residual %0.05f \n p_value: %0.05f \nquantiles'...'
        '\n\t90:%0.5f\n\t95:%0.05f\n\t99:%0.05f\n'], ...
        predictive_residuals, ...
        1.0 - sum(predictive_residuals < sum_resid(:, i)) / size(sum_resid, 1), ...
        quantile(sum_resid(:, i), 1.0 - 0.9), ...
        quantile(sum_resid(:, i), 1.0 - 0.95), ...
        quantile(sum_resid(:, i), 1.0 - 0.99));
end

%% Figure 5: Plot cross validation figure

gray =[0.4 0.4 0.4];
N = 9000;
f = figure(1)
set(f,'Position',[50 50 750 650]);

histogram(sum_resid(:,1),80,'EdgeColor','none','LineWidth',0.1);
ylim([0 N]);
xlim([1000 2500]);
hold on

patch_coords = [quantile(sum_resid(:,1),0.05) quantile(sum_resid(:,1),0.95) ...
    quantile(sum_resid(:,1),0.95) quantile(sum_resid(:,1),0.05)];

patch(patch_coords, [0 0 N N], 'b','FaceAlpha',0.15,'EdgeColor','none')
plot(repmat(sum(oos_cv),N,1),[1:N],'Color','r','LineWidth',2)

xlabel('Sum squared error')
ylabel('No. Samples')
title('Cross validation, full model');
[N1, edges1] = histcounts(sum_resid(:,1),5000);
P1 = N1/sum(N1);
idx1 = max(find(edges1<=sum(oos_cv)));
pval_full_model = P1(idx1);

% subplot(2,1,2)
% histogram(sum_resid(:,1),80,'EdgeColor','none','LineWidth',0.1);
% hold on
% %ylim = get(gca,'Ylim');
% ylim([0 16000])
% patch_coords = [quantile(sum_resid(:,1),0.05) quantile(sum_resid(:,1),0.95) ...
%     quantile(sum_resid(:,1),0.95) quantile(sum_resid(:,1),0.05)];
% 
% patch(patch_coords, [0 0 16000 16000], 'b','FaceAlpha',0.15,'EdgeColor','none')
% 
% plot(repmat(sum(oos_cv),16000,1),[1:16000],'Color','r','LineWidth',2)
% xlabel('Sum squared error')
% ylabel('No. Samples')
% title('Cross validation, \vartheta');
% xlim([1000 2500]);
purty_plot(1,[D.FIGURES_DIR 'rw_cross_validation_histogram'],'tiff')


