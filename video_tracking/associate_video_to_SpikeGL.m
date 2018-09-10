function associate_video_to_SpikeGL

clc; clear;

root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\';
m = getSessions(root);

for jj = 1:1:numel(m)
    mm = m(jj);
    update_Obj(mm, root)
end

end


function update_Obj(m, root)
close all;
datadir = '\SpikeGL\';

parent = m.parent(1:end-18);
day = m.parent(end-17:end-8);

dir_spikes = [parent day datadir];

% Get all files in the current folder
files = dir(dir_spikes);
files=files([files.isdir]==0); % get filename (not directory names)

% Loop through each
for ii = 1:length(files)
    fname = files(ii).name;
    ext(ii) = regexp(fname, '(?<=\.)[^.]*$', 'match');     % Check for extension
end
files=files(strcmp(ext,'bin')); % get only bin files


key.subject_id =str2num(m.anm_name(4:end));
key.session_date =day;

trials = fetch(EXP.BehaviorTrial & (EXP.Session & key),'*');

% if numel(files)~=numel(trials)
%     disp('Mismatch between SpikeGL and DJ');
    datadir = 'SpikeGL';
    
    parent = m.parent(1:end-18);
    day = m.parent(end-17:end-8);
    load(fullfile(parent, day, datadir, 'MetaData.mat'));
    anmix =strfind(parent, 'anm');
    anm = parent(anmix:anmix+8);
    
    obj_file_name = fullfile('Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\ProcessedData', ['data_structure_' anm '_' day '.mat']);
    if exist(obj_file_name, 'file') == 2
        load(obj_file_name)
    else
        return;
    end
    
    %     [obj] =  addMetaAndVideoToObj (meta, obj, root);
    
    sessionType = 'sensoryInput'; %sensoryInput or Epsilon
    parent = meta.parent(1:end-18);
    day = meta.parent(end-17:end-8);
    behav = getSoloData(fullfile(parent, day), day, sessionType);
    [c,idx_u,~]=unique(meta.bitcode,'stable');
    usableTrials = intersect(meta.bitcode(idx_u), 1:behav.Ntrials);
    behavTrialsToUse = ismember(1:behav.Ntrials, usableTrials);
    ephysTrialsToUse = ismember(meta.bitcode(idx_u), usableTrials);
    Nusable = numel(usableTrials);
    
    
    
    %% Add video to obj
    dir_data_video = [root 'video\' meta.anm_name '\' meta.day '\' ];
    if meta.video_flag && isdir(dir_data_video)
        dir_data_SpikeGL = meta.parent;
        session_name = [meta.anm_name '-' meta.day]
        [ephysVideoTrials]= getVideoTrialNum(dir_data_SpikeGL, dir_data_video,root, session_name, meta);
    
        % Saves only those video info that belong to ephysTrialsToUse (i.e has a valid bitcode)
        for iCam = 1:1:size(ephysVideoTrials.Cam,2) %insert this for every camera
            Cam = ephysVideoTrials.Cam {iCam};
            Cam.flags = Cam.flags (ephysTrialsToUse);
            Cam.fileName = Cam.fileName (ephysTrialsToUse);
            ephysVideoTrials.Cam {iCam} = Cam;
        end
        obj.ephysVideoTrials =  ephysVideoTrials;
        if numel (obj.trialIDs) ~=  numel(obj.ephysVideoTrials.Cam{1}.flags)
            display([ 'video to SpikeGL file number discrepancy in: ' parent])
        end
    else
        ephysVideoTrials =[];
    end
    
    
   
    
    
% end





% sessionType = 'sensoryInput'; %sensoryInput or Epsilon
% parent = meta.parent(1:end-18);
% day = meta.parent(end-17:end-8);
% behav = getSoloData(fullfile(parent, day), day, sessionType);
% [c,idx_u,~]=unique(meta.bitcode,'stable');
% usableTrials = intersect(meta.bitcode(idx_u), 1:behav.Ntrials);
% behavTrialsToUse = ismember(1:behav.Ntrials, usableTrials);
% ephysTrialsToUse = ismember(meta.bitcode(idx_u), usableTrials);
% Nusable = numel(usableTrials);










%
% load(fullfile(parent, day, datadir, 'MetaData.mat'));
% anmix =strfind(parent, 'anm');
% anm = parent(anmix:anmix+8);
%
% obj_file_name = fullfile('Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\ProcessedData', ['data_structure_' anm '_' day '.mat']);
% if exist(obj_file_name, 'file') == 2
%     load(obj_file_name)
% else
%     return;
% end
%
% [obj] =  addMetaAndVideoToObj (meta, obj, root);
%
% disp(['Saving ' obj_file_name]);
% save(obj_file_name, 'obj', '-v7.3');
% disp('Done');
%



end












































