function copy_video_files
dir_source_root='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\video\';
dir_destination_root='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\video_cam1\';

directories = dir(dir_source_root);
directories = directories([directories.isdir]==1); % get filename (not directory names)
directories=directories(contains({directories.name},'anm')); % get only  files for cam 1

for i_dir = 1:1:numel(directories)
    sub_directories = dir([dir_source_root directories(i_dir).name]);
    sub_directories = sub_directories([sub_directories.isdir]==1); % get filename (not directory names)
    
    sub_directories = sub_directories(3:end); % get filename (not directory names)
    
    
    for i_subdir = 1:1:numel(sub_directories)
        
        cur_dir = ([sub_directories(i_subdir).folder '\' sub_directories(i_subdir).name]);
        files = dir(cur_dir);
        files=files([files.isdir]==0); % get filename (not directory names)
        
        % Take only avi files of a certain camera
        ext={};
        for i_f = 1:1:length(files)
            fname = files(i_f).name;
            ext(i_f) = regexp(fname, '(?<=\.)[^.]*$', 'match');     % Check for extension
        end
        files=files(strcmp(ext,'avi')); % get only avi files
        files=files(contains({files.name},'v_cam_1')); % get only  files for cam 1
        
        
        % Loop through each file and copy it to a different folder
        dir_destionation_full = [dir_destination_root directories(i_dir).name '\' sub_directories(i_subdir).name '\']
        
        if isempty(dir(dir_destionation_full))
            mkdir (dir_destionation_full)
        end
        
        for i_f = 1:1:length(files)
            copyfile( [files(i_f).folder '\' files(i_f).name], dir_destionation_full);
        end
    end
    
end
