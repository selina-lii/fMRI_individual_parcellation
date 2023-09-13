clear
load('config.mat');
addpath(genpath(Utildir));
subIDs=csvread(idFile,1);
side={'LR','RL'};
numofVer=18907;

%% vertex
% average of LR & RL
CorrMatDir = [Workdir '/project/functional_connectivity_dconn'];
mkdir(resdir);

for j = 1:length(subIDs)
    tmpcdata=zeros(numofVer);
    if(mod(j,50)==0)
        disp(j);
    end
    ID = num2str(subIDs(j));
    for k = 1:2
        file=[SubjectsFolder '/fsaverage4/sub-' ID '/func/sub-' ID '_' sides{k} '_data_corr.mat'];
        load(file);
        tmpcdata=tmpcdata+tmpcifti.cdata(1:numofVer,1:numofVer);
    end
    out = [resdir '/' sides{k} '/' ID '.mat'];
    outcifti = tmpcifti;
    outcifti.cdata=tmpcdata/2;
    save(out);
end

%% vertex10k mat
allSubs=cell(310,1);
for j = 1:length(subIDs)
    allSubs{j}=zeros(numofVer);
end

for j = 1:length(subIDs)
    if(mod(j,20)==0)
        disp(j);
    end
    load([CorrMatDir '/' num2str(subIDs(j)) '.mat']);
    allSubs{j}=cdata(1:numofVer,1:numofVer);
end

parcelMap = zeros(numofVer,1);
connectivity=zeros(numofVer,numofVer);
for i = 1:numofVer
    cormat=zeros(numofVer,length(subIDs));
    for j = 1:length(subIDs)
        cormat(:,j)=allSubs{j}(:,i);
    end
    connectivity(:,i) = mean(cormat,2);
    cormat(i,:)=[];
    parcelMap(i) = 1-ICC(cormat,"C-1");
    if(mod(i,1000)==0)
        disp(i);disp(parcelMap(i));
    end
end
save(['vertex10k.mat'],'parcelMap');
save(['connectivity10k.mat'],'connectivity');
disp("done");


%%
%visualization
file = cifti_read('/Users/selinali/Downloads/Template_space-fsLR_den-28k_bold.dtseries.nii');
parcelMap=parcelMap-mean(parcelMap);%prctile(parcelMap,50);
cdata=repmat([parcelMap' zeros(1,28320-18907)],28320,1);
file.cdata = cdata;
cifti_write(file,'vertex10k.dconn.nii')


%% heatmap
load('/Users/selinali/Downloads/heatmap.mat');
for i=1:size(stdmat,2)
    for j=1:i-1
        stdmat(j,i)=stdmat(i,j);
    end
end
%stdmat=atanh(stdmat);

%%% visualization matrix
file = cifti_read('/Users/selinali/Downloads/Template_space-fsLR_den-28k_bold.dtseries.nii');
l=file.diminfo{1}.models{1}.vertlist;
r=file.diminfo{1}.models{2}.vertlist;
mask = [l r+10242];
mask=mask+1;
deletes=setdiff(1:20484,mask);

% open Yeo7 files
l = gifti('/Users/selinali/Downloads/L.7n28k_fs_LR.label.gii');
r = gifti('/Users/selinali/Downloads/R.7n28k_fs_LR.label.gii');
mask = [l.cdata' r.cdata'];
mask(deletes)=[];
legend=unique(mask); % get all Yeo labels
order=[5 7 2 8 3 4 6 1]; % Reorder as: network #1-7 (except limbic), limbic, medial wall
%['mw','DA-3','FP-6','DM-7','V-1','lim-5','SM-2','VA-4'];


% determine where to draw lines between networks
t=[];
start = 1;
lines = [1];
k = 1;
for i = 1:length(order)
        add=find(mask==legend(order(i)));
        t=[t add];
        start = start + length(add);
        lines(k+1)=start;
        k = k+1;
end

stdmat = ***your input here***;
data = stdmat(t,t); % reorder input matrix
data= data - diag(diag(data)); % set diagonals as zero for visualization purposes
graph=imagesc(data); % draw graph
%colorbar;
caxis([min(min(data)) max(max(data))]); % set scale bar by min/max
colormap('jet');
for j = 1:length(lines) % draw lines dividing network
    yline(lines(j),'Color','w','Linewidth',1);
    xline(lines(j),'Color','w','Linewidth',1);
end
axis square;
width=5000;
height=5000;
saveas(graph,['test.png']);


%% examine most variable vertices
mostvariable=find(parcelMap>prctile(parcelMap,85));
others=setdiff(1:length(parcelMap),mostvariable);
tnew=[mostvariable' others];
data = stdmat(tnew,tnew);
graph=imagesc(data);
caxis([0 max(max(data))]);
colormap('jet');
yline(length(mostvariable),'Color','w','Linewidth',1);
xline(length(mostvariable),'Color','w','Linewidth',1);
axis square;
width=5000;
height=5000;
saveas(graph,['mostvariable10.png']);

vers=mask(mostvariable);
for i = 1:length(legend)
        disp(length(find(vers==legend(i)))/length(vers)*100);
end
vers(vers==legend(1))=[];
vers(vers==legend(6))=[];

