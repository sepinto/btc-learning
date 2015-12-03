addpath('data'); addpath('preprocess'); addpath('train');

%% Load
load new_data

%% Preprocess
[x, y] = raw2ready(txo_data);

%% Train
svmModel = svm(x, y);
% linRegModel = linRegLearn(x,y);
% ... etc

%% Validate
% ....something
