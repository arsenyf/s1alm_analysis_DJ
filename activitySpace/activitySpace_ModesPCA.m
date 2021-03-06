function activitySpace_ModesPCA()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\PCA\'];


key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
k=key;

if contains(k.unit_quality, 'ok or good')
    k = rmfield(k,'unit_quality')
    rel_Selectivity = (( ANL.Selectivity * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition *   EPHYS.UnitCellType * EXP.SessionTraining *  ANL.IncludeSession ) ) & ANL.IncludeUnit & k & 'unit_quality!="multi"' ;
    rel_PSTH = (( ANL.PSTHAverageLR * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining *  ANL.IncludeSession ) ) & ANL.IncludeUnit & k & 'unit_quality!="multi"' ;
else
    rel_Selectivity = (( ANL.Selectivity * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining  *  ANL.IncludeSession ) ) & ANL.IncludeUnit & k ;
    rel_PSTH = (( ANL.PSTHAverageLR * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining  *  ANL.IncludeSession ) ) & ANL.IncludeUnit & k ;
end


%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.1;
panel_height=0.09;
horizontal_distance=0.14;
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

% Params
Param = struct2table(fetch (ANL.Parameters,'*'));
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
idx_time2plot = (time>= -2.5 & time<=0);
time2plot = time(idx_time2plot);

% 
% %fetch selectivity
% unit_selectivity = movmean(cell2mat(fetchn(rel_Selectivity,'unit_selectivity')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
% unit_selectivity = unit_selectivity(:,idx_time2plot);
% %normalize to max selectivity
% max_selectivity = max(abs(unit_selectivity),[],2);
% idx_exlude = (max_selectivity==0);
% unit_selectivity=unit_selectivity./max_selectivity;
% unit_selectivity = unit_selectivity(~idx_exlude,:);
%PCA
unit_selectivity = movmean(cell2mat(fetchn(rel_PSTH,'psth_avg')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
unit_selectivity = unit_selectivity(:,idx_time2plot);



[coeff,score,~, ~, explained] = pca(unit_selectivity);
num_of_PCs=5;


%fetch selectivity
unit_selectivity = movmean(cell2mat(fetchn(rel_Selectivity,'unit_selectivity')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
unit_selectivity = unit_selectivity(:,idx_time2plot);
%normalize to max selectivity
max_selectivity = max(abs(unit_selectivity),[],2);
idx_exlude = (max_selectivity==0);
unit_selectivity=unit_selectivity./max_selectivity;
unit_selectivity = unit_selectivity(~idx_exlude,:);
%PCA
[coeff,score,~, ~, explained] = pca(unit_selectivity);
num_of_PCs=5;

axes('position',[position_x(1), position_y(1)+0.1, panel_width, panel_height*0.6]);
title(sprintf('%s %s %s', key.brain_area,key.hemisphere,key.training_type));
axis off;
box off;
for i_PC = 1:num_of_PCs
    axes('position',[position_x(i_PC), position_y(1), panel_width, panel_height]);
    hold on;
    plot([t_go t_go], [-0.1 0.1], 'k-','LineWidth',2);
    plot([t_chirp1 t_chirp1], [-0.1 0.1], 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], [-0.1 0.1], 'k--','LineWidth',0.75);
    
    plot(time2plot, coeff(:,i_PC))
    xlabel('Time');
    ylabel(['PC ' num2str(i_PC)]);
    
    xlim([time2plot(1),time2plot(end)]);
        ylim([min(coeff(:,i_PC)) max(coeff(:,i_PC))]);

    title (sprintf('Variance \nexplained %.1f %%',explained(i_PC)));
end






if contains(key.unit_quality, 'ok or good')
    key.unit_quality = 'ok';
end

filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s_PCA' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type)];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);



end




