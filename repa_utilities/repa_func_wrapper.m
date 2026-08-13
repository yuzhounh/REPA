function repa_func_wrapper(para)
% Background worker entry point for the REPA GUI.
if isfield(para, 'repa_root') && ~isempty(para.repa_root)
    addpath(genpath(fullfile(para.repa_root, 'repa_utilities')), '-begin');
end
repa_func(para);
end
