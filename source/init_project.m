%% ----------------------------------------
%% BASE PATH
%% ----------------------------------------
base_path = '/home/kabush/';
base_name = 'CMPhaufe';

%% ----------------------------------------
%% Initialize project param structure
proj = struct();

%% ----------------------------------------
%% Link Library Tools
base_lib = [base_path,'lib/'];

proj.path.tools.kablab = [base_lib,'kablab/'];
addpath(genpath(proj.path.tools.kablab));

proj.path.tools.export_fig = [base_lib,'export_fig/'];
addpath(genpath(proj.path.tools.export_fig));

proj.path.tools.nifti = [base_lib,'nifti/'];
addpath(genpath(proj.path.tools.nifti));

%% ----------------------------------------
%% Link Atlases Path
proj.path.atlas = [base_path,'atlas'];

%% ----------------------------------------
%% Project Name
proj.path.name = base_name;

%% ----------------------------------------
%% Workspace (code,data,...)
proj.path.home = [base_path,'workspace/'];
proj.path.data = [proj.path.home,'data/',proj.path.name,'/'];
proj.path.code = [proj.path.home,'code/',proj.path.name,'/'];
proj.path.log =[proj.path.code,'log/']; 
proj.path.fig = [proj.path.code,'fig/'];
proj.path.tmp = [proj.path.code,'tmp/'];

%% Subject Lists
proj.path.subj_list = [proj.path.code,'subj_lists/'];

%% Logging (creates a unique time-stampted logfile)
formatOut = 'yyyy_mm_dd_HH:MM:SS';
t = datetime('now');
ds = datestr(t,formatOut);
proj.path.logfile = [proj.path.log,'logfile_',ds,'.txt'];

%% ----------------------------------------
%% Derivatives output directory (All top-level names)
proj.path.analysis.name = 'analysis/';

%% ----------------------------------------
%% Specific Data Paths

proj.path.haufe.cter = [proj.path.home,'data/CTER2haufe/haufe/id_ex_gm_mdl/'];
proj.path.haufe.inca = [proj.path.home,'data/INCA2haufe/haufe/id_ex_gm_mdl/'];
proj.path.haufe.hr = [proj.path.home,'data/HR2haufe/haufe/id_ex_gm_mdl/'];

%% Haufe parameters
proj.param.haufe.Npermute = 1000;

%% Clean build the directories as it runs
proj.flag.clean_build = 1;

%% Plotting parameters
proj.param.plot.axisLabelFontSize = 18;
proj.param.plot.circleSize = 10;
proj.param.plot.white = [1,1,1];
proj.param.plot.very_light_grey = [.9,.9,.9];
proj.param.plot.light_grey = [.8,.8,.8];
proj.param.plot.dark_grey = [.6,.6,.6];
proj.param.plot.axis_nudge = 0.1;
proj.param.plot.blue = [0,0,1];
proj.param.plot.orange = [1,.6,0];
proj.param.plot.red = [1,0,0];

%% ----------------------------------------
%% Seed random number generator
rng(1,'twister');

%% ----------------------------------------
%% Write out initialized project structure
save('proj.mat','proj');
