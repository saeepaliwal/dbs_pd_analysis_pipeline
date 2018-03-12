function reg_vals(reg, title,depvar)

fprintf('%s regressions: %s: R: %0.3f, F %0.3f (p=%0.3f)\n',title, depvar,reg.rsquare,...
    reg.fstat.f,reg.fstat.pval);
for i = 2:length(reg.beta)
    fprintf('B%d: %0.3f (t=%0.3f, p=%0.3f)\n',i, reg.beta(i),reg.tstat.t(i),...
        reg.tstat.pval(i));
end