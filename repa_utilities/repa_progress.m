function repa_progress(i, n)
    % time stamp file
    time_stamp_file = 'repa_utilities/repa_time_stamp.csv';
    % Create or open CSV file
    fileID = fopen(time_stamp_file, 'a');
    
    % Get current time and format it
    current_time = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
    
    % Write current iteration and timestamp
    fprintf(fileID, '%d/%d,%s\n', i, n, char(current_time));
    
    % Close file
    fclose(fileID);
    
    % Calculate and display progress if not the first iteration
    % Read CSV file
    data = readtable(time_stamp_file);

    % Get start time and current time
    start_time = datetime(data.time(1), 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
    current_time = datetime(data.time(end), 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

    % Calculate elapsed time (seconds)
    elapsed_time = seconds(current_time - start_time);

    % Calculate progress percentage
    progress_percentage = i * 100 / n;

    % Estimate remaining time using the length of data.time
    k = size(data, 1);
    estimated_remaining_time = elapsed_time * (n - i) / (k - 1);

    % Calculate estimated end time
    estimated_end_time = current_time + seconds(estimated_remaining_time);
    
    % Format output string
    if i~=n
        output_str = sprintf('Progress: %.1f%% | Iterations: %d/%d | Elapsed Time: %s \nEstimated Remaining Time: %s\nEstimated End Time: %s\n', ...
            progress_percentage, ...
            i, ...
            n, ...
            format_time_detailed(elapsed_time), ...
            format_time_detailed(estimated_remaining_time), ...
            datestr(estimated_end_time, 'yyyy-mm-dd HH:MM:SS'));
    else
        output_str = sprintf('Progress: %.1f%% | Iterations: %d/%d | Elapsed Time: %s\nEnd Time: %s\n', ...
            progress_percentage, ...
            i, ...
            n, ...
            format_time_detailed(elapsed_time), ...
            datestr(estimated_end_time, 'yyyy-mm-dd HH:MM:SS'));
    end
    % Display formatted output
    fprintf('%s\n',repmat('-',1,72));
    fprintf('%s', output_str);
    fprintf('%s\n\n',repmat('-',1,72));
end

function formatted_time = format_time_detailed(time_in_seconds)
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
    
    formatted_time = [formatted_time sprintf('%.2fs', seconds)];
end