
clear;
load('config.mat');
addpath(genpath(Utildir));

% Step 1: average profiles
cmd = [matlab ' -nosplash -nodesktop -r ' ...
       '"addpath(genpath(''' Utildir '''));load(''' Codedir '/config.mat'');' ...
       'CBIG_MSHBM_avg_profiles(seed_mesh,targ_mesh,out_dir,total_subs,total_sess);' ...
       'exit(0)">"' LogFolder '/log_avg_profiles.txt" 2>&1'];
ScriptPath = [LogFolder '/avg_profiles.sh'];
fid = fopen(ScriptPath, 'w');
fprintf(fid, cmd);
%system(['sh ' ScriptPath]);

% Step 2: Calculating group atlas
iteration = '1000';
mkdir(LogFolder);
cmd = [matlab ' -nosplash -nodesktop -r ' ...
       '"addpath(genpath(''' Utildir '''));load(''' Codedir '/config.mat'');' ...
       'CBIG_MSHBM_generate_ini_params(seed_mesh,targ_mesh,''17'',''' iteration ''',ProjectFolder);' ...
       'exit(0)">"' LogFolder '/log_generate_ini_params.txt" 2>&1'];
ScriptPath = [LogFolder '/generate_ini_params.sh'];
fid = fopen(ScriptPath, 'w');
fprintf(fid, cmd);
%system(['sh ' ScriptPath]);

% Generating the profile list
%%% seems like this is done in S3 so... if anything goes wrong put it back
%%% here again

% Estimate priors
mkdir(LogFolder);
cmd = [matlab ' -nosplash -nodesktop -r ' ...
       '"addpath(genpath(''' Codedir '''));load(''' Codedir '/config.mat'');' ...
       'CBIG_MSHBM_estimate_group_priors(ProjectFolder,targ_mesh,total_subs,total_sess,''17'');' ...
       'exit(0)">"' LogFolder '/log_estimate_group_priors.txt" 2>&1'];
ScriptPath = [LogFolder '/estimate_group_priors.sh'];
fid = fopen(ScriptPath, 'w');
fprintf(fid, cmd);
%system(['sh ' ScriptPath]);

