function plotUnitSummary (Unit,PSTH, PSTHAdaptive,PSTHAverageLR, Param, Spikes, Session)

panel_width=0.095;
panel_height=0.1;
horizontal_distance=0.14;
vertical_distance=0.24;

position_x(1)=0.06;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;
position_x(7)=position_x(6)+horizontal_distance*1.1;

position_y(1)=0.77;
position_y(2)=position_y(1)-vertical_distance*1.2;
position_y(3)=position_y(2)-vertical_distance*0.7;
position_y(4)=position_y(3)-vertical_distance*0.7;
% position_y(5)=position_y(4)-vertical_distance*1.3;

axes('position',[position_x(1)-0.05, position_y(1)+0.05, panel_width, panel_height]);
num_not_ignore_trials=sum(~contains(Spikes.outcome,'ignore'));
title(sprintf('%s  %s  anm%d    %s    training: %s   Unit uid #%d      Quality: %s    Cell-type: %s   %d response(not ignore) trials \nShank: %d      site: %d     depth: %d um  mFR Samp %.2f (Hz)  mFR Del %.2f (Hz)  mFR Resp %.2f (Hz) pFR adaptive basic trials %.2f (Hz)  ',Unit.brain_area, Unit.hemisphere, Unit.subject_id, Unit.session_date, Session(1).training_type, Unit.unit_uid, Unit.unit_quality, Unit.cell_type, num_not_ignore_trials, Unit.electrode_group, Unit.unit_channel, Unit.unit_dv_location, Unit.mean_fr_sample, Unit.mean_fr_delay, Unit.mean_fr_response, Unit.adaptive_peak_fr_basic_trials),'FontSize',12,'HorizontalAlignment','left');   

axis off;

%% Basic trials - Left and Right - Adaptive Average
% Correct
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
fn_plot_PSTH_basic_trials (Unit,PSTHAdaptive, Param, 'hit');
text(-3.25, Unit.peak_fr*1.4,'Adaptive Avg.','FontSize',10,'HorizontalAlignment','right')
% Correct vs Error
axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
fn_plot_PSTH_basic_trials (Unit,PSTHAdaptive, Param, 'miss');

%'Correct vs No-lick'
axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
fn_plot_PSTH_basic_trials (Unit,PSTHAdaptive, Param, 'ignore');


%% All  Left and Right trials grouped
% Correct
axes('position',[position_x(4), position_y(1), panel_width, panel_height]);
fn_plot_PSTH_basic_trials (Unit,PSTHAverageLR, Param, 'hit');
text(-3.25, Unit.peak_fr*1.4,'LR Avg.','FontSize',10,'HorizontalAlignment','right')

% Correct vs Error
axes('position',[position_x(5), position_y(1), panel_width, panel_height]);
fn_plot_PSTH_basic_trials (Unit,PSTHAverageLR, Param, 'miss');

%'Correct vs No-lick'
axes('position',[position_x(6), position_y(1), panel_width, panel_height]);
fn_plot_PSTH_basic_trials (Unit,PSTHAverageLR, Param, 'ignore');



%% trialtype_flag_full_late (Left and Right with late-delay stimulation)
%correct
axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
[trialtype_uid] = fn_plot_PSTH (Unit,PSTH, Param, [], 'hit', [], 1);
text(-8,0,'Correct trials','FontSize',14,'Rotation',90,'FontWeight','bold','HorizontalAlignment','left');
%error
axes('position',[position_x(1), position_y(3), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, [] , 'miss', [], 1);
text(-8,0,'Error trials','FontSize',14,'Rotation',90,'FontWeight','bold','HorizontalAlignment','left');
%no response
axes('position',[position_x(1), position_y(4), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, [], 'ignore', [], 1);
text(-8,0,'Ignore trials','FontSize',14,'Rotation',90,'FontWeight','bold','HorizontalAlignment','left');

% Plot trial-type legends
axes('position',[position_x(1), position_y(2)+0.11, panel_width, panel_height*0.7]);
fn_plot_trial_legend (trialtype_uid);
title ('Late delay photostim','Fontsize', 12);
  

%% All standard trials - Right
%correct
axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
[trialtype_uid] = fn_plot_PSTH (Unit,PSTH, Param, 'right', 'hit', 1, []);
%error
axes('position',[position_x(2), position_y(3), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, 'right' , 'miss', 1, []);
%no response
axes('position',[position_x(2), position_y(4), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, 'right', 'ignore', 1, []);

% Plot trial-type legends
axes('position',[position_x(2), position_y(2)+0.11, panel_width, panel_height*0.7]);
fn_plot_trial_legend (trialtype_uid);
title ('Lick Right','Fontsize', 12);

  

%% All standard trials - Left
%correct
axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
[trialtype_uid] = fn_plot_PSTH (Unit,PSTH, Param, 'left', 'hit', 1, []);
%error
axes('position',[position_x(3), position_y(3), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, 'left' , 'miss', 1, []);
%no response
axes('position',[position_x(3), position_y(4), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, 'left', 'ignore', 1, []);

% Plot trial-type legends
axes('position',[position_x(3), position_y(2)+0.11, panel_width, panel_height*0.7]);
fn_plot_trial_legend (trialtype_uid);
title ('Lick Left','Fontsize', 12);


%% All special trials (Left and/or Right)
%correct
axes('position',[position_x(4), position_y(2), panel_width, panel_height]);
[trialtype_uid] =  fn_plot_PSTH (Unit,PSTH, Param, [], 'hit', 0, []);
%error
axes('position',[position_x(4), position_y(3), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, [] , 'miss', 0, []);
%no response
axes('position',[position_x(4), position_y(4), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTH, Param, [], 'ignore', 0, []);

% Plot trial-type legends
axes('position',[position_x(4), position_y(2)+0.11, panel_width, panel_height*0.7]);
fn_plot_trial_legend (trialtype_uid);
title ('Special trials','Fontsize', 12);


%% Adaptive PSTH - All Right trials
%correct
axes('position',[position_x(5), position_y(2), panel_width, panel_height]);
[trialtype_uid] = fn_plot_PSTH (Unit,PSTHAdaptive, Param, 'right', 'hit', [], []);
%error
axes('position',[position_x(5), position_y(3), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTHAdaptive, Param, 'right', 'miss', [], []);
%no response
axes('position',[position_x(5), position_y(4), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTHAdaptive, Param, 'right', 'ignore', [], []);

% Plot trial-type legends
axes('position',[position_x(5), position_y(2)+0.11, panel_width, panel_height*0.7]);
fn_plot_trial_legend (trialtype_uid);
title (sprintf('Adaptive averaging\nLick right'),'Fontsize', 12);

%% Adaptive PSTH - All Left trials
%correct
axes('position',[position_x(6), position_y(2), panel_width, panel_height]);
[trialtype_uid] = fn_plot_PSTH (Unit,PSTHAdaptive, Param, 'left', 'hit', [], []);
%error
axes('position',[position_x(6), position_y(3), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTHAdaptive, Param, 'left', 'miss', [], []);
%no response
axes('position',[position_x(6), position_y(4), panel_width, panel_height]);
fn_plot_PSTH (Unit,PSTHAdaptive, Param, 'left', 'ignore', [], []);

% Plot trial-type legends
axes('position',[position_x(6), position_y(2)+0.11, panel_width, panel_height*0.7]);
fn_plot_trial_legend (trialtype_uid);
title (sprintf('Adaptive averaging\nLick left'),'Fontsize', 12);


%------------------------------------------------------------------------ 

%% Plot ISI histogram
axes('position',[position_x(7)-0.02, position_y(1)-0.2, panel_width, panel_height]);
pcnt_violation = 100* sum(Unit.unit_isi<=0.002)/numel(Unit.unit_isi);
isi_hist=Unit.unit_isi_hist;
isi_hist_bins=Unit.unit_isi_hist_bins;
hold on;
b = bar(isi_hist_bins, isi_hist);
plot([log10(2),log10(2)],[0, max(isi_hist)],'-k');
set(b, 'LineStyle', '-', 'BarWidth', 1, 'EdgeColor','r', 'FaceColor', 'r');  
xlim([-0.3,4]);
ylim([0 max(isi_hist)]);
set(gca,'XTick',[0,1,2,3,4],'XTickLabels',[1,10,100,1000,10000],'TickLength',[0.04 0.01],'TickDir','out','FontSize',8);
xlabel('ISI (ms)','FontSize',8);    
ylabel ('Counts','FontSize',8);  
title(sprintf('%.2f %% violations',pcnt_violation),'FontSize',8);

%% Plot spike-waveform and width
axes('position',[position_x(7)+0.03, position_y(1)-0.05, panel_width*0.3, panel_height*0.5]);
waveform =  Unit.waveform;
xwave=linspace(0,(1000*numel(waveform)./Unit.sampling_fq),numel(waveform));
plot(xwave, waveform);
axis tight; grid on;
title(sprintf('width = %.2f ms', Unit.spk_width_ms),'FontSize',8);
set(gca,'FontSize',8);

%% Plot Raster for all trials
axes('position',[position_x(7), position_y(1)+0.08, panel_width*0.8, panel_height]);
fn_plotSimpleRaster(Param, Spikes, Session)


%% Plot Trial-type summary
axes('position',[position_x(7), position_y(4)-0.12, panel_width*0.6, panel_height]);
[tt, tt_idx ,~] =unique(PSTH.trial_type_name);
for ityp=1:1:numel(tt)
    hit = PSTH.num_trials_averaged (strcmp('hit', PSTH.outcome) & strcmp(tt{ityp},PSTH.trial_type_name));
    miss = PSTH.num_trials_averaged (strcmp('miss', PSTH.outcome) & strcmp(tt{ityp},PSTH.trial_type_name));
    ignore = PSTH.num_trials_averaged (strcmp('ignore', PSTH.outcome) & strcmp(tt{ityp},PSTH.trial_type_name));
    text(-0.5,numel(tt)-ityp,sprintf('%s \n%d hit %d miss  %d ignore',tt{ityp}, hit, miss, ignore),'FontSize',8,'Color',PSTH.trialtype_rgb(tt_idx(ityp),:));
end
ylim([0 ityp/5]);
axis off;


























