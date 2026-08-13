function status = repa_check_dependencies_status()
% Summarize pinned dependency availability for the GUI (no download).
status = struct('ok', true, 'lines', {{}});
dpabiPath = '';

deps = repa_pinned_dependencies();
status.lines{end+1} = sprintf('REPA %s', deps.repa_version);

try
    [isPinned, spmVersion] = repa_try_pinned_spm_from_path(deps);
    if isPinned
        status.lines{end+1} = ['SPM: ', spmVersion, ' (MATLAB path)'];
    else
        spmPath = repa_resolve_dependency_path(deps.spm_folder, '');
        if ~isempty(spmPath)
            status.lines{end+1} = ['SPM: found at ', spmPath];
        else
            status.ok = false;
            status.lines{end+1} = ['SPM: pinned ', deps.spm_folder, ' not found'];
        end
    end
catch ME
    status.ok = false;
    status.lines{end+1} = ['SPM: ', ME.message];
end

try
    [isPinned, dpabiVersion] = repa_try_pinned_dpabi_from_path(deps);
    if isPinned
        status.lines{end+1} = ['DPABI: ', dpabiVersion, ' (MATLAB path)'];
        dpabiPath = repa_find_dependency_root_on_path(deps.dpabi_folder);
    else
        dpabiPath = repa_resolve_dependency_path(deps.dpabi_folder, '');
        if ~isempty(dpabiPath)
            status.lines{end+1} = ['DPABI: found at ', dpabiPath];
        else
            status.ok = false;
            status.lines{end+1} = ['DPABI: pinned ', deps.dpabi_folder, ' not found'];
        end
    end
catch ME
    status.ok = false;
    status.lines{end+1} = ['DPABI: ', ME.message];
end

if exist('niftiinfo', 'file') == 2
    status.lines{end+1} = 'MATLAB niftiinfo: available';
else
    status.ok = false;
    status.lines{end+1} = 'MATLAB niftiinfo: not available (Image Processing Toolbox recommended)';
end

if ~isempty(dpabiPath)
    dcm2niixDir = fullfile(dpabiPath, 'DPARSF', 'dcm2nii');
    if isfolder(dcm2niixDir)
        if ispc && isfile(fullfile(dcm2niixDir, 'dcm2niix.exe'))
            status.lines{end+1} = 'dcm2niix: bundled with DPABI (Windows)';
        elseif ismac && isfile(fullfile(dcm2niixDir, 'dcm2niix_mac'))
            status.lines{end+1} = 'dcm2niix: bundled with DPABI (macOS)';
        elseif isunix && isfile(fullfile(dcm2niixDir, 'dcm2niix_linux'))
            status.lines{end+1} = 'dcm2niix: bundled with DPABI (Linux)';
        else
            status.ok = false;
            status.lines{end+1} = 'dcm2niix: folder found, but platform binary missing';
        end
    else
        status.lines{end+1} = 'dcm2niix: not found under DPABI/DPARSF/dcm2nii';
    end
end

status.lines{end+1} = ['Offline folder: ', repa_third_party_root()];
end
