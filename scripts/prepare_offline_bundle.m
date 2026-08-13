%% Prepare offline dependency bundle for REPA
% Copy pinned SPM12 and DPABI releases into REPA/third_party/ so REPA can
% run without downloading dependencies from the internet.
%
% Usage (from MATLAB):
%   cd('<REPA root>');
%   run('scripts/prepare_offline_bundle.m');
%
% Optional: set source folders in the workspace before running:
%   spm_source = 'D:\tools\spm12';
%   dpabi_source = 'D:\tools\DPABI_V8.2_240510';
%   run('scripts/prepare_offline_bundle.m');

repa_root = fileparts(which('repa.m'));
if isempty(repa_root)
    repa_root = fileparts(fileparts(mfilename('fullpath')));
end

addpath(fullfile(repa_root, 'repa_utilities'));

deps = repa_pinned_dependencies();
target_root = repa_third_party_root();
if ~isfolder(target_root)
    mkdir(target_root);
end

fprintf('%s\n', repmat('-', 1, 72));
fprintf('Prepare REPA offline dependency bundle\n');
fprintf('Target directory: %s\n\n', target_root);

if ~exist('spm_source', 'var')
    spm_source = guess_dependency_source(deps.spm_folder);
end
if ~exist('dpabi_source', 'var')
    dpabi_source = guess_dependency_source(deps.dpabi_folder);
end

copy_dependency(spm_source, fullfile(target_root, deps.spm_folder), deps.spm_folder);
copy_dependency(dpabi_source, fullfile(target_root, deps.dpabi_folder), deps.dpabi_folder);

validate_offline_bundle(target_root, deps);

fprintf('%s\n', repmat('-', 1, 72));
fprintf('Offline bundle preparation finished.\n');
fprintf('Expected layout:\n');
fprintf('  %s\n', fullfile(target_root, deps.spm_folder));
fprintf('  %s\n\n', fullfile(target_root, deps.dpabi_folder));

function source = guess_dependency_source(folder_name)
source = repa_resolve_dependency_path(folder_name, pwd);

if ~isempty(source)
    return;
end

if strcmp(folder_name, 'spm12')
    spm_file = which('spm');
    if ~isempty(spm_file)
        candidate = fileparts(spm_file);
        [~, folder_part] = fileparts(candidate);
        if strcmpi(folder_part, 'spm12')
            source = candidate;
        end
    end
elseif contains(folder_name, 'DPABI')
    dparsfa_file = which('DPARSFA_run');
    if isempty(dparsfa_file)
        dparsfa_file = which('DPARSFA');
    end
    if ~isempty(dparsfa_file)
        candidate = fileparts(fileparts(dparsfa_file));
        if contains(candidate, 'DPABI')
            source = candidate;
        end
    end
end
end

function copy_dependency(source, target, label)
if isfolder(target)
    fprintf('Skip %s: already exists at\n  %s\n\n', label, target);
    return;
end

if isempty(source) || ~isfolder(source)
    error(['Could not find a source folder for ', label, '. ', ...
        'Set spm_source / dpabi_source before running, for example:\n', ...
        '  spm_source = ''D:\\path\\to\\spm12'';\n', ...
        '  dpabi_source = ''D:\\path\\to\\', label, ''';']);
end

[~, source_name] = fileparts(source);
if ~strcmp(source_name, label)
    error('Source folder name mismatch for %s.\nFound: %s\nRequired folder name: %s', ...
        label, source_name, label);
end

fprintf('Copying %s\n  from: %s\n  to:   %s\n', label, source, target);
copyfile(source, target);
fprintf('Done.\n\n');
end

function validate_offline_bundle(target_root, deps)
spm_target = fullfile(target_root, deps.spm_folder);
dpabi_target = fullfile(target_root, deps.dpabi_folder);

if ~isfolder(spm_target)
    error('Offline bundle incomplete: missing %s', spm_target);
end
if ~isfolder(dpabi_target)
    error('Offline bundle incomplete: missing %s', dpabi_target);
end

repa_validate_pinned_dpabi_folder(dpabi_target, deps);
fprintf('Validated pinned dependency folders under:\n  %s\n\n', target_root);
end
