
%
%%% miscellaneous preparatory work
%

clear
load('config.mat');
if ~exist(ProjectFolder, 'dir')
    mkdir(ProjectFolder);
end
addpath(genpath(SPMdir));

%% full mask = medial wall + SNR
colorInfo = [TemplateFolder '/colorInfo.txt'];
system(['rm -rf ' colorInfo]);
ColorPlate = '50 50 50';
system(['echo 1 >> ' colorInfo]);
system(['echo 1 ' ColorPlate ' 1 >> ' colorInfo]); 

%%% left
snrL = [TemplateFolder '/surf/mean_SNR_mask_10.L.func.gii'];
snrLfile = gifti(snrL);
medWallL = [TemplateFolder '/medialWall/L.notMedialWall.label.gii'];
medWallLfile = gifti(medWallL);
surfMLfile = gifti;
surfMLfile.cdata = snrLfile.cdata>10 & medWallLfile.cdata;
save(surfMLfile,surfML);
system([wb_command ' -metric-label-import ' surfML ' ' colorInfo ' ' surfML]);

surfMLfile_noMW = gifti;
cdata = surfMLfile.cdata;
cdata(medWallLfile.cdata==0)=[];
surfMLfile_noMW.cdata = cdata;
save(surfMLfile_noMW,surfML_noMW);

%%% right
snrR = [TemplateFolder '/surf/mean_SNR_mask_10.R.func.gii'];
snrRfile = gifti(snrR);
medWallR = [TemplateFolder '/medialWall/R.notMedialWall.label.gii'];
medWallRfile = gifti(medWallR);
surfMRfile = gifti;
surfMRfile.cdata = snrRfile.cdata>10 & medWallRfile.cdata;
save(surfMRfile,surfMR);
system([wb_command ' -metric-label-import ' surfMR ' ' colorInfo ' ' surfMR]);

surfMRfile_noMW = gifti;
cdata = surfMRfile.cdata;
cdata(medWallRfile.cdata==0)=[];
surfMRfile_noMW.cdata = cdata;
save(surfMRfile_noMW,surfMR_noMW);


%% UNRELATED HCP
subIDs=csvread(idFile,1);

system(['rm ' LRRLFile]);
system(['rm ' subListFile]);
for i = 1:length(subIDs)
    ID = num2str(subIDs(i));
    %%% make list of all LR & RL sessions
    LRFile = [SubjectsFolder '/sub-' ID '/func/sub-' ID ...
        '_task-REST1_acq-LR_space-fsLR_den-91k_desc-residual_smooth_bold.dtseries.nii'];
    cmd = ['echo ' LRFile ' >> ' LRRLFile];
    system(cmd);
    RLFile = [SubjectsFolder '/sub-' ID '/func/sub-' ID ...
        '_task-REST1_acq-RL_space-fsLR_den-91k_desc-residual_smooth_bold.dtseries.nii'];
    cmd = ['echo ' RLFile ' >> ' LRRLFile];
    system(cmd);
    
    %%% create merged file if does not exist
    out = [SubjectsFolder '/sub-' ID '/func/sub-' ID ...
        '_task-REST1_fsLR_den-91k_desc-residual_smooth_bold_LRRLmerged.dtseries.nii'];
    if(~exist(out, 'file'))
        cmd = [wb_command ' -cifti-merge ' out ' -cifti ' LRFile ' -cifti ' RLFile];
        system(cmd);
    end
    
    %%% make list of merged files
    cmd = ['echo ' out ' >> ' subListFile];
    system(cmd);
    
    disp(ID);
end
