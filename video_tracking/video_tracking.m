function video_tracking()
close all;
dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\video_tracking\'];

global dir_data
dir_data = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\ProcessedData\';
% dir_save_figure = [dir_root 'Results\figures\v2\'];

p_threshold =0.99;
% %Graphics
% %---------------------------------
% figure;
% set(gcf,'DefaultAxesFontName','helvetica');
% set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 3 23 25]);
% set(gcf,'PaperOrientation','portrait');
% set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);

% dir_video='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\video\Test_Set\anm365938\2017-10-17\'
%  dir_video='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\video\Test_Set\anm365942\2017-07-08\'
%  parent = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\anm365942 - AF04\2017-07-08\';

dir_video='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\video\Test_Set\anm365943\2017-07-08\'
parent = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\anm365943 - AF05\2017-07-08\';

key.subject_id = str2num(dir_video(end-17:end-12));
key.session_date = dir_video(end-10:end-1);
key.sesion=fetch1(EXP.Session & key,'session');
file_name1 =['data_structure_anm' num2str(fetch1(EXP.Session & key, 'subject_id')) '_' fetch1(EXP.Session & key, 'session_date') '.mat'];
load([dir_data file_name1]);
load([parent  '\SpikeGL\MetaData.mat']);




sessionType = 'sensoryInput'; %sensoryInput or Epsilon
day = key.session_date;
behav = getSoloData(fullfile(parent), day, sessionType);


trials =fetch(EXP.BehaviorTrial * EXP.Session & key,'*');


k.trial_event_type = 'go';
time_go = fetchn(EXP.BehaviorTrial * EXP.BehaviorTrialEvent * EXP.Session & key & k,'trial_event_time');

k.trial_event_type = 'trigger ephys rec.';
time_start_ephys = fetchn(EXP.BehaviorTrial * EXP.BehaviorTrialEvent * EXP.Session & key & k,'trial_event_time');

time_go_aligned=time_go-time_start_ephys;
% Get all files in the current folder
files = dir(dir_video);
files=files([files.isdir]==0); % get filename (not directory names)



% Loop through each
for ii = 1:length(files)
    fname = files(ii).name;
    ext(ii) = regexp(fname, '(?<=\.)[^.]*$', 'match');     % Check for extension
end
files=files(strcmp(ext,'csv')); % get only csv files

[~,temp_fiducial_labels,~] = xlsread([dir_video  files(1).name],'B2:X3');
fiducial_labels = unique(temp_fiducial_labels(1,:));

for jj= 1: length(fiducial_labels)
    column_idx = find(strcmp(temp_fiducial_labels(1,:),fiducial_labels{jj}),1);
    fiducials_idx(jj).label=fiducial_labels{jj};
    fiducials_idx(jj).XColumn=column_idx;
    fiducials_idx(jj).YColumn=column_idx+1;
    fiducials_idx(jj).ProbColumn=column_idx+2;
end

dt=0.0025;


hold on;
Xt=[];
Yt=[];
k=[];
time_lick=[];
% for ii = 1:length(behav.events.eventdat)
%      l=behav.events.eventdat(ii).lick_left_start - behav.events.statedat(ii).cue(1);
%           r=behav.events.eventdat(ii).lick_right_start- behav.events.statedat(ii).cue(1);
%               time_lick=[time_lick;l;r];
%
% end
Xjaw=[]; Yjaw=[]; Xnose=[]; Ynose=[]; XportL=[]; YportL=[]; XportR=[]; YportR=[];
for ii = 1:length(files)/5
    ii
    fname = files(ii).name;
    data = csvread([dir_video fname],3,1);
    
    f_idx = find(strcmp({fiducials_idx.label},'nose_tip'));
    X=data(:,fiducials_idx(f_idx).XColumn);
    Y=data(:,fiducials_idx(f_idx).YColumn);
    P=data(:,fiducials_idx(f_idx).ProbColumn);
    idx_P = P<p_threshold;
    X(idx_P)=[];
    Y(idx_P)=[];
    Xnose=[Xnose; X];
    Ynose=[Ynose; Y];
    
    f_idx = find(strcmp({fiducials_idx.label},'jaw'));
    X=data(:,fiducials_idx(f_idx).XColumn);
    Y=data(:,fiducials_idx(f_idx).YColumn);
    P=data(:,fiducials_idx(f_idx).ProbColumn);
    idx_P = P<p_threshold;
    X(idx_P)=[];
    Y(idx_P)=[];
    Xjaw=[Xjaw; X];
    Yjaw=[Yjaw; Y];
    
    f_idx = find(strcmp({fiducials_idx.label},'right_port'));
    X=data(:,fiducials_idx(f_idx).XColumn);
    Y=data(:,fiducials_idx(f_idx).YColumn);
    P=data(:,fiducials_idx(f_idx).ProbColumn);
    idx_P = P<p_threshold;
    X(idx_P)=[];
    Y(idx_P)=[];
    XportL=[XportL; X];
    YportL=[YportL; Y];
    
    f_idx = find(strcmp({fiducials_idx.label},'left_port'));
    X=data(:,fiducials_idx(f_idx).XColumn);
    Y=data(:,fiducials_idx(f_idx).YColumn);
    P=data(:,fiducials_idx(f_idx).ProbColumn);
    idx_P = P<p_threshold;
    X(idx_P)=[];
    Y(idx_P)=[];
    XportR=[XportR; X];
    YportR=[YportR; Y];
end

Xjaw=median(Xjaw);
Yjaw=median(Yjaw);

Xnose=median(Xnose)-Xjaw;
Ynose=median(Ynose)-Yjaw;

XportL=median(XportL)-Xjaw;
YportL=median(YportL)-Yjaw;

XportR=median(XportR)-Xjaw;
YportR=median(YportR)-Yjaw;
ThetaTongue=[];
RTongue=[];
RT_peak=[];
RT_onset=[];
RT_lickport=[];
for ii = 1:1:length(files) %[1:25:length(files)]%
    ii_b=meta.bitcode(ii);
    l=behav.events.eventdat(ii_b).lick_left_start- behav.events.statedat(ii_b).cue(1);
    r=behav.events.eventdat(ii_b).lick_right_start- behav.events.statedat(ii_b).cue(1);
    cue=behav.events.statedat(ii_b).cue(1);
    ephys=behav.events.statedat(ii_b).ephys(1);
    time_start_ephys(ii)
    time_lick=[l;r];
    k.trial=ii;
    time_lick_DJ = fetchn(EXP.BehaviorTrial * EXP.ActionEvent * EXP.Session & key & k,'action_event_time')-time_go(ii); %-0.2;
    trial_instruction = fetch1(EXP.BehaviorTrial * EXP.Session & key & k,'trial_instruction');
    trial_outcome = fetch1(EXP.BehaviorTrial  * EXP.Session & key & k,'outcome');
    early_lick = fetch1(EXP.BehaviorTrial  * EXP.Session & key & k,'early_lick');
    
    fname = files(ii).name;
    data = csvread([dir_video fname],3,1);
    
    f_idx1 = find(strcmp({fiducials_idx.label},'tongue_tip'));
    P1=data(:,fiducials_idx(f_idx1).ProbColumn);
    X1=data(:,fiducials_idx(f_idx1).XColumn);
    Y1=data(:,fiducials_idx(f_idx1).YColumn);
    
    f_idx2 = find(strcmp({fiducials_idx.label},'tongue_right'));
    P2=data(:,fiducials_idx(f_idx2).ProbColumn);
    X2=data(:,fiducials_idx(f_idx2).XColumn);
    Y2=data(:,fiducials_idx(f_idx2).YColumn);
    
    f_idx3 = find(strcmp({fiducials_idx.label},'tongue_left'));
    P3=data(:,fiducials_idx(f_idx3).ProbColumn);
    X3=data(:,fiducials_idx(f_idx3).XColumn);
    Y3=data(:,fiducials_idx(f_idx3).YColumn);
    
    idx_P = P1<p_threshold | P2<p_threshold | P3<p_threshold;
    
    t=1:1:numel(idx_P);
    t=t*dt+1*dt;
    
    %     X=mean([X1,X2,X3],2);
    %     Y=mean([Y1,Y2,Y3],2);
    X=X1;
    Y=Y1;
    X(idx_P)=[];
    Y(idx_P)=[];
    X=X-Xjaw;
    Y=Y-Yjaw;
    %     Xt=[Xt; X];
    %     Yt=[Yt; Y];
    %     X=sqrt(X.^2+Y.^2);
    %     plot(X,Y,'.r')
    %     temp_t = ((t + 1) + time_start_ephys(ii)) - time_go(ii);
    temp_t = (t + 1) + ephys - cue;
    temp_t(idx_P) = [];
    
    if size(X)<11
        continue;
    end
    ppx = spline(temp_t,X);
    ppy = spline(temp_t,Y);  
    
    min_time_bin=0.025/dt;
    [pks,pks_idx] = findpeaks(X, 'MinPeakDistance',min_time_bin,'MinPeakProminence',10);
    
    
%     subplot(2,2,1)
%     hold on;
%     plot(temp_t,X,'.-b')
%     if ~isempty(time_lick)
%         %         plot(time_lick,ppval(pp,time_lick),'*r')
%         plot(time_lick_DJ, ppval(ppx,time_lick_DJ),'*r')
%     end
%     xlim([-1 2]);
%     %     ylim([min([X]) max([X;1]) ]);
%     ylim([min([0;X]), max([X])]);
%     plot(temp_t(pks_idx),pks,'om');
%     file_name=files(ii).name;
%     file_name=file_name(9:12);
%     title(sprintf('%s %s %s early lick:%s',file_name,trial_instruction,trial_outcome,early_lick))
%     xlabel('Time(s)');
%     ylabel('A-P axis (pixels)');
%     
%     subplot(2,2,2)
%     hold on;
%     plot(temp_t,Y,'.-')
%     plot(temp_t,Y,'.-b')
%     if ~isempty(time_lick)
%         %         plot(time_lick,ppval(pp,time_lick),'*r')
%         plot(time_lick_DJ, ppval(ppy,time_lick_DJ),'*r')
%     end
%     xlim([-1 2]);
%     %     ylim([min([X]) max([X;1]) ]);
%     ylim([min([0;Y]), max([Y])]);
%     plot(temp_t(pks_idx),Y(pks_idx),'om');
%     xlabel('Time(s)');
%     ylabel('M-L axis (pixels)');
%     plot([-5 5],[0 0],'-k','LineWidth',2);
%     
%     subplot(2,2,3);
%     hold on;
%     plot(XportL,YportL,'.c','MarkerSize',100);
%     plot(XportR,YportR,'.y','MarkerSize',100);
%     plot([0, Xnose],[0, Ynose],'-k','LineWidth',2);
%     plot(X,Y,'.-');
%     plot(ppval(ppx,time_lick_DJ),ppval(ppy,time_lick_DJ),'*r','Clipping','off');
%     set(gca,'Ydir','reverse')
%     xlim([min([0;X;XportL;XportR]), max([X;XportL;XportR]) ]);
%     ylim([min([0;Y;YportL;YportR]), max([Y;YportL;YportR]) ]);
%     plot(X(pks_idx),Y(pks_idx),'om');
%     xlabel('A-P axis (pixels)');
%     ylabel('M-L axis (pixels)');
%     
%      filename = ['anm' num2str(key.subject_id) '_' key.session_date '_' file_name '_bottom'];
%     if isempty(dir(dir_save_figure))
%         mkdir (dir_save_figure)
%     end
%     figure_name_out=[ dir_save_figure filename];
%     eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
%     eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
%     
%     clf;
    
    
    [theta,r] = cart2pol(X(pks_idx),Y(pks_idx));
    theta=rad2deg(theta);
    if ~isempty(theta)
        ThetaTongue=[ThetaTongue;theta(1)];
        RTongue=[RTongue;r(1)];
    end
    
    idx_first_post_cue_lick=find(temp_t(pks_idx)>0,1);
    
    RT_peak= [RT_peak;temp_t(pks_idx(idx_first_post_cue_lick))];
    RT_onset=[RT_onset;temp_t(find(temp_t>0,1))];
    if ~isempty(time_lick_DJ)
    time_lick_DJ=sort((time_lick_DJ));
    RT_lickport= [RT_lickport; time_lick_DJ(find(time_lick_DJ>0,1))];
    end
   
end

subplot(3,3,9);
[X,Y] = pol2cart(deg2rad(ThetaTongue),RTongue);
hold on;
plot([0, Xnose],[0, Ynose],'-k');
set(gca,'Ydir','reverse')
plot(XportL,YportL,'.c','MarkerSize',100);
plot(XportR,YportR,'.y','MarkerSize',100);
plot(X,Y,'.');
xlim([min([0;X;XportL;XportR]), max([X;XportL;XportR]) ]);
ylim([min([0;Y;YportL;YportR]), max([Y;YportL;YportR]) ]);
    xlabel('A-P axis (pixels)');
    ylabel('M-L axis (pixels)');

subplot(3,3,2);
histogram(RT_peak,[0:0.025:0.3]);
xlabel('RT video peak');
ylabel('Count');

subplot(3,3,3);
histogram(RT_onset,[0:0.025:0.3]);
xlabel('RT video onset');
ylabel('Count');

subplot(3,3,1);
histogram(RT_lickport,[0:0.025:0.3]);
xlabel('RT electric lickport');
ylabel('Count');

subplot(3,3,7);
histogram(ThetaTongue,[-100:10:100]);
xlabel('Tongue Yaw (deg)');
ylabel('Count');
% plot(Xt,Yt,'.r')
% [N,Xedges,Yedges]=histcounts2( Yt,Xt);
% imagesc(N)

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure '_summary'];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);