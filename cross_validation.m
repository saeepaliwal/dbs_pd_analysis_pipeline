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
    
    y_pred(i) = cv_pred;
    
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


%% R-square

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
    
    y_true(i) = test_y;
    y_pred(i) = cv_pred;
    
end

%% Correlation with ID function
r = regstats(y_pred',y_true)

y_pred([1 5]) = [];
y_true([1 5]) = [];
figure(401)
clf
h = scatter(y_true, y_pred,'ko');
hold on
h.SizeData = 70;
h.MarkerFaceColor = 'k';
h.MarkerFaceAlpha = 0.7;
sim_X = [ones(1,36); -15:20]';

corr(y_true',y_pred');
% sim_y = sum(repmat(r.beta',36,1).*sim_X,2);
% plot(sim_X(:,2),sim_y,'k','LineWidth',2);

plot(sim_X(:,2),0.28*sim_X(:,2)+2,'Color',red,'LineWidth',2)
yticks([-10 0 10]);
xticks([-10 0 10 20]);
xlabel('Max BIS increase');
ylabel('Out-of-sample prediction');
purty_plot(401,[D.FIGURES_DIR 'oos_ypred_corr'],'tiff');

%% Regression of y and y_pred

r = regstats(y_pred',y_true)

figure(406)
clf
h = scatter(y, y_pred,'ko');
hold on
h.SizeData = 70;
h.MarkerFaceColor = 'k';
h.MarkerFaceAlpha = 0.7;
sim_X = [ones(1,36); -15:20]';
sim_y = sum(repmat(r.beta',36,1).*sim_X,2);
plot(sim_X(:,2),sim_y,'k','LineWidth',2);

yticks([-10 0 10]);
xticks([-10 0 10 20]);
xlabel('Max BIS increase');
ylabel('Out-of-sample prediction');
purty_plot(406,[D.FIGURES_DIR 'oos_ypred_reg'],'tiff');

%%
X = [log(stats{1}.omega) log(stats{1}.theta)];
y = stats{2}.BIS_MaxIncrease';
r = regstats(y,X,'linear');

figure(401)
clf
h = scatter3(X(:,1), X(:,2),y,'bo')
h.SizeData = 70;
h.MarkerFaceColor = 'b';
h.MarkerFaceAlpha = 0.7;
xlabel('\omega','FontSize',20,'FontWeight','bold')
ylabel('\vartheta','FontSize',20,'FontWeight','bold')
zlabel('Max BIS Increase','FontSize',20,'FontWeight','bold')
hold on
sim_X = [ones(1,36);  -30:0.8:-2 ;-15:0.4:-1]'
sim_y = sum(repmat(r.beta',36,1).*sim_X,2);
line(sim_X(:,2),sim_X(:,3),sim_y,'Color',red,'LineWidth',2);

%% Just BIS and theta

X = log(stats{1}.theta);
y = stats{2}.BIS_MaxIncrease';
r = regstats(y,X,'linear');

figure(402)
clf
h = scatter(X,y,'bo');
hold on
h.SizeData = 70;
h.MarkerFaceColor = 'b';
h.MarkerFaceAlpha = 0.7;
sim_X = [ones(1,25); -14:0.5:-2]';
sim_Y = sum(repmat(r.beta',25,1).*sim_X,2);
plot(sim_X(:,2),sim_Y,'k','LineWidth',2);
xticks([-14 -10 -6 -2])
yticks([-10 0 10 20])
xlim([-15 -1])
xlabel('\vartheta','FontSize',20,'FontWeight','bold')
ylabel('Max BIS Increase','FontSize',20,'FontWeight','bold')
purty_plot(402,[D.FIGURES_DIR 'bis_vartheta'],'tiff');

%% Marginal BIS and theta
X = [log(stats{1}.omega)  stats{1}.BDI'];
y = stats{2}.BIS_MaxIncrease';

r1 = regstats(y,X,'linear');


X2 = log(stats{1}.theta);
y2 = r1.r;
r2 = regstats(y2,X2,'linear');

%
figure(403)
clf
h = scatter(X2,y2,'ro');
hold on
h.SizeData = 70;
h.MarkerFaceColor = 'r';
h.MarkerFaceAlpha = 0.7;
sim_X =  [ones(1,25); -14:0.5:-2]';
sim_Y = sum(repmat(r2.beta',25,1).*sim_X,2);
plot(sim_X(:,2),sim_Y,'k','LineWidth',2);
xlim([-15 -1])
xticks([-14 -10 -6 -2])
yticks([-10 0 10 20])
xlabel('\vartheta','FontSize',20,'FontWeight','bold')
ylabel('Marginal max BIS Increase','FontSize',20,'FontWeight','bold')
purty_plot(403,[D.FIGURES_DIR 'bis_vartheta_marginal'],'tiff');

%% Without 5

% Just BIS and theta

X = log(stats{1}.theta);
X(5,:) = [];
y = stats{2}.BIS_MaxIncrease';
y(5) = [];
r = regstats(y,X,'linear');
r.fstat.f
r.fstat.pval
r.rsquare

figure(404)
clf
h = scatter(X,y,'bo');
hold on
h.SizeData = 70;
h.MarkerFaceColor = 'b';
h.MarkerFaceAlpha = 0.7;
sim_X = [ones(1,17); -10:0.5:-2]';
sim_Y = sum(repmat(r.beta',17,1).*sim_X,2);
plot(sim_X(:,2),sim_Y,'k','LineWidth',2);
xticks([-10 -6 -4 -2])
yticks([-10 0 10 20])
xlim([-11 -1])
xlabel('\vartheta','FontSize',20,'FontWeight','bold')
ylabel('Max BIS Increase','FontSize',20,'FontWeight','bold')
purty_plot(404,[D.FIGURES_DIR 'bis_vartheta_no5'],'tiff');

%%
X = [log(stats{1}.omega)  stats{1}.BDI'];
y = stats{2}.BIS_MaxIncrease';
X(5,:) = [];
y(5) = [];

r1 = regstats(y,X,'linear');


X2 = log(stats{1}.theta);
X2(5,:) = [];
y2 = r1.r;
r2 = regstats(y2,X2,'linear');

r2.fstat.f
r2.fstat.pval
r2.rsquare

%
figure(405)
clf
h = scatter(X2,y2,'ro');
hold on
h.SizeData = 70;
h.MarkerFaceColor = 'r';
h.MarkerFaceAlpha = 0.7;
sim_X =  [ones(1,17); -10:0.5:-2]';
sim_Y = sum(repmat(r2.beta',17,1).*sim_X,2);
plot(sim_X(:,2),sim_Y,'k','LineWidth',2);
xticks([-10 -6 -4 -2])
yticks([-10 0 10 20])
xlim([-11 -1])
xlabel('\vartheta','FontSize',20,'FontWeight','bold')
ylabel('Marginal max BIS Increase','FontSize',20,'FontWeight','bold')
purty_plot(405,[D.FIGURES_DIR 'bis_vartheta_marginal_no5'],'tiff');






