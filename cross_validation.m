function cross_validation(stats,D)

%% Pre predicting max  change

for t=1:2
    X = [log(stats{1}.omega) log(stats{1}.theta) stats{1}.BDI'];
    y = stats{2}.BIS_MaxIncrease';
    
    
    for i = 1:100000
        residuals = [];
        if t ==1
            X(:, 2) = X(randperm(38), 3);
        elseif t == 2
            y = y(randperm(38));
        end
        for j = 1:38
            
            x_test = X(j,:);
            x_train = X;
            x_train(j,:)  = [];
            
            
            mean_X = mean(x_train,1);
            x_train  = [ones(37,1) x_train-repmat(mean_X,37,1)];
            
            x_test =  [1 X(j,:)-mean_X];
            
            y_test = y(j);
            
            y_train = y;
            y_train(j) = [];
            
            r.beta = regress(y_train,x_train);
            
            pred_y = x_test*r.beta;
            
            residuals(j) = (y_test-pred_y)^2;
        end
        sum_resid(i,t) = sum(residuals);
    end
end

X = [log(stats{1}.omega) log(stats{1}.theta) stats{1}.BDI'];
y = stats{2}.BIS_MaxIncrease';
for i = 1:38
    train_X = X;
    train_X(i,:) = [];
    
    mean_X = mean(train_X,1);
    train_X  = [ones(37,1) train_X-repmat(mean_X,37,1)];
    
    test_X =  [1 X(i,:)-mean_X];
    
    train_y = y;
    train_y(i) = [];
    test_y = y(i);
    
    r.beta = regress(train_y,train_X);
    cv_pred = test_X*r.beta;
    
    oos_cv(i) = (test_y - cv_pred)^2;
end
sum(oos_cv)


%% Plot pretty figure

gray =[0.4 0.4 0.4];
figure('Position',[50 50 750 650]);
subplot(2,1,1)
histogram(sum_resid(:,2),80,'EdgeColor','none','LineWidth',0.1);
ylim = get(gca,'Ylim');
hold on

patch_coords = [quantile(sum_resid(:,2),0.05) quantile(sum_resid(:,2),0.95) ...
    quantile(sum_resid(:,2),0.95) quantile(sum_resid(:,2),0.05)];

patch(patch_coords, [0 0 8000 8000], 'b','FaceAlpha',0.15,'EdgeColor','none')
plot(repmat(sum(oos_cv),8000,1),[1:8000],'Color','r','LineWidth',2)

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
ylim = get(gca,'Ylim');

patch_coords = [quantile(sum_resid(:,1),0.05) quantile(sum_resid(:,1),0.95) ...
    quantile(sum_resid(:,1),0.95) quantile(sum_resid(:,1),0.05)];

patch(patch_coords, [0 0 12000 12000], 'b','FaceAlpha',0.15,'EdgeColor','none')

plot(repmat(sum(oos_cv),12000,1),[1:12000],'Color','r','LineWidth',2)
xlabel('Sum squared error')
ylabel('No. Samples')
title('Cross validation, \vartheta');
purty_plot(1,[D.FIGURES_DIR 'cross_validation_histogram'],'tiff')



