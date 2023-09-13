
clear
load('config.mat');
addpath(genpath(Workdir));%,genpath(SPMdir));

subIDs=csvread(idFile,1);

thick = 'corrThickness.32k_fs_LR.shape.gii';
curv = 'curvature.32k_fs_LR.shape.gii';
sulc = 'sulc.32k_fs_LR.shape.gii';
myelin = 'SmoothedMyelinMap.32k_fs_LR.func.gii';

side = {'L','R'};
type = {thick, curv, sulc, myelin};
names = {'corticalThickness', 'curvature', 'sulcalDepth', 'myelinMap'};
StructuralFolder = '/GPFS/cuizaixu_lab_permanent/Public_Data/HCP_ALL_Family/rawdata/Structral_processed';

numofVer = 32492;
total_subs=310;

maskL = gifti(surfML);
maskL=maskL.cdata;
maskR = gifti(surfMR);
maskR=maskR.cdata;
mask = [maskL; maskR];

result = zeros(numofVer*2,1);

mkdir([TemplateFolder '/anatomical']);

%%
for i = 1:length(type)
    data = zeros(numofVer*2,total_subs);
    disp(num2str(i));
    for k = 1:2
        for j = 1:length(subIDs)
            ID=num2str(subIDs(j));
            if mod(j,50)==0
                disp(ID);
            end
            file = [StructuralFolder '/' ID '/MNINonLinear/fsaverage_LR32k/' ID '.' side{k} '.' type{i}];
            data=gifti(file);
            data=data.cdata;
            data(1+numofVer*(k-1):numofVer+numofVer*(k-1),j)=data;
        end
    end
    data(mask==0,:)=zeros([length(mask(mask==0)) total_subs]);
    save([TemplateFolder '/anatomical/' names{i} '.mat'],'allSubs');
end

%%
for i = 1:4
    istr = num2str(i);
    mat=load(['/Users/selinali/Downloads/' istr '.mat']);
    data=mat.allSubs;
    if i == 1 || i == 4
        test=log(std(zscore(data)')');
        test(isinf(test)|isnan(test)) = 0;
        test(test~=0)=test(test~=0)-min(test);
    else
        test=std(atanh(data)')';
    end
    
    for j = 1:2
        file=gifti;
        file.cdata=test(1+(j-1)*numofVer:numofVer+(j-1)*numofVer);
        save(file,[TemplateFolder '/anatomical/' side{j} '.' istr '.std.log.func.gii']);
    end
    data(mask==0,:)=zeros([length(mask(mask==0)) total_subs]);
end

