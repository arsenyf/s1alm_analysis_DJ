function analysis_RegressionModeSubspaceCorRegressionModeSubspaceCorrelationrelation()
close all;


key.regression_time_start=round(0,4);


figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);


dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\RegressionModeSubspaceCorrelation\' 't' num2str(key.regression_time_start) '\'];


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
% mode_type_name{end+1}='Movement';
mode_type_name{end+1}='Movement Orthog.';
% mode_type_name{end+1}='Stimulus Orthog.';

mode_labels{1}='Choice';
mode_labels{end+1}='Ramping';
mode_labels{end+1}='Movement';


lick_direction_name{1}='all';
lick_direction_name{2}='right';
lick_direction_name{3}='left';


tuning_param_name{1}='lick_horizoffset_relative';
tuning_param_name{2}='lick_peak_x';
tuning_param_name{3}='lick_rt_video_onset';

tuning_param_label{1}='MLRegres';
tuning_param_label{2}='APRegres';
tuning_param_label{3}='ReactionTimeRegres';


rel_unit=EPHYS.Unit;
rel_unit=rel_unit.proj('unit_quality->unit_quality2','unit_uid');

rel_unit2=rel_unit.proj('unit_uid->unit_uid2');

rel_RegSignif=ANL.RegressionUnitSignificanceRsq3 & 'flag_regression_significant=1';


for i_p=1:1:numel(tuning_param_name)
    key.tuning_param_name=tuning_param_name{i_p};
    for  i_d=1:1:numel(lick_direction_name)
        
        key.lick_direction=lick_direction_name{i_d};
        
        mode_unit_weight=[];
        regres_unit_weight=[];
        weights_and_coefficie=[];
        
        for i_m=1:1:numel(mode_type_name)
            key.mode_type_name=mode_type_name{i_m};
            rel_mode=(ANL.Mode*rel_unit*EPHYS.UnitPosition)& key  & (rel_RegSignif&key);
            mode_unit_weight(:,i_m)=fetchn(rel_mode,'mode_unit_weight','ORDER BY unit_uid');
        end
        rel_mode_units=rel_unit2&rel_mode;
        rel_regres=((ANL.RegressionTongueSingleUnit3*EPHYS.UnitPosition*EPHYS.UnitCellType*rel_unit) & key) & (rel_RegSignif&key)&rel_mode_units;
        
        regres_unit_weight=fetchn(rel_regres,'regression_coeff_b2_normalized','ORDER BY unit_uid');
        
        
        % plotting
        subplot(2,2,i_d);
        weights_and_coefficie=mode_unit_weight;
        weights_and_coefficie(:,end+1)=regres_unit_weight;
        r=corr(weights_and_coefficie,'rows','Pairwise');

        labels_current=mode_labels;
        labels_current(end+1)=tuning_param_label(i_p);
        imagesc(r);
        colormap(jet);
        colorbar
        set(gca,'Xtick',[1:1:4],'XtickLabel',labels_current,'Ytick',[1:1:4],'YtickLabel',labels_current);
        xtickangle(90)
        title(sprintf('%s licks\nPearson r',lick_direction_name{i_d}));
    end
    
    if isempty(dir(dir_save_figure))
        mkdir (dir_save_figure)
    end
    filename=['regression_mode_angle' tuning_param_label{i_p}];
    figure_name_out=[ dir_save_figure filename];
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
    clf

end

a=1