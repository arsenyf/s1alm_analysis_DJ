function fn_plot_reconstruction_population_scatter (oneDnum_plot , recNum_plot, tuning_param_name, tuning_param_label, key, rel_reconstruction, counter)

for oneDnum=1:1:numel(tuning_param_name)
    key.tuning_param_name=tuning_param_name{oneDnum};
    for recNum=1:1:numel(tuning_param_name)
        key_recon.reconstruction_tuning_param_name=tuning_param_name{recNum};
        if oneDnum==recNum
            TUNING_RECON.oneD{oneDnum}.reconstructBy{recNum}=[];
        else
            TUNING_RECON.oneD{oneDnum}.reconstructBy{recNum}=struct2table(fetch (EPHYS.Unit * (rel_reconstruction & key & key_recon),'*','ORDER BY unit_uid'));
        end
    end
end

for oneDnum=1:1:numel(tuning_param_name)
    for recNum=1:1:numel(tuning_param_name)
        if oneDnum==recNum
            continue
        end
        rec_error(oneDnum,recNum,:)=TUNING_RECON.oneD{oneDnum}.reconstructBy{recNum}.reconstruction_error;
    end
end


hold on
rec_x=squeeze(rec_error(oneDnum_plot,recNum_plot,:));
rec_y=squeeze(rec_error(recNum_plot,oneDnum_plot,:));
plot(rec_x,rec_y,'.k')
xl=[0,nanmax([rec_x;rec_y])];
yl=[0,nanmax([rec_x;rec_y])];

plot(xl,yl,'-k')

above_diag=100*sum(rec_y>rec_x)/numel(rec_x);
below_diag=100*sum(rec_y<=rec_x)/numel(rec_x);
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*0.9,sprintf('%.1f %%',above_diag));
text(xl(1)+diff(xl)*0.9, yl(1)+diff(yl)*0.8,sprintf('%.1f %%',below_diag));


xlim(xl);
ylim(yl);
xlabel(sprintf('%s by %s' , tuning_param_label{oneDnum_plot}, tuning_param_label{recNum_plot}));
ylabel(sprintf('%s by %s' , tuning_param_label{recNum_plot}, tuning_param_label{oneDnum_plot}));
if counter==1
title(sprintf('%s significant cells at t = %.1f s, %s licks \n Reconstruction error', tuning_param_label{oneDnum_plot},key.time_window_start, key.lick_direction),'HorizontalAlignment','Center');
else
    title(sprintf('\n Reconstruction error'));
end
axis tight
