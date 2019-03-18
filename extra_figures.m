%{
%% Extra figures not in manuscript

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

figure(401)
clf
h = scatter(y_true, y_pred,'ko');
hold on
h.SizeData = 70;
h.MarkerFaceColor = 'k';
h.MarkerFaceAlpha = 0.7;
sim_X = [ones(1,36); -15:20]';

corr(y_true',y_pred');


plot(sim_X(:,2),0.28*sim_X(:,2)+2,'Color',red,'LineWidth',2)
yticks([-10 0 10]);
xticks([-10 0 10 20]);
xlabel('Max BIS increase');
ylabel('Out-of-sample prediction');
purty_plot(401,[D.FIGURES_DIR 'oos_ypred_corr'],'tiff');

%% Regression of y and y_pred

y_pred([1 5]) = [];
y_true([1 5]) = [];

if plot_flag
    figure(401)
    clf
    h = scatter(y_true, y_pred,'ko');
    hold on
    h.SizeData = 70;
    h.MarkerFaceColor = 'k';
    h.MarkerFaceAlpha = 0.7;
    sim_X = [ones(1,36); -15:20]';

    corr(y_true',y_pred');

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
end


figure(406)
clf
h = scatter(y, y_pred','ko');
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

if plot_flag
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
end
%% Just BIS and theta

X = log(stats{1}.theta);
y = stats{2}.BIS_MaxIncrease';
r = regstats(y,X,'linear');

if plot_flag
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
end
%% Marginal BIS and theta
X = [log(stats{1}.omega)  stats{1}.BDI'];
y = stats{2}.BIS_MaxIncrease';

r1 = regstats(y,X,'linear');


X2 = log(stats{1}.theta);
y2 = r1.r;
r2 = regstats(y2,X2,'linear');

if plot_flag
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
end
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

if plot_flag
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
end
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
if plot_flag
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
end
%}

