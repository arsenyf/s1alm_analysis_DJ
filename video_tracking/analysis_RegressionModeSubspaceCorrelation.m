function analysis_RegressionModeSubspaceCorrelation()
close all;


key.regression_time_start=round(-0.2,4);


figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);


dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\RegressionModeSubspaceCorrelation\'];


key.brain_area = 'ALM';
% key.hemisphere = 'Left';
% key.trialtype_left_and_right_no_distractors=1;
key.unit_quality = 'all';
key.cell_type = 'Pyr';
% key.training_type = 'regular';
% key.outcome = 'hit';

key.outcome_grouping='all';
key.flag_use_basic_trials=0;


mode_type_name{1}='LateDelay';
mode_type_name{end+1}='Ramping Orthog.';
mode_type_name{end+1}='Movement';
mode_type_name{end+1}='Movement Orthog.';
% mode_type_name{end+1}='Stimulus Orthog.';

mode_labels{1}='Choice';
mode_labels{end+1}='Ramping';
mode_labels{end+1}='Movement';


% lick_direction_name{1}='all';
lick_direction_name{1}='right';
lick_direction_name{2}='left';


tuning_param_name{1}='lick_horizoffset_relative';
tuning_param_name{2}='lick_peak_x';
tuning_param_name{3}='lick_rt_video_onset';

tuning_param_label{1}='ML';
tuning_param_label{2}='AP';
tuning_param_label{3}='RT';


rel_Regres=(ANL.RegressionTongueSingleUnit2 & ANL.IncludeSession -ANL.ExcludeSession);

rel_unit=EPHYS.Unit & rel_Regres;
rel_unit=rel_unit.proj('unit_quality->unit_quality2','unit_uid');
rel_unit2=rel_unit.proj('unit_uid->unit_uid2');

labels=[];
for i_m=1:1:numel(mode_type_name)
    key.mode_type_name=mode_type_name{i_m};
    rel_mode=(ANL.Mode*rel_unit*EPHYS.UnitPosition)& key  & (rel_Regres);
    mode_unit_weight(:,i_m)=fetchn(rel_mode,'mode_unit_weight','ORDER BY unit_uid');
    labels{end+1}=mode_type_name{i_m};
end

counter=1;
for i_p=1:1:numel(tuning_param_name)
    key.tuning_param_name=tuning_param_name{i_p};
    for  i_d=1:1:numel(lick_direction_name)
        key.lick_direction=lick_direction_name{i_d};
       
        rel_mode_units=rel_unit2 & rel_mode;
        rel_regres=((ANL.RegressionTongueSingleUnit2*EPHYS.UnitPosition*EPHYS.UnitCellType*rel_unit) & key) & rel_mode_units;
        regres_unit_weight(:,counter)=fetchn(rel_regres,'regression_coeff_b2_normalized','ORDER BY unit_uid').*fetchn(rel_regres,'regression_rsq','ORDER BY unit_uid');
        counter=counter+1;
        labels{end+1}=[tuning_param_label{i_p} lick_direction_name{i_d}];

    end
end

% plotting
weights_all=mode_unit_weight;

weights_all(: , (end+1): (end + size(regres_unit_weight,2)))=regres_unit_weight;
r=corr(weights_all,'rows','Pairwise');
blank=diag(ones(size(r,1),1)'+NaN);

imagescnan(r+blank);
colormap(jet);
colorbar
set(gca,'Xtick',[1:1:numel(labels)],'XtickLabel',labels,'Ytick',[1:1:numel(labels)],'YtickLabel',labels);
xtickangle(90)
title(sprintf('Regression at t= %.2f licks\nPearson r',key.regression_time_start));
 
if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
filename=['regressionMode_corr_t' num2str(key.regression_time_start)];
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
clf
