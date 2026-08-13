function root = repa_third_party_root()
% Return the bundled dependency directory under the REPA installation root.
root = fullfile(fileparts(which('repa.m')), 'third_party');
end
