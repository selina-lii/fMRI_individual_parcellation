
Utildir = ''; % no I do not have local CBIG


SubjectsFolder = [Workdir '/subs'];
    idFile = [SubjectsFolder '/HCPSingleFuncParcel_n1080_SubjectsIDs.csv'];
    subListFile = [SubjectsFolder '/subList.txt'];


%
%%% create work environment.
%

%%% open workdir [CHANGE]
Workdir = '/Users/selinali/Documents/work/#7/code/workingdir';
Codedir = [Workdir '/code/S3_SingleParcellation_Kong'];
cd(Codedir);

%%% utils: [CHANGE]
matlab = '/usr/nzx-cluster/apps/MATLAB/MATLAB2018b/bin/matlab';
wb_command = '/usr/nzx-cluster/apps/connectome-workbench/workbench/bin_rh_linux64/wb_command';
Utildir =  '';
Ciftidir = '/home/cuizaixu_lab/liyaoxin/DATA/cifti-matlab-master';

%%% inputs: [CHANGE] these are the files you should have ready.
SubjectsFolder = [Workdir '/subs/'];
    idFile = [SubjectsFolder '/HCPSingleFuncParcel_n1080_SubjectsIDs.csv'];
    idFile_unrelated = [SubjectsFolder '/HCPSingleFuncParcel_n339_SubjectsIDs.csv'];

TemplateFolder = [Workdir '/project/data'];
    yeoAtlas = [TemplateFolder '/YeoAtlas/RSN-networks.32k_fs_LR.dlabel.nii'];

%%% output sturctures
ProjectFolder = [Workdir '/project/SingleParcellation_Kong'];
    DataListFolder = [ProjectFolder '/data_list'];
        fMRIListFolder = [DataListFolder '/fMRI_list'];
        censorListFolder = [DataListFolder '/censor_list'];
    LogFolder = [ProjectFolder '/logs'];
    ProfileFolder = [ProjectFolder '/profiles'];
    TrainingFolder = [ProjectFolder '/profile_list/training_set'];
    IndiParcFolder = [ProjectFolder '/individual_parcellation_200_30'];

%%% parameters
seed_mesh = 'fs_LR_900';
targ_mesh = 'fs_LR_32k';
out_dir = Workdir;
total_sess = '2';

%%% save paths
allPathsMat = [Codedir '/config.mat'];
save(allPathsMat,'matlab','wb_command','Workdir','Utildir','Ciftidir','Codedir', ...
'SubjectsFolder', 'idFile', 'TemplateFolder', 'yeoAtlas', 'ProjectFolder', 'DataListFolder', 'fMRIListFolder', 'censorListFolder', ... 
'LogFolder', 'ProfileFolder', 'TrainingFolder', 'IndiParcFolder', 'seed_mesh', 'targ_mesh', 'out_dir', 'total_sess');
