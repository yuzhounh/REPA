% Clear temporary files and check for correct file counts
fprintf('%s\n\n',repmat('-',1,72));
fprintf('Clearing temporary files...\n');

% Load configuration
load('repa_utilities/repa_config_DPARSFA.mat', 'Cfg');

%% FunImg
% Specify main folder path
mainFolder = fullfile(Cfg.WorkingDir, 'FunImg');

% Get all subfolders
subFolders = dir(mainFolder);
subFolders = subFolders([subFolders.isdir] & ~ismember({subFolders.name}, {'.', '..'})); % Filter out '.' and '..'

% Iterate through each subfolder
for i = 1:length(subFolders)
    subFolderPath = fullfile(mainFolder, subFolders(i).name);
    
    % Delete files matching specific patterns
    patterns = {'*asub*.nii', '*a.json', '*b.json', 'c.json'};
    for j = 1:length(patterns)
        filesToDelete = dir(fullfile(subFolderPath, patterns{j}));
        for k = 1:length(filesToDelete)
            fileToDelete = fullfile(subFolderPath, filesToDelete(k).name);
            delete(fileToDelete);
            fprintf('Deleted: %s\n', fileToDelete);
        end
    end
end

%% T1Img
% Specify main folder path
mainFolder = fullfile(Cfg.WorkingDir, 'T1Img');

% Get all subfolders
subFolders = dir(mainFolder);
subFolders = subFolders([subFolders.isdir] & ~ismember({subFolders.name}, {'.', '..'})); % Filter out '.' and '..'

% Iterate through each subfolder
for i = 1:length(subFolders)
    subFolderPath = fullfile(mainFolder, subFolders(i).name);
    
    % % Define patterns
    % patterns = cell(1, 26*2);
    % index = 0;
    % for letter = 'a':'c'  % Loop through letters from 'a' to ~
    %     % Add the basic pattern
    %     index = index + 1;
    %     patterns{index} = ['*' letter '.*'];  
    % 
    %     % Add the pattern with '_Crop_1'
    %     index = index + 1;
    %     patterns{index} = ['*' letter '_Crop_1.*'];  
    % end

    % Delete files matching specific patterns
    patterns ={'*a.*', '*a_Crop_1.*', '*b.*', '*b_Crop_1.*', '*c.*', '*c_Crop_1.*'};
    for j = 1:length(patterns)
        filesToDelete = dir(fullfile(subFolderPath, patterns{j}));
        for k = 1:length(filesToDelete)
            fileToDelete = fullfile(subFolderPath, filesToDelete(k).name);
            delete(fileToDelete);
            fprintf('Deleted: %s\n', fileToDelete);
        end
    end
end

fprintf('File cleanup completed.\n\n');