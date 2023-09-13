
clear;
load('config.mat');
system(['rm -rf ' ProjectFolder  '/*']);
mkdir(fMRIListFolder);
mkdir(censorListFolder);
IDs = csvread(idFile,1);
 
%%%disp(mfilename('fullpath'));
 
for i = 1:total_subs
    ID_Str = num2str(IDs(i,1));
    % session 1, REST1 LR
    FilePath = [fMRIListFolder '/sub' num2str(i) '_sess1.txt'];
    cmd = ['echo ' SubjectsFolder '/sub-' ID_Str '/func/sub-' ID_Str ...
           '_task-REST1_acq-LR_space-fsLR_den-91k_desc-clean_smooth_bold.dtseries.nii >> ' FilePath];
    system(cmd);
    % session 2, REST1 RL
    FilePath = [fMRIListFolder '/' 'sub' num2str(i) '_sess2.txt'];
    cmd = ['echo ' SubjectsFolder '/sub-' ID_Str '/func/sub-' ID_Str ...
           '_task-sREST1_acq-RL_space-fsLR_den-91k_desc-clean_smooth_bold.dtseries.nii >> ' FilePath];
    system(cmd);
end

%%% local check