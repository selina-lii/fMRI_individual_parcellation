
clear;
load('config.mat');
addpath(genpath(Utildir));
IDs = csvread(idFile,1);

for i = 1:total_subs
    for sess = 1:total_sess
        CBIG_MSHBM_generate_profiles(seed_mesh, targ_mesh, out_dir, num2str(i), num2str(sess), '0');
    end
end

%%% ran on server 4-9 9PM