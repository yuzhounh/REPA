function [isValid] = repa_check_directories(working_dir, starting_dir)
    % output the working directory
    fprintf('Working directory: %s\n\n', working_dir); 

    % check the starting directory
    switch starting_dir
        case 'FunImg'
            [funImgExists, t1ImgExists] = checkFunImgDirectories(working_dir);
            isValid = funImgExists && t1ImgExists;
            
            if ~isValid
                if ~funImgExists && ~t1ImgExists
                    error('Both FunImg and T1Img directories are missing. Please check the paths.');
                elseif ~funImgExists
                    error('FunImg directory is missing. Please check the path.');
                else
                    error('T1Img directory is missing. Please check the path.');
                end
            end
            
        case 'FunRaw'
            [funRawExists, t1RawExists] = checkFunRawDirectories(working_dir);
            isValid = funRawExists && t1RawExists;
            
            if ~isValid
                if ~funRawExists && ~t1RawExists
                    error('Both FunRaw and T1Raw directories are missing. Please check the paths.');
                elseif ~funRawExists
                    error('FunRaw directory is missing. Please check the path.');
                else
                    error('T1Raw directory is missing. Please check the path.');
                end
            end
            
        otherwise
            error('Invalid starting_dir. Must be either "FunImg" or "FunRaw".');
    end
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