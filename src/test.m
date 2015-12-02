addpath('tests'); addpath('data'); addpath('preprocess');

load 11302015.mat

filelist = dir(fullfile('tests', '*.m'));
for k = 1:length(filelist)
    run(filelist(k).name)
end
