function depRoot = repa_find_dependency_root_on_path(folderName)
% Find the root directory of a dependency already present on the MATLAB path.
depRoot = '';
path_list = strsplit(path, pathsep);

for i = 1:numel(path_list)
    current = path_list{i};
    while ~isempty(current)
        [parent, name] = fileparts(current);
        if strcmp(name, folderName) && isfolder(current)
            depRoot = current;
            return;
        end
        if isequal(current, parent)
            break;
        end
        current = parent;
    end
end
end
