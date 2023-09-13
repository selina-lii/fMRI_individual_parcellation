clear
load('config.mat');
addpath(genpath(Utildir));

subIDs=csvread(idFile,1);
%subIDs = [100307 100408];

side={'LR','RL'};


%% surface
glasser = '_atlas-Glasser_den-91k_bold.pconn.nii';
schaefer = '_atlas-Schaefer407_den-91k_bold.pconn.nii';
gordon = '_atlas-Gordon_den-91k_bold.pconn.nii';

parcels = {glasser,schaefer,gordon};
parcelnames = {'Glasser','Schaefer407','Gordon'};
parcelsize = {360,400,333};

for i = 1:length(parcels)
    disp(i)
    allSubs = zeros(length(subIDs),parcelsize{i},parcelsize{i});
    for j = 1:length(subIDs)
        ID = num2str(subIDs(j));
        mat = zeros(2,parcelsize{i},parcelsize{i});
        for k = 1:2
            file=[SubjectsFolder '/sub-' ID '/func/sub-' ID '_task-REST1_acq-' side{k} '_space-fsLR' parcels{i}];
            tmp=ciftiopen(file,wb_command);
            mat(k,:,:)=tmp.cdata;
        end
        allSubs(j,:,:)=(mat(1,:,:)+mat(2,:,:))/2;
        clear mat;
        variaibility=std(atanh(allSubs),0,1);
        variaibility=reshape(variaibility,[],size(variaibility,2),1);
        variaibility(isnan(variaibility))=0;
    end
    csvwrite([parcelnames{i} '.csv'],variaibility);
    save([parcelnames{i} '.mat'],'allSubs');
end

% Schaefer
lines_read=[];
labels=readtable('Schaefer407_labels.csv');
now = strsplit(string(labels{1,2}),'_');
j =1 ;
for i= 1:size(labels,1)
    tmp = strsplit(string(labels{i,2}),'_');
    if strcmp(tmp(3),now(3))==false %&& j < 17
        now = tmp;
        lines_read(j)=i-1;
        j=j+1;
    end
end

% cluster according to nework label
l = [0 lines_read(1:7)];
r = [lines_read(7:end) 400];
t = [];
start = 1;
lines = [1];
k = 1;
for j = 1:length(l)-1
    if(j~=5)
        add = [l(j)+1:l(j+1) r(j)+1:r(j+1)];
        t = [t add];
        start = start + length(add);
        lines(k+1)=start;
        k = k+1;
    end
end
j = 5;
add = [l(j)+1:l(j+1) r(j)+1:r(j+1)];
t = [t add];

% heatmap i=2;
for i = 1:length(parcels)
    data=csvread(['/Users/selinali/Downloads/parcel_variability/' parcelnames{i} '.csv']);
    data = data(t,t);
    graph=imagesc(data);
    colorbar;
    caxis([0.10 max(max(data))]);
    colormap('jet');
    for j = 1:length(lines)
        yline(lines(j),'Color','w','Linewidth',2);
        xline(lines(j),'Color','w','Linewidth',2);
    end
    axis square;
    width=10000;
    height=10000;
    saveas(graph,['/Users/selinali/Downloads/parcel_variability/' parcelnames{i} 'reordered_l+r.png']);
end

% surface map
VariabilityMatFolder = '/Users/selinali/Downloads/mat/';
for i = 1:length(parcels) 
    clear allSubs
    load([VariabilityMatFolder parcelnames{i} '.mat']);
    parcelMap = zeros(parcelsize{i},1);
    for j = 1:parcelsize{i}
        mat = reshape(allSubs(:,j,:),[],parcelsize{i},1)';
        mat(j,:)=[];
        parcelMap(j) = 1-ICC(mat,"C-1"); % ICC(2,1): two-way, consistency, single rater
    end
    parcelMap=parcelMap-prctile(parcelMap,30);

    c=cifti_read([SubjectsFolder '/sub-100408/func/sub-100408_task-REST1_acq-LR_space-fsLR_atlas-' ...
                parcelnames{i} '_den-91k_bold.pconn.nii']);
    c.cdata=repmat(parcelMap',parcelsize{i},1);
    cifti_write(c,[VariabilityMatFolder parcelnames{i} '.pconn.nii']);
end

%c.diminfo{1}.parcels

%pconn of sub i & j:
%r between parcels = connectivity between parcels
%single parcel connectivity variability = vector of (ICC of (all subs, connectivity profile of parcel x))