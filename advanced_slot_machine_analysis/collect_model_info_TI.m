function  [FE_HH, FE_RW, llh_all,kappa_all, omega_all, theta_all, beta_all] = collect_model_info_TI(subject_type,stats)

% Pull out DoubleHGF parameter estimates
% FE will be 1x3 and kappa, etc will be subjectsx3
runs = length(stats{subject_type}.hhgf_est);
for r = 1:runs
    hh = stats{subject_type}.hhgf_est{r};
    for m = 1:length(stats{subject_type}.labels)
        clear pars_distro llh
        for i = 1:length(hh.samples_theta)
            pars_distro(i,:) = hh.samples_theta{i}{m};
            llh(i) = hh.llh{1}(m,end,i);
        end
        idx = find(llh==max(llh));
        kappa_all(m,r) = 1;
        omega_all(m,r) = exp(pars_distro(idx(1),1));
        theta_all(m,r) = exp(pars_distro(idx(1),2));
        llh_avg = mean(hh.llh{1},3);
        llh_all(m,r) = trapz(hh.T(1,:),llh_avg(m,:));
        if r == 1
           beta_all(m,r) = exp(pars_distro(idx(1),3));
        else
           beta_all(m,r) = 0;
        end
    end
    FE_HH(r) = hh.fe;
end
clear llh
for m = 1:length(stats{subject_type}.labels)
    hh = stats{subject_type}.rw_est;
    for i = 1:length(hh.samples_theta)
        llh(i) = hh.llh{1}(m,end,i);
    end
    idx = find(llh==max(llh));
    llh_all(m,3) = llh(idx(1));
end


% Pull out RW FE
if isfield(stats{subject_type},'rw_est')
    FE_RW = stats{subject_type}.rw_est.fe;
else
    FE_RW = [];
end
