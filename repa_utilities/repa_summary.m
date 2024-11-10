function repa_summary(working_dir, totalSubjects)
    % Set working directory and errors folder path
    errorsDir = fullfile(working_dir, 'errors');
    
    % Get all files in the errors folder
    files = dir(fullfile(errorsDir, '*.txt'));
    
    % Initialize cell array to store subject information
    subjectInfo = cell(length(files), 1);
    
    % Loop through all files and extract subject information
    for i = 1:length(files)
        fileName = files(i).name;
        % Remove '.txt' extension if present
        fileName = strrep(fileName, '.txt', '');
        parts = strsplit(fileName, '_');
        if length(parts) >= 2
            subjectInfo{i} = strjoin(parts(1:2), '_');
        end
    end
    
    % Remove empty cells and get unique subject information
    subjectInfo = unique(subjectInfo(~cellfun('isempty', subjectInfo)));
    
    % Count the number of subjects with errors
    numErrorSubjects = length(subjectInfo);
    
    % Calculate the number of successfully processed subjects
    numSuccessfulSubjects = totalSubjects - numErrorSubjects;
    
    % Count fALFF results
    fALFF_dir = fullfile(working_dir, 'Results', 'fALFF_FunImgARCW');
    fALFF_files = dir(fullfile(fALFF_dir, '*.nii'));
    num_fALFF_results = length(fALFF_files) / 3;
    
    % Count ReHo results
    ReHo_dir = fullfile(working_dir, 'Results', 'ReHo_FunImgARCWF');
    ReHo_files = dir(fullfile(ReHo_dir, '*.nii'));
    num_ReHo_results = length(ReHo_files) / 3;
    
    % Output results
    diary(fullfile(working_dir,'repa_summary.txt'));
    fprintf('%s\n\n',repmat('-',1,72));
    fprintf('Total number of subjects: %d\n', totalSubjects);
    fprintf('Number of subjects with errors: %d\n', numErrorSubjects);
    fprintf('Number of successfully processed subjects: %d\n', numSuccessfulSubjects);
    fprintf('Number of fALFF results: %d\n', num_fALFF_results);
    fprintf('Number of ReHo results: %d\n\n', num_ReHo_results);
    
    % Output list of subjects with errors
    fprintf('%s\n\n',repmat('-',1,72));
    fprintf('List of subjects with errors:\n');
    for i = 1:length(subjectInfo)
        fprintf('%s\n', subjectInfo{i});
    end
    
    diary off; 
end