%
% Correspondence to Yeo 17 systems
%

clear
load('config.mat');
addpath(genpath(Utildir), genpath(Ciftidir));
k=17;

%%% group parcellation we calculated
ParcMat = load('/Users/selinali/Documents/work/#8/visuals/339init/label.mat');
%ParcMat = load([AnalysisFolder '/Group_AtlasLabel.mat']);
ParcLabels = [ParcMat.labelL,ParcMat.labelR];
ParcLegend = [1:k];
%%% Yeo 17 atlas
YeoLabels = cifti_read(yeoAtlas, 'wbcmd', wb_command);
YeoLabels = YeoLabels.cdata(:, 2);
NetworkName = {'fs medial wall' 'Visual1', 'Visual2', 'Motor1', 'Motor2', 'DA1', 'DA2', 'VA1', 'VA2', ...
               'Limbic1', 'Limbic2', 'FP1', 'FP2', 'FP3', 'DM1', 'DM2', 'DM3', 'DM4'};
LookUpTable = [37 54 45 58 55 50 47 60 59 56 49 57 48 51 61 53 46 52];

YeoLegend = unique(YeoLabels);   
size = zeros(1,length(YeoLegend));
for i = 1:length(YeoLegend)
    size(i)=length(find(YeoLabels == YeoLegend(i)));
end

Parc2YeoNo = zeros(1, k);
for i = 1:length(ParcLegend)
    Indices = find(ParcLabels == ParcLegend(i));
    size=length(Indices);
    Yeo4Parc_i = YeoLabels(Indices);
    Yeo4Parc_i_Legend = unique(Yeo4Parc_i);
    clear frequency;
    frequency = zeros(length(Yeo4Parc_i_Legend),3);
    frequency(:,2)=Yeo4Parc_i_Legend';
    for j = 1:length(Yeo4Parc_i_Legend)
        frequency(j,1) = length(find(Yeo4Parc_i == Yeo4Parc_i_Legend(j)));
        frequency(j,3) = round(frequency(j,1)/size*100);
    end
    frequency=sortrows(frequency,'descend');
    outstr=[num2str(i) ':'];
    for j = 1:length(Yeo4Parc_i_Legend)
        if(frequency(j,3)<20)
            break;
        end
        netNum=find(LookUpTable==frequency(j,2));
        outstr = [outstr ' ' NetworkName{netNum} '/' num2str(frequency(j,3)) '%.'];
    end
    %[~, mostFrequent] = max(frequency);
    %Parc2YeoNo(i) = find(LookUpTable==Yeo4Parc_i_Legend(mostFrequent));
    % display the network name
    %disp([num2str(i) ': ' num2str(NetworkName{Parc2YeoNo(i)})]);
    disp(outstr);
end

