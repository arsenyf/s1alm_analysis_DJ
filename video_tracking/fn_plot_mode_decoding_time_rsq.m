function fn_plot_mode_decoding_time_rsq (rel, key, tuning_param_label)




t=fetch1(rel,'t_for_decoding','LIMIT 1');
rsq_t  = cell2mat(fetchn(rel*EXP.SessionID & key,'rsq_linear_regression_t','ORDER BY session_uid'));
% rmse_based_on_distribution_mean_t  = cell2mat(fetchn(rel*EXP.SessionID & key,'rmse_based_on_distribution_mean_t','ORDER BY session_uid'));
% rmse_t=rmse_t-rmse_based_on_distribution_mean_t;

hold on;
plot(t,rsq_t,'g')
plot(t,mean(rsq_t,1),'b')

% plot(t,rmse_based_on_distribution_mean_t,'k')
ylim([min(rsq_t(:)),max(rsq_t(:))]);
xlim([t(1),t(end)]);

xlabel('Time (s)');
ylabel('R^2')
title(sprintf('%s, %s licks\n', tuning_param_label, key.lick_direction));

