function [OUT, GP] = get_ramping_magnitude (rel,  Param)

panel_width=0.1;
panel_height=0.1;
horizontal_distance=0.15;
vertical_distance=0.17;

position_x(1)=0.1;
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

mode_names = {'Stimulus Orthog.','LateDelay', 'Ramping Orthog.'};
mode_names_titles = {'Stimulus','Late Selectivity', 'Ramping'};

% mode_names = {'Stimulus Orthog.','EarlyDelay Orthog.', 'LateDelay'};
% mode_names_titles = {'Stimulus','Early Selectivity', 'Late Selectivity'};

% mode_names = {'Stimulus','EarlyDelay','LateDelay','Stimulus Orthog.','EarlyDelay Orthog.','LateDelay Orthog.','Ramping Orthog.','Movement Orthog.'};


trialtype_uid = unique(fetchn(rel,'trialtype_uid'));

for imod = 1:1:numel(mode_names)
    key_mode.mode_type_name = mode_names{imod};
    key_mode.mode_title = mode_names_titles{imod};
    
    key_mode.outcome = 'hit'; ylab='Correct';
    %     trial_type_substract='l';
    trial_type_substract=[];
    proj2D_hit(imod) = fn_getProjection_magnitude(Param, rel, key_mode, trial_type_substract, ylab)
    
    key_mode.outcome = 'miss'; ylab='Correct';
    %     trial_type_substract='l';
    trial_type_substract=[];
    proj2D_miss(imod) = fn_getProjection(Param, rel, key_mode, trial_type_substract, ylab)
    
    key_mode.outcome = 'ignore'; ylab='Correct';
    %     trial_type_substract='l';
    trial_type_substract=[];
    proj2D_ignore(imod) = fn_getProjection(Param, rel, key_mode, trial_type_substract, ylab)
    
end
xl=[-25,27];
yl1= [-5,20];
yl2= [-5,40];
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
% Stim vs LateDelay
axes('position',[position_x(xposition), position_y(1), panel_width, panel_height]);

for itype= 1:1:size([proj2D_hit.p],1)
    hold on;
    plot(proj2D_hit(2).p(itype,:),proj2D_hit(1).p(itype,:),  'Color', proj2D_hit(2).rgb(itype,:),'LineWidth',2)
    plot(proj2D_hit(2).p(itype,1),proj2D_hit(1).p(itype,1),'.',  'Color', proj2D_hit(2).rgb(itype,:),'MarkerSize',18)
    plot(proj2D_hit(2).p(itype,end), proj2D_hit(1).p(itype,end),'o',  'Color', proj2D_hit(2).rgb(itype,:));
end
if ylabel_flag==1
xlabel(sprintf('%s', proj2D_hit(2).mode_title))
ylabel(sprintf('Correct trials \n \n%s', proj2D_hit(1).mode_title))
end
xlim(xl);
ylim(yl1);
box off;

% Ramping vs LateDelay
axes('position',[position_x(xposition), position_y(2), panel_width, panel_height]);
for itype= 1:1:size([proj2D_hit.p],1)
    hold on;
    plot(proj2D_hit(2).p(itype,:),proj2D_hit(3).p(itype,:),  'Color', proj2D_hit(2).rgb(itype,:),'LineWidth',2)
    plot(proj2D_hit(2).p(itype,1),proj2D_hit(3).p(itype,1),'.',  'Color', proj2D_hit(2).rgb(itype,:),'MarkerSize',18)
    plot(proj2D_hit(2).p(itype,end), proj2D_hit(3).p(itype,end),'o',  'Color', proj2D_hit(2).rgb(itype,:));
end
if ylabel_flag==1
xlabel(sprintf('%s', proj2D_hit(2).mode_title))
ylabel(sprintf('Correct trials \n \n%s', proj2D_hit(3).mode_title))
end
xlim(xl);
ylim(yl2);
box off;

%% Error
axes('position',[position_x(xposition), position_y(3), panel_width, panel_height]);

for itype= 1:1:size([proj2D_hit.p],1)
    hold on;
    plot(proj2D_miss(2).p(itype,:),proj2D_miss(1).p(itype,:),  'Color', proj2D_miss(2).rgb(itype,:),'LineWidth',2)
    plot(proj2D_miss(2).p(itype,1),proj2D_miss(1).p(itype,1),'.',  'Color', proj2D_miss(2).rgb(itype,:),'MarkerSize',18)
    plot(proj2D_miss(2).p(itype,end), proj2D_miss(1).p(itype,end),'o',  'Color', proj2D_miss(2).rgb(itype,:));
end
if ylabel_flag==1
xlabel(sprintf('%s', proj2D_miss(2).mode_title))
ylabel(sprintf('Error trials \n \n%s', proj2D_miss(1).mode_title))
end
xlim(xl);
ylim(yl1);
box off;

% Ramping vs LateDelay
axes('position',[position_x(xposition), position_y(4), panel_width, panel_height]);
for itype= 1:1:size([proj2D_miss.p],1)
    hold on;
    plot(proj2D_miss(2).p(itype,:),proj2D_miss(3).p(itype,:),  'Color', proj2D_miss(2).rgb(itype,:),'LineWidth',2)
    plot(proj2D_miss(2).p(itype,1),proj2D_miss(3).p(itype,1),'.',  'Color', proj2D_miss(2).rgb(itype,:),'MarkerSize',18)
    plot(proj2D_miss(2).p(itype,end), proj2D_miss(3).p(itype,end),'o',  'Color', proj2D_miss(2).rgb(itype,:));
end
if ylabel_flag==1
xlabel(sprintf('%s', proj2D_miss(2).mode_title))
ylabel(sprintf('Error trials \n \n%s', proj2D_miss(3).mode_title))
end
xlim(xl);
ylim(yl2);
box off;