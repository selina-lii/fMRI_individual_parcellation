
%
% For variability of probability atlas:
% Using MADM=median(|x(i) - median(x)|) to calculate variability
% For variability of hard label atlas:
% See: 
%   https://stats.stackexchange.com/questions/221332/variance-of-a-distribution-of-multi-level-categorical-data
%

clear
load('config.mat');
addpath(genpath(AnalysisFolder),genpath(Workdir));%genpath(SPMdir)
numofVer = 32492;
subIDs=csvread(idFile,1);

mwIndVec_l = gifti(surfML);
mwIndVec_l=mwIndVec_l.cdata;
Index_l = setdiff([1:numofVer], find(mwIndVec_l==0));
mwIndVec_r = gifti(surfMR);
mwIndVec_r=mwIndVec_r.cdata;
Index_r = setdiff([1:numofVer], find(mwIndVec_r==0));

%% Variability of probability atlas
LoadingFolder = [AnalysisFolder '/FinalAtlasLoading'];
DataCell = g_ls([LoadingFolder '/*.mat']);
for i = 1:length(subIDs)
  tmp = load(DataCell{i});
  for j = 1:17
    cmd = ['sbj_Loading_lh_Matrix_' num2str(j) '(i, :) = tmp.loadingL(j, :);'];
    eval(cmd);
    cmd = ['sbj_Loading_rh_Matrix_' num2str(j) '(i, :) = tmp.loadingR(j, :);'];
    eval(cmd);
  end
end

Variability_Visualize_Folder = [AnalysisFolder '/Variability_Visualize'];
mkdir(Variability_Visualize_Folder);
Variability_All_lh = zeros(17, numofVer);
Variability_All_rh = zeros(17, numofVer);
for m = 1:17
  for n = 1:numofVer
    % left hemi
    cmd = ['tmp_data = sbj_Loading_lh_Matrix_' num2str(m) '(:, n);'];
    eval(cmd);
    Variability_lh(n) = median(abs(tmp_data - median(tmp_data)));
    eval(cmd);
    % right hemi
    cmd = ['tmp_data = sbj_Loading_rh_Matrix_' num2str(m) '(:, n);'];
    eval(cmd);
    Variability_rh(n) = median(abs(tmp_data - median(tmp_data)));
  end

  % write to files
  outPath = [Variability_Visualize_Folder '/Variability_' num2str(m) '.dscalar.nii'];
  visualizeVariability(Variability_lh',Variability_rh',outPath,tmpFolder,wb_command)
 
  Variability_All_lh(m, :) = Variability_lh;
  Variability_All_rh(m, :) = Variability_rh;
end

Variability_All_NoMedialWall = [Variability_All_lh(:, Index_l) Variability_All_rh(:, Index_r)];
save([Variability_Visualize_Folder '/VariabilityLoading.mat'], 'Variability_All_lh', 'Variability_All_rh', 'Variability_All_NoMedialWall');

% 17 system mean
VariabilityLoading_Median_17SystemMean_lh = mean(Variability_All_lh);
VariabilityLoading_Median_17SystemMean_rh = mean(Variability_All_rh);

outPath = [Variability_Visualize_Folder '/VariabilityLoading_17SystemMean.dscalar.nii'];
visualizeVariability(VariabilityLoading_Median_17SystemMean_lh',VariabilityLoading_Median_17SystemMean_rh',outPath,tmpFolder,wb_command)

% Save average variability of 17 system 
VariabilityLoading_Median_17SystemMean_NoMedialWall = [VariabilityLoading_Median_17SystemMean_lh(Index_l) ...
    VariabilityLoading_Median_17SystemMean_rh(Index_r)];
save([Variability_Visualize_Folder '/VariabilityLoading_Median_17SystemMean.mat'], ...
    'VariabilityLoading_Median_17SystemMean_lh', 'VariabilityLoading_Median_17SystemMean_rh', ...
    'VariabilityLoading_Median_17SystemMean_NoMedialWall');

%% Variability of hard parcellation atlas
for i = 1:length(subIDs)
  tmp = load([AnalysisFolder '/FinalAtlasLabel/' num2str(subIDs(i)) '.mat']);
  labelL_Matrix(i, :) = tmp.labelL;
  labelR_Matrix(i, :) = tmp.labelR;
end
for m = 1:numofVer
  for n = 1:17
    % left hemi
    Probability_lh(m, n) = length(find(labelL_Matrix(:, m) == n)) / length(subIDs);
    Probability_lh(m, n) = Probability_lh(m, n) * log2(Probability_lh(m, n));
    % right hemi
    Probability_rh(m, n) = length(find(labelR_Matrix(:, m) == n)) / length(subIDs);
    Probability_rh(m, n) = Probability_rh(m, n) * log2(Probability_rh(m, n));
  end
  Probability_lh(find(isnan(Probability_lh))) = 0;
  Probability_rh(find(isnan(Probability_rh))) = 0;
  VariabilityLabel_lh(m) = -sum(Probability_lh(m, :));
  VariabilityLabel_rh(m) = -sum(Probability_rh(m, :));
end
VariabilityLabel_NoMedialWall = [VariabilityLabel_lh(Index_l) VariabilityLabel_rh(Index_r)];
save([Variability_Visualize_Folder '/VariabilityLabel.mat'], 'VariabilityLabel_lh', 'VariabilityLabel_rh', 'VariabilityLabel_NoMedialWall');

% For visualization
outPath = [Variability_Visualize_Folder '/VariabilityLabel.dscalar.nii'];
visualizeVariability(VariabilityLabel_lh',VariabilityLabel_rh',outPath,tmpFolder,wb_command)

%% helper functions
function visualizeVariability(ldata,rdata,outPath,tmpFolder,wb_command)
    lPath = [tmpFolder '/l_loading.func.gii'];
    rPath = [tmpFolder '/r_loading.func.gii'];

    lFile = gifti;
    lFile.cdata = ldata;
    save(lFile, lPath);

    rFile = gifti;
    rFile.cdata = rdata;
    save(rFile, rPath);

    cmd = [wb_command ' -cifti-create-dense-scalar ' outPath ' -left-metric ' lPath ' -right-metric ' rPath];
    system(cmd);
    pause(1);
    system(['rm -rf ' lPath ' ' rPath]); %tmp files
end