function [isPinned, spm_version] = repa_try_pinned_spm_from_path(deps)
% Return true only if spm.m on the MATLAB path belongs to pinned spm12.
isPinned = false;
spm_version = '';

if nargin < 1
    deps = repa_pinned_dependencies();
end

spm_file = which('spm');
if isempty(spm_file)
    return;
end

spm_root = fileparts(spm_file);
[~, folderName] = fileparts(spm_root);
if ~strcmp(folderName, deps.spm_folder)
    return;
end

spm_version = spm('Ver');
repa_validate_pinned_spm(spm_version, deps);
isPinned = true;
end
