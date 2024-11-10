function repa_run(iSubject)
% load configuration
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
fprintf('Begin processing %s.', SubjectID);
fprintf('\n%s\n\n',repmat('-',1,72));

% check error status
error_file = fullfile(working_dir, 'errors', [SubjectID, '*.txt']);
if ~isempty(dir(error_file))
    fprintf('Skip running DPARSFA due to errors.\n\n');
    return;
end

% load fMRI information
load(fullfile(working_dir,'fMRI_info', [SubjectID,'.mat']), 'fMRI_info');

% Process subject folder and update Cfg
if ~isempty(fMRI_info)
    % Parameters individually set for each subject
    if ~isempty(fMRI_info.SliceOrder) 
        Cfg.TimePoints = fMRI_info.TimePoints;
        Cfg.TR = fMRI_info.RepetitionTime;
        Cfg.SliceTiming.SliceNumber = fMRI_info.SliceNumber;
        Cfg.SliceTiming.SliceOrder = fMRI_info.SliceOrder;
        Cfg.SliceTiming.ReferenceSlice = fMRI_info.SliceOrder(round(fMRI_info.SliceNumber/2));
    else
        Error = 'Slice order is empty.';
        Type = 2;  % error in slice order 
        repa_save_error(SubjectID, Error, Type);
        fprintf('Skip processing %s due to errors.\n\n', SubjectID);
        return;
    end
else
    Error = 'Cannot load the fMRI information.';
    fprintf('%s\n',Error);
    repa_save_error(SubjectID, Error);
    return;
end

% save configuration for the current subject
configFileName = fullfile(working_dir,'configurations',sprintf('%s_DPARSFA.mat',SubjectID));
save(configFileName,'Cfg');

try
    % delete TRInfo.tsv
    TRInfo = fullfile(working_dir, 'TRInfo.tsv');
    if isfile(TRInfo)
        delete(TRInfo);
    end

    % run DPARSFA
    Error = DPARSFA_serial(Cfg);
    fprintf('%s\n',repmat('-',1,72));
    
    % save errors
    if ~isempty(Error)
        Type = 3;  % error in running DPARSFA
        repa_save_error(SubjectID, Error, Type);
        fprintf('Failed in processing %s.\n', SubjectID);
    else
        fprintf('Successfully processed %s.\n', SubjectID);
    end
    fprintf('%s\n',repmat('-',1,72));
    fprintf(repmat('\n', 1, 4));  % print newlines

catch ME
    % cd to the starting folder
    cd(working_dir);
    cd('..');

    % save errors
    Type = 3;  % error in running DPARSFA
    repa_save_error(SubjectID, ME, Type);
end

% cd to the starting folder
cd(working_dir);
cd('..');

end