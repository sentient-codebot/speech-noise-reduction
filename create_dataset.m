% this script 
%   load .wav files as vectors
%   create noisy data (AWGN)
%   save to target .mat file
% 
% load following files: 
%   clean_1, 
%   clean_2, 
%   babble
% create (AWGN) noisy signals:
%   noisy_1,
%   noisy_2
% specified SNR(dB)
%
SNR = 10;
amp_arti = 8.8967; % amplification for the arti. nonstat. noise to be perceivable
amp_babble = 1; % make babble noise smaller? 
amp_spee = 1;

filefolder = 'data\';
filenames = {'clean_speech.wav'; 'clean_speech_2.wav'; 'babble_noise.wav';...
    'artificial_nonstat_noise.wav';...
    'speech_shaped_noise.wav'};
datanames = {'clean_1'; 'clean_2'; 'babble';...
    'artificial_nonstat';...
    'speech_shaped'};
for i = 1:length(filenames)
    filepath = strcat(filefolder,filenames{i});
    importfile(filepath)
    assignin('base', datanames{i}, data);
    clear data filepath
end

% noisy_1 = awgn(clean_1,SNR,'measured');
%   norm(clean_1,2) == 40.9257
% noisy_2 = awgn(clean_2,SNR,'measured');

noisy_arti_1 = artificial_nonstat(1:length(clean_1))*amp_arti + clean_1;
noisy_babble_1 = babble(1:length(clean_1))*amp_babble + clean_1;
noisy_spee_1 = speech_shaped(1:length(clean_1))*amp_spee + clean_1;

% save([filefolder,'data.mat'],'clean_1','clean_2','babble',...
%     'noisy_1','noisy_2','fs')

% clear 