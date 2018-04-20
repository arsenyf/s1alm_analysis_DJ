function activitySpace_ModesVariance()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\projections\'];


key.brain_area = 'ALM'
key.hemisphere = 'right'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
key.mode_weights_sign = 'all';



k = key;

if contains(key.hemisphere, 'both')
    k = rmfield(k, 'hemisphere');
end
k_psth = key;


%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);


Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
idx_time2plot = (time>= -3.5 & time<=0);
time2plot = time(idx_time2plot);

dir_save_figure = [dir_save_figure 'smooth' num2str(smooth_time) 's\']

rel_proj =((EXP.Session * EXP.SessionID * ANL.ProjTrialAverageLR * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction *  ANL.IncludeSession * ANL.SessionGrouping * ANL.TrialTypeStimTime ) ) & k & 'unit_quality!="multi"' ;

if contains(k_psth.unit_quality, 'ok or good')
    k_psth = rmfield(k_psth,'unit_quality')
    rel_PTSH =((EXP.Session * EXP.SessionID * ANL.PSTHAverageLR * EPHYS.Unit *  EPHYS.UnitCellType * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction *  ANL.IncludeSession * ANL.SessionGrouping * ANL.TrialTypeStimTime ) ) & k_psth & 'unit_quality!="multi"' ;
    rel_Selectivity =((EXP.Session * EXP.SessionID * ANL.Selectivity * EPHYS.Unit * EPHYS.UnitPosition *   EPHYS.UnitCellType * EXP.SessionTraining    *  ANL.IncludeSession * ANL.SessionGrouping  ) ) & k_psth & 'unit_quality!="multi"' ;

else    
    rel_PTSH =((EXP.Session * EXP.SessionID * ANL.PSTHAverageLR * EPHYS.Unit *  EPHYS.UnitCellType * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction *  ANL.IncludeSession * ANL.SessionGrouping * ANL.TrialTypeStimTime ) ) & k_psth ;
    rel_Selectivity =((EXP.Session * EXP.SessionID * ANL.Selectivity * EPHYS.Unit * EPHYS.UnitPosition *  EPHYS.UnitCellType * EXP.SessionTraining    *  ANL.IncludeSession * ANL.SessionGrouping  ) ) & k_psth ;

end


unit_selectivity = movmean(cell2mat(fetchn(rel_Selectivity,'unit_selectivity')) ,[smooth_bins 0], 2, 'Endpoints','shrink');
unit_selectivity = unit_selectivity(:,idx_time2plot);

[coeff,score,~, ~, explained] = pca(unit_selectivity);
num_of_PCs=5;
   figure('position',[0 720 1000 200])
for c = 1:num_of_PCs
    subplot(1,num_of_PCs,c)
    plot(time2plot, coeff(:,c))
    xlabel('Time');
    ylabel(['PC ' num2str(c)]);
    xlim([time2plot(1),time2plot(end)]);
    title (sprintf('Variance \nexplained %.1f %%',explained(c)));
end






session_uid = unique(fetchn(rel_proj, 'session_uid'));


for i_s = 1:1:numel(session_uid)
    key_session.session_uid = session_uid(i_s);
    
    
    PSTH_l = fetch(rel_PTSH & key_session  & 'outcome="hit"' & 'trial_type_name="l"','*');
    PSTH_r = fetch(rel_PTSH & key_session  & 'outcome="hit"' & 'trial_type_name="l"','*');

    for i_cell=1:1:size(PSTH_l,1)
%         PSTH_concat(i_cell,:) = [PSTH_l(i_cell).psth_avg,PSTH_r(i_cell).psth_avg]
        PSTH_concat(i_cell,isnan(PSTH_concat(i_cell,:))) =0;
        PSTH_concat(i_cell,:) = [PSTH_l(i_cell).psth_avg,PSTH_r(i_cell).psth_avg]

    end
    
     PSTH_concat(isnan(PSTH_concat)) =0;
    
    

    
%     mode_names = {'Stimulus','EarlyDelay','LateDelay','Ramping','Stimulus orthogonal to LateDelay', 'EarlyDelay orthogonal to LateDelay', 'LateDelay orthogonal to EarlyDelay'};
% 
%     
%     for imod = 1:1:numel(mode_names)
%              key_mode.mode_type_name = mode_names{imod};
%             PROJ = fetch(rel_proj & key_session & key_mode & 'outcome="hit"','*');
% 
%     end
    
    axes('position',[0.05, 0.92, 0.2, 0.1]);
    text( 0,0 , sprintf('%s %s side   Training: %s    CellQuality: %s  Cell-type: %s     Animal %d    %s    session id %d' ,...
        key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type, subject_id,session_date,  key_session.session_uid),'HorizontalAlignment','Left','FontSize', 10);
    axis off;
    box off;
    
    
    
    if contains(key.unit_quality, 'ok or good')
        key.unit_quality = 'ok';
    end
    
    filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s_suid%d' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type, key_session.session_uid )];
    
    if isempty(dir(dir_save_figure_full))
        mkdir (dir_save_figure_full)
    end
    figure_name_out=[ dir_save_figure_full filename];
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
    eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
    
    
    if flag_single_sessions==0 % average across sessions
        break
    end
    clf
end
end



