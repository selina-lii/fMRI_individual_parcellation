
%
%%% generate merged dtseries.
% spatial neighborhood estimation(gNb) & save for later use
%

clear
load('config.mat');
addpath(genpath(Utildir),genpath(Ciftidir));

[surfStru, surfMask] = getHcpSurf(surfL, surfR, surfML, surfMR);
gNb = createPrepData('surface', surfStru, 1, surfMask);
prepDataFile = [ProjectFolder '/CreatePrepData.mat'];

save(prepDataFile, 'gNb');