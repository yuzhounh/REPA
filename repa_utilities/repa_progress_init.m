function repa_progress_init
% Time stamp file
time_stamp_file = 'repa_utilities/repa_time_stamp.csv';

% Delete if it exists
if isfile(time_stamp_file)
    delete(time_stamp_file);
end

% Create or open CSV file
fileID = fopen(time_stamp_file, 'a');

% Write header if file is empty
if ftell(fileID) == 0
    fprintf(fileID, 'iterations,time\n');
end

% Get current time and format it
current_time = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');

% Write current iteration and timestamp
fprintf(fileID, '0,%s\n', char(current_time));

% Close file
fclose(fileID);
end