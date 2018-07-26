function PSTH_all_cells()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Cells\'];

% Graphics
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
    unit_uid = fetchn(EXP.SessionID * EPHYS.Unit & key_s, 'unit_uid', 'ORDER BY unit_uid');
    
    Session = fetch((EXP.SessionID * EXP.BehaviorTrial * EXP.SessionTraining) & key_s,'*');
    training = Session(1).training_type;
    if contains(training,'distractor')
        training='expert_mice';
    else
        training='regular_mice';
    end
    
    for i_u = 1:1:numel(unit_uid)
%         if unit_uid(i_u)<3708
%             continue
%         end
        PSTH=[]; PSTHAdaptive=[]; Spikes=[]; Unit =[];
        unit_uid(i_u)
            
            key_u.unit_uid = unit_uid(i_u);
            rel1 = (EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.UnitFiringRate * ANL.UnitISI * EPHYS.UnitWaveform) & key_s & key_u;
            Unit = fetch(rel1,'*');
            
            rel2 = (EXP.SessionID * EPHYS.Unit * ANL.PSTHAverage * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * ANL.TrialTypeStimTime) & key_s & key_u;
            PSTH = struct2table(fetch(rel2,'*', 'ORDER BY trialtype_plot_order DESC'));
            
            rel3 = (EXP.SessionID * EPHYS.Unit * ANL.PSTHAdaptiveAverage * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction  * ANL.TrialTypeStimTime) & key_s & key_u;
            PSTHAdaptive = struct2table(fetch(rel3,'*', 'ORDER BY trialtype_plot_order DESC'));
            
            rel4 = (EXP.SessionID * EPHYS.Unit * ANL.PSTHAverageLR * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction  * ANL.TrialTypeStimTime) & key_s & key_u;
            PSTHAverageLR = struct2table(fetch(rel4,'*', 'ORDER BY trialtype_plot_order DESC'));

            rel4 = (ANL.TrialSpikesGoAligned * EXP.SessionID * EXP.BehaviorTrial) & key_s  &  (EPHYS.Unit & key_u);
            
            if rel4.count<=1
                continue
            end
            
            Spikes = struct2table(fetch(rel4,'*', 'ORDER BY trial'));
            
            rel5 = (ANL.IncludeUnit * EPHYS.Unit) & key_u;
            
            plotUnitSummary (Unit,PSTH, PSTHAdaptive,PSTHAverageLR, Param, Spikes, Session);
            
            
            
            
            % Saving Figure
            %--------------------------------------------------------------------------
            
            
            anm_name = num2str(Unit.subject_id);
            date =  Unit.session_date;
            brain_area = Unit.brain_area;
            hemisphere = Unit.hemisphere;
            %         dir_name =  [dir_save_figure brain_area '\' hemisphere '\' anm_name '\' date];
            dir_name =  [dir_save_figure brain_area '\' hemisphere '\' training '\' ];
            
            %         if exist(dir_name)
            %             [status, message, messageid] = rmdir (dir_name,'s')
            %         end
            
            
            
            cell_type=Unit.cell_type;
            if contains(cell_type,'not classified')
                cell_type='not_classified';
            end
            
            if rel5.count>0
                accept_cell_flag=1;
                if contains(Unit.unit_quality,'multi') %multi units
                    dir_save_cell = [dir_name 'multi_units\'  cell_type '\'];
                else %single units
                    dir_save_cell = [dir_name 'single_units\'  cell_type '\'];
                end
            else  % rejected cells
                dir_save_cell = [dir_name '\rejected\'];
            end
            
            if isempty(dir(dir_save_cell))
                mkdir (dir_save_cell)
            end
            figure_name_out=[dir_save_cell 'anm' anm_name '_' date '_uid_' num2str(Unit.unit_uid)];
            eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
            
            clf;
        
    end
    
end