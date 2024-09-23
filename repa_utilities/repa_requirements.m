function repa_requirements(working_dir)
% export software versions
% 2024-9-11 20:12:28

fprintf('%s\n\n',repmat('-',1,72));
diary(fullfile(working_dir,'repa_requirements.txt'));

% time stamp
currentTime = datetime('now');
currentTime.Format = 'yyyy-M-dd HH:mm:ss';
currentTime = char(currentTime);
fprintf('%s\n\n', currentTime);

% Operating System
os_info = feature('GetOS');
fprintf('Operating System: %s\n', os_info);

% Matlab version
fprintf('Matlab version: %s\n', version);

% SPM version
try
    spm_version = spm('Ver');
    fprintf('SPM version: %s\n', spm_version);
catch
    spm_url = 'https://www.fil.ion.ucl.ac.uk/spm/software/download/';
    fprintf('\nSPM not found. You can download it from:\n%s\n', spm_url);
    choice = input('Do you want to download and install SPM12 automatically? (y/n): ', 's');
    if strcmpi(choice, 'y')
        spm_url = 'https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip';
        spm_zip = fullfile(pwd,'spm12.zip');
        fprintf('\nStarting download from:\n%s\n', spm_url);
        websave(spm_zip, spm_url);
        fprintf('Completed.\n\n')

        fprintf('Starting extraction and installation of SPM.\n')
        unzip(spm_zip);
        addpath('spm12/');
        spm_version = spm('Ver');
        fprintf('SPM version: %s\n', spm_version);
        fprintf('Completed.\n')
    else
        error('Download and install SPM, then continue.');
    end
end

% DPABI version
try
    dpabi_version = repa_DPABI_version;
    fprintf('DPABI version: %s\n', dpabi_version);
catch
    dpabi_url = 'https://rfmri.org/DPABI/';
    fprintf('\nDPABI not found. You can download it from:\n%s\n', dpabi_url);
    choice = input('Do you want to download and install DPABI V8.2 automatically? (y/n): ', 's');
    if strcmpi(choice, 'y')
        dpabi_url = 'https://d.rnet.co/DPABI/DPABI_V8.2_240510.zip';
        dpabi_zip = fullfile(pwd,'DPABI_V8.2_240510.zip');
        fprintf('\nStarting download from:\n%s\n', dpabi_url);
        websave(dpabi_zip, dpabi_url);
        fprintf('Completed.\n\n')

        fprintf('Starting extraction and installation of DPABI.\n')
        unzip(dpabi_zip);
        addpath(genpath('DPABI_V8.2_240510/'));
        dpabi_version = repa_dpabi_version;
        fprintf('DPABI version: %s\n', dpabi_version);
        fprintf('Completed.\n')
    else
        error('Download and install DPABI, then continue.');
    end
end

fprintf('\n');

diary off;

% % run DPARSFA
% evalc('DPARSFA');
