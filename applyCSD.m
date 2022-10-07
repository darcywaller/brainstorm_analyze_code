%% Current source density analysis code
% This code applies a CSD transform, thereby reducing the effects of volume
% conduction on subsquent beta event analyses.
% where is the eeg data?
clear; clc;
addpath(genpath('CSDtoolbox'));
% training sets
% filpath = '/gpfs/data/brainstorm-ws/data/TRAINING/';
% testing sets
filpath = '/gpfs/data/brainstorm-ws/data/VALIDATION/';
% grab data files from all subjects, all times, all series
files   = dir([filpath,'series_*/T*/preprocessed/*.set']);
%savefolder = mkdir('/gpfs/home/ddiesbur/scratch/CSD');

% go through subjects
parfor file = 1:length(files)
    
    % load
    EEG = pop_loadset([files(file).folder,'/',files(file).name]);
    
    % select channels
    EEG = pop_select(EEG,'nochannel',{'M1','M2'});
    
    % CSD
    disp('CSD transform...');
    M = ExtractMontage('10-5-System_Mastoids_EGI129.csd',{EEG.chanlocs.labels}');
    MapMontage(M)
    [G,H] = GetGH(M);
    EEG.data = CSD(EEG.data,G,H);
    
    % save
    % training sets
    % savefile = strcat('/gpfs/home/ddiesbur/scratch/CSD/',files(file).name(1:end-4),'_CSD.set');
    % testing sets
    savefile = strcat('/gpfs/home/ddiesbur/scratch/CSD_val/',files(file).name(1:end-4),'_CSD.set');
    EEG = pop_saveset(EEG,'filename',savefile);
    
end