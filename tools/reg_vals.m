function reg_vals(reg, title,depvar, indepvar)

fprintf('\n\n%s regressions: %s: R: %0.3f, F %0.3f (p=%0.3f)\n',title, depvar,reg.rsquare,...
    reg.fstat.f,reg.fstat.pval);
for i = 2:length(reg.beta)
    fprintf('%s: %0.3f (t=%0.3f, p=%0.3f)\n',indepvar{i-1}, reg.beta(i),reg.tstat.t(i),...
        reg.tstat.pval(i));
end