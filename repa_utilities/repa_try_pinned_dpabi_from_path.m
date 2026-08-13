function [isPinned, dpabi_version] = repa_try_pinned_dpabi_from_path(deps)
% Return true only if a pinned DPABI root is already on the MATLAB path.
isPinned = false;
dpabi_version = '';

if nargin < 1
    deps = repa_pinned_dependencies();
end

depPath = repa_find_dependency_root_on_path(deps.dpabi_folder);
if isempty(depPath)
    return;
end

repa_validate_pinned_dpabi_folder(depPath, deps);
dpabi_version = deps.dpabi_version_token;
isPinned = true;
end
