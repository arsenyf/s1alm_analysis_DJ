function activitySpace_Decoding_switch_binning()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\Decoding_before_perturbation\'];



%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.12;
panel_height=0.15;
horizontal_distance=0.3;
vertical_distance=0.3;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;
position_x(7)=position_x(6)+horizontal_distance;
position_x(8)=position_x(7)+horizontal_distance;

position_y(1)=0.65;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;

key.brain_area = 'ALM'
% key.hemisphere = 'right'
key.cell_type = 'Pyr'
key.unit_quality = 'ok or good'



axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
k=[];
k=key;
k.training_type = 'distractor'
condition = 'full'
if strcmp(condition,'mini')
    k.session_flag_mini = 1;
    k.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    k.session_flag_full = 1;
    k.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    k.session_flag_full_late = 1;
    k.trialtype_flag_full_late = 1;
end

k.mode_weights_sign='all';
k.mode_type_name = 'LateDelay';


k.trial_type_name='l_-1.6Full';

k.trial_decoded_type='error';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 1];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});


k.trial_decoded_type='correct';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[1 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});


k.trial_type_name='l';

k.trial_decoded_type='error';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});


k.trial_decoded_type='correct';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[1 0 1];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});

ylim([0 1]);

%%
axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
hold on;
k.trial_decoded_type='all';

k.trial_type_name='l_-1.6Full';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob1 =  movmean(switch_prob ,[3 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob1);
y_stem=nanstd(switch_prob1)./sqrt(size(switch_prob1,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});

k.trial_type_name='l';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob2 =  movmean(switch_prob ,[3 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob2);
y_stem=nanstd(switch_prob2)./sqrt(size(switch_prob2,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});


ylim([0 1]);

axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
%differencehold on;
colr=[0 1 0];
x=nanmedian(normalized_proj_bins);
switch_prob=switch_prob1-switch_prob2;
% switch_prob = switch_prob- nanmean(switch_prob,2);
switch_prob = switch_prob- nanmin(switch_prob,[],2);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});

ylim([0 0.45])



%%

axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
k=[];
k=key;
k.training_type = 'regular'
condition = 'mini'
if strcmp(condition,'mini')
    k.session_flag_mini = 1;
    k.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    k.session_flag_full = 1;
    k.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    k.session_flag_full_late = 1;
    k.trialtype_flag_full_late = 1;
end

k.mode_weights_sign='all';
k.mode_type_name = 'LateDelay';
k.trial_type_name='l_-1.6Mini';

k.trial_decoded_type='error';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 1];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});


k.trial_decoded_type='correct';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[1 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});

k.trial_type_name='l';

k.trial_decoded_type='error';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});


k.trial_decoded_type='correct';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob =  movmean(switch_prob ,[5 0], 2, 'omitnan','Endpoints','shrink');
colr=[1 0 1];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});

ylim([0 1]);


%%
axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
hold on;
k.trial_decoded_type='all';

k.trial_type_name='l_-1.6Mini';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob1 =  movmean(switch_prob ,[3 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob1);
y_stem=nanstd(switch_prob1)./sqrt(size(switch_prob1,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});

k.trial_type_name='l';
rel_Switch = ( ANL.SwitchProbability * EXP.SessionID * EXP.SessionTraining *ANL.SessionGrouping ) & k;
switch_prob = cell2mat(fetchn(rel_Switch,'switch_prob' ,'ORDER BY session_uid'));
normalized_proj_bins =  cell2mat(fetchn(rel_Switch,'normalized_proj_bins' ,'ORDER BY session_uid'));
hold on;
switch_prob2 =  movmean(switch_prob ,[3 0], 2, 'omitnan','Endpoints','shrink');
colr=[0 0 0];
x=nanmedian(normalized_proj_bins);
y_mean=nanmedian(switch_prob2);
y_stem=nanstd(switch_prob2)./sqrt(size(switch_prob2,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});
ylim([0 1]);

axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
%difference
hold on;
colr=[0 1 0];
x=nanmedian(normalized_proj_bins);
switch_prob=switch_prob1-switch_prob2;
switch_prob = switch_prob- nanmin(switch_prob,[],2);
y_mean=nanmedian(switch_prob);
y_stem=nanstd(switch_prob)./sqrt(size(switch_prob,1));
shadedErrorBar(x,y_mean,y_stem,'lineprops',{'-','Color',colr,'markeredgecolor',colr,'markerfacecolor',colr,'linewidth',1});

ylim([0 0.25])



if contains(key.unit_quality, 'ok or good')
    key.unit_quality = 'ok';
end

filename =[sprintf('decoding_before_perturbation')];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
