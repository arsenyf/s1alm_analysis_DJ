function fn_plot_regression_decoding (rel, key, tuning_param_label)


minimal_num_significant_cells=2;

sessions = unique(fetchn(rel*EXP.SessionID & key, 'session_uid'));

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
% for i_s=1:1:numel(sessions)
%     k.session_uid = sessions(i_s);
%     num_signif_cells(i_s) = sum((fetchn((rel_significant_cells&rel)*EXP.SessionID & key & k, 'flag_regression_significant')));
% end
% 

% idx_include_sessions=num_signif_cells>minimal_num_significant_cells;


t=fetchn(ANL.RegressionTime3,'regression_time_start');
rmse_t  = cell2mat(fetchn(rel*EXP.SessionID & key,'rmse_regression_t','ORDER BY session_uid'));
rmse_based_on_distribution_mean_t  = cell2mat(fetchn(rel*EXP.SessionID & key,'rmse_based_on_distribution_mean_t','ORDER BY session_uid'));
rmse_t=rmse_t-rmse_based_on_distribution_mean_t;

% rmse_t=rmse_t(idx_include_sessions,:);
plot(t,rmse_t)

hold on;
plot(t,rmse_t,'g')
plot(t,mean(rmse_t,1),'b')

% plot(t,rmse_based_on_distribution_mean_t,'k')
ylim([min([min(rmse_t(:)),-0.4]), 0]);
xlim([t(1),t(end)]);

xlabel('Time (s)');
ylabel('{\Delta}  RMSE')
title(sprintf('%s, %s licks', tuning_param_label, key.lick_direction));

