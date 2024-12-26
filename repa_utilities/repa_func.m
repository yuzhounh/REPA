function repa_func(para)
% 2024-8-15 18:36:13

%% parameters
working_dir = para.working_dir;
time_points_removed = para.time_points_removed;
voxel_size = para.voxel_size;
FWHM = para.FWHM;
filter_band = para.filter_band;

%% prepare
% customized scripts
working_path = fullfile(fileparts(which('repa.m')), 'repa_utilities');

% welcome
repa_welcome;

% check the working directory
starting_dir = repa_check_directories(working_dir);

% install related softwares
repa_installation(working_dir);

% remove path: DPABI_V8.2_240510\DPARSF\Subfunctions
repa_remove_path;

% add to the top of the search path
addpath(genpath(working_path),'-begin');

% load subject list
fun_img_dir = fullfile(working_dir,starting_dir);
folder_info = dir(fun_img_dir);
SubjectID = {folder_info([folder_info.isdir]).name};
SubjectID = SubjectID(~ismember(SubjectID, {'.', '..'}));
SubjectID = SubjectID';
num_subject = length(SubjectID);

% create a folder to save configurations for each subject
repa_mkdir(fullfile(working_dir, 'configurations'));

% create a folder to save errors for each subject
repa_mkdir(fullfile(working_dir, 'errors'));

% create a folder to save fMRI information in .json format for each subject
repa_mkdir(fullfile(working_dir, 'fMRI_info'));

% suppress warnings
warning('off');

%% configuration for dcm2nii
if strcmp(starting_dir, 'FunRaw')
    % load the default configuration for dcm2nii
    load(fullfile(working_path,'repa_config_dcm2nii.mat'),'Cfg');

    Cfg.WorkingDir = working_dir;
    Cfg.DataProcessDir = working_dir;
    Cfg.SubjectID = SubjectID;
    Cfg.RemoveFirstTimePoints = time_points_removed;
    Cfg.StartingDirName = 'FunRaw';

    % overwrite the default configuration
    save(fullfile(working_path,'repa_config_dcm2nii.mat'),'Cfg');
end

%% configuration for DPARSFA
% load the default configuration of DPARSFA
load(fullfile(working_path,'repa_config_DPARSFA.mat'),'Cfg');

% modify configuration
Cfg.WorkingDir = working_dir;
Cfg.DataProcessDir = working_dir;
Cfg.SubjectID = SubjectID;
Cfg.Normalize.VoxSize = voxel_size;
Cfg.Smooth.FWHM = FWHM;
Cfg.Filter.AHighPass_LowCutoff = filter_band(1);
Cfg.Filter.ALowPass_HighCutoff = filter_band(2);
Cfg.CalALFF.AHighPass_LowCutoff = filter_band(1);
Cfg.CalALFF.ALowPass_HighCutoff = filter_band(2);
Cfg.StartingDirName = 'FunImg';

% overwrite the default configuration of DPARSFA
save(fullfile(working_path,'repa_config_DPARSFA.mat'),'Cfg');

%% configuration for DPARSFA with GSR
% load the default configuration of DPARSFA with GSR
load(fullfile(working_path,'repa_config_DPARSFA_with_GSR.mat'),'Cfg');

% modify configuration
Cfg.WorkingDir = working_dir;
Cfg.DataProcessDir = working_dir;
Cfg.SubjectID = SubjectID;

% Starting directory will change to 'FunImgARglobal' in DPARSFA_with_GSR_serial.m
Cfg.StartingDirName = 'FunImg';  

% overwrite the default configuration of DPARSFA with GSR
save(fullfile(working_path,'repa_config_DPARSFA_with_GSR.mat'),'Cfg');

%% processing
% convert dicom to nifti by dcm2niix
if strcmp(starting_dir, 'FunRaw')
    repa_progress_init(working_dir);
    for i = 1:num_subject
        repa_run_dcm2nii(i);  % dicom to nifti
        repa_progress(i, num_subject, working_dir);
    end
end

% restore FunImg
repa_restore_data;

% export fMRI information
fmri_info_file = fullfile(working_dir,'repa_fmri_info.csv');
repa_fmri_info(working_dir, fmri_info_file);

% DPARSFA without and with GSR
repa_progress_init(working_dir);
for i = 1:num_subject
    repa_run(i);      % DPARSFA
    repa_run_GSR(i);  % DPARSFA with GSR
    repa_progress(i, num_subject, working_dir);
end

% summary
repa_summary(working_dir, num_subject);