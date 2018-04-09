function [OUT, GP] = plotModes (rel,Param, key_mode)


panel_width=0.076;
panel_height=0.09;
horizontal_distance=0.12;
vertical_distance=0.18;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;
position_x(7)=position_x(6)+horizontal_distance;
position_x(8)=position_x(7)+horizontal_distance;

position_y(1)=0.75;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;



mode_names = unique(fetchn(rel,'mode_type_name'))';
% mode_names = mode_names(~contains(mode_names, 'orthogonal'))
% mode_names = mode_names(contains(mode_names, 'orthogonal'))

% mode_names = {'Stimulus','EarlyDelay','LateDelay','Ramping'};
for imod = 1:1:numel(mode_names)
    key_mode.mode_type_name = mode_names{imod};
    axes('position',[position_x(imod), position_y(1), panel_width, panel_height]);
    hold on
    key_mode.outcome = 'hit';
    %     key_mode.trial_type_name = 'l';
    trial_type_substract='l';
%     trial_type_substract=[];
    fn_plotProjection(Param, rel, key_mode, trial_type_substract)
    
    axes('position',[position_x(imod), position_y(2), panel_width, panel_height]);
    hold on
    key_mode.outcome = 'miss';
    %     key_mode.trial_type_name = 'l';
    % trial_type_substract='l';
    trial_type_substract=[];
    fn_plotProjection(Param, rel, key_mode, trial_type_substract)
    title(sprintf('%s',mode_names{imod}));
    axes('position',[position_x(imod), position_y(3), panel_width, panel_height]);
    hold on
    key_mode.outcome = 'ignore';
    %     key_mode.trial_type_name = 'l';
    % trial_type_substract='l';
    trial_type_substract=[];
    fn_plotProjection(Param, rel, key_mode, trial_type_substract)
    
   
    
end

