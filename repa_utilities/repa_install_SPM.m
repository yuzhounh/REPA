function spm_version = repa_install_SPM()
% Function to check and install SPM (Statistical Parametric Mapping)
% 2024-10-16

fprintf('Install SPM...\n');

% Step 1: Try to get SPM version
try
    spm_version = spm('Ver');
    fprintf('SPM version: %s\n\n', spm_version);
    return;
catch
    % fprintf('Could not get SPM version. Moving to next step.\n');
end

% Step 2: Try to add SPM to path
try
    SPM_dir = dir('spm*');
    SPM_dir = SPM_dir([SPM_dir.isdir]);
    addpath(SPM_dir(1).name);
    spm_version = spm('Ver');
    fprintf('SPM version: %s\n\n', spm_version);
    return;
catch
    % fprintf('Could not add SPM to path. Moving to next step.\n');
end

% Step 3: Try to unzip SPM and add to path
try
    spm_zip = dir('spm*.zip');
    unzip(spm_zip(1).name);
    SPM_dir = dir('spm*');
    SPM_dir = SPM_dir([SPM_dir.isdir]);
    addpath(SPM_dir(1).name);
    spm_version = spm('Ver');
    fprintf('SPM version: %s\n\n', spm_version);
    return;
catch
    % fprintf('Could not unzip and add SPM to path. Moving to next step.\n');
end

% Step 4: Try to download SPM12 from official website
try
    spm_url = 'https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip';
    spm_zip = fullfile(pwd, 'spm12.zip');
    fprintf('\nStarting download from:\n%s\n', spm_url);
    websave(spm_zip, spm_url);
    fprintf('Download completed.\n\n');
    fprintf('Starting extraction and installation of SPM.\n');
    unzip(spm_zip);
    SPM_dir = dir('spm*');
    SPM_dir = SPM_dir([SPM_dir.isdir]);
    addpath(SPM_dir(1).name);
    spm_version = spm('Ver');
    fprintf('SPM version: %s\n\n', spm_version);
    return;
catch
    % fprintf('Could not download SPM from official website. Moving to next step.\n');
end

% Step 5: Try to download SPM12 from GitHub
try
    github_url = 'https://codeload.github.com/spm/spm12/zip/refs/heads/main';
    spm_zip = fullfile(pwd, 'spm12.zip');
    fprintf('\nStarting download from:\n%s\n', github_url);
    websave(spm_zip, github_url);
    fprintf('Download completed.\n\n');
    fprintf('Starting extraction and installation of SPM.\n');
    unzip(spm_zip);
    SPM_dir = dir('spm*');
    SPM_dir = SPM_dir([SPM_dir.isdir]);
    addpath(SPM_dir(1).name);
    spm_version = spm('Ver');
    fprintf('SPM version: %s\n\n', spm_version);
    return;
catch
    % fprintf('Could not download SPM from GitHub.\n');
end

% Step 6: If all steps fail, display error message
error('Failed to download and install SPM. Please install manually.');
end