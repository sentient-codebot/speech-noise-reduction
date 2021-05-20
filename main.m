% where the work is done



%% load data

load("data\data.mat")

%% frame + dft + ... + idft + overlap + store back
next = 1;
OVERLAP_RATIO = 0.5;
output=[];
for i = 1:5
    %% frame
    [yl, next] = frame(noisy_1, next, "overlap_ratio", OVERLAP_RATIO);
    
    %% dft
    Yl = fft(yl);
    
    %% processing
    Sl = Yl; % no processing 
    
    %% idft
    sl = ifft(Sl);
    
    %% overlap
    output = attach_frame(output, sl, "overlap_ratio", OVERLAP_RATIO);
    
end
plot(output,'.')
hold on
plot(noisy_1(1:length(output)))
norm(output-noisy_1(1:length(output)),2)
