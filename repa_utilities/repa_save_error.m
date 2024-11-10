function repa_save_error(subjectID, errorInfo, type)
    % load configuration
    load('repa_utilities/repa_config_DPARSFA.mat','Cfg'); 
    
    % Determine the error file name based on the number of input arguments
    if nargin == 2
        errorFileName = fullfile(Cfg.WorkingDir, 'errors', sprintf('%s.txt', subjectID));
    elseif nargin == 3
        switch type
            case 0
                errorFileName = fullfile(Cfg.WorkingDir, 'errors', sprintf('%s_incorrect_file_number.txt', subjectID));
            case 1
                errorFileName = fullfile(Cfg.WorkingDir, 'errors', sprintf('%s_failed_in_dcm2nii.txt', subjectID));
            case 2
                errorFileName = fullfile(Cfg.WorkingDir, 'errors', sprintf('%s_empty_slice_order.txt', subjectID));
            case 3
                errorFileName = fullfile(Cfg.WorkingDir, 'errors', sprintf('%s_failed_in_DPARSFA.txt', subjectID));
            case 4
                errorFileName = fullfile(Cfg.WorkingDir, 'errors', sprintf('%s_failed_in_DPARSFA_with_GSR.txt', subjectID));
            case 5
                errorFileName = fullfile(Cfg.WorkingDir, 'errors', sprintf('%s_failed_in_smoothing_results.txt', subjectID));
            otherwise
                error('Invalid type specified. Type must be between 0 and 5.');
        end
    else
        error('Invalid number of input arguments. Expected 2 or 3.');
    end
    
    fid = fopen(errorFileName, 'w');
    fprintf('%s\n',repmat('-',1,72));
    if fid ~= -1
        fprintf(fid, 'Error processing subject %s:\n', subjectID);
        if isa(errorInfo, 'MException')
            fprintf(fid, 'Error message: %s\n', errorInfo.message);
            fprintf(fid, 'Error stack:\n');
            for j = 1:length(errorInfo.stack)
                fprintf(fid, '  File: %s\n  Line: %d\n  Function: %s\n', ...
                    errorInfo.stack(j).file, errorInfo.stack(j).line, errorInfo.stack(j).name);
            end
        else
            fprintf(fid, 'Error information: %s\n', mat2str(errorInfo));
        end
        fclose(fid);
        fprintf('Error occurred for subject %s. \nError info saved to %s.\n', subjectID, errorFileName);
    else
        fprintf('Error occurred for subject %s, but could not save error info.\n', subjectID);
    end
    fprintf('%s\n',repmat('-',1,72));
    fprintf(repmat('\n', 1, 3));  
end