function result = repa_read_fmri_info(folder_path)
    % Process a single subject folder
    [~, subject_id, ~] = fileparts(folder_path);
    
    % Find JSON and NII files
    json_file = dir(fullfile(folder_path, '*.json'));
    nii_file = dir(fullfile(folder_path, '*.nii'));
    
    if isempty(json_file) || isempty(nii_file)
        fprintf('Missing files for %s\n', subject_id);
        result = [];
        return;
    end
    
    % Process JSON file
    json_data = jsondecode(fileread(fullfile(folder_path, json_file(1).name)));
    manufacturer = '';
    repetition_time = [];
    slice_timing = [];
    
    if isfield(json_data, 'Manufacturer')
        manufacturer = json_data.Manufacturer;
    end
    if isfield(json_data, 'RepetitionTime')
        repetition_time = json_data.RepetitionTime;
    end
    if isfield(json_data, 'SliceTiming')
        slice_timing = json_data.SliceTiming;
    end
    
    % Process NII file
    nii_info = niftiinfo(fullfile(folder_path, nii_file(1).name));
    image_size = nii_info.ImageSize;
    slice_number = image_size(3);
    voxel_size = nii_info.PixelDimensions(1:3);
    
    % time points
    try
        time_points = nii_info.ImageSize(4);
    catch
        time_points = 1;
    end

    % check time points
    if time_points ~= 200 && time_points ~= 230
        fprintf('Subject ID, time points\n');
        fprintf('%s, %d\n\n', subject_id, time_points);
    end

    % Calculate SliceOrder
    if ~isempty(slice_timing)
        [~, slice_order] = sort(slice_timing);
    else
        slice_order = [];
    end
    
    result = struct('SubjectID', subject_id, ...
                    'Manufacturer', manufacturer, ...
                    'ImageSize', image_size, ...
                    'VoxelSize', voxel_size, ...
                    'TimePoints', time_points,...
                    'RepetitionTime', repetition_time, ...
                    'SliceNumber', slice_number, ...
                    'SliceOrder', slice_order);
end