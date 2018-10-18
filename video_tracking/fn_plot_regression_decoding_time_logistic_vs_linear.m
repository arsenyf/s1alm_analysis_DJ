function fn_plot_regression_decoding_time_logistic_vs_linear (rel, key, tuning_param_label)


% minimal_num_significant_cells=0;

sessions = unique(fetchn(rel*EXP.SessionID & key, 'session_uid'));

% for i_s=1:1:numel(sessions)
%     k.session_uid = sessions(i_s);
%     num_signif_cells(i_s) = sum((fetchn((rel_significant_cells&rel)*EXP.SessionID & key & k, 'flag_regression_significant')));
% end




% k.regression_time_start=round(-0.2,4);
% rel_significant_cells=ANL.RegressionTongueSingleUnit2* ANL.SessionPosition*EXP.SessionTraining*EXP.SessionID & ANL.RegressionDecoding2 & key;
% 
% for i_s=1:1:numel(sessions)
%     k.session_uid = sessions(i_s);
%     a=fetch(rel_significant_cells & k,'*');
%     rel_temp=(rel_significant_cells&rel & key & k & 'regression_rsq>0.1');
%     num_signif_cells(i_s) = rel_temp.count;
% end

% 

% 

% idx_include_sessions=num_signif_cells>minimal_num_significant_cells;


t=fetch1(rel,'t_for_decoding','LIMIT 1');
rsq_linear_regression_t  = cell2mat(fetchn(rel*EXP.SessionID & key,'rsq_linear_regression_t','ORDER BY session_uid'));
rsq_logistic_regression_t  = cell2mat(fetchn(rel*EXP.SessionID & key,'rsq_logistic_regression_t','ORDER BY session_uid'));


% rsq_linear_regression_t=rsq_linear_regression_t(idx_include_sessions,:);
% rsq_logistic_regression_t=rsq_logistic_regression_t(idx_include_sessions,:);

hold on;


plot(t,rsq_linear_regression_t,'c')
if strcmp(key.lick_direction,'all')
plot(t,rsq_logistic_regression_t,'Color',[1 0.9 1])
plot(t,nanmean(rsq_logistic_regression_t,1),'m')
end
plot(t,nanmean(rsq_linear_regression_t,1),'b')


% plot(t,rmse_based_on_distribution_mean_t,'k')
% ylim([ min([rmse_linear_regression_t(:);rmse_logistic_regression_t(:)]) 0]);
ylim([ 0  max([rsq_linear_regression_t(:);rsq_logistic_regression_t(:)])]);

xlim([t(1),t(end)]);

xlabel('Time (s)');
ylabel('R^2')
title(sprintf('%s, %s licks\n', tuning_param_label, key.lick_direction));

