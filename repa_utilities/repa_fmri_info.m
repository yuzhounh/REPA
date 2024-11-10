function repa_fmri_info(working_dir, output_file)
    % Main function to process all subject folders and write results to CSV
    results = cell(1, 1000);  % Pre-allocate cell array
    result_count = 0;
    
    folders = dir(fullfile(working_dir, 'FunImg', '*'));
    folders = folders([folders.isdir] & ~strcmp({folders.name}, '.') & ~strcmp({folders.name}, '..'));
    
    diary(fullfile(working_dir,'repa_summary.txt'));
    for i = 1:numel(folders)
        folder_path = fullfile(working_dir, 'FunImg', folders(i).name);
        fMRI_info = repa_read_fmri_info(folder_path);
        
        if ~isempty(fMRI_info)
            result_count = result_count + 1;
            results{result_count} = fMRI_info;
            
            fMRI_info_file = fullfile(working_dir, 'fMRI_info', [folders(i).name, '.mat']);
            save(fMRI_info_file, 'fMRI_info');
        end
    end
    results = results(1:result_count);  % Trim unused cells
    diary off;
    
    % Write results to CSV
    fid = fopen(output_file, 'w');
    fprintf(fid, 'SubjectID,Manufacturer,ImageSize,VoxelSize,TimePoints,RepetitionTime (TR),SliceNumber,SliceOrder\n');
    for i = 1:length(results)
        result = results{i};
        fprintf(fid, '%s,%s,%s,%s,%d,%0.2f,%d,%s\n', ...
            result.SubjectID, ...
            result.Manufacturer, ...
            mat2str(result.ImageSize), ...
            mat2str(result.VoxelSize, 5), ...
            result.TimePoints, ...
            result.RepetitionTime, ...
            result.SliceNumber, ...
            mat2str(result.SliceOrder));
    end
    fclose(fid);
    
    % Extract TimePoints safely
    time_points_array = zeros(1, length(results));
    for i = 1:length(results)
        if isfield(results{i}, 'TimePoints')
            time_points_array(i) = results{i}.TimePoints;
        else
            time_points_array(i) = NaN;  % or some other default value
        end
    end
    
    % Count occurrences of TimePoints
    [unique_time_points, ~, ic] = unique(time_points_array);
    time_points_count = accumarray(ic, 1);
    
    % Find and print abnormal time points
    diary(fullfile(working_dir,'repa_summary.txt'));
    if sum(time_points_count <= 3) > 0
        fprintf('%s\n\n',repmat('-',1,72));
        fprintf('Subjects with abnormal time points (occurrence <= 3):\n\n');
        fprintf('Subject ID, time points\n');
        for i = 1:length(unique_time_points)
            if time_points_count(i) <= 3
                abnormal_indices = find(time_points_array == unique_time_points(i));
                for j = 1:length(abnormal_indices)
                    subject = results{abnormal_indices(j)};
                    fprintf('%s, %d\n', subject.SubjectID, subject.TimePoints);
                end
            end
        end
        fprintf('\n');
    end
    diary off;
    
    fprintf('%s\n\n',repmat('-',1,72));
    fprintf('The fMRI data information has been exported to:\n%s\n\n', output_file);
    fprintf('%s\n\n',repmat('-',1,72));
end

function result = repa_read_fmri_info(folder_path)
    % Process a single subject folder
    [~, subject_id, ~] = fileparts(folder_path);
    
    % Find JSON and NII files
    json_file = dir(fullfile(folder_path, '*.json'));
    nii_file = dir(fullfile(folder_path, '*.nii'));
    
    % Incorrect number of files
    if numel(nii_file) ~= 1 || numel(json_file) ~= 1
        Error = sprintf('Incorrect number of files in: %s\n', subject_id);
        fprintf(Error);
        fprintf(' .nii files: %d\n', numel(nii_file));
        fprintf('.json files: %d\n\n', numel(json_file));
        result = [];
        
        % save error
        Type = 0;  
        repa_save_error(subject_id, Error, Type);
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
    
    % Time points
    if numel(nii_info.ImageSize) == 4
        time_points = nii_info.ImageSize(4);
    else
        time_points = 1;
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
                    'TimePoints', time_points, ...
                    'RepetitionTime', repetition_time, ...
                    'SliceNumber', slice_number, ...
                    'SliceOrder', slice_order);
end