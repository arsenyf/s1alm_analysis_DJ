function  fn_plot_CD_rotation(time,r)

imagesc(time,time,r);
axx=gca;
colormap jet;
c = colorbar;
cbar_x =axx.Position(1) + axx.Position(3)*1.05;
cbar_y =axx.Position(2) + axx.Position(4)/6;
cbar_width =0.01;
cbar_height= axx.Position(4)/2;
c.Position=[cbar_x cbar_y cbar_width cbar_height];
c.Ticks=[0,1];
c.Label.String = 'r';
cbar_label_x = c.Label.Position(1);
cbar_label_y = c.Label.Position(2);
cbar_label_z = c.Label.Position(3);
c.Label.Position(1) = cbar_label_x-1.2;
c.Label.FontAngle ='italic';
c.Label.FontSize =10;
c.Label.FontWeight ='bold';

set(gca,'Fontsize',10);
hold on;
plot([ time(1) time(end)], [-3 -3 ], 'w-','LineWidth',0.7);
plot([ time(1) time(end)], [-2.15 -2.15], 'w-','LineWidth',0.7);
plot([ time(1) time(end)], [0 0 ], 'w-','LineWidth',0.7);
plot([ -3 -3 ], [time(1) time(end)], 'w-','LineWidth',0.7);
plot([ -2.15 -2.15 ], [time(1) time(end)], 'w-','LineWidth',0.7);
plot([ 0 0 ], [time(1) time(end)], 'w-','LineWidth',0.7);

% text(-3.5,-3.7,'Presam.','fontsize',9,'Rotation',10,'HorizontalAlignment','left');
text(-3.2,-4.3,'Sample','fontsize',9,'Rotation',0,'HorizontalAlignment','left');
text(-1.5,-4.3,'Delay','fontsize',9,'Rotation',0,'HorizontalAlignment','left');
text(0,-4.3,'Response','fontsize',9,'Rotation',0,'HorizontalAlignment','left');

% text(-3.7,-3.5,'Presam.','fontsize',9,'Rotation',10,'HorizontalAlignment','left');
text(-4.3,-3.2,'Sample','fontsize',9,'Rotation',+90,'HorizontalAlignment','right');
text(-4.3,-1.5,'Delay','fontsize',9,'Rotation',+90,'HorizontalAlignment','right');
text(-4.3,0,'Response','fontsize',9,'Rotation',+90,'HorizontalAlignment','right');
set(gca,'Fontsize',10,'YAxisLocation','right', 'fontname', 'helvetica','Xtick',[-4:1:1],'Ytick',[-4:1:1]);
axis equal;

text(1.8,2,'Time (s)','fontsize',10,'Rotation',45,'HorizontalAlignment','center');


xlim([-3.9 1.5])
ylim([-3.9 1.5])
% axis tight;
