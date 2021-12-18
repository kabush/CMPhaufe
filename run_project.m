%%========================================
%%========================================
%%
%% Keith Bush, PhD (2021)
%% Univ. of Arkansas for Medical Sciences
%% Brain Imaging Research Center (BIRC)
%%
%%========================================
%%========================================

tic

%% ----------------------------------------
%% Clean up matlab environment
matlab_reset;

%% ----------------------------------------
%% Link all source code
addpath(genpath('./source/'));

%% ----------------------------------------
%% Initialize the projects directories and parameters.
init_project;

% %% ----------------------------------------
% %% Set-up top-level data directory structure
% clean_project;

%% ----------------------------------------
%% Encoding evaluation
analyze_encoding_all_voxels;
analyze_encoding_sig_voxels;

toc
