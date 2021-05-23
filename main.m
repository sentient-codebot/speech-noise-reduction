% where the work is done



%% load data
addpath("data\")
load("data\data.mat")

%% frame + dft + ... + idft + overlap + store back
next = 1;
OVERLAP_RATIO = 0.5;
output=[];
frame_count = 0;
sigma_N2 = 0.09*ones(320,1);
SNR_priori = 10*ones(320,1);
Sl = 0*ones(320,1); % how much?
while next<length(noisy_1)
    %% frame
    frame_count = frame_count+1;
    [yl, next] = frame(noisy_1, next, "overlap_ratio", OVERLAP_RATIO);
    
    %% dft
    Yl = fft(yl);
    
    %% processing 1: noise PSD tracking
    sigma_N2 = noise_track(Yl,sigma_N2,....
        'alpha',0.95,...
        'P_H1',0.7); % which alpha should be used?
    
    %% processing 2: a priori SNR estimate (DD method)
    alpha_DD = 0.98;
    SNR_priori = alpha_DD*abs(Sl).^2./sigma_N2+...
        (1-alpha_DD)*max(abs(Yl).^2./sigma_N2,0);
    
    %% processing 3: apply Gain function
    % Wiener Gain
    Sl = SNR_priori./(SNR_priori+1).*Yl; % SNR/(SNR+1) = P_SS/P_YY
    
    %% idft
    sl = ifft(Sl);
    
    %% overlap
    output = attach_frame(output, sl, "overlap_ratio", OVERLAP_RATIO);
    
end
plot(output,'.')
hold on
plot(noisy_1(1:length(output)))
norm(output-noisy_1(1:length(output)),2)
