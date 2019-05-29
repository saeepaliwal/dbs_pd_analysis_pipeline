function cross_validation(stats)
nice_colors

N_sub = length(stats{1}.labels);
%% Pre predicting max  change
for t = 1:2
    X = [stats{1}.omega stats{1}.beta];
    y = stats{2}.BIS_MaxIncrease';


    for i = 1:10000

        if mod(i,1000)==0
            fprintf('Iteration: %d\n',i);
        end
        residuals = [];
        if t == 1
            
            X(:, 1) = X(randperm(N_sub), 1);

        elseif t == 2
            y = y(randperm(N_sub));
        end
        for j = 1:N_sub

            x_test = X(j, :);
            x_train = X;
            x_train(j,:)  = [];


            mean_X = mean(x_train, 1);
            x_train  = [ones(N_sub-1,1) (x_train - repmat(mean_X,N_sub-1,1))];
            
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


X = [stats{1}.omega stats{1}.beta];
y = stats{2}.BIS_MaxIncrease';

for i = 1:N_sub
    train_X = X;
    train_X(i,:) = [];

    mean_X = mean(train_X, 1);
    train_X  = [ones(N_sub-1,1) (train_X - repmat(mean_X, N_sub-1, 1))];

    test_X =  [1 (X(i,:) - mean_X)];

    train_y = y;
    train_y(i) = [];
    test_y = y(i);

    r.beta = regress(train_y, train_X);
    cv_pred = test_X * r.beta;

    y_pred(i) = cv_pred;

    oos_cv(i) = (test_y - cv_pred)^2;
end
save cv_workspace

%% Get p-values of distributions
predictive_residuals = sum(oos_cv);

permutation_test = {'omega', 'whole model'};

for i = 1:2
    fprintf('Permutation test: %s\n', permutation_test{i});
    fprintf(...
        ['Predicted residual %0.05f quantile: %0.05f \n' ...
        'quantiles \t90:%0.5f\n' ...
        '          \t95:%0.05f\n' ...
        '          \t99:%0.05f\n'], predictive_residuals, ...
        1.0 - sum(predictive_residuals < sum_resid(:, i)) / ...
            size(sum_resid, 1), ...
        quantile(sum_resid(:, i), 1.0 - 0.9), ...
        quantile(sum_resid(:, i), 1.0 - 0.95), ...
        quantile(sum_resid(:, i), 1.0 - 0.99));
end

%% Figure 5: Plot cross validation figure
patch_dim_1 = 1000;
patch_dim_2 = 1200;
gray =[0.4 0.4 0.4];
f = figure(1);
clf
set(f,'Position',[50 50 750 650]);
subplot(2,1,1)
histogram(sum_resid(:,2),80,'EdgeColor','none','LineWidth',0.1);
%ylim([0 8000]);
%xlim([1000 2500]);
hold on

patch_coords = [quantile(sum_resid(:,2),0.05) quantile(sum_resid(:,2),0.95) ...
    quantile(sum_resid(:,2),0.95) quantile(sum_resid(:,2),0.05)];

patch(patch_coords, [0 0 patch_dim_1 patch_dim_1], 'b','FaceAlpha',0.15,'EdgeColor','none')
plot(repmat(sum(oos_cv),patch_dim_1,1),[1:patch_dim_1],'Color','r','LineWidth',2)

xlabel('Sum squared error')
ylabel('No. Samples')
title('Cross validation, full model');
[N1, edges1] = histcounts(sum_resid(:,2),5000);
P1 = N1/sum(N1);
idx1 = max(find(edges1<=sum(oos_cv)));
pval_full_model = P1(idx1);

subplot(2,1,2)
histogram(sum_resid(:,1),80,'EdgeColor','none','LineWidth',0.1);
hold on
%ylim = get(gca,'Ylim');
%lylim([0 16000])
patch_coords = [quantile(sum_resid(:,1),0.05) quantile(sum_resid(:,1),0.95) ...
    quantile(sum_resid(:,1),0.95) quantile(sum_resid(:,1),0.05)];

patch(patch_coords, [0 0 patch_dim_2 patch_dim_2], 'b','FaceAlpha',0.15,'EdgeColor','none')

plot(repmat(sum(oos_cv),patch_dim_2,1),[1:patch_dim_2],'Color','r','LineWidth',2)
xlabel('Sum squared error')
ylabel('No. Samples')
title('Cross validation, \omega');
%xlim([1000 2500]);
%purty_plot(1,[D.FIGURES_DIR 'cross_validation_histogram'],'tiff')

