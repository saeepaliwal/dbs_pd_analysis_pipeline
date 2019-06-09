function test_recoverability

m_subjects = 50; 

for i = 1:m_subjects
    load(['pars_inversion_sim_chm_' sprintf('%d',i)])
    
    keyboard
end
