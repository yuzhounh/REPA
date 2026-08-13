function depPath = repa_resolve_dependency_path(folderName, working_dir)
% Return the first existing local directory for a pinned dependency, or ''.
candidates = {fullfile(repa_third_party_root(), folderName)};

if nargin >= 2 && ~isempty(working_dir)
    candidates{end+1} = fullfile(working_dir, folderName); %#ok<AGROW>
end

candidates{end+1} = fullfile(pwd, folderName);

for i = 1:numel(candidates)
    if isfolder(candidates{i})
        depPath = candidates{i};
        return;
    end
end

depPath = '';
end
