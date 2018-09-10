function analysis_tongue_tuning()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\tuning2D\'];

Param = struct2table(fetch (ANL.Parameters,'*'));
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
len = 0.4;
sz = [0 200];

xdat = [0 0 len len];
ydat = [sz(1) sz(2) sz(2) sz(1)];



figure1=figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);

key_1D.smooth_flag=1;
key_2D.smooth_flag=1;

% key1.brain_area='ALM';
% key1.hemisphere='left';
key1.cell_type='Pyr';
key2.outcome='all';
key2.smooth_flag=1;
key2.tuning_param_name_x='lick_horizoffset_relative';
key2.tuning_param_name_y='lick_peak_x';
key2.time_window_start=-0.4;
rel1= (ANL.UnitTongue2DTuning*ANL.UnitTongue2DTuningSignificance & key2  & 'number_of_trials>100' & 'number_of_spikes_window>100' & 'stability_odd_even_corr_r>=0.5' & 'tongue_tuning_2d_peak_fr>3')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key1 ) ;
key2.time_window_start=0;
rel2=(ANL.UnitTongue2DTuning*ANL.UnitTongue2DTuningSignificance & key2  & 'number_of_trials>100' & 'number_of_spikes_window>100' & 'stability_odd_even_corr_r>=0.5' & 'tongue_tuning_2d_peak_fr>3')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key1 ) ;

relSignif=(EPHYS.Unit & 'unit_quality!="multi"') & (rel1 | rel2);

UNITS=struct2table(fetch(relSignif*EPHYS.UnitPosition*EPHYS.UnitCellType ,'*','ORDER BY unit_uid'));


time_window_start=([-0.4, 0]);
time_window_end=([0, 0.2]);
tuning_param_name{1}='lick_horizoffset_relative';
tuning_param_name{2}='lick_peak_x';


num=1;
key_time.time_window_start=time_window_start(num);
key_1D.tuning_param_name=tuning_param_name{1};
TUNING{1}.X=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & relSignif & key_1D & key_time),'*','ORDER BY unit_uid'));
key_1D.tuning_param_name=tuning_param_name{2};
TUNING{1}.Y=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & relSignif & key_1D & key_time),'*','ORDER BY unit_uid'));
TUNING{1}.XY=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue2DTuning*ANL.UnitTongue2DTuningSignificance  & relSignif & key_2D  & key_time),'*','ORDER BY unit_uid'));

num=2;
key_time.time_window_start=time_window_start(num);
key_1D.tuning_param_name=tuning_param_name{1};
TUNING{2}.X=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & relSignif & key_1D & key_time),'*','ORDER BY unit_uid'));
key_1D.tuning_param_name=tuning_param_name{2};
TUNING{2}.Y=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & relSignif & key_1D & key_time),'*','ORDER BY unit_uid'));
TUNING{2}.XY=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue2DTuning*ANL.UnitTongue2DTuningSignificance  & relSignif  & key_2D & key_time),'*','ORDER BY unit_uid'));


histogram(TUNING{1}.XY.stability_odd_even_corr_r)


hist_bins_centers=TUNING{1}.X.hist_bins_centers(1,:);
hist_bins_centers_x=TUNING{1}.XY.hist_bins_centers_x (1,:);
hist_bins_centers_y=TUNING{1}.XY.hist_bins_centers_y (1,:);

for i_u=1:1:size(TUNING{1}.X,1)
    
    num=1;
    subplot(3,3,1)
    X=TUNING{num}.X.tongue_tuning_1d(i_u,:);
    stability=TUNING{num}.X.stability_odd_even_corr_r(i_u,:);
    SI=TUNING{num}.X.tongue_tuning_1d_si(i_u,:);
    pvalue=TUNING{num}.X.pvalue_si_1d(i_u,:);
    plot(hist_bins_centers,X)
    ylim([0,nanmax(X)]);
    vname=replace(tuning_param_name{1},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    ylabel('FR (Hz)');
    title(sprintf('uid= %d %s %s %s \n t wind=[%.1f,%.1f]\nr (odd,even)=%.2f \nI=%.2f b/s p= %.3f',UNITS.unit_uid(i_u),  UNITS.brain_area{i_u,1}, UNITS.hemisphere{i_u}, UNITS.cell_type{i_u}, time_window_start(num), time_window_end(num), stability, SI, pvalue));
    
    subplot(3,3,2)
    Y=TUNING{num}.Y.tongue_tuning_1d(i_u,:);
    stability=TUNING{num}.Y.stability_odd_even_corr_r(i_u,:);
    SI=TUNING{num}.Y.tongue_tuning_1d_si(i_u,:);
    pvalue=TUNING{num}.Y.pvalue_si_1d(i_u,:);
    plot(hist_bins_centers,Y)
    ylim([0,nanmax(Y)]);
    vname=replace(tuning_param_name{2},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    ylabel('FR (Hz)');    ylabel('FR (Hz)');
    title(sprintf('r (odd,even)=%.1f \nI=%.2f b/s p= %.3f',stability, SI, pvalue));
    
    subplot(3,3,3)
    XY=TUNING{num}.XY.tongue_tuning_2d{i_u,:};
    stability=TUNING{num}.XY.stability_odd_even_corr_r(i_u,:);
    SI=TUNING{num}.XY.tongue_tuning_2d_si(i_u,:);
    pvalue=TUNING{num}.XY.pvalue_si_2d(i_u,:);
    imagescnan(hist_bins_centers_x,hist_bins_centers_y,XY')
    set(gca,'YDir','normal')
    hold on
    colormap(jet);
    colorbar;
    caxis([0 nanmax(XY(:))])
    vname=replace(tuning_param_name{1},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    vname=replace(tuning_param_name{2},'_',' ');
    vname=erase(vname,'lick');
    ylabel(vname);
    title(sprintf('r (odd,even)=%.1f \nI=%.2f b/s  p= %.3f',stability, SI, pvalue));
    
    num=2;
    subplot(3,3,4)
    X=TUNING{num}.X.tongue_tuning_1d(i_u,:);
    stability=TUNING{num}.X.stability_odd_even_corr_r(i_u,:);
    SI=TUNING{num}.X.tongue_tuning_1d_si(i_u,:);
    pvalue=TUNING{num}.X.pvalue_si_1d(i_u,:);
    plot(hist_bins_centers,X)
    ylim([0,nanmax(X)]);
    vname=replace(tuning_param_name{1},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    ylabel('FR (Hz)');
    title(sprintf('t wind=[%.1f,%.1f] \nr (odd,even)=%.2f \nI=%.2f b/s p= %.3f', time_window_start(num), time_window_end(num),stability, SI, pvalue));
    
    subplot(3,3,5)
    Y=TUNING{num}.Y.tongue_tuning_1d(i_u,:);
    stability=TUNING{num}.Y.stability_odd_even_corr_r(i_u,:);
    SI=TUNING{num}.Y.tongue_tuning_1d_si(i_u,:);
    pvalue=TUNING{num}.Y.pvalue_si_1d(i_u,:);
    plot(hist_bins_centers,Y)
    ylim([0,nanmax(Y)]);
    vname=replace(tuning_param_name{2},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    ylabel('FR (Hz)');
    title(sprintf('r (odd,even)=%.1f \nI=%.2f b/s p= %.3f',stability, SI, pvalue));
    
    subplot(3,3,6)
    XY=TUNING{num}.XY.tongue_tuning_2d{i_u,:};
    stability=TUNING{num}.XY.stability_odd_even_corr_r(i_u,:);
    SI=TUNING{num}.XY.tongue_tuning_2d_si(i_u,:);
    pvalue=TUNING{num}.XY.pvalue_si_2d(i_u,:);
    imagescnan(hist_bins_centers_x,hist_bins_centers_y,XY')
    set(gca,'YDir','normal')
    hold on
    colormap(jet);
    colorbar;
    caxis([0 nanmax(XY(:))])
    vname=replace(tuning_param_name{1},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    vname=replace(tuning_param_name{2},'_',' ');
    vname=erase(vname,'lick');
    ylabel(vname);
    title(sprintf('r (odd,even)=%.1f \nI=%.2f b/s  p= %.3f',stability, SI, pvalue));
    
    
    
    
    
    subplot(3,3,7)
    title('Correct trials');
    key_psth.outcome='hit';
    hold on;
    plot([t_go t_go], sz, 'k-','LineWidth',1.5);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    key_psth.unit_uid=TUNING{num}.X.unit_uid(i_u);
    key_psth.trial_type_name='l';
    p=fetch1(ANL.PSTHAverageLR & (EPHYS.Unit&key_psth) & key_psth,'psth_avg');
    p=movmean(p,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    plot(time,p,'r')
    peak(1)=nanmax(p);
    
    key_psth.trial_type_name='r';
    p=fetch1(ANL.PSTHAverageLR & (EPHYS.Unit&key_psth) & key_psth,'psth_avg');
    p=movmean(p,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    plot(time,p,'b');
    peak(2)=nanmax(p);
    xlim([-4,2]);
    ylim([0 nanmax(peak)]);
    ylabel ('FR (Hz)','Fontsize', 12);
    xlabel ('Time (s)','Fontsize', 12);
    
    subplot(3,3,8)
    title('Error trials');
    key_psth.outcome='miss';
    hold on;
    plot([t_go t_go], sz, 'k-','LineWidth',1.5);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    key_psth.unit_uid=TUNING{num}.X.unit_uid(i_u);
    key_psth.trial_type_name='l';
    p=fetch1(ANL.PSTHAverageLR & (EPHYS.Unit&key_psth) & key_psth,'psth_avg');
    p=movmean(p,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    plot(time,p,'r')
    peak(1)=nanmax(p);
    
    key_psth.trial_type_name='r';
    p=fetch1(ANL.PSTHAverageLR & (EPHYS.Unit&key_psth) & key_psth,'psth_avg');
    p=movmean(p,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    plot(time,p,'b');
    peak(2)=nanmax(p);
    xlim([-4,2]);
    ylim([0 nanmax(peak)]);
    ylabel ('FR (Hz)','Fontsize', 12);
    xlabel ('Time (s)','Fontsize', 12);
    
    filename = [UNITS.brain_area{i_u,1} UNITS.hemisphere{i_u} UNITS.cell_type{i_u} num2str(UNITS.unit_uid(i_u)) '_tuning2D'];
    
    
    dir_save_figure_full=[dir_save_figure];
    
    if isempty(dir(dir_save_figure_full))
        mkdir (dir_save_figure_full)
    end
    dir_save_figure_full=[dir_save_figure_full '\' filename ];
    eval(['print ', dir_save_figure_full, ' -dtiff -cmyk -r200']);
    %                 eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
    
    
    clf
end

[p12, p1, p2] = estpab(vec1,vec2)

key=[];
key.brain_area='ALM';
% key.hemisphere='right';
key.outcome='all';
key.flag_use_basic_trials=0;
% figure
% x=(fetchn( ANL.TongueMLdecoder*ANL.SessionPosition& key,'time_vector_ml'));
% x=x{1}';
% y=(cell2mat(fetchn( ANL.TongueMLdecoder*ANL.SessionPosition& key,'ml_performance_left_at_t')));
% y=y-y(:,1)
%  y=mean(y)
% plot(x,y)

figure
x=(fetchn( ANL.TongueSVMbinarydecoder*ANL.SessionPosition & key,'time_vector'));
x=x{1}';
y=(cell2mat(fetchn( ANL.TongueSVMbinarydecoder*ANL.SessionPosition & key,'performance_right_at_t')));
y=y-y(:,1)
 y=nanmean(y)
plot(x,y)


