function activitySpace_Modes()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\projection_slope\'];


key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
key.mode_weights_sign = 'all';

condition = 'full'

if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key_mode.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key_mode.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key_mode.trialtype_flag_full_late = 1;
end

k = key;
rel =((EXP.Session * EXP.SessionID * ANL.ProjTrialAverage * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * EXP.SessionComment * ANL.IncludeSession * ANL.SessionGrouping) - ANL.ExcludeSession) & k & 'unit_quality!="multi"' ;

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
smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);


mode_names = {'Stimulus','EarlyDelay','LateDelay','Ramping'};
key_mode.mode_type_name = mode_names{3};
key_mode.outcome = 'hit';
%     key_mode.trial_type_name = 'hit';
Proj=struct2table(fetch(rel & key_mode,'*'));

trial_types = unique(Proj.trial_type_name);
recovery_offset = 0.4;
for itype= 1:1:numel(trial_types)
    P = Proj(strcmp(trial_types{itype},Proj.trial_type_name),:);
    idx_include = (P.num_trials_projected >=5 & P.num_units_projected >=20);
    
    for i_session = 1:1:size(P,1)
        
        %     Proj_avg=nanmean(P.proj_average(idx_include,:),1);
        %     Proj_smooth = movmean(Proj_avg ,[smooth_bins 0], 2, 'Endpoints','shrink');
        Proj_smooth = movmean(P.proj_average(i_session,:) ,[smooth_bins 0], 2, 'Endpoints','shrink');
        key_name.trial_type_name = trial_types{itype};
        stim_onset = fetch1 (ANL.TrialTypeStimTime & key_name,'stim_onset');
        
        if ~isempty(stim_onset)
            slope_t_start = stim_onset(end) + recovery_offset;
            slope_t_end = slope_t_start + 0.2;
            slope_t_idx = find(time>= slope_t_start & time< slope_t_end);
            time_for_slope = time(slope_t_idx);
            Proj_for_slope = Proj_smooth(slope_t_idx);
            %             slope{itype}(i_session) = nanmean(diff(Proj_for_slope)./diff(time_for_slope))
            if idx_include (i_session)
                slope{itype}(i_session) = (Proj_for_slope(end) - Proj_for_slope(1))/(time_for_slope(end) - time_for_slope(1));
            else
                slope{itype}(i_session) = NaN;
            end
        end
    end
end
trial_types
y.mean(1) = nanmean(slope{7})
y.mean(2) = nanmean(slope{6})

y.stem(1) = nanstd(slope{7})./sqrt(sum(~isnan(slope{7})));
y.stem(2) = nanstd(slope{6})./sqrt(sum(~isnan(slope{6})));



[~,p]=ttest2(slope{6},slope{7},'Vartype','unequal')
% ranksum(slope{6},slope{7})

y.symbol{1}=' ';
if p<=0.001
    y.symbol{2}='***';
elseif p<=0.01
    y.symbol{2}='**';
elseif p<=0.05
    y.symbol{2}='*';
else
    y.symbol{2}=' ';
end


y.mean(3) = nanmean(slope{3})
y.mean(4) = nanmean(slope{2})

y.stem(3) = nanstd(slope{3})./sqrt(sum(~isnan(slope{3})));
y.stem(4) = nanstd(slope{2})./sqrt(sum(~isnan(slope{2})));

[~,p]=ttest2(slope{3},slope{2},'Vartype','unequal')
% ranksum(slope{6},slope{7})

y.symbol{3}=' ';
if p<=0.001
    y.symbol{4}='***';
elseif p<=0.01
    y.symbol{4}='**';
elseif p<=0.05
    y.symbol{4}='*';
else
    y.symbol{4}=' ';
end


key_mode.outcome = 'miss';
%     key_mode.trial_type_name = 'hit';
Proj=struct2table(fetch(rel & key_mode,'*'));

trial_types = unique(Proj.trial_type_name);
recovery_offset = 0.4;
for itype= 1:1:numel(trial_types)
    P = Proj(strcmp(trial_types{itype},Proj.trial_type_name),:);
    idx_include = (P.num_trials_projected >=5 & P.num_units_projected >=20);
    
    for i_session = 1:1:size(P,1)
        
        %     Proj_avg=nanmean(P.proj_average(idx_include,:),1);
        %     Proj_smooth = movmean(Proj_avg ,[smooth_bins 0], 2, 'Endpoints','shrink');
        Proj_smooth = movmean(P.proj_average(i_session,:) ,[smooth_bins 0], 2, 'Endpoints','shrink');
        key_name.trial_type_name = trial_types{itype};
        stim_onset = fetch1 (ANL.TrialTypeStimTime & key_name,'stim_onset');
        
        if ~isempty(stim_onset)
            slope_t_start = stim_onset(end) + recovery_offset;
            slope_t_end = slope_t_start + 0.2;
            slope_t_idx = find(time>= slope_t_start & time< slope_t_end);
            time_for_slope = time(slope_t_idx);
            Proj_for_slope = Proj_smooth(slope_t_idx);
            %             slope{itype}(i_session) = nanmean(diff(Proj_for_slope)./diff(time_for_slope))
            if idx_include (i_session)
                slope{itype}(i_session) = (Proj_for_slope(end) - Proj_for_slope(1))/(time_for_slope(end) - time_for_slope(1));
            else
                slope{itype}(i_session) = NaN;
            end
        end
    end
end


y.mean(5) = nanmean(slope{7})
y.mean(6) = nanmean(slope{6})

y.stem(5) = nanstd(slope{7})./sqrt(sum(~isnan(slope{7})));
y.stem(6) = nanstd(slope{6})./sqrt(sum(~isnan(slope{6})));



[~,p]=ttest2(slope{6},slope{7},'Vartype','unequal')
% ranksum(slope{6},slope{7})

y.symbol{5}=' ';
if p<=0.001
    y.symbol{6}='***';
elseif p<=0.01
    y.symbol{6}='**';
elseif p<=0.05
    y.symbol{6}='*';
else
    y.symbol{6}=' ';
end


y.mean(7) = nanmean(slope{3})
y.mean(8) = nanmean(slope{2})

y.stem(7) = nanstd(slope{3})./sqrt(sum(~isnan(slope{3})));
y.stem(8) = nanstd(slope{2})./sqrt(sum(~isnan(slope{2})));

[~,p]=ttest2(slope{3},slope{2},'Vartype','unequal')
% ranksum(slope{6},slope{7})

y.symbol{7}=' ';
if p<=0.001
    y.symbol{8}='***';
elseif p<=0.01
    y.symbol{8}='**';
elseif p<=0.05
    y.symbol{8}='*';
else
    y.symbol{8}=' ';
end




axes('position',[0.05, 0.5, 0.4, 0.4]);

hold on;
x= [ 1 2 3 4 5 6 7 8];
bar(x([1,2,5,6]),y.mean([1,2,5,6]), 'FaceColor', [0 0 1])
errorbar_myown( x([1,2,5,6]), y.mean([1,2,5,6]) ,y.mean([1,2,5,6])*0, y.stem([1,2,5,6]), '.b', 0.1 );
bar(x([3,4,7,8]),y.mean([3,4,7,8]), 'FaceColor', [1 0 0])
errorbar_myown( x([3,4,7,8]), y.mean([3,4,7,8]) ,y.mean([3,4,7,8])*0, y.stem([3,4,7,8]), '.r', 0.1 );
xlim([0 x(end)+1]);
for i=1:1:numel(y.mean)
text(x(i),(y.mean(i)+y.stem(i))+5, y.symbol{i},'FontSize',20);
end
ylabel('Projection Slope');
set(gca, 'Xtick', x, 'XtickLabel', {'-1.6 correct','-0.8 correct', '-1.6 correct','-0.8 correct', '-1.6 error','-0.8 error', '-1.6 error','-0.8 error'} , 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
box off;

filename = [key.hemisphere 'smoothing_' num2str(1000*smooth_time) 'ms_slope'];
figure_name_out=[ dir_save_figure filename];

 if isempty(dir(dir_save_figure))
        mkdir (dir_save_figure)
    end
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);