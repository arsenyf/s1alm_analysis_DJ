function video_tracking()
close all;
dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\video_tracking\'];
filename = 'video_tracking';
global dir_data
dir_data = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\ProcessedData\';

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
%              load([dir_data file_name1]);
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

[~,temp_feducial_labels,~] = xlsread([dir_video  files(1).name],'B2:X3');
feducial_labels = unique(temp_feducial_labels(1,:));

for jj= 1: length(feducial_labels)
    column_idx = find(strcmp(temp_feducial_labels(1,:),feducial_labels{jj}),1);
    feducials_idx(jj).label=feducial_labels{jj};
    feducials_idx(jj).XColumn=column_idx;
    feducials_idx(jj).YColumn=column_idx+1;
    feducials_idx(jj).ProbColumn=column_idx+2;
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


for ii = 1:length(files)
    ii_b=meta.bitcode(ii);
     l=behav.events.eventdat(ii_b).lick_left_start- behav.events.statedat(ii_b).cue(1)
          r=behav.events.eventdat(ii_b).lick_right_start- behav.events.statedat(ii_b).cue(1)
    time_lick=[l;r];
    hold on;
    k.trial=ii;
 time_lick_DJ = fetchn(EXP.BehaviorTrial * EXP.ActionEvent * EXP.Session & key & k,'action_event_time')-time_go(ii); %-0.2;

    fname = files(ii).name;
    data = csvread([dir_video fname],3,1);
    
    f_idx1 = find(strcmp({feducials_idx.label},'tongue_tip'));
    P1=data(:,feducials_idx(f_idx1).ProbColumn);
    X1=data(:,feducials_idx(f_idx1).XColumn);
    Y1=data(:,feducials_idx(f_idx1).YColumn);
    
    f_idx2 = find(strcmp({feducials_idx.label},'tongue_right'));
    P2=data(:,feducials_idx(f_idx2).ProbColumn);
    X2=data(:,feducials_idx(f_idx2).XColumn);
    Y2=data(:,feducials_idx(f_idx2).YColumn);
    
    f_idx3 = find(strcmp({feducials_idx.label},'tongue_left'));
    P3=data(:,feducials_idx(f_idx3).ProbColumn);
    X3=data(:,feducials_idx(f_idx3).XColumn);
    Y3=data(:,feducials_idx(f_idx3).YColumn);
    
    idx_P = P1<p_threshold | P2<p_threshold | P3<p_threshold;
    
    t=1:1:numel(idx_P);
    t=t*dt+2*dt;
    
    X=mean([X2,X3],2);
    Y=mean([Y2,Y3],2);
    X(idx_P)=[];
    Y(idx_P)=[];
    Xt=[Xt; X];
    Yt=[Yt; Y];
    %     plot(X,Y,'.r')
    temp_t = (t + 1) + time_start_ephys(ii) - time_go(ii);
    temp_t(idx_P) = [];
    plot(temp_t,X,'.-')
    if ~isempty(time_lick)
        plot(time_lick,max([X;1]),'*r')
                plot(time_lick_DJ,max([X;1]),'*g')

    end
    xlim([-4 3]);
    %    hist(P,[0:0.01:1])
    
    %     f_idx = find(strcmp({feducials_idx.label},'left_port'));
    %     X=data(:,feducials_idx(f_idx).XColumn);
    %     Y=data(:,feducials_idx(f_idx).YColumn);
    %     P=data(:,feducials_idx(f_idx).ProbColumn);
    %     idx_P = P<p_threshold;
    %     X(idx_P)=NaN;
    %     Y(idx_P)=NaN;
    %     plot(nanmean(X),nanmean(Y),'.y')
    %     %    hist(P,[0:0.01:1])
    %
    %     f_idx = find(strcmp({feducials_idx.label},'right_port'));
    %     X=data(:,feducials_idx(f_idx).XColumn);
    %     Y=data(:,feducials_idx(f_idx).YColumn);
    %     P=data(:,feducials_idx(f_idx).ProbColumn);
    %     idx_P = P<p_threshold;
    %     X(idx_P)=NaN;
    %     Y(idx_P)=NaN;
    %     plot(nanmean(X),nanmean(Y),'.c')
    %     %    hist(P,[0:0.01:1])
    %
    %     f_idx = find(strcmp({feducials_idx.label},'jaw'));
    %     X=data(:,feducials_idx(f_idx).XColumn);
    %     Y=data(:,feducials_idx(f_idx).YColumn);
    %     P=data(:,feducials_idx(f_idx).ProbColumn);
    %     idx_P = P<p_threshold;
    %     X(idx_P)=NaN;
    %     Y(idx_P)=NaN;
    %     plot(nanmean(X),nanmean(Y),'.b')
    %     %    hist(P,[0:0.01:1])
    %
    %     f_idx = find(strcmp({feducials_idx.label},'nose_tip'));
    %     X=data(:,feducials_idx(f_idx).XColumn);
    %     Y=data(:,feducials_idx(f_idx).YColumn);
    %     P=data(:,feducials_idx(f_idx).ProbColumn);
    %     idx_P = P<p_threshold;
    %     X(idx_P)=NaN;
    %     Y(idx_P)=NaN;
    %     plot(nanmean(X),nanmean(Y),'.g')
    %    hist(P,[0:0.01:1])
    clf;
end

plot(Xt,Yt,'.r')
[N,Xedges,Yedges]=histcounts2( Yt,Xt);
imagesc(N)

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);