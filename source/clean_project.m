%% Load in path data
load('proj.mat');

if(proj.flag.clean_build)

    %% Create project directory
    disp(['Creating data sub-directories']);

    %% Create all top-level directories
    eval(['! rm -rf ',proj.path.data,proj.path.analysis.name]);
    eval(['! mkdir ',proj.path.data,proj.path.analysis.name]);

end