%
% The second step of single brain parcellation, clustering of 50 group atlas to create the final group atlas
% For the toolbox of single brain parcellation, see: 
%

clear
load('config.mat');
addpath(genpath(Utildir),genpath(Workdir));

mkdir(RobustInitFolder);
inFile = [RobustInitFolder  '/ParcelInit_List.txt'];
system(['rm ' inFile]);
AllFiles = g_ls([ProjectFolder  '/Initialization/*/*/*.mat']);
for i = 1:length(AllFiles)
  cmd = ['echo ' AllFiles{i} ' >> ' inFile];
  system(cmd);
end

% Parcellate into 17 networks
K = 17;
selRobustInit(inFile, K, RobustInitFolder);