key.brain_area = 'ALM';
key.hemisphere = 'both';
key.training_type = 'all';
key.cell_type = 'Pyr';
key.outcome_grouping='all';
key.flag_use_basic_trials=0;
key.tuning_param_name='lick_rt_video_onset'; 
key.lick_direction='all';

rel=ANL.RegressionRotationAverage2 ;
regress_mat_timebin_vector=fetch1 (rel & key,'regress_mat_timebin_vector');
blank1=diag(ones(numel(regress_mat_timebin_vector),1)+NaN);
blank2=diag([ones(numel(regress_mat_timebin_vector)-1,1)+NaN],1);
% blank3=diag([ones(numel(regress_mat_timebin_vector)-1,1)+NaN],-1);
blank=blank1 + blank2 ;


subplot(2,2,1)
r_s_avg=fetch1 (rel & key,'avg_regress_b2_mat_corr');
imagescnan(regress_mat_timebin_vector,regress_mat_timebin_vector,r_s_avg+blank)
colorbar
title('regression coefficient');

subplot(2,2,2)
r_s_avg=fetch1 (rel & key,'avg_regress_rsq_mat_corr');
regress_mat_timebin_vector=fetch1 (rel & key,'regress_mat_timebin_vector');
imagescnan(regress_mat_timebin_vector,regress_mat_timebin_vector,r_s_avg+blank)
colorbar
title('R^2');

subplot(2,2,3)
r_s_avg=fetch1 (rel & key,'avg_regress_weights_mat_corr');
regress_mat_timebin_vector=fetch1 (rel & key,'regress_mat_timebin_vector');
imagescnan(regress_mat_timebin_vector,regress_mat_timebin_vector,r_s_avg+blank)
colorbar
title('weights= beta X R^2');


subplot(2,2,4)
r_s_avg=fetch1 (rel & key,'avg_regress_weights2_mat_corr');
regress_mat_timebin_vector=fetch1 (rel & key,'regress_mat_timebin_vector');
imagescnan(regress_mat_timebin_vector,regress_mat_timebin_vector,r_s_avg+blank)
colorbar
title('weights= beta X surprise');
