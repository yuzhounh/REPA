function repa_install_dependency_error(depLabel, folderName, zipUrl, working_dir)
% Display a detailed manual-install message and throw an error.
thirdPartyRoot = repa_third_party_root();
thirdPartyTarget = fullfile(thirdPartyRoot, folderName);

messageParts = {
    ['Failed to install pinned ', depLabel, ' release (', folderName, ').']
    ''
    'REPA searched in this order:'
    ['  1. ', thirdPartyTarget]
    };

if nargin >= 4 && ~isempty(working_dir)
    messageParts{end+1} = ['  2. ', fullfile(working_dir, folderName)];
    messageParts{end+1} = ['  3. ', fullfile(working_dir, [folderName, '.zip'])];
    stepOffset = 2;
else
    stepOffset = 0;
end

messageParts{end+1} = ['  ', num2str(2 + stepOffset), '. ', fullfile(pwd, folderName)];
messageParts{end+1} = ['  ', num2str(3 + stepOffset), '. ', fullfile(pwd, [folderName, '.zip'])];
messageParts{end+1} = ['  ', num2str(4 + stepOffset), '. Online download from ', zipUrl];
messageParts{end+1} = ['  ', num2str(5 + stepOffset), '. MATLAB path (only if already pinned ', depLabel, ')'];
messageParts{end+1} = '';
messageParts{end+1} = 'Version mismatches are rejected. Other SPM/DPABI releases on the MATLAB path are ignored.';
messageParts{end+1} = '';
messageParts{end+1} = 'Recommended offline setup:';
messageParts{end+1} = ['  - Extract ', folderName, ' into ', thirdPartyRoot];
messageParts{end+1} = '  - Or run scripts/prepare_offline_bundle.m from the REPA root directory';
messageParts{end+1} = ['  - Or download manually from ', zipUrl];

error('%s', strjoin(messageParts, newline));
end
