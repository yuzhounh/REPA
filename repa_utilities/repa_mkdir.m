function repa_mkdir(folder_name)

if ~exist(folder_name,'dir')
    mkdir(folder_name);
end