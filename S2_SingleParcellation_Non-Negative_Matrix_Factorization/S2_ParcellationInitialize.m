
% The first step of single brain parcellation, initialization of group atlas
% Each time resample 100 subjects, and repeat 50 times
% For the toolbox of single brain parcellation, see: 
%

clear
load('config.mat');
mkdir(InitializationFolder);
mkdir([InitializationFolder '/Input']);
fid = fopen(subListFile);
file = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
SubList = string(file{:});
SubjectsQuantity = 100; % resampling 100 subjects

spaR = 1;
vxI = 1;
ard = 0;
iterNum = 2000; %2000
tNum = 2400; % 2400, number of time points
alpha = 1;
beta = 10;
resId = 'init';
K = 17; % number of networks
wb_command = wb_command;
prepDataFile = [ProjectFolder '/CreatePrepData.mat'];

% Repeat 50 times
for i = 1:50
  ResultantFile_Path = [InitializationFolder '/InitializationRes_' num2str(i) ...
      '/Initialization_num100_comp17_S1_3265_L_2721_spaR_1_vxInfo_1_ard_0/init.mat'];
  if ~exist(ResultantFile_Path, 'file')
    SubjectsIDs = randperm(length(SubList), SubjectsQuantity);
    sbjListFile = [InitializationFolder '/Input/sbjListFile_' num2str(i) '.txt'];
    system(['rm ' sbjListFile]);
    for j = 1:length(SubjectsIDs)
      cmd = ['echo ' SubList{SubjectsIDs(j)} ' >> ' sbjListFile];
      system(cmd);
  end

    outDir = [InitializationFolder '/InitializationRes_' num2str(i)];
    save([InitializationFolder '/Configuration_' num2str(i) '.mat'], 'sbjListFile', 'wb_command', ...
        'surfL', 'surfR', 'surfML', 'surfMR', 'prepDataFile', 'outDir', ... 
        'spaR', 'vxI', 'ard', 'iterNum', 'K', 'tNum', 'alpha', 'beta', 'resId','surfML_noMW','surfMR_noMW');
      cmd = [matlab ' -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' Utildir ''')),load(''' ...
          InitializationFolder '/Configuration_' num2str(i) '.mat''),' ...
          'deployFuncInit_surf_hcp(sbjListFile, wb_command, surfL, surfR, ' ...
          'surfML, surfMR, prepDataFile, outDir, spaR, vxI, ard, iterNum, K, tNum, alpha, beta, resId,surfML_noMW,surfMR_noMW),' ...
          'exit(1)">"' InitializationFolder '/ParcelInit' num2str(i) '.log" 2>&1'];
    fid = fopen([InitializationFolder '/tmp' num2str(i) '.sh'], 'w');
    fprintf(fid, cmd);
  end
end