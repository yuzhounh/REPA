function repa_validate_pinned_dpabi_folder(depPath, deps)
% Validate that a DPABI directory matches the pinned REPA dependency.
if nargin < 2
    deps = repa_pinned_dependencies();
end

[~, folderName] = fileparts(depPath);
if ~strcmp(folderName, deps.dpabi_folder)
    repa_dependency_version_error('DPABI', folderName, deps.dpabi_folder);
end
end
