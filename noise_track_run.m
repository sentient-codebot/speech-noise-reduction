% test if the noise PSD track algorithm works



%% load data
addpath("data\")
load("data\data.mat")

%% frame + dft + ... + idft + overlap + store back
next = 1;
OVERLAP_RATIO = 0.5;
output=[];
real_sigma_N2=[];
real_sigma_S2=[];
K = 60; % observe ONLY ONE frequency band
sigma_N2 = 0.09*ones(320,1); % initial value
%   0.09 is usable for noisy_1
P_smooth = 0.5*ones(320,1);
frame_count = 0;
while next<length(noisy_1)
    %% frame
    frame_count = frame_count+1;
    sl = frame(clean_1,next, "overlap_ratio", OVERLAP_RATIO);
    [yl, next] = frame(noisy_1, next, "overlap_ratio", OVERLAP_RATIO);
    
    %% dft
    Yl = fft(yl);
    Sl = fft(sl);
    
    %% ground truth noise PSD
    real_sigma_N2 = [real_sigma_N2, abs(Yl-Sl).^2];
    real_sigma_S2 = [real_sigma_S2, abs(Sl).^2];
    
    %% noise PSD estimate
    [sigma_N2,GLR,P_smooth] = noise_track(Yl,sigma_N2,P_smooth,....
        'alpha',0.8,...
        'P_H1',0.6); % which alpha should be used?
    output = [output;sigma_N2(K)];
    
    %% idft
    %sl = ifft(Sl);
    
    %% overlap
    %output = attach_frame(output, sl, "overlap_ratio", OVERLAP_RATIO);
    
end


%% plot result
obs_interval = 1:floor(0.1*frame_count);
figure
plot(obs_interval,output(obs_interval),'*')
hold on
plot(obs_interval,real_sigma_N2(K,obs_interval),'-')
true_noise_level = mean(real_sigma_N2(K,:));
plot(obs_interval,true_noise_level*ones(floor(0.1*frame_count),1))


% figure
% plot(0.1*real_sigma_S2(K,:))
% hold on
% plot(output,'*')

