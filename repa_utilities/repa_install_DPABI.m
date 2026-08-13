function dpabi_version = repa_install_DPABI(working_dir)
% Function to check and install DPABI (Data Processing & Analysis for Brain Imaging)
% 2024-10-16

if nargin < 1
    working_dir = '';
end

deps = repa_pinned_dependencies();
fprintf('Install DPABI (pinned: %s)...\n', deps.dpabi_folder);

% Step 1: Local pinned folders (third_party first, then working directory, then pwd)
depPath = repa_resolve_dependency_path(deps.dpabi_folder, working_dir);
if ~isempty(depPath)
    dpabi_version = repa_activate_pinned_dpabi(depPath, deps);
    return;
end

% Step 2: Exact local zip archives
zipPath = repa_resolve_dependency_zip(deps.dpabi_zip_name, working_dir);
if ~isempty(zipPath)
    dpabi_version = repa_extract_and_activate_dpabi(zipPath, working_dir, deps);
    return;
end

% Step 3: Download pinned DPABI release into REPA/third_party
try
    extractDir = repa_third_party_root();
    if ~isfolder(extractDir)
        mkdir(extractDir);
    end

    dpabi_zip = fullfile(extractDir, deps.dpabi_zip_name);
    fprintf('\nStarting download into third_party from:\n%s\n', deps.dpabi_zip_url);
    websave(dpabi_zip, deps.dpabi_zip_url);
    fprintf('Download completed.\n\n');
    dpabi_version = repa_extract_and_activate_dpabi(dpabi_zip, working_dir, deps);
    return;
catch
end

% Step 4: MATLAB path, only if it already points to pinned DPABI
[isPinned, dpabi_version] = repa_try_pinned_dpabi_from_path(deps);
if isPinned
    fprintf('Using pinned DPABI already on MATLAB path.\n');
    fprintf('DPABI version: %s\n\n', dpabi_version);
    return;
end

repa_install_dependency_error('DPABI', deps.dpabi_folder, deps.dpabi_zip_url, working_dir);
end

function dpabi_version = repa_activate_pinned_dpabi(depPath, deps)
repa_validate_pinned_dpabi_folder(depPath, deps);
fprintf('Using local DPABI folder:\n%s\n', depPath);
addpath(genpath(depPath), '-begin');
dpabi_version = deps.dpabi_version_token;
fprintf('DPABI version: %s\n\n', dpabi_version);
end

function dpabi_version = repa_extract_and_activate_dpabi(zipPath, working_dir, deps)
extractDir = repa_third_party_root();
if ~isfolder(extractDir)
    mkdir(extractDir);
end

fprintf('Extracting DPABI archive:\n%s\n', zipPath);
unzip(zipPath, extractDir);

depPath = repa_resolve_dependency_path(deps.dpabi_folder, working_dir);
if isempty(depPath)
    error('DPABI archive extracted, but folder "%s" was not found under %s.', ...
        deps.dpabi_folder, extractDir);
end

dpabi_version = repa_activate_pinned_dpabi(depPath, deps);
end
