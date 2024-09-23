clear,clc;

% set parameters manually
para.working_dir = 'G:/PPMI/PPMI_Preprocess_2/';
para.starting_dir = 'FunImg';  % FunRaw or FunImg
para.time_points_removed = 10;
para.voxel_size = [3,3,3];
para.FWHM = [6,6,6];
para.filter_band = [0.01, 0.1];

% run the main program
working_path = 'repa_utilities/';  % customized scripts
addpath(genpath(working_path),'-begin');
repa_func(para);
