
clear
load('config.mat');
%addpath(genpath(SPMdir));
%%% nubmer of vertices (med wall included) for each hemi
numofVer = 32492;

% for surface data
%%% create mask of medial wall to map decomp results back to graphical surface.
mwIndVecL = gifti(surfML);
mwIndVecL=mwIndVecL.cdata;
mwMaskL = setdiff([1:numofVer], find(mwIndVecL==0));
mwIndVecR = gifti(surfMR);
mwIndVecR=mwIndVecR.cdata;
mwMaskR = setdiff([1:numofVer], find(mwIndVecR==0));

% Group atlas was the clustering results of 50 atlases during the initialization
GroupAtlasLoading_Mat = load([RobustInitFolder '/init.mat']);
initV = GroupAtlasLoading_Mat.initV;
initV_Max = max(initV);
trimInd = initV ./ max(repmat(initV_Max, size(initV, 1), 1), eps) < 5e-2;
initV(trimInd) = 0;

loadingNoMW = initV;

[~, labelNoMW] = max(loadingNoMW, [], 2);

labelL = zeros(1, numofVer);
loadingL = zeros(17, numofVer); 
labelL(mwMaskL) = labelNoMW(1:length(mwMaskL));
loadingL(:, mwMaskL) = loadingNoMW(1:length(mwMaskL), :)';

labelR = zeros(1, numofVer);
loadingR = zeros(17, numofVer);
labelR(mwMaskR) = labelNoMW(length(mwMaskL) + 1:end);
loadingR(:, mwMaskR) = loadingNoMW(length(mwMaskL) + 1:end, :)';

save([AnalysisFolder '/Group_AtlasLabel.mat'], 'labelL', 'labelR', 'labelNoMW');
save([AnalysisFolder '/Group_AtlasLoading.mat'], 'loadingL', 'loadingR', 'loadingNoMW');
