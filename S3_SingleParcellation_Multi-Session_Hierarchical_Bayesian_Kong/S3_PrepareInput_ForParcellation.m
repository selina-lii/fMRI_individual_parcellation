clear
load('config.mat');

mkdir(TrainingFolder);
system(['rm ' TrainingFolder '/*']);
Suffix = '_fs_LR_32k_roifs_LR_900.surf2surf_profile.mat';
for i = 1:total_subs
    disp(i);
    i_str = num2str(i);
        % session 1
        cmd = ['echo ' ProfileFolder '/sub' i_str '/sess1/sub' i_str '_sess1' Suffix ' >> ' TrainingFolder '/' 'sess1.txt'];
        system(cmd);
        % session 2
        cmd = ['echo ' ProfileFolder '/sub' i_str '/sess2/sub' i_str '_sess2' Suffix ' >> ' TrainingFolder '/' 'sess2.txt'];
        system(cmd);
end

%%% ran 4-11