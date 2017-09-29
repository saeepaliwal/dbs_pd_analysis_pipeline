function reg_vals(reg)

for i = 2:length(reg.beta)
display(sprintf('%0.4f (%0.4f (%0.4f))',reg.beta(i), reg.tstat.t(i),reg.tstat.pval(i)));
end

%display(sprintf('%0.4f (%0.4f (%0.4f))',reg.beta(3), reg.tstat.t(3), reg.tstat.pval(3)));

display(reg.rsquare);


display(sprintf('%0.4f (%0.4f)',reg.fstat.f, reg.fstat.pval));
