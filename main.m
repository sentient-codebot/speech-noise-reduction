% where the work is done



%% load data
addpath("data\")
load("data\data.mat")
load("data\Gain_1_1.mat")
%   load Gain_gamma_nu.mat
%   possible Gain options:
%   gamma   |   nu
%   1       |   1
%   1       |   1.5
%   1       |   2
%   2       |   0.5
%   2       |   1       % standard Wiener Gain
%   2       |   1.5
%   2       |   2

clean = clean_1;

noisy = noisy_babble_1;
%   available:
%       noisy_1: gaussian
%       noisy_2: gaussian
%       noisy_arti_1: artificial_nonstat
%       noisy_spee_1: speech_shaped
%       noisy_babble_1: babble
noise_type = 'babble';
%   noise_type should of one of the following:
%       'gaussian'
%       'artificial_nonstat'
%       'speech_shaped'
%       'babble'

%% select gain function
gain_name = 'none';
% gain_name = 'wiener';
% gain_name = 'other';
% gain_name = 'hendriks';
% gain_name = 'none'


%% frame + dft + parameter estimate + apply gain + idft + overlap + store back
next = 1;
OVERLAP_RATIO = 0.5;
output=[];
frame_count = 0;
sigma_N2 = 0.09*ones(320,1);
SNR_priori = 31.62*ones(320,1); % 15dB optimal according to literature, why?
Sl = 0*ones(320,1); % how much?
P_smooth = 0.5*ones(320,1);
GLRs = [];
sigma_NK2=[];
P_H1_posts=[];
K = 11;
while next<length(noisy)
    %% frame
    frame_count = frame_count+1;
    [yl, next] = frame(noisy, next, "overlap_ratio", OVERLAP_RATIO);
    
    %% dft
    Yl = fft(yl.*hann(320));
    
    %% processing 1: noise PSD tracking
    [sigma_N2,GLR,P_smooth,P_H1_post] = noise_track(Yl,sigma_N2,P_smooth,....
        'alpha',0.8,... % 0.8 according to literature? 0.97 works
        'P_H1',0.8); % which alpha should be used?
%     sigma_N2 = true_sigma_N2;
    %% processing 2: a priori SNR estimate (DD method)
    alpha_DD = 0.98;
    SNR_priori = alpha_DD*abs(Sl).^2./sigma_N2+...
        (1-alpha_DD)*max(abs(Yl).^2./sigma_N2-1,0);
%     SNR_priori(K)
    %% processing 3: apply Gain function
    if strcmp(gain_name, 'wiener')
        % Wiener Gain
        Sl = SNR_priori./(SNR_priori+1).*Yl; % SNR/(SNR+1) = P_SS/P_YY
    elseif strcmp(gain_name,'other')
        % MMSE Gain (Magnitude of S Rayleigh distributed)
        Sl = mmse_gain(GLR,SNR_priori,abs(Yl).^2./sigma_N2).*Yl;
    elseif strcmp(gain_name,'hendriks')
        % Richard Gain
        gain = lookup_gain_in_table(Gain,...
            abs(Yl).^2./sigma_N2,...
            SNR_priori,...
            [-40,50],[-40,50],1);
        Sl = gain.*Yl;
    elseif strcmp(gain_name,'none')
        Sl = Yl;
    end

    GLRs = [GLRs;GLR];
    sigma_NK2=[sigma_NK2;sigma_N2(K)];
    P_H1_posts=[P_H1_posts;P_H1_post(K)];
    %% idft
    sl = ifft(Sl);
    
    %% overlap
    output = attach_frame(output, sl, "overlap_ratio", OVERLAP_RATIO);
    
end

%% show result
figure
subplot(3,1,1)
% plot(output(1:length(clean)),'.')
% hold on
plot(clean)
axis([-inf inf -0.6 0.6])
% reduced_mse = norm(output(1:length(clean))-clean,2)
subplot(3,1,2)
plot(2*output(1:length(clean)))
axis([-inf inf -0.6 0.6])
subplot(3,1,3)
plot(noisy)
axis([-inf inf -0.6 0.6])
% noisy_mse = norm(noisy(1:length(clean))-clean,2) 
% NOTE: it's not fair to compare the mse in time domain, because spectral
% magnitude mse is what we truly care about. 


%% metrics
normalized_mag_MSE = dft_mag_mse(clean, output);
STOI_output = stoi(clean, output(1:length(clean)), fs);

clear SavedMetrics
load('data\SavedMetrics.mat','SavedMetrics')
Method = {gain_name};
Noise = {noise_type};
MagnitudeMSE = normalized_mag_MSE;
STOI = STOI_output;
Datetime = datetime;
t = table(Method,Noise,MagnitudeMSE,STOI,Datetime);
SavedMetrics = [SavedMetrics;t]
save('data\SavedMetrics.mat','SavedMetrics')

writetable(SavedMetrics,'SavedMetrics.xlsx')


%% metrics (deprecated)
% 
% 
% metrics = MethodMetrics;
% 
% normalized_mag_MSE = dft_mag_mse(clean, output);
% STOI_output = stoi(clean, output(1:length(clean)), fs);
% 
% metrics.Method = gain_name;
% metrics.Noise = noise_type;
% metrics.MagnitudeMSE = normalized_mag_MSE;
% metrics.STOI = STOI_output;
% metrics
% 
% clear SavedMetrics
% load('data\SavedMetrics.mat','SavedMetrics')
% SavedMetrics = [SavedMetrics;metrics];
% save('data\SavedMetrics.mat','SavedMetrics')
% 
% 
% 
