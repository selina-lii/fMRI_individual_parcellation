
%
% Correspondence to Yeo 17 systems
%

clear;
load('config.mat');
addpath(genpath(Utildir), genpath(Ciftidir));

%%% group parcellation we calculated
ParcMat = load([ProjectFolder '/group/group.mat']);
ParcLabels = [ParcMat.gp_AtlasLabel_l,ParcMat.gp_AtlasLabel_r];
ParcLegend = unique(ParcLabels);
ParcLegend = ParcLegend(2:end);
%%% Yeo 17 atlas
YeoLabels = cifti_read(yeoAtlas, 'wbcmd', wb_command);
YeoLabels = YeoLabels.cdata(:, 2);
NetworkName = {'Visual1', 'Visual2', 'Motor1', 'Motor2', 'DA1', 'DA2', 'VA1', 'VA2', ...
               'Limbic1', 'Limbic2', 'FP1', 'FP2', 'FP3', 'DM1', 'DM2', 'DM3', 'DM4', 'mid'};

%%% Labels corresponding to Yeo Networks 1-17
% LookUpTable = [54 45 58 55 50 47 60 59 56 49 57 48 51 61 53 46 52];

Correspondence_Parc2Yeo = zeros(1, 17);
for i = 1:length(ParcLegend)
    Indices = find(ParcLabels == ParcLegend(i));
    Yeo4Parc_i = YeoLabels(Indices);
    Yeo4Parc_i_Legend = unique(Yeo4Parc_i);
    frequency = zeros(1,length(Yeo4Parc_i_Legend));
    for j = 1:length(Yeo4Parc_i_Legend)
        frequency(j) = length(find(Yeo4Parc_i == Yeo4Parc_i_Legend(j)));
    end
    [~, mostFrequent] = max(frequency);
    Correspondence_Parc2Yeo(ParcLegend(i)) = Yeo4Parc_i_Legend(mostFrequent);
    % display the network name
    disp([num2str(i) ': ' num2str(NetworkName{mostFrequent})]);
    clear frequency;
end
