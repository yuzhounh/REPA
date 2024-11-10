function repa_progress_mini(elapsed_time, current_iteration, total_iterations)
    % Calculate estimated remaining time
    remaining_iterations = total_iterations - current_iteration;
    estimated_remaining_time = (elapsed_time / current_iteration) * remaining_iterations;
    
    % Format the remaining time
    remaining_time_str = format_time(estimated_remaining_time);
    
    % Calculate progress percentage
    progress_percentage = (current_iteration / total_iterations) * 100;
    
    % Display progress - omit remaining time for final iteration
    if current_iteration == total_iterations
        fprintf('Iteration: %d/%d\nProgress: %.1f%%\n', ...
            current_iteration, total_iterations, progress_percentage);
    else
        fprintf('Iteration: %d/%d\nProgress: %.1f%%\nEstimated Remaining Time: %s\n', ...
            current_iteration, total_iterations, progress_percentage, remaining_time_str);
    end
end

function time_str = format_time(time_in_seconds)
    % Convert seconds to hours, minutes and seconds
    hours = floor(time_in_seconds / 3600);
    minutes = floor((time_in_seconds - hours * 3600) / 60);
    seconds = round(mod(time_in_seconds, 60));
    
    % Format the time string
    if hours > 0
        time_str = sprintf('%dh %dm %ds', hours, minutes, seconds);
    elseif minutes > 0
        time_str = sprintf('%dm %ds', minutes, seconds);
    else
        time_str = sprintf('%ds', seconds);
    end
end