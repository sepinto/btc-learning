addpath('data'); addpath('preprocess'); addpath('learn');

%% Load
load new_data

%% Preprocess
[x, y] = raw2ready(txo_data);

%% Train
svmModel = svmLearn(x, y);
% linRegModel = linRegLearn(x,y);
% ... etc

%% Validate
% ....something
