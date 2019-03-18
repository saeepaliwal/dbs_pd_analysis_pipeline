%% Before and after
figure(201)
subplot(3,2,1)
histogram(stats{1}.omega,10);
hold on
histogram(stats{2}.omega,10);
title('\omega')

subplot(3,2,2)
histogram(stats{1}.beta,10);
hold on
histogram(stats{2}.beta,10);
title('\beta')

subplot(3,2,3)
histogram(stats{1}.BIS,10);
hold on
histogram(stats{2}.BIS,10);
title('BIS')

subplot(3,2,4)
histogram(stats{1}.ICD,10);
hold on
histogram(stats{2}.ICD,10);
title('ICD')

subplot(3,2,5)
histogram(stats{1}.LEDD,10);
hold on
histogram(stats{2}.LEDD,10);
title('ICD')
legend 'Pre' 'Post'

%% Changes
figure(202)
subplot(2,2,1)
histogram(stats{2}.omega-stats{1}.omega,10);
title('Change in \omega')

subplot(2,2,2)
histogram(stats{2}.beta-stats{1}.beta,10);
title('Change in \beta')

subplot(2,2,3)
histogram(stats{2}.BIS-stats{1}.BIS,10);
title('Change in BIS')

subplot(2,2,4)
histogram(stats{2}.ICD-stats{1}.ICD,10);
title('Chagnge in ICD')

%% Plot posterior

% model = stats{1}.hhgf_est{1};
% figure;
% for s = 1:length(model.data)
%    clf
%     A = [];
%     N = size(model.samples_theta,2);
%     for i = 1:N
%         A(i,:,s) = model.samples_theta{s,i}(end-2:end);
%     end
% 
%     for a = 1:size(A,2)
%         subplot(1,3,a);
%         histogram(A(:,a,s));
%     end
%     title(s);
% end
% 


















