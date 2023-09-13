
clear
load('config.mat');
addpath(genpath(Utildir), genpath(Ciftidir));%,genpath(SPMdir)
mkdir(VisualizationFolder);

%% Color templates. Needed for label atlases
colorInfo = [VisualizationFolder '/name_Atlas.txt'];
system(['rm -rf ' colorInfo]);

%%% temporarily gonna leave it like that
SystemName = {'DM 1', 'Motor 1', 'FP 1', 'Motor 2', 'DA 1', ...
              'Visual 1', 'VA 1', 'DM 2', 'VA 2', 'Visual 2', 'Motor 3', ...
              'DM 3', 'Motor 4', 'DA 2', 'FP 2', 'Auditory', 'FP 3'};
ColorPlate = {'242 139 168', '158 186 204', '244 197 115', '73 143 191', ...
              '65 171 93', '137 63 153', '217 117 242', '226 57 93', ...
              '206 28 249', '102 5 122', '33 113 181', '170 12 61', ...
              '7 69 132', '0 109 44', '216 144 72', '78 49 168', '204 109 14'};
for i = 1:17
  system(['echo ' SystemName{i} ' >> ' colorInfo]);
  system(['echo ' num2str(i) ' ' ColorPlate{i} ' 1 >> ' colorInfo]); 
  
  colorInfo_i = [VisualizationFolder '/name_Atlas_Network' num2str(i) '.txt'];
  system(['rm -rf ' colorInfo_i]);
  system(['echo ' SystemName{i} ' >> ' colorInfo_i]);
  system(['echo 1 ' ColorPlate{i} ' 1 >> ' colorInfo_i]);
end

%% Group
%%% Group - probability atlases (loading) - 17 networks
groupLoadingMat = load([AnalysisFolder '/Group_AtlasLoading.mat']);
for i = 1:17
  outPath = [VisualizationFolder '/Group_AtlasLoading_Network_' num2str(i) '.dscalar.nii'];
  %visualizeAtlas_loading(groupLoadingMat,outPath,VisualizationFolder,i,wb_command);
end

%%% Group - hard label atlas
groupLabelMat = load([AnalysisFolder '/Group_AtlasLabel.mat']);
outpath = [VisualizationFolder '/Group_AtlasLabel.dlabel.nii'];
%visualizeAtlas_label(groupLabelMat,outpath,VisualizationFolder,colorInfo,wb_command);

%%% Group - hard label atlas - 17 networks
for i = 1:17
  colorInfo = [VisualizationFolder '/name_Atlas_Network' num2str(i) '.txt'];
  tmp = getNetworki(groupLabelMat.labelL,groupLabelMat.labelR,i);
  outPath = [VisualizationFolder '/Group_AtlasLabel_Network_' num2str(i) '.dlabel.nii'];
  %visualizeAtlas_label(tmp,outPath,VisualizationFolder,colorInfo,wb_command);
end

%% Individual subjects
% BBLID: 130411 (age = 98), 91310 (age = 176), 102958 (age = 179), 115969 (age = 697)
AllSubjectsLoadingFolder = [AnalysisFolder '/FinalAtlasLoading'];
AllSubjectsLabelFolder = [AnalysisFolder '/FinalAtlasLabel'];
ID = [140117 154936 174841 201111 256540 522434 729557 894067 930449 972566];

for i = 1:length(ID)
  SubFolder = [VisualizationFolder '/' num2str(ID(i))];
  mkdir(SubFolder);

  % Individual - probability atlases (loading)
  subLoadingMat = load([AllSubjectsLoadingFolder '/' num2str(ID(i)) '.mat']);
  for j = 1:1%7
    outPath=[SubFolder '/' num2str(ID(i)) '_AtlasLoading_Network_' num2str(j) '.dscalar.nii'];
    %visualizeAtlas_loading(subLoadingMat,outPath,SubFolder,j,wb_command);
  end

  % Individual - hard label atlas
  colorInfo = [VisualizationFolder '/name_Atlas.txt'];
  subLabelMat = load([AllSubjectsLabelFolder '/' num2str(ID(i)) '.mat']);
  outPath=[SubFolder '/' num2str(ID(i)) '_AtlasLabel.dlabel.nii'];
  visualizeAtlas_label(subLabelMat,outPath,SubFolder,colorInfo,wb_command);

  % Individual - hard label atlas - 17 networks 
  for j = 1:1%7
    colorInfo = [VisualizationFolder '/name_Atlas_Network' num2str(i) '.txt'];
    tmp = getNetworki(subLabelMat.labelL,subLabelMat.labelR,i);
    outPath = [SubFolder '/' num2str(ID(i)) '_AtlasLabel_Network_' num2str(j) '.dlabel.nii'];
    %visualizeAtlas_label(tmp,outPath,SubFolder,colorInfo,wb_command);
  end
end


%% helper functions
function visualizeAtlas_loading(sourceMat,outPath,tmpFolder,i,wb_command)

    lPath = [tmpFolder '/l_loading.func.gii'];
    rPath = [tmpFolder '/r_loading.func.gii'];

    lFile = gifti;
    lFile.cdata = sourceMat.loadingL(i,:)';
    save(lFile, lPath);

    rFile = gifti;
    rFile.cdata = sourceMat.loadingR(i,:)';
    save(rFile, rPath);

    cmd = [wb_command ' -cifti-create-dense-scalar ' outPath ' -left-metric ' lPath ' -right-metric ' rPath];
    system(cmd);
    pause(1);
    system(['rm -rf ' lPath ' ' rPath]); %tmp files
end

function visualizeAtlas_label(sourceMat,outPath,tmpFolder,colorInfo,wb_command)

    lPath = [tmpFolder '/l.func.gii'];
    rPath = [tmpFolder '/r.func.gii'];
    lLabelPath = [tmpFolder '/l.label.gii'];
    rLabelPath = [tmpFolder '/r.label.gii'];

    lFile = gifti;
    lFile.cdata = sourceMat.labelL';
    save(lFile, lPath);
    pause(1);
    cmd = [wb_command ' -metric-label-import ' lPath ' ' colorInfo ' ' lLabelPath];
    system(cmd);

    rFile = gifti;
    rFile.cdata = sourceMat.labelR';
    save(rFile, rPath);
    pause(1);
    cmd = [wb_command ' -metric-label-import ' rPath ' ' colorInfo ' ' rLabelPath];
    system(cmd);

    cmd = [wb_command ' -cifti-create-label ' outPath ' -left-label ' lLabelPath ' -right-label ' rLabelPath];
    system(cmd);
    pause(1);
    system(['rm -rf ' lPath ' ' rPath ' ' lLabelPath ' ' rLabelPath]); %tmp files
end

function tmp = getNetworki(l,r,i)
    tmp = struct('labelL',l,'labelR',r);
    tmp.labelL(find(tmp.labelL ~= i)) = 0;
    tmp.labelL(find(tmp.labelL == i)) = 1;
    tmp.labelR(find(tmp.labelR ~= i)) = 0;
    tmp.labelR(find(tmp.labelR == i)) = 1;
end