function [OUT, GP] = plotModes_2D (rel,Param, xposition,title1, title2, title3, ylabel_flag, flag_normalize_modes)


panel_width=0.06;
panel_height=0.07;
horizontal_distance=0.1;
vertical_distance=0.12;

position_x(1)=0.1;
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
position_y(6)=position_y(5)-vertical_distance;



mode_names = unique(fetchn(rel,'mode_type_name'))';

% mode_names = {'Ramping Orthog.', 'Stimulus Orthog.', 'LateDelay'};
% mode_names_titles = {'Ramping', 'Stimulus', 'Choice'};
mode_names = {'Left vs. baseline', 'Stimulus Orthog.', 'Right vs. baseline'};
mode_names_titles = {'Left', 'Stimulus', 'Right'};
% mode_names = {'Stimulus Orthog.','EarlyDelay Orthog.', 'LateDelay'};
% mode_names_titles = {'Stimulus','Early Selectivity', 'Late Selectivity'};

% mode_names = {'Stimulus','EarlyDelay','LateDelay','Stimulus Orthog.','EarlyDelay Orthog.','LateDelay Orthog.','Ramping Orthog.','Movement Orthog.'};


trialtype_uid = unique(fetchn(rel,'trialtype_uid'));

for imod = 1:1:numel(mode_names)
    key_mode.mode_type_name = mode_names{imod};
    key_mode.mode_title = mode_names_titles{imod};
    
    key_mode.outcome = 'hit'; 
    %     trial_type_substract='l';
    trial_type_substract=[];
    PROJ2D_hit(imod) = fn_getProjection(Param, rel, key_mode, trial_type_substract,  flag_normalize_modes);
    
    key_mode.outcome = 'miss'; 
    %     trial_type_substract='l';
    trial_type_substract=[];
    PROJ2D_miss(imod) = fn_getProjection(Param, rel, key_mode, trial_type_substract, flag_normalize_modes);
    
    key_mode.outcome = 'ignore';
    %     trial_type_substract='l';
    trial_type_substract=[];
    PROJ2D_ignore(imod) = fn_getProjection(Param, rel, key_mode, trial_type_substract,  flag_normalize_modes);
    
end
if flag_normalize_modes==1
    ax_lims(1,:)=[-0.3,1];
    ax_lims(2,:) = [-0.3,1];
    ax_lims(3,:) = [-0.3,1];
else
    ax_lims(1,:) = [-2,25];
    ax_lims(2,:) = [-3,17];
    ax_lims(3,:) = [-5,25];
%    ax_lims(1,:) = [-2,26];
%     ax_lims(2,:) = [-3,17];
%     ax_lims(3,:) = [-5,33];
end
%
% if ylabel_flag==1
%     text ((xl(1)-diff(xl)*0.35), (yl(1) + diff(yl)*0.5), sprintf('%s\n(a.u.)',mode_names_titles{imod}),'Fontsize', 10,'Rotation',90,'VerticalAlignment','middle','HorizontalAlignment','center');
% end
axes('position',[position_x(xposition), position_y(1)+0.03, panel_width, panel_height*1]);
% fn_plot_trial_legend (trialtype_uid);
xlim([-4 0.5]);
axis off;
box off;
ax=gca;
yl=ax.YLim;
text (-2, (yl(1) + diff(yl)*1.4), sprintf('%s\n\n%s\n\n%s',title3,title1, title2),'Fontsize', 10,'VerticalAlignment','middle','HorizontalAlignment','center','FontWeight','bold');

%% Correct
% Stimulus vs Ramping
axes('position',[position_x(xposition), position_y(1), panel_width, panel_height]);
correct_error_label='Correct';
order = [1 2 3];
fn_plot_projection_2D (PROJ2D_hit, order, ylabel_flag, correct_error_label, ax_lims)

% LateDelay vs Ramping
axes('position',[position_x(xposition), position_y(2), panel_width, panel_height]);
correct_error_label='Correct';
order = [1 3 2];
fn_plot_projection_2D (PROJ2D_hit, order, ylabel_flag, correct_error_label, ax_lims)

% Stimulus vs Ramping
axes('position',[position_x(xposition), position_y(3), panel_width, panel_height]);
correct_error_label='Error';
order = [1 2 3];
fn_plot_projection_2D (PROJ2D_miss, order, ylabel_flag, correct_error_label, ax_lims)

% LateDelay vs Ramping
axes('position',[position_x(xposition), position_y(4), panel_width, panel_height]);
correct_error_label='Error';
order = [1 3 2];
fn_plot_projection_2D (PROJ2D_miss, order, ylabel_flag, correct_error_label, ax_lims)

% Stimulus vs Ramping
axes('position',[position_x(xposition), position_y(5), panel_width, panel_height]);
correct_error_label='Ignore';
order = [1 2 3];
fn_plot_projection_2D (PROJ2D_ignore, order, ylabel_flag, correct_error_label, ax_lims)

% LateDelay vs Ramping
axes('position',[position_x(xposition), position_y(6), panel_width, panel_height]);
correct_error_label='Ignore';
order = [1 3 2];
fn_plot_projection_2D (PROJ2D_ignore, order, ylabel_flag, correct_error_label, ax_lims)

