function  fn_plot_projection_2D (proj2D,order, ylabel_flag, correct_error_label,  ax_lims)

for itype= 1:1:size([proj2D.p],1)
    hold on;
    stim_onset_idx(1) = proj2D(1).stim_onset_idx(itype,1);
        stim_onset_idx(2) = proj2D(1).stim_onset_idx(itype,end);

    plot3(proj2D(order(1)).p(itype,:), proj2D(order(2)).p(itype,:), proj2D(order(3)).p(itype,:),  'Color', proj2D(1).rgb(itype,:),'LineWidth',0.75)
    plot3(proj2D(order(1)).p(itype,end), proj2D(order(2)).p(itype,end), proj2D(order(3)).p(itype,end), 'o',  'Color', proj2D(1).rgb(itype,:),'MarkerSize',3)
    if ~isnan(stim_onset_idx)
%         plot3(proj2D(order(1)).p(itype,stim_onset_idx(1)), proj2D(order(2)).p(itype,stim_onset_idx(1)), proj2D(order(3)).p(itype,stim_onset_idx(1)), '.',  'Color', proj2D(1).rgb(itype,:),'MarkerSize',18)
%         plot3(proj2D(order(1)).p(itype,stim_onset_idx(end)), proj2D(order(2)).p(itype,stim_onset_idx(end)), proj2D(order(3)).p(itype,stim_onset_idx(end)), '.',  'Color', proj2D(1).rgb(itype,:),'MarkerSize',18)
    end
end
if ylabel_flag==1
    xlabel(sprintf('%s', proj2D(order(1)).mode_title))
    ylabel(sprintf('%s trials \n \n%s',correct_error_label, proj2D(order(2)).mode_title))
    zlabel(sprintf('%s', proj2D(order(3)).mode_title))
   
end
xlim(ax_lims(order(1),:));
ylim(ax_lims(order(2),:));
zlim(ax_lims(order(3),:));
box off;