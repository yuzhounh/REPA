function repa_progress(i, n, working_dir)
% time stamp file
time_stamp_file = fullfile(working_dir, 'repa_time_stamp.csv');

% Create or open CSV file
fileID = fopen(time_stamp_file, 'a');

% Get current time and format it
current_time = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');

% Write current iteration and timestamp
fprintf(fileID, '%d/%d,%s\n', i, n, char(current_time));

% Close file
fclose(fileID);

% Calculate and display progress
% Read CSV file
data = readtable(time_stamp_file);
k = size(data, 1);

% Calculate progress percentage
progress_percentage = i * 100 / n;

% Get start time and current time
start_time = datetime(data.time(1), 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
current_time = datetime(data.time(end), 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

% Calculate total elapsed time (seconds)
total_elapsed_time = seconds(current_time - start_time);

% Estimate remaining time using the length of data.time
estimated_remaining_time = total_elapsed_time * (n - i) / (k - 1);

% Calculate last elapsed time if not the first iteration
if size(data, 1) > 1
    last_time = datetime(data.time(end-1), 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
    last_elapsed_time = seconds(current_time - last_time);
else
    last_elapsed_time = total_elapsed_time;
end

% Calculate estimated end time
estimated_end_time = current_time + seconds(estimated_remaining_time);

% Function to format output lines with aligned colons
    function formatted_line = format_line(label, value)
        formatted_line = sprintf('%*s: %s\n', 35, label, value);
    end

% Format output string
output_str = format_line('Iterations', sprintf('%d/%d', i, n));
output_str = [output_str format_line('Progress', sprintf('%.1f%%', progress_percentage))];
output_str = [output_str format_line('Iteration Time', repa_format_time(last_elapsed_time))];
output_str = [output_str format_line('Total Elapsed Time', repa_format_time(total_elapsed_time))];
if i ~= n
    output_str = [output_str format_line('Estimated Remaining Time', repa_format_time(estimated_remaining_time))];
end
output_str = [output_str format_line('Start Time', char(datetime(start_time, 'Format', 'yyyy-MM-dd HH:mm:ss')))];
output_str = [output_str format_line('Estimated End Time', char(datetime(estimated_end_time, 'Format', 'yyyy-MM-dd HH:mm:ss')))];

% Display formatted output
fprintf('%s\n',repmat('-',1,72));
fprintf('%s', output_str);
fprintf('%s\n',repmat('-',1,72));
fprintf('\n');

end


function formatted_time = repa_format_time(time_in_seconds)
% Format time in days, hours, minutes and seconds with decimal precision
days = floor(time_in_seconds / 86400);
hours = floor(mod(time_in_seconds, 86400) / 3600);
minutes = floor(mod(time_in_seconds, 3600) / 60);
seconds = mod(time_in_seconds, 60);

formatted_time = '';

if days > 0
    formatted_time = [formatted_time sprintf('%dd ', days)];
end

if hours > 0 || days > 0
    formatted_time = [formatted_time sprintf('%dh ', hours)];
end

if minutes > 0 || hours > 0 || days > 0
    formatted_time = [formatted_time sprintf('%dm ', minutes)];
end

formatted_time = [formatted_time sprintf('%.1fs', seconds)];
end

