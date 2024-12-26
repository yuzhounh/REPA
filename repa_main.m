clear,clc;

% Update REPA version
repa_version = '1.34.0';
repa_releaseDate = char(datetime('now', 'Format', 'yyyy/MM/dd'));
working_path = fullfile(fileparts(which('repa.m')), 'repa_utilities');
save(fullfile(working_path, 'repa_version.mat'),'repa_version','repa_releaseDate');

% Set parameters manually
para.working_dir = 'D:\Data\fMRI_Preprocess';
para.time_points_removed = 10;
para.voxel_size = [3,3,3];
para.FWHM = [6,6,6];
para.filter_band = [0.01, 0.1];

% Run the main program
repa_func(para);