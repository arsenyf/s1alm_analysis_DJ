function Figure_svm_decoder_time()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root '\Results\SVM_decoder\'];

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);

panel_width=0.17;
panel_height=0.17;
horizontal_distance=0.2;
vertical_distance=0.27;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance; 
position_x(3)=position_x(2)+horizontal_distance;

position_y(1)=0.68;
position_y(2)=position_y(1)- vertical_distance;
position_y(3)=position_y(2)- vertical_distance;

key.flag_include_distractor_trials=1;
rel=ANL.SVMdecoderTime * ANL.SessionPosition * EXP.SessionTraining ;
t = fetch1(rel,'time_vector_svm', 'LIMIT 1');

%% ALM,left regular
% fetch performance

key.brain_area = 'ALM';
key.hemisphere = 'left';
key.training_type ='regular';
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
svm_performance_mat = (fetchn(rel & key,'svm_performance_mean_time_mat'));
time_mat=[];
for i=1:1:size(svm_performance_mat,1)
    time_mat(i,:,:)=svm_performance_mat{i};
end
time_mat = 100*squeeze(mean(time_mat,1));
fn_plot_svm_decoder_rotation(t,time_mat);
title(sprintf('Regular mice \n ALM left\n\n'))
freezeColors;

%% ALM,left Expert
key.training_type ='distractor';
axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
svm_performance_mat = (fetchn(rel & key,'svm_performance_mean_time_mat'));
time_mat=[];
for i=1:1:size(svm_performance_mat,1)
    time_mat(i,:,:)=svm_performance_mat{i};
end
time_mat = 100*squeeze(mean(time_mat,1));
fn_plot_svm_decoder_rotation(t,time_mat);
title(sprintf('Expert mice \n ALM left\n\n'))
freezeColors;

%% ALM,right regular
% fetch performance

key.brain_area = 'ALM';
key.hemisphere = 'right';
key.training_type ='regular';
axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
svm_performance_mat = (fetchn(rel & key,'svm_performance_mean_time_mat'));
time_mat=[];
for i=1:1:size(svm_performance_mat,1)
    time_mat(i,:,:)=svm_performance_mat{i};
end
time_mat = 100*squeeze(mean(time_mat,1));
fn_plot_svm_decoder_rotation(t,time_mat);
title(sprintf('Regular mice \n ALM right\n\n'))
freezeColors;

%% ALM,right Expert
key.training_type ='distractor';
axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
svm_performance_mat = (fetchn(rel & key,'svm_performance_mean_time_mat'));
time_mat=[];
for i=1:1:size(svm_performance_mat,1)
    time_mat(i,:,:)=svm_performance_mat{i};
end
time_mat = 100*squeeze(mean(time_mat,1));
fn_plot_svm_decoder_rotation(t,time_mat);
title(sprintf('Expert mice \n ALM right\n\n'))
freezeColors;

%% vS1,left regular
% fetch performance
key.brain_area = 'vS1';
key.hemisphere = 'left';
key.training_type ='regular';
axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
svm_performance_mat = (fetchn(rel & key,'svm_performance_mean_time_mat'));
time_mat=[];
for i=1:1:size(svm_performance_mat,1)
    time_mat(i,:,:)=svm_performance_mat{i};
end
time_mat = 100*squeeze(mean(time_mat,1));
fn_plot_svm_decoder_rotation(t,time_mat);
title(sprintf('Regular mice \n vS1 left\n\n'))
freezeColors;

%% vS1,left Expert
key.training_type ='distractor';
axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
svm_performance_mat = (fetchn(rel & key,'svm_performance_mean_time_mat'));
time_mat=[];
for i=1:1:size(svm_performance_mat,1)
    time_mat(i,:,:)=svm_performance_mat{i};
end
time_mat = 100*squeeze(mean(time_mat,1));
fn_plot_svm_decoder_rotation(t,time_mat);
title(sprintf('Expert mice \n vS1 left\n\n'))
freezeColors;

dir_save_figure_full=dir_save_figure;
filename =[sprintf('fig_svm_performance_time_rotation')];

if isempty(dir(dir_save_figure_full))
    mkdir (dir_save_figure_full)
end
figure_name_out=[ dir_save_figure_full filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
