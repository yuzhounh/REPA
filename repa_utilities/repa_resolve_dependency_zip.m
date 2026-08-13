function zipPath = repa_resolve_dependency_zip(zipName, working_dir)
% Return the first existing exact zip archive for a pinned dependency, or ''.
searchDirs = {repa_third_party_root()};

if nargin >= 2 && ~isempty(working_dir)
    searchDirs{end+1} = working_dir; %#ok<AGROW>
end

searchDirs{end+1} = pwd;

for i = 1:numel(searchDirs)
    candidate = fullfile(searchDirs{i}, zipName);
    if isfile(candidate)
        zipPath = candidate;
        return;
    end
end

zipPath = '';
end
