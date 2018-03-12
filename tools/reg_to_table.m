function reg_to_table(reg,depvar,indepvar, FILENAME, printheader)

if printheader == 1
    fid = fopen(FILENAME,'w');
else
    fid = fopen(FILENAME,'a');
end

labels = {''};
for i = 1:length(indepvar)
    labels{i+1} = [ indepvar{i} 'B(b)'];
end
labels{end+1} = 'R2';
labels{end+1} = 'F-stat (p-val)';

reg_string_1 = {depvar};
reg_string_2 = {''};
for i = 2:length(reg.beta)
    us_coeff = reg.beta(i)*std(reg.y)/std(reg.X(:,i-1));
    reg_string_1{i} = [sprintf('%0.3f (%0.3f)',us_coeff,reg.beta(i))];
end
reg_string_1{end+1} = sprintf('%0.3f',reg.rsquare);


reg_string_1{end+1} = [sprintf('%0.3f',reg.fstat.f) '(' sprintf('%0.3f',reg.fstat.pval) ')'];

if printheader == 1
    for i = 1:length(labels)-1
        fprintf(fid,'%s,',labels{i});
    end
    fprintf(fid,'%s\n',labels{end});
end

for i = 1:length(labels)-1
    fprintf(fid,'%s,',reg_string_1{i});
end
fprintf(fid,'%s\n',reg_string_1{end});

fclose(fid);