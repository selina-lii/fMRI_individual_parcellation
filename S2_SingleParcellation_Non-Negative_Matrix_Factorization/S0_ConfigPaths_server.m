
%
%%% create work environment.
%

%%% open workdir [CHANGE]
Workdir = '/home/cuizaixu_lab/liyaoxin/DATA/workdir';
Codedir = [Workdir '/code/S2_SingleParcellation'];
cd(Codedir);

%%% utils: [CHANGE]
matlab = '/usr/nzx-cluster/apps/MATLAB/MATLAB2018b/bin/matlab';
wb_command = '/usr/nzx-cluster/apps/connectome-workbench/workbench/bin_rh_linux64/wb_command';
Utildir =  '/home/cuizaixu_lab/liyaoxin/DATA/Collaborative_Brain_Decomposition';
Ciftidir = '/home/cuizaixu_lab/liyaoxin/DATA/cifti-matlab';
SPMdir = '/home/cuizaixu_lab/liyaoxin/DATA/spm12';

%%% inputs: [CHANGE] these are the files you should have ready.
TemplateFolder = [Workdir '/project/data'];
    surfL = [TemplateFolder '/surfaceMeshTemplate/L.pial.32k_fs_LR.surf.gii'];
    surfR = [TemplateFolder '/surfaceMeshTemplate/R.pial.32k_fs_LR.surf.gii']; 
    %%% surfL and surfR are taken from an arbitrary subject becasue we only need
    %%% topology info, which is the same for everybody
    surfML = [TemplateFolder '/surfaceMeshTemplate/L.surfMask.label.gii'];
    surfMR = [TemplateFolder '/surfaceMeshTemplate/R.surfMask.label.gii'];
    surfML_noMW = [TemplateFolder '/surfaceMeshTemplate/L.surfMask_noMW.label.gii'];
    surfMR_noMW = [TemplateFolder '/surfaceMeshTemplate/R.surfMask_noMW.label.gii'];
    yeoAtlas = [TemplateFolder '/YeoAtlas/RSN-networks.32k_fs_LR.dlabel.nii'];

%SubjectsFolder = '/GPFS/cuizaixu_lab_permanent/wuguowei/test_out/xcp_abcd';
SubjectsFolder = '/GPFS/cuizaixu_lab_permanent/Public_Data/HCP_ALL_Family/processed_data/xcpabcd';
    LRRLFile = [SubjectsFolder '/subject_list_LR_RL.txt'];
    subListFile = [SubjectsFolder '/subject_list_merged.txt'];
    idFile = [SubjectsFolder '/HCPSingleFuncParcel_n310_SubjectsIDs.csv'];
    outSubsFile = [SubjectsFolder '/out_sub.mat'];
    
%%% output structuress
ProjectFolder = [Workdir '/project/SingleParcellation'];
    InitializationFolder = [ProjectFolder '/Initialization'];
    RobustInitFolder  = [ProjectFolder  '/RobustInitialization'];
    IndividualParcFolder = [ProjectFolder '/SingleParcel_1by1'];
    AnalysisFolder = [ProjectFolder '/SingleAtlas_Analysis'];
        VisualizationFolder = [AnalysisFolder '/Atlas_Visualize'];
        
%%% save paths
save([Codedir '/config.mat']);
