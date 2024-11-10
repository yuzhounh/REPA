function repa_welcome()
% REPA_WELCOME Display welcome message for REPA toolbox
% This function prints the welcome message, version info, release date,
% and acknowledgements for the REPA toolbox.

% Load version info
load('repa_utilities/repa_version.mat','repa_version','repa_releaseDate');

% Print welcome message
fprintf('%s\n\n',repmat('-',1,72));
fprintf('REPA: REsting-state fMRI Preprocessing and Analysis\n');
fprintf('Version: %s\n', repa_version);
fprintf('Release Date: %s\n', repa_releaseDate);
fprintf('Homepage: https://github.com/yuzhounh/REPA/\n');
fprintf('Copyright (C) 2024 Jing Wang\n\n');
fprintf('This toolbox is built upon:\n');
fprintf('- SPM12\n');
fprintf('- DPABI V8.2\n\n');
fprintf('Thank you for using REPA.\n');
fprintf('For support or to report issues, please visit our GitHub page.\n');
fprintf('\n');
end