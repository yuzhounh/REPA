function repa_welcome()
% REPA_WELCOME Display welcome message for REPA toolbox
% This function prints the welcome message, version info, release date,
% and acknowledgements for the REPA toolbox.

% Define version info
version = '1.0.0';
releaseDate = '2024/09/23';

% Print welcome message
fprintf('\n');
fprintf('<strong>REPA:</strong> REsting-state fMRI Preprocessing and Analysis\n');
fprintf('Version: %s\n', version);
fprintf('Release Date: %s\n', releaseDate);
fprintf('Homepage: https://github.com/yuzhounh/repa/\n');
fprintf('Copyright (C) 2024 Jing Wang\n\n');
fprintf('This toolbox is built upon:\n');
fprintf('- SPM12\n');
fprintf('- DPABI V8.2\n\n');
fprintf('Thank you for using REPA. For support or to report issues, please visit our GitHub page.\n');
fprintf('\n');
end