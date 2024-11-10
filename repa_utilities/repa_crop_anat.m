function repa_crop_anat(t1_image)
% repa_crop_anat - Reorient, normalize, and crop a T1 image using SPM

% Check if the input file exists
if ~exist(t1_image, 'file')
    error('Input T1 image file does not exist: %s', t1_image);
end

% Initialize SPM
spm('defaults', 'FMRI');
spm_jobman('initcfg');

% % Get the directory and filename of the input image
% [filepath, name, ext] = fileparts(t1_image);
% output_filename = fullfile(filepath, [name, '_Crop_1', ext]);

% Define path to SPM template
template_image = fullfile(spm('Dir'), 'tpm', 'TPM.nii');

% Set up the batch job for normalization
matlabbatch = {};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {t1_image};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {t1_image};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {template_image};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70; 78 76 85];  % Bounding box
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [1 1 1];  % Voxel size
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;  % Interpolation
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';

% Run the batch job
spm_jobman('run', matlabbatch);

end