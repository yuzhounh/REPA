% remove path: DPABI_V8.2_240510\DPARSF\Subfunctions
% 2024-9-19 16:20:32

% Get the current MATLAB path
current_path = path;

% Split the path into individual folders
folders = strsplit(current_path, pathsep);

% Find folders containing 'DPABI_'
dpabi_folders = folders(contains(folders, 'DPABI'));

% DPABI folders
[shortest_length, shortest_index] = min(cellfun(@length, dpabi_folders));
shortest_path = dpabi_folders{shortest_index};

% remove path: DPABI_V8.2_240510\DPARSF\Subfunctions
subfunctions_path = fullfile(shortest_path, 'DPARSF', 'Subfunctions');
if contains(path, subfunctions_path)
    rmpath(subfunctions_path);
end 

% check 
subfunctions_path_new = fileparts(which('y_reho.m'));

% % Display
% fprintf('%s\n\n',repmat('-',1,72));
% fprintf('Found DPABI folders: \n%s\n\n', shortest_path);
% fprintf(['The functions located in: \n%s\nhave been replaced with the ' ...
%     'modified functions located in:\n%s\n\n'], subfunctions_path, ...
%     subfunctions_path_new);