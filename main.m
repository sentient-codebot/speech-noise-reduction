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
    [sigma_N2,GLR] = noise_track(Yl,sigma_N2,....
        'alpha',0.95,...
        'P_H1',0.7,...
        'SNR_H1',SNR_priori); % which alpha should be used?
%     sigma_N2 = true_sigma_N2;
    %% processing 2: a priori SNR estimate (DD method)
    alpha_DD = 0.98;
    SNR_priori = alpha_DD*abs(Sl).^2./sigma_N2+...
        (1-alpha_DD)*max(abs(Yl).^2./sigma_N2,0);
%     SNR_priori(K)
    %% processing 3: apply Gain function
    % Wiener Gain
    Sl = SNR_priori./(SNR_priori+1).*Yl; % SNR/(SNR+1) = P_SS/P_YY
    % MMSE Gain (Magnitude of S Rayleigh distributed)
%     Sl = mmse_gain(GLR,SNR_priori,abs(Yl).^2./sigma_N2).*Yl;
    
    %% idft
    sl = ifft(Sl);
    
    %% overlap
    output = attach_frame(output, sl, "overlap_ratio", OVERLAP_RATIO);
    
end

%% show result
figure
subplot(2,1,1)
plot(output(1:length(clean_1)),'.')
hold on
plot(clean_1)
reduced_mse = norm(output(1:length(clean_1))-clean_1,2)
subplot(2,1,2)
plot(noisy_1)
noisy_mse = norm(noisy_1(1:length(clean_1))-clean_1,2)

