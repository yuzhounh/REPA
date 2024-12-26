# REPA

[![License](https://img.shields.io/badge/License-LGPL%20v2.1-blue.svg)](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

REPA (Resting-state fMRI Preprocessing and Analysis) is a toolbox developed based on SPM and DPABI for processing resting-state fMRI data.

## Requirements

- MATLAB
- SPM12
- DPABI

## Installation

1. Download REPA from this repository
2. Add REPA folder to MATLAB path
3. Run `repa.m` to start the GUI

<img src="repa_utilities/repa_gui.png" width="80%" style="display: block; margin: 0 auto;">

## Data Organization

REPA expects input data to be organized in a specific directory structure as shown below:

For DICOM format data, please organize your data in the following structure:

```
RootDir/
├── FunRaw/
│   ├── sub000001/
│   │   ├── 000001.dcm
│   │   ├── 000002.dcm
│   │   ├── 000003.dcm
│   │   └── ......
│   ├── sub000002/
│   │   ├── 000001.dcm
│   │   ├── 000002.dcm
│   │   ├── 000003.dcm
│   │   └── ......
│   ├── sub000003/
│   │   ├── 000001.dcm
│   │   ├── 000002.dcm
│   │   ├── 000003.dcm
│   │   └── ......
│   └── ......
└── T1Raw/
    ├── sub000001/
    │   ├── 000001.dcm
    │   ├── 000002.dcm
    │   ├── 000003.dcm
    │   └── ......
    ├── sub000002/
    │   ├── 000001.dcm
    │   ├── 000002.dcm
    │   ├── 000003.dcm
    │   └── ......
    ├── sub000003/
    │   ├── 000001.dcm
    │   ├── 000002.dcm
    │   ├── 000003.dcm
    │   └── ......
    └── ......
```

For NIFTI format data, please organize your data in the following structure:

```
RootDir/
├── FunImg/
│   ├── sub000001/
│   │   ├── sub000001_task-rest_bold.nii
│   │   └── sub000001_task-rest_bold.json
│   ├── sub000002/
│   │   ├── sub000002_task-rest_bold.nii
│   │   └── sub000002_task-rest_bold.json
│   ├── sub000003/
│   │   ├── sub000003_task-rest_bold.nii
│   │   └── sub000003_task-rest_bold.json
│   └── ......
└── T1Img/
    ├── sub000001/
    │   ├── sub000001_T1w.nii
    │   ├── sub000001_T1w_Crop_1.nii
    │   └── sub000001_T1w.json
    ├── sub000002/
    │   ├── sub000002_T1w.nii
    │   ├── sub000002_T1w_Crop_1.nii
    │   └── sub000002_T1w.json
    ├── sub000003/
    │   ├── sub000003_T1w.nii
    │   ├── sub000003_T1w_Crop_1.nii
    │   └── sub000003_T1w.json
    └── ......
```

For testing and demonstration purposes, you can download sample resting-state fMRI data in DICOM format from:
https://rfmri.org/content/demonstrational-data-resting-state-fmri

The data is already organized in the required directory structure and can be used directly with REPA after downloading and extracting.

## Usage Instructions

1. Organize your data according to the directory structure shown above
2. Open the REPA toolbox and set the following parameters in the interface:
   - `Working directory`: Set to the full path of your data root directory (RootDir)
   - `Time points to remove`: Set the number of initial time points to remove (default is 10)
   - `Voxel size (mm)`: Set the voxel dimensions in [x, y, z] format (default is [3, 3, 3])
   - `FWHM (mm)`: Set the spatial smoothing full-width at half maximum in [x, y, z] format (default is [6, 6, 6])
   - `Filter band (Hz)`: Set the temporal filtering frequency range in [low, high] format (default is [0.01, 0.1])
3. Click the `RUN` button to start processing

## Processing Pipeline

1. **Remove the first few time points**: The first few volumes are discarded to allow signal stabilization.

2. **Slice Timing Correction**: All functional time series are processed by slice timing correction to account for differences in slice acquisition timing.

3. **Realignment**: Motion correction is applied to realign all functional volumes and correct for head movement.

4. **Generating Automask**: Automask is generated for checking EPI coverage and creating group mask.

5. **BET**: Brain Extraction Tool (BET) is used to remove non-brain tissue from images.

6. **Coregistration**: The structural T1 image is coregistered to the mean functional image to maximize mutual information between them.

7. **Segmentation**: The coregistered structural data is segmented into gray matter, white matter and cerebrospinal fluid using New Segment, followed by DARTEL registration.

8. **Nuisance Covariates Regression**: Nuisance covariates regression removes noise including polynomial trend, head motion parameters (Friston 24-parameter model), and mean signals from white matter, CSF and global signal.

9. **Normalization**: The preprocessed data is normalized to MNI space using DARTEL transformations.

10. **ALFF**: ALFF and fALFF analyses are performed to measure the amplitude of low frequency fluctuations.

11. **Filtering**: Temporal bandpass filtering is applied with frequency range 0.01-0.1 Hz.

12. **ReHo**: Regional Homogeneity (ReHo) analysis is conducted to measure local connectivity.

13. **Degree Centrality**: Degree Centrality is calculated as a measure of global connectivity.

14. **VMHC**: Data is normalized to symmetric template for VMHC (Voxel-Mirrored Homotopic Connectivity) analysis.

15. **Smoothing**: Spatial smoothing is applied to all derivative maps.

## Key Features

1. **Flexible Data Input**: 
   - Supports both DICOM and NiFTI format data as input
   - Complete resting-state fMRI preprocessing pipeline with default settings
   - Comprehensive data analysis capabilities

2. **Automated Slice Timing Parameters**:
   - Automatically extracts slice timing information from JSON metadata
   - Calculates slice number, slice order, and reference slice
   - Less manual parameter input needed

3. **Data Documentation**:
   - Saves key fMRI acquisition parameters and metadata
   - Stores preprocessing configuration files for each subject
   - Maintains complete processing history

4. **Robust Processing**:
   - Serial processing to avoid errors and memory issues
   - Error logging for failed subjects with detailed diagnostics
   - Easy error tracking and debugging

5. **Enhanced User Experience**:
   - Clean and organized console output
   - Real-time progress tracking
   - Estimated time remaining for each processing step
   - Clear status updates throughout pipeline execution
