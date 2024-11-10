function repa_installation()
% Install related softwares and check dependencies
% 2024-9-11 20:12:28

fprintf('%s\n\n',repmat('-',1,72));

%% Installation
% Install SPM
spmVersion = repa_install_SPM;

% Install DPABI
dpabiVersion = repa_install_DPABI;

fprintf('Installation is completed.\n\n');

%% Software versions
% Start diary
fprintf('%s\n\n',repmat('-',1,72));
diary('repa_utilities/repa_dependencies.txt');

% time stamp
currentTime = char(datetime('now', 'Format', 'yyyy-M-dd HH:mm:ss'));
fprintf('%s\n\n', currentTime);

% Operating System
if ispc
    osType = 'Windows';
    os_info = feature('GetOS');
    os_parts = strsplit(os_info);
    osVersion = strjoin(os_parts(1:end-1), ' ');
elseif ismac
    osType = 'macOS';
    [~, osVersion] = system('sw_vers -productVersion');
    osVersion = strtrim(osVersion);
else
    osType = 'Linux';
    [~, osInfo] = system('uname -a');
    osInfo = strtrim(osInfo);
    [~, distroInfo] = system('cat /etc/os-release | grep "PRETTY_NAME"');
    distroInfo = strtrim(regexprep(distroInfo, 'PRETTY_NAME=|"', ''));
    [~, kernelVersion] = system('uname -r');
    kernelVersion = strtrim(kernelVersion);
end

% Matlab version
matlabVersion = version;

% REPA version
try
    load('repa_utilities/repa_version.mat','repa_version','repa_releaseDate');
    repaVersion = repa_version;
catch
    repaVersion = 'Not installed or not in MATLAB path';
end

% Output results
fprintf('Operating System: %s\n', osType);
if strcmp(osType, 'Windows')
    fprintf('Windows Version: %s\n', osVersion);
else
    if strcmp(osType, 'macOS')
        fprintf('macOS Version: %s\n', osVersion);
    else
        fprintf('Linux Distribution: %s\n', distroInfo);
        fprintf('Kernel Version: %s\n', kernelVersion);
    end
end
fprintf('MATLAB Version: %s\n', matlabVersion);
fprintf('SPM Version: %s\n', spmVersion);
fprintf('DPABI Version: %s\n', dpabiVersion);
fprintf('REPA Version: %s\n', repaVersion);

if ~ispc
    % Check FSL version
    [status, fslVersion] = system('cat $FSLDIR/etc/fslversion');
    if status ~= 0
        fslVersion = 'Not installed or FSLDIR not set';
    else
        fslVersion = strtrim(fslVersion);
    end

    % Check AFNI version
    [status, afniVersion] = system('afni -ver 2>&1');
    if status ~= 0
        afniVersion = 'Not installed or not in PATH';
    else
        afniVersion = strsplit(afniVersion, '\n');
        afniVersion = strtrim(afniVersion{1});
    end

    % Check FreeSurfer version
    [status, freesurferVersion] = system('recon-all -version');
    if status ~= 0
        freesurferVersion = 'Not installed or not in PATH';
    else
        freesurferVersion = strsplit(freesurferVersion, '\n');
        freesurferVersion = strtrim(freesurferVersion{1});
    end

    % Check ANTs version
    try
        antsPath = getenv('ANTSPATH');
        parts = strsplit(antsPath, filesep);
        antsVersion = parts{end-2};
    catch
        antsVersion = 'Not installed or not in PATH';
    end

    fprintf('FSL Version: %s\n', fslVersion);
    fprintf('AFNI Version: %s\n', afniVersion);
    fprintf('FreeSurfer Version: %s\n', freesurferVersion);
    fprintf('ANTs Version: %s\n', antsVersion);
end

fprintf('\n');
diary off;

end