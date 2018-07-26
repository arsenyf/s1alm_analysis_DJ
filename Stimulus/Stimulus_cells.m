function Stimulus_cells()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root '\Results\Stimulus\'];



%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.1;
panel_height=0.08;
horizontal_distance=0.2;
vertical_distance=0.2;

position_x(1)=0.1;
position_x(2)=position_x(1) + horizontal_distance;
position_x(3)=position_x(2) + horizontal_distance;

position_y(1)=0.6;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;




%% Mini Stimuli
key.brain_area = 'vS1'
key.hemisphere = 'left'
key.training_type = 'regular'
% key.unit_quality = 'ok or good'  %'ok or good'
key.unit_quality = 'multi'
key.cell_type = 'Pyr'
% key.session_flag_mini = 1;
% key.trialtype_flag_left_stim_mini = 1;

k = key;
k.session_flag_mini = 1;
k.trialtype_flag_left_and_control_right = 1;
k.trialtype_flag_mini = 1;

if contains(key.unit_quality, 'ok or good')
    k= rmfield(k,'unit_quality');
    rel=(EXP.SessionID *  EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'unit_quality!="multi"' & 'outcome="hit"';
    key.unit_quality = 'ok';
elseif contains(key.unit_quality, 'multi')
    k= rmfield(k,'unit_quality');
    rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
    key.unit_quality = 'multi';
else
    rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
end

axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
rel1=rel;
k1=k;
fn_plot_stimulus(rel1, k1)
title(sprintf('Trained mice \n mini stimuli \n'),'FontSize',10);





% %% Mini Stimuli - distractor
% key.brain_area = 'vS1'
% key.hemisphere = 'left'
% key.training_type = 'distractor'
% % key.unit_quality = 'ok or good'  %'ok or good'
% key.unit_quality = 'multi'
% key.cell_type = 'Pyr'
% key.session_flag_mini = 1;
% key.trialtype_flag_left_stim_mini = 1;
% 
% 
% k = key;
% if contains(key.hemisphere, 'both')
%     k= rmfield(k,'hemisphere');
% end
% if contains(key.training_type, 'all')
%     k= rmfield(k,'training_type');
% end
% 
% if contains(key.unit_quality, 'ok or good')
%     k= rmfield(k,'unit_quality');
%     rel=(EXP.SessionID *  EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'unit_quality!="multi"' & 'outcome="hit"';
%     key.unit_quality = 'ok';
% elseif contains(key.unit_quality, 'multi')
%     k= rmfield(k,'unit_quality');
%     rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
%     key.unit_quality = 'multi';
% else
%     rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
% end

% axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
% rel2=rel;
% k2=k;
% fn_plot_stimulus(rel2, k2)
% title(sprintf('Expert mice \n mini stimuli \n'),'FontSize',12);




%% Full Stimuli
key=[];
key.brain_area = 'vS1'
key.hemisphere = 'left'
key.training_type = 'distractor'
% key.unit_quality = 'ok or good'  %'ok or good'
key.unit_quality = 'multi'
key.cell_type = 'Pyr'


k = key;
k.session_flag_full = 1;
k.trialtype_flag_left_stim_full = 1;

if contains(key.unit_quality, 'ok or good')
    k= rmfield(k,'unit_quality');
    rel=(EXP.SessionID *  EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'unit_quality!="multi"' & 'outcome="hit"';
    key.unit_quality = 'ok';
elseif contains(key.unit_quality, 'multi')
    k= rmfield(k,'unit_quality');
    rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
    key.unit_quality = 'multi';
else
    rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
end

% Plot
axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
rel3=rel;
k3=k;
fn_plot_stimulus(rel3, k3)
title(sprintf('Expert mice \n full stimuli \n'),'FontSize',10);




%% Quantification

%% Mini Stimuli
key.brain_area = 'vS1'
key.hemisphere = 'left'
key.training_type = 'regular'
% key.unit_quality = 'ok or good'  %'ok or good'
key.unit_quality = 'multi'
key.cell_type = 'Pyr'

k=[];
k = key;
k.session_flag_mini = 1;
k.trialtype_flag_left_stim_mini = 1;

if contains(key.unit_quality, 'ok or good')
    k= rmfield(k,'unit_quality');
    rel=(EXP.SessionID *  EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'unit_quality!="multi"' & 'outcome="hit"';
    key.unit_quality = 'ok';
elseif contains(key.unit_quality, 'multi')
    k= rmfield(k,'unit_quality');
    rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
    key.unit_quality = 'multi';
else
    rel=(EXP.SessionID * EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeGraphic  * ANL.SessionGrouping) & ANL.IncludeUnit & k & 'outcome="hit"';
end
rel1=rel;
k1=k;


axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
yyaxis left
colr = [0 0.4 0.5];
fn_plot_stimulus_quantification(rel1, k1,colr)
ylim([0,0.7]);
set(gca,'YColor',colr,'Fontsize', 10)
ylabel (['\Delta ' sprintf('Spikes \n Mini Stimuli')],'Fontsize', 10,'Color',colr);
text(-1.8,0.7*1.1,'Delay','FontSize',9);
% fn_plot_stimulus_quantification(rel2, k2,colr)
% colr = [0 0 1];
% ylabel ('\Delta Spikes, Mini Stimuli','Fontsize', 12);
% set(gca,'YColor',colr,'Fontsize', 12)

yyaxis right
colr = [0 1 0];
fn_plot_stimulus_quantification(rel3, k3,colr)
ylim([0,7]);
xlabel ('Time (s)','Fontsize', 10);
set(gca,'YColor',colr)
ylabel (['\Delta ' sprintf('Spikes \n Full Stimuli')],'Fontsize', 10,'Color',colr);
title(sprintf('Spike count in vS1\n  at stimulation \n'),'Fontsize', 10);


filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s__Stimulus' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type)];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
eval(['print ', figure_name_out, ' -dpdf -cmyk -r100']);

end