function prior_variance_TI(D)

load stats_DoubleHGF_PRE_DBS
data{1} = stats{1};

load stats_DoubleHGF_POST_DBS
data{2} = stats{1};

for s = 1:2
    for r = 1:2
        hh = data{s}.hhgf_est{r};
        
        for m = 1:length(data{s}.labels)
            for i = 1:length(hh.samples_theta)
                if m ==1
                    prior_omega(i,r,s) = hh.samples_prior_theta{i}{1}.mu(1);
                    prior_theta(i,r,s) = hh.samples_prior_theta{i}{1}.mu(2);
                    if r==1
                        prior_beta(i,s) = hh.samples_prior_theta{i}{1}.mu(3);
                    end
                end
            end
            
            llh_avg = mean(hh.llh{1},3);
            llh_all(m,r,s) = trapz(hh.T(1,:),llh_avg(m,:));
        end
    end
end

%%
colors = [0 0 1 ; 1 0 0];
for s = 1:2
    f = figure(s);
    f.Position = [50 50 950 750];
    
    if s == 1
        time = 'Pre DBS:';
    else
        time = 'Post DBS:';
    end
    
    subplot(3,2,1);
    histogram(prior_omega(:,1,s),'FaceColor',colors(s,:))
    xlim([-20 -2])
    title([time ' prior on \omega, Std model'])
    ylabel('Samples')
    
    subplot(3,2,2);
    histogram(prior_omega(:,2,s),10,'FaceColor',colors(s,:))
    xlim([-20 -2])
    title([time ' prior on \omega, UD model'])
      ylabel('Samples')
    subplot(3,2,3);
    histogram(prior_theta(:,1,s),'FaceColor',colors(s,:))
    xlim([-15 -2])
    title([time ' prior on \vartheta, Std model'])
     ylabel('Samples')
    
    subplot(3,2,4);
    histogram(prior_theta(:,2,s),'FaceColor',colors(s,:))
    xlim([-15 -2])
    title([time ' prior on \vartheta, UD model'])
      ylabel('Samples')
    subplot(3,2,5);
    histogram(prior_beta(:,s),'FaceColor',colors(s,:))
    title([time ' prior on \beta, Std model'])
    ylabel('Samples')
    
    if s == 1
    purty_plot(s,[ D.FIGURES_DIR 'prior_variance_test_pre_dbs'],'tiff');
    else
    purty_plot(s,[ D.FIGURES_DIR 'prior_variance_test_post_dbs'],'tiff');
    end
     
     
end

%%

f =figure(3);
f.Position = [50 50 500 700];
for k = 1:2
    subplot(2,1,k)
    b = bar(llh_all(:,1,k)-llh_all(:,2,k));
    b.EdgeColor = 'none'; b.FaceAlpha = 0.9;
    if k == 1
        title('Pre DBS, Std-UD');
    elseif k == 2
        title('Post DBS, Std-UD');
    end
    ylabel('Evidence Differences')
    xlabel('Subjects')
end

purty_plot(3,[ D.FIGURES_DIR 'model_RFX_test'],'tiff');
%             idx = find(llh==max(llh));
%             kappa_all(m,r) = 1;
%             omega_all(m,r) = exp(pars_distro(idx(1),1));
%             theta_all(m,r) = exp(pars_distro(idx(1),2));
%             llh_avg = mean(hh.llh{1},3);
%             llh_all(m,r) = trapz(hh.T(1,:),llh_avg(m,:));
%             if r == 1
%                 beta_all(m,r) = exp(pars_distro(idx(1),3));
%             else
%                 beta_all(m,r) = 0;
%             end
%         end
%         FE_HH(r) = hh.fe;
%     end
% end
