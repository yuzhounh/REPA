function deps = repa_pinned_dependencies()
% Pinned third-party versions tested with the current REPA release.
deps.repa_version = '1.35.0';
deps.third_party_folder = 'third_party';
deps.spm_folder = 'spm12';
deps.spm_version_prefix = 'SPM12';
deps.spm_zip_name = 'spm12.zip';
deps.spm_zip_url = 'https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip';
deps.dpabi_folder = 'DPABI_V8.2_240510';
deps.dpabi_version_token = 'V8.2_240510';
deps.dpabi_zip_name = 'DPABI_V8.2_240510.zip';
deps.dpabi_zip_url = 'https://d.rnet.co/DPABI/DPABI_V8.2_240510.zip';
end
