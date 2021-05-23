% where the work is done



%% load data

load("data\data.mat")

%% frame + dft + abs&square + sum up
next = 1;
OVERLAP_RATIO = 0.5;
FRAME_LENGTH = floor(0.02*fs);
periodogram = zeros(FRAME_LENGTH,1);
frame_count = 0;
while next<length(clean_1)
    %% frame
    [sl, next] = frame(clean_1, next, ...
        "overlap_ratio", OVERLAP_RATIO, ...
        "length", FRAME_LENGTH);
    frame_count = frame_count+1;
    %% dft
    Sl = fft(sl.*hann(FRAME_LENGTH));
    
    %% PSD estimate
    periodogram = periodogram + abs(Sl).^2;
    
    %% processing
%     Sl = Yl; % no processing 
    
    %% idft
%     sl = ifft(Sl);
    
    %% overlap
%     output = attach_frame(output, sl, "overlap_ratio", OVERLAP_RATIO);
    
end

%% average
periodogram = periodogram/frame_count;

plot(periodogram)

% plot(output,'.')
% hold on
% plot(noisy_1(1:length(output)))
% norm(output-noisy_1(1:length(output)),2)
