function repa_run_dcm2nii(iSubject)
% load configuration
load('repa_utilities/repa_config_dcm2nii.mat','Cfg');

% current subject
SubjectID_list = Cfg.SubjectID;
Cfg.SubjectID = cell(1,1);
SubjectID = SubjectID_list{iSubject,1};
Cfg.SubjectID{1,1} = SubjectID;

% begin processing
fprintf('\n\n%s\n',repmat('-',1,72));
fprintf('Begin processing %s with dcm2nii.', SubjectID);
fprintf('\n%s\n\n',repmat('-',1,72));

% TR is not used in the dcm2nii process
% set TR to an arbitrary value to avoid generating TRInfo.tsv and to avoid
% further problems
Cfg.TR = 2.4;

% save configuration for the current subject
configFileName = fullfile(Cfg.WorkingDir,'configurations',sprintf('%s_dcm2nii.mat',SubjectID));
save(configFileName,'Cfg');

try
    % delete TRInfo.tsv
    TRInfo = fullfile(Cfg.WorkingDir, 'TRInfo.tsv');
    if isfile(TRInfo)
        delete(TRInfo);
    end

    % run DPARSFA
    Error = DPARSFA_serial(Cfg);
    fprintf('%s\n',repmat('-',1,72));

    % save errors
    if ~isempty(Error)
        Type = 1;  % error in dicom to nifti
        repa_save_error(SubjectID, Error, Type);
        fprintf('Failed in processing subject: %s with dcm2nii.\n', SubjectID);
    else
        fprintf('Successfully processed subject: %s with dcm2nii.\n', SubjectID);
    end
    fprintf('%s\n',repmat('-',1,72));
    fprintf(repmat('\n', 1, 3));  % print newlines

catch ME
    % cd to the starting folder
    cd(Cfg.WorkingDir);
    cd('..');

    % save errors
    Type = 1;  % error in dicom to nifti
    repa_save_error(SubjectID, ME, Type);
end

% cd to the starting folder
cd(Cfg.WorkingDir);
cd('..');

end