function [converted_ver, original_ver] = repa_DPABI_version()
    % Extract DPABI version from MATLAB path
    original_ver = original_DPABI_version();
    
    % Convert the version to the new format
    converted_ver = converted_DPABI_version(original_ver);
end

function ver = original_DPABI_version()
    % Get MATLAB path
    path_list = strsplit(path, pathsep);
    % Find the matching path
    DPABI_path = '';
    for i = 1:length(path_list)
        if contains(path_list{i}, 'DPABI_')
            DPABI_path = path_list{i};
            break;
        end
    end
    % If a matching path is found, extract the version number
    version = regexp(DPABI_path, 'V\d+\.\d+_\d+', 'match');
    if isempty(version)
        ver = 'Version not found';
    else
        ver = version{1};
    end
end

function ver = converted_DPABI_version(version_string)
    % Check if the version string is valid
    if ~regexp(version_string, '^V\d+\.\d+_\d{6}$', 'once')
        ver = 'Invalid version format';
        return;
    end
    
    % Extract version number and date
    parts = strsplit(version_string, '_');
    version = lower(parts{1}); % Convert 'V' to 'v'
    date_str = parts{2};
    
    % Convert date format
    year = str2double(['20', date_str(1:2)]);
    month = str2double(date_str(3:4));
    day = str2double(date_str(5:6));
    
    % Format the converted version string
    ver = sprintf('%s (released in %04d/%02d/%02d)', version, year, month, day);
end