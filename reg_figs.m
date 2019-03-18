function reg_figs(r,y,X,dep_var, indep_var)

X = (X-mean(X))./std(X);
num_figs = length(indep_var);
msize=800;
f = figure;
set(f,'Position',[50 50 900 250]);
hold on;
for i=1:size(X,2)
    subplot(1, num_figs,i);
    scatter(X(:,i), y, msize,'Marker','.')
    title(indep_var{i});
    ylabel(strrep(dep_var,'_',' '));
end

% fitline = [ones(size(X,1),1) X]*r.beta;
% plot(X(:,1),fitline);