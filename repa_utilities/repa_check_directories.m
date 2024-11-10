function starting_dir = repa_check_directories(working_dir)
    % output the working directory
    fprintf('%s\n\n',repmat('-',1,72));
    fprintf('Working directory: %s\n', working_dir); 

    % Check for FunRaw and T1Raw directories
    [funRawExists, t1RawExists] = checkFunRawDirectories(working_dir);
    
    % Check for FunImg and T1Img directories
    [funImgExists, t1ImgExists] = checkFunImgDirectories(working_dir);

    if funImgExists && t1ImgExists
        fprintf('Starting from NIfTI files.\n');
        starting_dir = 'FunImg'; 
    elseif funRawExists && t1RawExists
        fprintf('Starting from DICOM files.\n');
        starting_dir = 'FunRaw'; 
    else
        error('Invalid starting directory.\n');
    end
    fprintf('\n');
end

function [funImgExists, t1ImgExists] = checkFunImgDirectories(working_dir)
    % Check if 'FunImg' directory exists
    funImgPath = fullfile(working_dir, 'FunImg');
    funImgExists = isfolder(funImgPath);
    
    % Check if 'T1Img' directory exists
    t1ImgPath = fullfile(working_dir, 'T1Img');
    t1ImgExists = isfolder(t1ImgPath);
end

function [funRawExists, t1RawExists] = checkFunRawDirectories(working_dir)
    % Check if 'FunRaw' directory exists
    funRawPath = fullfile(working_dir, 'FunRaw');
    funRawExists = isfolder(funRawPath);
    
    % Check if 'T1Raw' directory exists
    t1RawPath = fullfile(working_dir, 'T1Raw');
    t1RawExists = isfolder(t1RawPath);
end