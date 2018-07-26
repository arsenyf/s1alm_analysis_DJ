function activitySpace_Modes_2D_figure()
% close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes2D\'];
flag_normalize_modes =0; % 1 to normalize projections between 0 and 1, 0 to plot absolute values

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);

Param = struct2table(fetch (ANL.Parameters,'*'));
smooth_time = Param.parameter_value{(strcmp('smooth_time_proj2D',Param.parameter_name))};
dir_save_figure = [dir_save_figure 'smooth' num2str(smooth_time) 's\']

%% Regular mini 
key.trialtype_flag_left_and_control_right=1;
key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'regular'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
key.mode_weights_sign = 'all';
condition = 'mini'
title1 = 'Regular mice';
title2='mini stimuli';
title3=[];
ylabel_flag=1;

if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key.trialtype_flag_full_late = 1;
end
k = key;

xposition=1;
rel =((EXP.Session * EXP.SessionID * ANL.ProjTrialAdaptiveAverageBaseline	 * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction *  ANL.IncludeSession * ANL.SessionGrouping * ANL.TrialTypeStimTime - ANL.ExcludeSession) & k & 'unit_quality!="multi"' );  
plotModes_2D (rel,  Param, xposition,title1, title2, title3, ylabel_flag, flag_normalize_modes);
            


%% Distractor mini 
key=[];
k=[];
key.trialtype_flag_left_and_control_right=1;
key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
key.mode_weights_sign = 'all';
condition = 'mini'
title1 = 'Expert mice';
title2='mini stimuli';
title3=[];
ylabel_flag=0;

if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key.trialtype_flag_full_late = 1;
end
k = key;

xposition=4;
rel =((EXP.Session * EXP.SessionID * ANL.ProjTrialAdaptiveAverageBaseline * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction *  ANL.IncludeSession * ANL.SessionGrouping * ANL.TrialTypeStimTime - ANL.ExcludeSession) & k & 'unit_quality!="multi"') ;  
plotModes_2D (rel,  Param, xposition,title1, title2, title3, ylabel_flag, flag_normalize_modes);

%% Distractor full 
key=[];
k=[];
key.trialtype_flag_left_and_control_right=1;
key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
key.mode_weights_sign = 'all';
condition = 'full'
title1 = 'Expert mice';
title2='full stimuli';
title3=[];
ylabel_flag=0;

if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key.trialtype_flag_full_late = 1;
end
k = key;

xposition=2;
rel =((EXP.Session * EXP.SessionID * ANL.ProjTrialAdaptiveAverageBaseline * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction *  ANL.IncludeSession * ANL.SessionGrouping * ANL.TrialTypeStimTime - ANL.ExcludeSession) & k & 'unit_quality!="multi"' );  
plotModes_2D (rel,  Param, xposition,title1, title2, title3, ylabel_flag, flag_normalize_modes);


dir_save_figure_full=dir_save_figure;
filename =[sprintf('fig3_2D_rotations_SLR')];
% filename =[sprintf('fig3_2D_rotations_SLeftRight')];

if isempty(dir(dir_save_figure_full))
    mkdir (dir_save_figure_full)
end
figure_name_out=[ dir_save_figure_full filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
savefig([figure_name_out '.fig'])


