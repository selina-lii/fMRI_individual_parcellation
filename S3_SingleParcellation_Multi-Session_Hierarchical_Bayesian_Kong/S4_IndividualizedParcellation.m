clear;
load('config.mat');
addpath(genpath(Utildir));
num_clusters = '17';
w = '200';
c = '30';

mkdir(IndiParcFolder);
for i = 1:total_subs
  disp(i);
  ID_str = num2str(i);
  [lh_labels, rh_labels] = CBIG_MSHBM_generate_individual_parcellation(ProjectFolder, targ_mesh, total_sess, num_clusters, ID_str, w, c);
  save([IndiParcFolder '/' ID_str '.mat'], 'lh_labels', 'rh_labels');
end