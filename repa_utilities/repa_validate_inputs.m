function [ok, message] = repa_validate_inputs(para)
% Validate GUI / script inputs before starting REPA.
ok = true;
message = '';

if ~isfield(para, 'working_dir') || isempty(para.working_dir)
    ok = false;
    message = 'Working directory is required.';
    return;
end

if ~isfolder(para.working_dir)
    ok = false;
    message = sprintf('Working directory does not exist:\n%s', para.working_dir);
    return;
end

try
    repa_check_directories(para.working_dir, para.starting_dir);
catch ME
    ok = false;
    message = ME.message;
    return;
end

if ~isfield(para, 'time_points_removed') || isnan(para.time_points_removed) || para.time_points_removed < 0
    ok = false;
    message = 'Time points to remove must be a non-negative number.';
    return;
end

if ~isfield(para, 'voxel_size') || numel(para.voxel_size) ~= 3 || any(para.voxel_size <= 0)
    ok = false;
    message = 'Voxel size must be a 3-element positive vector, e.g. [3, 3, 3].';
    return;
end

if ~isfield(para, 'FWHM') || numel(para.FWHM) ~= 3 || any(para.FWHM <= 0)
    ok = false;
    message = 'FWHM must be a 3-element positive vector, e.g. [6, 6, 6].';
    return;
end

if ~isfield(para, 'filter_band') || numel(para.filter_band) ~= 2 || para.filter_band(1) <= 0 || para.filter_band(2) <= para.filter_band(1)
    ok = false;
    message = 'Filter band must be [low, high] in Hz, with 0 < low < high.';
    return;
end
end
