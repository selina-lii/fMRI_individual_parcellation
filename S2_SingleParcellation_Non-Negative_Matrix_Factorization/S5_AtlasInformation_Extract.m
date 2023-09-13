
clear
load('config.mat');
addpath(genpath(Workdir));%genpath(SPMdir));
%%% nubmer of vertices (med wall included) for each hemi
numofVer = 32492;
subIDs=csvread(idFile,1);

surfML = [TemplateFolder '/medialWall/L.notMedialWall.label.gii'];
surfMR = [TemplateFolder '/medialWall/R.notMedialWall.label.gii'];
% for surface data
%%% create mask of medial wall to map decomp results back to graphical surface.
maskL = gifti(surfML);
maskL=maskL.cdata;
notMaskedOutL = setdiff([1:numofVer], find(maskL==0));
maskR = gifti(surfMR);
maskR=maskR.cdata;
notMaskedOutR = setdiff([1:numofVer], find(maskR==0));

if ~exist(AnalysisFolder, 'dir')
    mkdir(AnalysisFolder);
end
FinalLabelFolder = [AnalysisFolder '/FinalAtlasLabel'];
if ~exist(FinalLabelFolder, 'dir')
    mkdir(FinalLabelFolder);
end
FinalLoadingFolder = [AnalysisFolder '/FinalAtlasLoading'];
if ~exist(FinalLoadingFolder, 'dir')
    mkdir(FinalLoadingFolder);
end

for i = 1:length(subIDs)

    ID = num2str(subIDs(i));
    path=[IndividualParcFolder '/sub-' ID '/IndividualParcel_Final_sbj1_' ...
        'comp17_alphaS21_1_alphaL10_vxInfo1_ard0_eta0/final_UV.mat'];
    
    SingleSubjectParcel = load(path);
    loadingMasked = SingleSubjectParcel.V{1};
    
    [~, labelMasked] = max(loadingMasked, [], 2);
    
    labelL = zeros(1, numofVer);
    loadingL = zeros(17, numofVer);
    labelL(notMaskedOutL) = labelMasked(1:length(notMaskedOutL));
    loadingL(:, notMaskedOutL) = loadingMasked(1:length(notMaskedOutL), :)';
    
    labelR = zeros(1, numofVer);
    loadingR = zeros(17, numofVer);
    labelR(notMaskedOutR) = labelMasked(length(notMaskedOutL) + 1:end);
    loadingR(:, notMaskedOutR) = loadingMasked(length(notMaskedOutL) + 1:end, :)';
    
    ID_Mat = load([IndividualParcFolder '/sub-' ID '/ID.mat']);
    
    save([FinalLabelFolder '/' num2str(ID_Mat.ID) '.mat'], 'labelL', 'labelR', 'labelMasked');
    save([FinalLoadingFolder '/' num2str(ID_Mat.ID) '.mat'], 'loadingL', 'loadingR', 'loadingMasked');
end
