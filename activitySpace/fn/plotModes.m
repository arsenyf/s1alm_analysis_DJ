function [OUT, GP] = plotModes (Modes, PSTH, Param)


panel_width=0.09;
panel_height=0.09;
horizontal_distance=0.15;
vertical_distance=0.18;

position_x(1)=0.07;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;

position_y(1)=0.75;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;


% hit = Spikes.trial (strcmp('hit',Spikes.outcome) & strcmp('no early',Spikes.early_lick))';
% miss = Spikes.trial (strcmp('miss',Spikes.outcome) & strcmp('no early',Spikes.early_lick))';
% ignore = Spikes.trial (strcmp('ignore',Spikes.outcome) & strcmp('no early',Spikes.early_lick))';
% early = Spikes.trial (~strcmp('no early',Spikes.early_lick))';


mode_names = unique({Modes.mode_type_name})';
mode_names = mode_names(~contains(mode_names, 'orthogonal'))
for imod = 1:1:numel(mode_names)
    
    M = Modes(strcmp(mode_names{imod},{Modes.mode_type_name}'));
    %% Correct trials
    axes('position',[position_x(1), position_y(imod), panel_width, panel_height]);
    substract_trialtype_num=[];
    fn_projectTrialAvg(M, PSTH);
    %     plotProjection(MODE(num).PROJ.proj_avg_pop, '-', substract_trialtype_num, GP.trial_order, GP);
    %     tmp = ylim;
    %     tmp(1) = min ([-1, tmp(1)]);
    %     tmp(2) =  max ([+1, tmp(2)]);
    %     global_yl(imod,:) = tmp+[-abs(diff(tmp))*0.1,abs(diff(tmp))*0.1];
    %     yl = global_yl(imod,:);
    %     set(gca,'Ylim',yl)
    %     xl = get(gca,'Xlim');
    %     if strcmp(filt_str,'~lickearly&hit')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'Correct trials','FontSize',12, 'HorizontalAlignment','center');
    %     elseif strcmp(filt_str,'~lickearly&~hit&~no')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'Error trials','FontSize',12, 'HorizontalAlignment','center');
    %     elseif strcmp(filt_str,'~lickearly&no')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'No-lick trials','FontSize',12, 'HorizontalAlignment','center');
    %     else
    %         text(xl(1) + diff(xl)*0.5, yl(1) + diff(yl)*1.35, filt_str,'FontSize',12);
    %     end
    %     text(xl(1) - diff(xl)*0.6, yl(1) + diff(yl)/2, [MODE(num).label],'FontSize',14,'Rotation',90, 'HorizontalAlignment','center');
    %     plot(tint1(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
    %     plot(tint2(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
    
    %
    %     %% Error trials
    %     filt_str = '~lickearly&~hit&~no';
    %     axes('position',[position_x(5), position_y(imod), panel_width, panel_height]);
    %     substract_trialtype_num=[];
    %     [MODE(num).PROJ_error] = projectTrials(psth, tt, MODE(num), filt_str);
    %     plotProjection(MODE(num).PROJ_error.proj_avg_pop, '-', substract_trialtype_num, GP.trial_order, GP);
    %     yl = global_yl(imod,:);
    %     set(gca,'Ylim',yl)
    %     if strcmp(filt_str,'~lickearly&hit')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'Correct trials','FontSize',12, 'HorizontalAlignment','center');
    %     elseif strcmp(filt_str,'~lickearly&~hit&~no')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'Error trials','FontSize',12, 'HorizontalAlignment','center');
    %     elseif strcmp(filt_str,'~lickearly&no')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'No-lick trials','FontSize',12, 'HorizontalAlignment','center');
    %     else
    %         text(xl(1) + diff(xl)*0.5, yl(1) + diff(yl)*1.35, filt_str,'FontSize',12);
    %     end
    %     plot(tint1(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
    %     plot(tint2(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
    %
    %
    %
    %     %% No response trials
    %     filt_str = '~lickearly&no';
    %     axes('position',[position_x(6), position_y(imod), panel_width, panel_height]);
    %     substract_trialtype_num=[];
    %     [MODE(num).PROJ_nolick] = projectTrials(psth, tt, MODE(num), filt_str);
    %     plotProjection(MODE(num).PROJ_nolick.proj_avg_pop, '-', substract_trialtype_num, GP.trial_order, GP);
    %     yl = global_yl(imod,:);
    %     set(gca,'Ylim',yl)
    %     if strcmp(filt_str,'~lickearly&hit')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'Correct trials','FontSize',12, 'HorizontalAlignment','center');
    %     elseif strcmp(filt_str,'~lickearly&~hit&~no')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'Error trials','FontSize',12, 'HorizontalAlignment','center');
    %     elseif strcmp(filt_str,'~lickearly&no')
    %         text(xl(1) + diff(xl)*0.25, yl(1) + diff(yl)*1.4,'No-lick trials','FontSize',12, 'HorizontalAlignment','center');
    %     else
    %         text(xl(1) + diff(xl)*0.5, yl(1) + diff(yl)*1.35, filt_str,'FontSize',12);
    %     end
    %     plot(tint1(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
    %     plot(tint2(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
    %
    %
    
end

% filt_str = '~lickearly&hit';
% [filt_mat_correct] = filt_SingleTrial(tt, filt_str);
% filt_str = '~lickearly&~hit&~no';
% [filt_mat_error] = filt_SingleTrial(tt, filt_str);
% filt_str = '~lickearly&no';
% [filt_mat_nolick] = filt_SingleTrial(tt, filt_str);
%
% idx_reject_cells_all = [];
% spk_width_all = [];
% wav_all = [];
% idx_Pyr = [];
% idx_FS = [];
% idx_unclassified = [];
% depth_all = [];
%
% weights_dim={[],[],[],[],[]};
% xwave = O.O{1}.xwave;
%
% for imod = 1:numel(fn)
%     idx_reject_cells_all = [idx_reject_cells_all, O.idx_reject_cells{imod}'];
%
%     spk_width_all = [spk_width_all, O.O{imod}.spk_width_all];
%     wav_all = [wav_all; O.O{imod}.wav_all];
%     depth_all = [depth_all, O.O{imod}.depth_all];
%
%     idx_Pyr = [idx_Pyr, O.O{imod}.idx_Pyr];
%     idx_FS = [idx_FS, O.O{imod}.idx_FS];
%     idx_unclassified = [idx_unclassified, O.O{imod}.idx_unclassified];
%
%     for ii_d = 1:size(MODE,2)
%         weights_dim{ii_d} = [weights_dim{ii_d},MODE(ii_d).weights{imod}];
%     end
%
% end
%
% spk_width_all = spk_width_all(~idx_reject_cells_all);
% wav_all = wav_all(~idx_reject_cells_all,:);
% depth_all = depth_all(~idx_reject_cells_all);
% idx_Pyr = logical(idx_Pyr(~idx_reject_cells_all));
% idx_FS = logical(idx_FS(~idx_reject_cells_all));
% idx_unclassified = logical(idx_unclassified(~idx_reject_cells_all));
%
%
% % Spike width
% axes('position',[position_x(4), position_y(1)+0.12, panel_width*0.5, panel_height*0.5]);
% hold on;
% hhh=histogram(spk_width_all,20);
% hhh.FaceColor = [0 0 0];
% hhh.EdgeColor = [0 0 0];
% yl = [0, max([max(hhh.Values),eps])];
% plot([GP.width_thresh(1),GP.width_thresh(1)],[0,yl(2)],'-r');
% plot([GP.width_thresh(2),GP.width_thresh(2)],[0,yl(2)],'-k');
% ylim(yl)
% xlim([0,max(1,hhh.BinLimits(2))]);
% xlabel('Spike width (ms)');
% ylabel('# of neurons');
%
% % Waveforms of Pyr vs FS
% axes('position',[position_x(4)+0.05, position_y(1)+0.12, panel_width*0.4, panel_height*0.5]);
% hold on;
% if ~isempty (find(idx_Pyr))
%     plot(xwave,-1*wav_all(idx_Pyr,:),'-k','LineWidth',0.5)
% end
%
% if ~isempty (find(idx_unclassified))
%     plot(xwave,-1*wav_all(idx_unclassified,:),'-','Color',[0.75 0.75 0.75],'LineWidth',0.5)
% end
%
% if ~isempty (find(idx_FS))
%     plot(xwave,-1*wav_all(idx_FS,:),'-','Color',[1 0 0],'LineWidth',0.5)
% end
% axis off;
% box off;
%
% % Depth vs weight
% nbins = 4;
% w_binned_percent = zeros(size(weights_dim,2),nbins);
% w_threshold = 0.25;
% for imod = 1:1:size(weights_dim,2)
%     %     axes('position',[position_x(i), position_y(5), panel_width*0.5, panel_height*0.5]);
%     %     fn_plot_w_vs_depth (weights_dim{i}(idx_Pyr), depth_all(idx_Pyr), [-1,1], [0 0 0])
%     %     fn_plot_w_vs_depth (weights_dim{i}(idx_unclassified), depth_all(idx_unclassified), [-1,1], [0.75 0.75 0.75])
%     %     fn_plot_w_vs_depth (weights_dim{i}(idx_FS), depth_all(idx_FS), [-1,1], [1 0 0])
%     %     ylim([min(depth_all),max(depth_all)]);
%     %     set(gca,'Ydir','reverse')
%
%     axes('position',[position_x(4), position_y(imod), panel_width*0.4, panel_height*0.6]);
%     hold on;
%     w = abs(weights_dim{imod});
%     fn_plot_w_vs_depth ( w(idx_Pyr), depth_all(idx_Pyr), [0,1], [0 0 0]);
%     fn_plot_w_vs_depth (w(idx_unclassified), depth_all(idx_unclassified), [0,1], [0.75 0.75 0.75]);
%     fn_plot_w_vs_depth (w(idx_FS), depth_all(idx_FS), [0,1], [1 0 0]);
%     plot([w_threshold,w_threshold],[0,5000],'--g','LineWidth',2);
%     ylim([min(depth_all),max(depth_all)]);
%     set(gca,'Ydir','reverse')
%     xlabel('Weight')
%     if imod ==1
%         ylabel('Depth (\mum)');
%     end;
%     title (sprintf('%s', MODE(imod).label))
%     bin_edges = linspace(min(depth_all),max(depth_all),nbins+1);
%     bin_centers = bin_edges(1:end-1) + diff(bin_edges)/2;
%     [N,~,bin_idx] = histcounts(depth_all,bin_edges);
%     w (w<w_threshold) = NaN;
%     for jj = unique(bin_idx)
%         w_binned = w(bin_idx==jj);
%         w_binned_percent (imod,jj)= 100*sum(~isnan(w_binned))/numel(w(~isnan(w)));
%     end
%     w_binned_percent(isnan(w_binned_percent)) = 0;
% end
%
% % Percentage of neurons with high weights at different depth
% for imod = 1:1:size(weights_dim,2)
%     axes('position',[position_x(4)+0.045, position_y(imod), panel_width*0.4, panel_height*0.6]);
%     plot(w_binned_percent(imod,:),bin_centers,'-xg','LineWidth',2)
%     xlim([0 ceil(max(w_binned_percent(:)))+5]);
%     ylim ([min(depth_all),max(depth_all)]);
%     set(gca,'Ydir','reverse','Yticklabel',[])
%     xlabel('%')
%     box off;
% end
%
%
% %% Error and no-lick trials averaged for all trialtypes
% GP2 = GP;
% GP2.task_grouping = [];
% GP2.order=[];
% GP2.trial_reorder = [];
% % Select relevant trials
% [O2] = Inclusion_criteria_cells (parent, fn, GP2);
%
% for imod = 1:1:size(O2.psth,2)
%     psth2{imod} = O2.psth{imod}(:,~idx_reject_cells{imod},:);
% end
% psth2 = smoothPSTH(psth2, GP2);
%
%
% tt=O2.tt;
%
%
%
% for imod = 1:1:size(MODE,2)
%     num = imod;
%     % Correct vs Error averaged for all trialtypes
%     axes('position',[position_x(2), position_y(imod), panel_width, panel_height]);
%     filt_str1 = '~lickearly&hit';
%     filt_str2 = '~lickearly&~hit&~no';
%     ylegend = 'Correct vs Error (x)';
%     [proj_avg, ~] = projectTrials_allLvsR(psth2, tt, MODE(imod), filt_str1, filt_str2, O.task, GP2);
%     plotProjection_allLvsR(proj_avg,  'x',substract_trialtype_num, [1,2,3,4], GP2);
%     ylabel(sprintf('Projection (a.u.)'),'FontSize',12);
%     yl = global_yl(imod,:);
%     set(gca,'Ylim',yl)
%     text(xl(1) + diff(xl)*0.5, yl(1) + diff(yl)*1.3,sprintf('%s', ylegend ),'FontSize',12, 'HorizontalAlignment','center');
%     xlabel('Trial time (s)','FontSize',12);
%     plot(tint1(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
%     plot(tint2(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
%
%     % Correct vs No-lick averaged for all trialtypes
%     axes('position',[position_x(3), position_y(imod), panel_width, panel_height]);
%     filt_str1 = '~lickearly&hit';
%     filt_str2 = '~lickearly&no';
%     ylegend = 'Correct vs No-lick (x)';
%     [proj_avg, ~] = projectTrials_allLvsR(psth2, tt, MODE(imod), filt_str1, filt_str2 , O.task, GP2);
%     plotProjection_allLvsR(proj_avg,  'x' ,substract_trialtype_num, [1,2,3,4], GP2);
%     ylabel(sprintf('Projection (a.u.)'),'FontSize',12);
%     yl = global_yl(imod,:);
%     set(gca,'Ylim',yl)
%     text(xl(1) + diff(xl)*0.5, yl(1) + diff(yl)*1.3,sprintf('%s', ylegend ),'FontSize',12, 'HorizontalAlignment','center');
%     xlabel('Trial time (s)','FontSize',12);
%     plot(tint1(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
%     plot(tint2(num,:), [yl(1), yl(1)], '-','LineWidth',5,'Color',[0.5 0.5 0.5]);
% end
%
% OUT.MODE = MODE;
% OUT.filt_mat_correct = filt_mat_correct;
% OUT.filt_mat_error = filt_mat_error;
% OUT.filt_mat_nolick = filt_mat_nolick;
%
