function compute_noise_corr()
close all;
dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\noise_correlations\'];
filename = 'noise_correlations';

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 3 23 25]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);

plot_counter=0;
% k.training_type='distractor';
% k.unit_quality='ok or good';
k.flag_include_distractor_trials=0;

%%
k.outcome='hit';
k.time_interval_correlation_description='pre-sample';

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[];
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);


%%
k.outcome='miss';
k.time_interval_correlation_description='pre-sample';

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[];
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);


%%
k.outcome='hit';
k.time_interval_correlation_description='delay';

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[];
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

%%
k.outcome='miss';
k.time_interval_correlation_description='delay';

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'Pyr';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[]; 
key.brain_area = 'vS1';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

key=[];
key.brain_area = 'ALM';
% key.hemisphere = 'left';
key.cell_type = 'FS';
plot_counter=plot_counter+1;
subplot(4,4,plot_counter)
[pairwise_corr,pairwise_cov]=fn_extract_noise_corr_from_matrix(key, k);

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);