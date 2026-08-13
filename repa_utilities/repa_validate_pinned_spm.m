function repa_validate_pinned_spm(spm_version, deps)
% Validate that the loaded SPM release matches the pinned REPA dependency.
if nargin < 2
    deps = repa_pinned_dependencies();
end

normalized = upper(strtrim(spm_version));
required = upper(deps.spm_version_prefix);

if ~startsWith(normalized, required)
    repa_dependency_version_error('SPM', spm_version, deps.spm_version_prefix);
end
end
