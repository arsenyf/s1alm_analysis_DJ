function [selectivity_struct] = fn_selectivity_cell (psth_cell, x_trialtype_num, y_trialtype_num, filt_mat, time, tint)


FR_x = psth_cell(:,logical(sum(filt_mat(:,x_trialtype_num),2)));
FR_y = psth_cell(:,logical(sum(filt_mat(:,y_trialtype_num),2)));

dt_idx = find((time>tint(1)) & (time<tint(2)));

FR_x_at_t = mean(FR_x(dt_idx,:),1);
FR_y_at_t = mean(FR_y(dt_idx,:),1);

FR_x_at_t (isnan(FR_x_at_t)) = [];
FR_y_at_t (isnan(FR_y_at_t)) = [];

selectivity = FR_x_at_t - mean(FR_y_at_t);

peak_FR_tint = max([mean(FR_x_at_t), mean(FR_y_at_t)]);

selectivity_struct.FR_x_at_t= FR_x_at_t;
selectivity_struct.FR_y_at_t= FR_y_at_t;
selectivity_struct.s_mean = mean(selectivity);
selectivity_struct.s_std = std(selectivity);
selectivity_struct.s_stem = std(selectivity)./(sqrt(sum(selectivity)));
selectivity_struct.peak_FR_tint = peak_FR_tint;
[~, selectivity_struct.pVal] = ttest2(FR_x_at_t, FR_y_at_t);
