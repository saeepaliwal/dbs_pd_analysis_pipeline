function reg_vals(reg, title,depvar, indepvars)

fprintf('%s regressions: %s: R: %0.3f, F(%d,%d)= %0.3f  (p=%0.3f)\n',title, depvar,reg.rsquare,...
    reg.fstat.dfr,reg.fstat.dfe,reg.fstat.f,reg.fstat.pval);
for i = 2:length(reg.beta)
    fprintf('%s: %0.3f (t(%d)=%0.3f, p=%0.3f)\n',indepvars{i-1}, reg.beta(i),reg.tstat.dfe,reg.tstat.t(i),...
        reg.tstat.pval(i));
end

