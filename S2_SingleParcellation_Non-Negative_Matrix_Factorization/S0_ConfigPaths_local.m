
%
%%% create work environment.
%

%%% open workdir [CHANGE]
Workdir = '/Users/selinali/Documents/work/#7/code/workingdir';
Codedir = [Workdir '/code/S2_SingleParcellation'];
cd(Codedir);

%%% utils: [CHANGE]
matlab = '/Applications/MATLAB_R2020b.app/bin/matlab';
wb_command = '/Users/selinali/Documents/work/utilities/workbench/bin_macosx64/wb_command';
Utildir =  '/Users/selinali/Documents/work/#7/code/Collaborative_Brain_Decomposition';
Ciftidir = '/Users/selinali/Documents/work/#7/code/cifti-matlab-master';

%%% inputs: [CHANGE] these are the files you should have ready.
TemplateFolder = [Workdir '/project/data'];
    surfL = [TemplateFolder '/surfaceMeshTemplate/L.pial.32k_fs_LR.surf.gii'];
    surfR = [TemplateFolder '/surfaceMeshTemplate/R.pial.32k_fs_LR.surf.gii']; 
    %%% surfL and surfR are taken from an arbitrary subject becasue we only need
    %%% topology info, which is the same for everybody
    surfML = [TemplateFolder '/L.surfMask.label.gii'];
    surfMR = [TemplateFolder '/R.surfMask.label.gii'];
    yeoAtlas = [TemplateFolder '/YeoAtlas/RSN-networks.32k_fs_LR.dlabel.nii'];
    
SubjectsFolder = [Workdir '/subs'];
    LRRLFile = [SubjectsFolder '/subList_LR_RL.txt'];
    subListFile = [SubjectsFolder '/subList.txt'];
    idFile = [SubjectsFolder '/HCPSingleFuncParcel_n310_SubjectsIDs.csv'];
    outSubsFile = [SubjectsFolder '/out_sub.mat'];
    
%%% output structuress
ProjectFolder = [Workdir '/project/SingleParcellation'];
    InitializationFolder = [ProjectFolder '/Initialization'];
    RobustInitFolder  = [ProjectFolder  '/RobustInitialization'];
    IndividualParcFolder = [ProjectFolder '/SingleParcel_1by1'];
    AnalysisFolder = [ProjectFolder '/SingleAtlas_Analysis'];
        VisualizationFolder = [AnalysisFolder '/Atlas_Visualize'];
        %Variability_Visualize_Folder
        
%%% save paths
save([Codedir '/config.mat']);