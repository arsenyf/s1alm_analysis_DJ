function activitySpace_Modes()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Results\Population\activitySpace\Modes\'];

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);


% fetch PSTH
session_uid = fetchn (EXP.SessionID & EPHYS.Unit, 'session_uid');
Param = struct2table(fetch (ANL.Parameters,'*'));

for i_s = 1:numel (session_uid)
    key_s.session_uid = session_uid(i_s);
    
    Session = fetch((EXP.SessionID * EXP.BehaviorTrial * EXP.SessionTraining) & key_s,'*');
    training = Session(1).training_type;
    if contains(training,'distractor')
        training='expert_mice';
    else
        training='regular_mice';
    end
    
    Proj =( (EXP.Session * EXP.SessionID * ANL.ProjTrialAverage * EXP.SessionTraining) & 'training_type!="distractor"' & 'unit_quality="good" or unit_quality="ok"' & 'unit_quality!="all"' & 'cell_type="Pyr"' & 'outcome="hit"');

    a=fetch(Proj & 'trial_type_name="r"'  & 'mode_type_name="Stimulus"','*')
% key=fetch(EXP.SessionID & 'session_uid = 38');

    p=cell2mat({a(1:46).proj_average}');
    pm=nanmean(p,1)
plot(pm)
    Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & key_s & 'unit_quality!="multi"' & 'cell_type="Pyr"', '*');
    
    rel2 = (EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * ANL.PSTHAverage * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * ANL.TrialTypeStimTime) & ANL.IncludeUnit & key_s & 'unit_quality!="multi"' & 'cell_type="Pyr"';
    PSTH = struct2table(fetch(rel2,'*', 'ORDER BY trialtype_plot_order DESC'));

    rel3 = (ANL.PSTHTrial  * EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * ANL.TrialTypeStimTime) & ANL.IncludeUnit & key_s & 'unit_quality!="multi"' & 'cell_type="Pyr"';
    PSTH = struct2table(fetch(rel2,'*', 'ORDER BY trialtype_plot_order DESC'));

    
    plotModes (Modes, PSTH, Param);
    
    
    
    
%     
%     % Saving Figure
%     %--------------------------------------------------------------------------
%     
%     
%     anm_name = num2str(Unit.subject_id);
%     date =  Unit.session_date;
%     brain_area = Unit.brain_area;
%     hemisphere = Unit.hemisphere;
%     %         dir_name =  [dir_save_figure brain_area '\' hemisphere '\' anm_name '\' date];
%     dir_name =  [dir_save_figure brain_area '\' hemisphere '\' training '\' ];
%     
%     %         if exist(dir_name)
%     %             [status, message, messageid] = rmdir (dir_name,'s')
%     %         end
%     
%     
%     
%     cell_type=Unit.cell_type;
%     if contains(cell_type,'not classified')
%         cell_type='not_classified';
%     end
%     
%     if rel5.count>0
%         accept_cell_flag=1;
%         if contains(Unit.unit_quality,'multi') %multi units
%             dir_save_cell = [dir_name 'multi_units\'  cell_type '\'];
%         else %single units
%             dir_save_cell = [dir_name 'single_units\'  cell_type '\'];
%         end
%     else  % rejected cells
%         dir_save_cell = [dir_name '\rejected\'];
%     end
%     
%     if isempty(dir(dir_save_cell))
%         mkdir (dir_save_cell)
%     end
%     figure_name_out=[dir_save_cell 'anm' anm_name '_' date '_uid_' num2str(Unit.unit_uid)];
%     eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
    
    clf;
    
    
end