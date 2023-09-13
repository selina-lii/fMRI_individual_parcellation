
%
% Based on the group atlas, creating each subject's individual specific atlas
% For the toolbox of single brain parcellation, see: 
%

clear
load('config.mat');
addpath(genpath(Workdir));
mkdir(IndividualParcFolder);
resId = 'IndividualParcel_Final';
initFile = [ProjectFolder '/RobustInitialization/init.mat'];
prepDataFile = [ProjectFolder '/CreatePrepData.mat'];

fid = fopen(subListFile);
file = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
SubList = string(file{:});

subIDs=csvread(idFile,1);

K = 17;
% Use parameters in Hongming's NeuroImage paper
alphaS21 = 1;
alphaL = 10;
vxI = 1;
spaR = 1;
ard = 0;
iterNum = 30; %30
eta =0;
calcGrp = 0;
parforOn = 0;
wb_command = wb_command;

% Parcellate for each subject
for i = 1:length(subIDs)
    ID = num2str(subIDs(i));
    disp(ID);
    IndividualParcFolder_i = [IndividualParcFolder '/sub-' ID];
    ResultantFile = [IndividualParcFolder_i '/IndividualParcel_Final_sbj1_' ...
        'comp17_alphaS21_1_alphaL10_vxInfo1_ard0_eta0/final_UV.mat'];
    if ~exist(ResultantFile, 'file')
        mkdir(IndividualParcFolder_i);
        IDMatFile = [IndividualParcFolder_i '/ID.mat'];
        save(IDMatFile, 'ID');

        sbjListFile = [IndividualParcFolder_i '/sbjListAllFile_' num2str(i) '.txt'];
        system(['rm ' sbjListFile]);

        cmd = ['echo ' SubList{i} ' >> ' sbjListFile];
        system(cmd);

        save([IndividualParcFolder_i '/Configuration.mat'], 'sbjListFile', 'wb_command', 'prepDataFile', ...
        'IndividualParcFolder_i', 'resId', 'initFile', 'K', 'alphaS21', 'alphaL', 'vxI', 'spaR', 'ard', ...
        'eta', 'iterNum', 'calcGrp', 'parforOn');
        ScriptPath = [IndividualParcFolder_i '/tmp.sh'];
        cmd = [matlab ' -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' Utildir ''')),' ...
          'load(''' IndividualParcFolder_i '/Configuration.mat''),' ...
          'deployFuncMvnmfL21p1_func_surf_hcp(sbjListFile,wb_command,' ...
          'prepDataFile,IndividualParcFolder_i,resId,initFile,K,alphaS21,' ...
          'alphaL,vxI,spaR,ard,eta,iterNum,calcGrp,parforOn),exit(1)">"' ...
          IndividualParcFolder_i '/ParcelFinal.log" 2>&1'];
        fid = fopen(ScriptPath, 'w');
        fprintf(fid, cmd);
        system(['sh ' ScriptPath]);
        pause(1);
    end
end

