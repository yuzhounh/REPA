function dpabi_version = repa_install_DPABI()
% Function to check and install DPABI (Data Processing & Analysis for Brain Imaging)
% 2024-10-16

fprintf('Install DPABI...\n');

% Step 1: Try to get DPABI version
try
    dpabi_version = repa_DPABI_version();
    fprintf('DPABI version: %s\n\n', dpabi_version);
    return;
catch
    % fprintf('Could not get DPABI version. Moving to next step.\n');
end

% Step 2: Try to add DPABI to path
try
    dpabi_dir = dir('DPABI*');
    dpabi_dir = dpabi_dir([dpabi_dir.isdir]);
    dpabi_dir = dpabi_dir(~endsWith({dpabi_dir.name}, '.zip'));
    addpath(genpath(dpabi_dir(1).name));
    dpabi_version = repa_DPABI_version();
    fprintf('DPABI version: %s\n\n', dpabi_version);
    return;
catch
    % fprintf('Could not add DPABI to path. Moving to next step.\n');
end

% Step 3: Try to unzip DPABI and add to path
try
    dpabi_zip = dir('DPABI*.zip');
    unzip(dpabi_zip(1).name);
    dpabi_dir = dir('DPABI*');
    dpabi_dir = dpabi_dir([dpabi_dir.isdir]);
    dpabi_dir = dpabi_dir(~endsWith({dpabi_dir.name}, '.zip'));
    addpath(genpath(dpabi_dir(1).name));
    dpabi_version = repa_DPABI_version();
    fprintf('DPABI version: %s\n\n', dpabi_version);
    return;
catch
    % fprintf('Could not unzip and add DPABI to path. Moving to next step.\n');
end

% Step 4: Try to download DPABI from official website
try
    dpabi_url = 'https://d.rnet.co/DPABI/DPABI_V8.2_240510.zip';
    dpabi_zip = fullfile(pwd, 'DPABI.zip');
    fprintf('\nStarting download from:\n%s\n', dpabi_url);
    websave(dpabi_zip, dpabi_url);
    fprintf('Completed.\n\n');
    fprintf('Starting extraction and installation of DPABI.\n');
    unzip(dpabi_zip);
    dpabi_dir = dir('DPABI*');
    dpabi_dir = dpabi_dir([dpabi_dir.isdir]);
    dpabi_dir = dpabi_dir(~endsWith({dpabi_dir.name}, '.zip'));
    addpath(genpath(dpabi_dir(1).name));
    dpabi_version = repa_DPABI_version();
    fprintf('DPABI version: %s\n\n', dpabi_version);
    return;
catch
    % fprintf('Download from %s failed. Moving to next step.\n', dpabi_url);
end

% Step 5: Try to download DPABI from GitHub
try
    github_url = 'https://codeload.github.com/Chaogan-Yan/DPABI/zip/refs/heads/master';
    dpabi_zip = fullfile(pwd, 'DPABI.zip');
    fprintf('\nStarting download from:\n%s\n', github_url);
    websave(dpabi_zip, github_url);
    fprintf('Completed.\n\n');
    fprintf('Starting extraction and installation of DPABI.\n');
    unzip(dpabi_zip);
    dpabi_dir = dir('DPABI*');
    dpabi_dir = dpabi_dir([dpabi_dir.isdir]);
    dpabi_dir = dpabi_dir(~endsWith({dpabi_dir.name}, '.zip'));
    addpath(genpath(dpabi_dir(1).name));
    dpabi_version = repa_DPABI_version();
    fprintf('DPABI version: %s\n\n', dpabi_version);
    return;
catch
    % fprintf('Download from GitHub failed.\n');
end

% Step 6: If all steps fail, display error message
error('Failed to download and install DPABI. Please install manually.');
end
