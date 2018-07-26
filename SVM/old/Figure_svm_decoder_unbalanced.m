function Figure_svm_decoder_unbalanced()
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

horizontal_distance=0.2;
vertical_distance=0.3;
panel_width=0.1;
panel_height=0.1;
position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;
position_x(7)=position_x(6)+horizontal_distance;
position_x(8)=position_x(7)+horizontal_distance;

position_y(1)=0.7;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;


key.flag_include_distractor_trials=1;
rel1 = ANL.SVMdecoderSensoryMotor;
 rel2=rel1.proj('number_of_trials_svm->temp','*');
 rel2=rel2.proj('svm_performance_time->temp2','*');
 rel2=rel2.proj('time_vector_svm->temp3','*');


%% All trials
% fetch performance
% rel=ANL.SVMdecoder * ANL.SessionPosition * EXP.SessionTraining & rel2 ;
rel=ANL.SVMdecoder * ANL.SessionPosition * EXP.SessionTraining & 'number_of_trials_svm>200';

t = fetch1(rel,'time_vector_svm', 'LIMIT 1');
legend_flag=1;
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
key.training_type ='regular';
svm_performance = fn_fetch_svm_performance_unbalanced(key,rel);
fn_plot_svm_performance(svm_performance,t,legend_flag);
title(sprintf('Regular mice\n all'));

axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
key.training_type ='distractor';
svm_performance = fn_fetch_svm_performance_unbalanced(key,rel);
fn_plot_svm_performance(svm_performance,t,legend_flag);
title(sprintf('Expert mice\n all'));


%% Sensory only
% fetch performance
key.sensory_or_motor='sensory';
rel=ANL.SVMdecoderSensoryMotorUnbalanced2 * ANL.SessionPosition * EXP.SessionTraining & 'number_of_trials_svm>20';
t = fetch1(rel,'time_vector_svm', 'LIMIT 1');
legend_flag=0;
axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
key.training_type ='regular';
svm_performance = fn_fetch_svm_performance_unbalanced(key,rel);
fn_plot_svm_performance(svm_performance,t,legend_flag);
title(sprintf('Regular mice\n sensory decoding'));

axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
key.training_type ='distractor';
svm_performance = fn_fetch_svm_performance_unbalanced(key,rel);
fn_plot_svm_performance(svm_performance,t,legend_flag);
title(sprintf('Expert mice\n sensory decoding'));


%% Motor only
% fetch performance
key.sensory_or_motor='motor';
rel=ANL.SVMdecoderSensoryMotorUnbalanced2 * ANL.SessionPosition * EXP.SessionTraining & 'number_of_trials_svm>20';
t = fetch1(rel,'time_vector_svm', 'LIMIT 1');
legend_flag=0;
axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
key.training_type ='regular';
svm_performance = fn_fetch_svm_performance_unbalanced(key,rel);
fn_plot_svm_performance(svm_performance,t,legend_flag);
title(sprintf('Regular mice\n motor decoding'));

axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
key.training_type ='distractor';
svm_performance = fn_fetch_svm_performance_unbalanced(key,rel);
fn_plot_svm_performance(svm_performance,t,legend_flag);
title(sprintf('Expert mice\n motor decoding'));



dir_save_figure_full=dir_save_figure;
filename =[sprintf('fig_svm_performance')];

if isempty(dir(dir_save_figure_full))
    mkdir (dir_save_figure_full)
end
figure_name_out=[ dir_save_figure_full filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);



end




