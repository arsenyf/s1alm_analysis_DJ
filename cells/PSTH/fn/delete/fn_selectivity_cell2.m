function [s_struct] = fn_selectivity_cell2 (psth_cell, x_trialtype_num, y_trialtype_num, filt_mat, tint, min_num_trials, GP)

dt_idx = find((GP.time>tint(1)) & (GP.time<tint(2)));

FR_x = psth_cell(dt_idx,logical(sum(filt_mat(:,x_trialtype_num),2)));
FR_y = psth_cell(dt_idx,logical(sum(filt_mat(:,y_trialtype_num),2)));

if sum(~isnan(mean(FR_x,1)))< min_num_trials || sum(~isnan(mean(FR_y,1)))< min_num_trials %if there are too few trials
        FR_x_mean = mean(FR_x,2)' +NaN;
        FR_y_mean = mean(FR_y,2)'+ NaN;
        pVal(1:1:numel(dt_idx))=NaN;
        reject_cell_flag = 1;
else
            reject_cell_flag = 0;

    for ii_t=1:1:numel(dt_idx)
%         if (sum(~isnan(FR_x(ii_t,:))) & sum(~isnan(FR_y(ii_t,:)))) % only if there is data
            pVal(ii_t) = ranksum(FR_x(ii_t,:),FR_y(ii_t,:));
% %         else
%             pVal(ii_t)=NaN;
%         end
    end
    FR_x_mean = nanmean(FR_x,2)' ;
FR_y_mean = nanmean(FR_y,2)';
end

peak_FR = max([FR_x_mean, FR_y_mean]);

s_mean = FR_x_mean - FR_y_mean;
s_mean_norm = s_mean./peak_FR;

concat_XY = [FR_x_mean,FR_y_mean];
concat_XY_norm = concat_XY./peak_FR;

s_struct.peak_FR = peak_FR;
s_struct.s_mean = s_mean;
s_struct.s_mean_norm = s_mean_norm;
s_struct.pVal = pVal;

s_struct.concat_XY = concat_XY;
s_struct.concat_XY_norm = concat_XY_norm;
s_struct.reject_cell_flag = reject_cell_flag;