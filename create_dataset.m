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

filefolder = 'data\';
filenames = {'clean_speech.wav'; 'clean_speech_2.wav'; 'babble_noise.wav'};
datanames = {'clean_1'; 'clean_2'; 'babble'};
for i = 1:3
    filepath = strcat(filefolder,filenames{i});
    importfile(filepath)
    assignin('base', datanames{i}, data);
    clear data filepath
end

noisy_1 = awgn(clean_1,SNR,'measured');
%   norm(clean_1,2) == 40.9257
noisy_2 = awgn(clean_2,SNR,'measured');


save([filefolder,'data.mat'],'clean_1','clean_2','babble',...
    'noisy_1','noisy_2','fs')

clear 