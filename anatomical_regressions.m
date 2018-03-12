function anatomical_regressions(stats,D)

% Associative
ad.d_assoc = [stats{2}.Right_Contact_Distance_To_Associative' ...
    stats{2}.Left_Contact_Distance_To_Associative'];
ad.vat_assoc = [stats{2}.Right_Associative_Percentage_VAT_Overlap' ...
    stats{2}.Left_Associative_Percentage_VAT_Overlap'];
ad.ratio_assoc = [stats{2}.Right_Associative_Motor_VATRatio' ...
    stats{2}.Left_Associative_Motor_VATRatio'];

% Limbic
ad.d_limbic = [stats{2}.Right_Contact_Distance_To_Limbic' ...
    stats{2}.Left_Contact_Distance_To_Limbic'];
ad.vat_limbic = [stats{2}.Right_Limbic_Percentage_VAT_Overlap' ...
    stats{2}.Left_Limbic_Percentage_VAT_Overlap'];
ad.ratio_limbic = [stats{2}.Right_Limbic_Motor_VATRatio' ...
    stats{2}.Left_Limbic_Motor_VATRatio'];

% Motor
ad.d_motor = [stats{2}.Right_Contact_Distance_To_Motor' ...
    stats{2}.Left_Contact_Distance_To_Motor'];
ad.vat_motor = [stats{2}.Right_Motor_Percentage_VAT_Overlap'...
 stats{2}.Left_Motor_Percentage_VAT_Overlap'];
ad.ratio_motor = [stats{2}.Right_Limbic_Motor_VATRatio' ...
    stats{2}.Left_Limbic_Motor_VATRatio'];

% Had to remove stats{2}.Right_Limbic_Percentage_VAT_Overlap
% because of singular matrix

right_regions = [stats{2}.RCentroidAssoc'...
stats{2}.Right_Associative_Percentage_VAT_Overlap'
];

motor_overlap = [stats{2}.Right_Contact_Distance_To_Motor'...
stats{2}.Left_Contact_Distance_To_Motor'...
stats{2}.Right_Motor_Percentage_VAT_Overlap'...
stats{2}.Left_Motor_Percentage_VAT_Overlap'];

limbic_centroid = [stats{2}.RCentroidLimbic' stats{2}.LCentroidLimbic'];
motor_centroid = [stats{2}.RCentroidMotor' stats{2}.LCentroidMotor'];
assoc_centroid = [stats{2}.RCentroidAssoc' stats{2}.LCentroidAssoc'];

%RCentroidAssociative distance and the
%Right Associative Percentage VAT overlap will be key variables here.

%% Motor regression on BIS
X = motor_overlap;
analysis = 'MotorBIS';
fields = {'BIS','BIS_NonPlanning','BIS_Motor','BIS_Attentional'};
for f = 1:length(fields)
    y = stats{2}.(fields{f});
    
    r = regstats(y,X,'linear');
    r.X = X;
    r.y = y;
    
    reg_vals(r,analysis,fields{f});  
end

%% Right regressions on everything
fields = {'BIS','BIS_NonPlanning','BIS_Motor','BIS_Attentional',...
    'EQ','QUIP','BIS_MaxIncrease','QUIP_MaxIncrease',...
    'EQ_MaxDecrease',};
X = [ad.d_assoc ad.d_limbic ad.d_motor ]; 
analysis = 'RightRegionBIS';

for f = 1:length(fields)
    y = stats{2}.(fields{f});
    
    r = regstats(y,X,'linear');
    r.X = X;
    r.y = y;
    
    reg_vals(r,analysis,fields{f});
    
end

%% Logistic regression, significant psych
y = stats{2}.Signif_Psych' + 1;
X = assoc_centroid(:,1);
[B,dev,l] =  mnrfit(X,y);
l.p
LL = l.beta(2) - 1.96.*l.se(2);
UL = l.beta(2) + 1.96.*l.se(2);

%% Anatomical regressions, model parameter change
param_fields = {'omega';'theta';'beta'};
analysis = 'AnatParam_Change'
X = [ad.d_assoc];
for f = 1:length(param_fields)
    y = stats{2}.(param_fields{f})-stats{1}.(param_fields{f});
%y = stats{2}.(param_fields{f});
    r = regstats(y,X,'linear');
    r.X = X;
    r.y = y;
    
    reg_vals(r,analysis,param_fields{f});

end















 