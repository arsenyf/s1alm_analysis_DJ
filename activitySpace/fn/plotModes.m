function [OUT, GP] = plotModes (rel,Param)


panel_width=0.08;
panel_height=0.09;
horizontal_distance=0.12;
vertical_distance=0.15;

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



mode_names = unique(fetchn(rel,'mode_type_name'))';
% mode_names = mode_names(~contains(mode_names, 'orthogonal'))
% mode_names = mode_names(contains(mode_names, 'orthogonal'))

mode_names = {'Stimulus','EarlyDelay','LateDelay','Stimulus Orthog.','EarlyDelay Orthog.','LateDelay Orthog.','Ramping Orthog.','Movement Orthog.'};
mode_names_titles = mode_names; 

% mode_names_titles = {'Stimulus','EarlyDelay','LateDelay','Stimulus orthogonal to EarlyDelay','Stimulus ort. LD', 'EarlyDelay ort. LD', 'LD ort. Movement', 'LD ort. ED'};
trialtype_uid = unique(fetchn(rel,'trialtype_uid'));

for imod = 1:1:numel(mode_names)
    key_mode.mode_type_name = mode_names{imod};
    
    axes('position',[position_x(imod), position_y(1)+0.1, panel_width, panel_height*0.6]);
    fn_plot_trial_legend (trialtype_uid);
    title(sprintf('%s\n',mode_names_titles{imod}));
    xlim([-4.5 1.5]);
    axis off;
    box off;
    
    axes('position',[position_x(imod), position_y(1), panel_width, panel_height]);
    hold on
    key_mode.outcome = 'hit'; ylab='Correct';
%     trial_type_substract='l';
        trial_type_substract=[];
    fn_plotProjection(Param, rel, key_mode, trial_type_substract, ylab)
    
    axes('position',[position_x(imod), position_y(2), panel_width, panel_height]);
    hold on
    key_mode.outcome = 'miss'; ylab='Error';
    % trial_type_substract='l';
    trial_type_substract=[];
    fn_plotProjection(Param, rel, key_mode, trial_type_substract, ylab)
    
    axes('position',[position_x(imod), position_y(3), panel_width, panel_height]);
    hold on
    key_mode.outcome = 'ignore'; ylab='No-lick';
    % trial_type_substract='l';
    trial_type_substract=[];
    fn_plotProjection(Param, rel, key_mode, trial_type_substract, ylab)
    
    
    
end

