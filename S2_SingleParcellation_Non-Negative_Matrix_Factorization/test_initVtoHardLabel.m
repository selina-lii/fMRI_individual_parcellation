%
%%% Group probability atlas and hard label atlas
%
clear
load('config.mat');
addpath(genpath(Utildir), genpath(Ciftidir));

ResultsFolder = '/Users/selinali/Documents/work/#8/visuals/339init';
mkdir(ResultsFolder);

colorInfo = [ResultsFolder '/name_Atlas.txt'];
system(['rm -rf ' colorInfo]);
                   
ColorPlate = {'242 139 168',  ...
              '158 186 204',  ...
              '244 197 115',  ...
              '73 143 191', ...
              '65 171 93',  ...
              '137 63 153',  ...
              '217 117 242',  ...
              '226 57 93', ...
              '206 28 249',  ...
              '102 5 122',  ...
              '33 113 181',  ...
              '170 12 61', ...
              '7 69 132',  ...
              '0 109 44',  ...
              '216 144 72',  ...
              '78 49 168',  ...
              '204 109 14'};
              %orginal pallete
         
for i = 1:17
  system(['echo ' num2str(i) ' >> ' colorInfo]);
  system(['echo ' num2str(i) ' ' ColorPlate{i} ' 1 >> ' colorInfo]); 
end

numofVer = 32492;

% for surface data
mwIndVec_l = gifti(surfML);
mwIndVec_l=mwIndVec_l.cdata;
Index_l = setdiff([1:numofVer], find(mwIndVec_l==0));
mwIndVec_r = gifti(surfMR);
mwIndVec_r=mwIndVec_r.cdata;
Index_r = setdiff([1:numofVer], find(mwIndVec_r==0));

%for i = 1:50
    
file = ['/Users/selinali/Downloads/init.mat'];
%file = ['/Users/selinali/Documents/work/#8/visuals/unrelated_normVSoriginal/init_original.mat'];
GroupAtlasLoading_Mat = load(file);

initV = GroupAtlasLoading_Mat.initV;
%initV = GroupAtlasLoading_Mat.Params.theta;

initV_Max = max(initV);
trimInd = initV ./ max(repmat(initV_Max, size(initV, 1), 1), eps) < 5e-2;
initV(trimInd) = 0;
gp_AtlasLoading_NoMedialWall = initV;
[~, labelNoMW] = max(gp_AtlasLoading_NoMedialWall, [], 2);

%%%%%Li
labelL = zeros(1, numofVer);
gp_AtlasLoading_l = zeros(17, numofVer);
labelL(Index_l) = labelNoMW(1:length(Index_l));
gp_AtlasLoading_l(:, Index_l) = gp_AtlasLoading_NoMedialWall(1:length(Index_l), :)';
labelR = zeros(1, numofVer);
loadingR = zeros(17, numofVer);
labelR(Index_r) = labelNoMW(length(Index_l) + 1:end);
loadingR(:, Index_r) = gp_AtlasLoading_NoMedialWall(length(Index_l) + 1:end, :)';

%%%%%Kong
%maskL = gifti([ResultsFolder '/L.medialWall.label.gii']);
%maskL = maskL.cdata;
%maskR = gifti([ResultsFolder '/R.medialWall.label.gii']);
%maskR = maskR.cdata;

labelMat = [ResultsFolder '/label.mat'];
%labelL = labelNoMW(1:numofVer,:)';
%labelL(maskL==1) = 0;
%labelR = labelNoMW(numofVer+1:end,:)';
%labelR(maskR==1) = 0;

%%%%%Kong
%save(labelMat, 'labelL', 'labelR');
%%%%%Li
save(labelMat, 'labelL', 'labelR','labelNoMW');

%%% Group - hard label atlas
labelMat = load(labelMat);
outpath = [ResultsFolder '/hardlabel.dlabel.nii'];
visualizeAtlas_label(labelMat,outpath,ResultsFolder,colorInfo,wb_command);
%end
tmpFolder = '/Users/selinali/Documents/work/#8/visuals/test_hcp1080';

function visualizeAtlas_label(sourceMat,outPath,tmpFolder,colorInfo,wb_command)

    mkdir(tmpFolder);
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


