% Fetch mean firing rates for Pyr/FS cells

function getFRdistributionForRNN()

rel=(ANL.UnitFiringRate500ms & ANL.IncludeUnit) * EPHYS.UnitCellType * EPHYS.UnitPosition * (EPHYS.Unit & 'unit_quality!="multi"') * EXP.SessionTraining;



%% Pyr cells
key.brain_area='ALM';
key.cell_type='Pyr';
% key.hemisphere='left';
key.trial_type_name='l';
query_result=fetch(rel & key ,'*');

FR_Pyr.Left.mean_fr_presample = [query_result.mean_fr_presample];
FR_Pyr.Left.mean_fr_sample = [query_result.mean_fr_sample];
FR_Pyr.Left.mean_fr_delay = [query_result.mean_fr_delay];


key.brain_area='ALM';
key.cell_type='Pyr';
key.hemisphere='left';
key.trial_type_name='r';
query_result=fetch(rel & key ,'*');

FR_Pyr.Right.mean_fr_presample = [query_result.mean_fr_presample];
FR_Pyr.Right.mean_fr_sample = [query_result.mean_fr_sample];
FR_Pyr.Right.mean_fr_delay = [query_result.mean_fr_delay];


%% FS cells
key.brain_area='ALM';
key.cell_type='FS';
% key.hemisphere='left';
key.trial_type_name='l';
query_result=fetch(rel & key ,'*');

FR_FS.Left.mean_fr_presample = [query_result.mean_fr_presample];
FR_FS.Left.mean_fr_sample = [query_result.mean_fr_sample];
FR_FS.Left.mean_fr_delay = [query_result.mean_fr_delay];


key.brain_area='ALM';
key.cell_type='FS';
key.hemisphere='left';
key.trial_type_name='r';
query_result=fetch(rel & key ,'*');

FR_FS.Right.mean_fr_presample = [query_result.mean_fr_presample];
FR_FS.Right.mean_fr_sample = [query_result.mean_fr_sample];
FR_FS.Right.mean_fr_delay = [query_result.mean_fr_delay];


%% Plotting FR histogram
hist_bins = [0:5:50];
subplot(2,2,1)
histogram(FR_Pyr.Left.mean_fr_delay,hist_bins)
xlabel('mean FR (Hz)');
ylabel('Counts');
title ('Pyr cells, left trials');
xlim([0 max(hist_bins)]);

subplot(2,2,2)
histogram(FR_Pyr.Right.mean_fr_delay,hist_bins)
xlabel('mean FR (Hz)');
ylabel('Counts');
title ('Pyr cells, right trials');
xlim([0 max(hist_bins)]);

subplot(2,2,3)
histogram(FR_FS.Left.mean_fr_delay,hist_bins)
xlabel('mean FR (Hz)');
ylabel('Counts');
title ('FS cells, left trials');
xlim([0 max(hist_bins)]);

subplot(2,2,4)
histogram(FR_FS.Right.mean_fr_delay,hist_bins)
xlabel('mean FR (Hz)');
ylabel('Counts');
title ('FS cells, right trials');
xlim([0 max(hist_bins)]);


