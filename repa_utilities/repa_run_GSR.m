function repa_run_GSR(iSubject)
% Load configuration
% Do not load repa_utilities/repa_config_DPARSFA_with_GSR.mat here
load('repa_utilities/repa_config_DPARSFA.mat','Cfg');

% current subject
SubjectID_list = Cfg.SubjectID;
Cfg.SubjectID = cell(1,1);
SubjectID = SubjectID_list{iSubject,1};
Cfg.SubjectID{1,1} = SubjectID;

% working directory
working_dir = Cfg.WorkingDir;

% begin processing
fprintf('\n\n%s\n',repmat('-',1,72));
fprintf('Begin processing %s with GSR.', SubjectID);
fprintf('\n%s\n\n',repmat('-',1,72));

% check error status
error_file = fullfile(working_dir, 'errors', [SubjectID, '*.txt']);
if ~isempty(dir(error_file))
    fprintf('Skip running DPARSFA with GSR due to errors.\n\n');
    return;
end

% load fMRI information
load(fullfile(working_dir,'fMRI_info', [SubjectID,'.mat']), 'fMRI_info');

% Extract time points and TR, and write to Cfg
Cfg.TimePoints = fMRI_info.TimePoints;
Cfg.TR = fMRI_info.RepetitionTime;

try
    % delete TRInfo.tsv
    TRInfo = fullfile(working_dir, 'TRInfo.tsv');
    if isfile(TRInfo)
        delete(TRInfo);
    end

    % run DPARSFA with GSR
    Error_GSR = DPARSFA_with_GSR_serial(Cfg);
    fprintf('%s\n',repmat('-',1,72));

    % save errors
    if ~isempty(Error_GSR)
        Type = 4;  % error in running DPARSFA with GSR
        repa_save_error(SubjectID, Error_GSR, Type);
        fprintf('Failed in processing %s with GSR.\n', SubjectID);
    else
        fprintf('Successfully processed %s with GSR.\n', SubjectID);
    end
    fprintf('%s\n',repmat('-',1,72));
    fprintf(repmat('\n', 1, 3));  % print newlines

catch ME
    % cd to the starting folder
    cd(working_dir);
    cd('..');

    % save errors
    Type = 4;  % error in running DPARSFA with GSR
    repa_save_error(SubjectID, ME, Type);
end

% cd to the starting folder
cd(working_dir);
cd('..');

end
