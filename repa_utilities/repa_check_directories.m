function starting_dir = repa_check_directories(working_dir, preferred_start)
% Determine whether processing starts from DICOM (FunRaw) or NIfTI (FunImg).
if nargin < 2 || isempty(preferred_start) || strcmpi(preferred_start, 'auto')
    preferred_start = 'auto';
end

fprintf('%s\n\n', repmat('-', 1, 72));
fprintf('Working directory: %s\n', working_dir);

[funRawExists, t1RawExists] = checkFunRawDirectories(working_dir);
[funImgExists, t1ImgExists] = checkFunImgDirectories(working_dir);

if strcmpi(preferred_start, 'auto')
    if funImgExists && t1ImgExists
        fprintf('Starting from NIfTI files.\n');
        starting_dir = 'FunImg';
    elseif funRawExists && t1RawExists
        fprintf('Starting from DICOM files.\n');
        starting_dir = 'FunRaw';
    else
        error(['Invalid starting directory. Expected either:\n', ...
            '  FunImg/ + T1Img/\n', ...
            '  FunRaw/ + T1Raw/']);
    end
elseif strcmpi(preferred_start, 'FunRaw')
    if ~(funRawExists && t1RawExists)
        error('DICOM input selected, but FunRaw/ and T1Raw/ were not found.');
    end
    fprintf('Starting from DICOM files.\n');
    starting_dir = 'FunRaw';
elseif strcmpi(preferred_start, 'FunImg')
    if ~(funImgExists && t1ImgExists)
        error('NIfTI input selected, but FunImg/ and T1Img/ were not found.');
    end
    fprintf('Starting from NIfTI files.\n');
    starting_dir = 'FunImg';
else
    error('Unknown starting directory mode: %s', preferred_start);
end

fprintf('\n');
end

function [funImgExists, t1ImgExists] = checkFunImgDirectories(working_dir)
funImgExists = isfolder(fullfile(working_dir, 'FunImg'));
t1ImgExists = isfolder(fullfile(working_dir, 'T1Img'));
end

function [funRawExists, t1RawExists] = checkFunRawDirectories(working_dir)
funRawExists = isfolder(fullfile(working_dir, 'FunRaw'));
t1RawExists = isfolder(fullfile(working_dir, 'T1Raw'));
end
