function spm_version = repa_install_SPM(working_dir)
% Function to check and install SPM (Statistical Parametric Mapping)
% 2024-10-16

if nargin < 1
    working_dir = '';
end

deps = repa_pinned_dependencies();
fprintf('Install SPM (pinned: %s)...\n', deps.spm_folder);

% Step 1: Local pinned folders (third_party first, then working directory, then pwd)
depPath = repa_resolve_dependency_path(deps.spm_folder, working_dir);
if ~isempty(depPath)
    spm_version = repa_activate_pinned_spm(depPath, deps);
    return;
end

% Step 2: Exact local zip archives
zipPath = repa_resolve_dependency_zip(deps.spm_zip_name, working_dir);
if ~isempty(zipPath)
    spm_version = repa_extract_and_activate_spm(zipPath, working_dir, deps);
    return;
end

% Step 3: Download pinned SPM12 release into REPA/third_party
try
    extractDir = repa_third_party_root();
    if ~isfolder(extractDir)
        mkdir(extractDir);
    end

    spm_zip = fullfile(extractDir, deps.spm_zip_name);
    fprintf('\nStarting download into third_party from:\n%s\n', deps.spm_zip_url);
    websave(spm_zip, deps.spm_zip_url);
    fprintf('Download completed.\n\n');
    spm_version = repa_extract_and_activate_spm(spm_zip, working_dir, deps);
    return;
catch
end

% Step 4: MATLAB path, only if it already points to pinned spm12
[isPinned, spm_version] = repa_try_pinned_spm_from_path(deps);
if isPinned
    fprintf('Using pinned SPM already on MATLAB path.\n');
    fprintf('SPM version: %s\n\n', spm_version);
    return;
end

repa_install_dependency_error('SPM', deps.spm_folder, deps.spm_zip_url, working_dir);
end

function spm_version = repa_activate_pinned_spm(depPath, deps)
fprintf('Using local SPM folder:\n%s\n', depPath);
addpath(depPath, '-begin');
spm_version = spm('Ver');
repa_validate_pinned_spm(spm_version, deps);
fprintf('SPM version: %s\n\n', spm_version);
end

function spm_version = repa_extract_and_activate_spm(zipPath, working_dir, deps)
extractDir = repa_third_party_root();
if ~isfolder(extractDir)
    mkdir(extractDir);
end

fprintf('Extracting SPM archive:\n%s\n', zipPath);
unzip(zipPath, extractDir);

depPath = repa_resolve_dependency_path(deps.spm_folder, working_dir);
if isempty(depPath)
    error('SPM archive extracted, but folder "%s" was not found under %s.', ...
        deps.spm_folder, extractDir);
end

spm_version = repa_activate_pinned_spm(depPath, deps);
end
