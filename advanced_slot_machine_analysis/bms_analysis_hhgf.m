function [bms] = bms_results(stats)

for s = 1:length(stats)
    [FE_HH,FE_RW,llh_all,kappa_all,omega_all,theta_all,beta_all] = collect_model_info_TI(s, stats);
    
    bms{s}.FE_grid = [FE_HH FE_RW];
    bms{s}.llh = llh_all;
    bms{s}.kappa_all = kappa_all;
    bms{s}.omega_all = omega_all;
    bms{s}.theta_all = theta_all;
    bms{s}.beta_all = beta_all;  
    bms = BMS_analysis(bms,s,1);  
end
