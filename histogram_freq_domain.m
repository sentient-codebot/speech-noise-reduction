% where the work is done



%% load data
addpath("data\")
load("data\data.mat")

%% frame + dft + store 
next = 1;
OVERLAP_RATIO = 0.5;
FRAME_LENGTH = floor(0.02*fs);
S_cmp = [];
frame_count = 0;
while next<length(clean_1)
    %% frame
    [sl, next] = frame([clean_1;], next, ...
        "overlap_ratio", OVERLAP_RATIO, ...
        "length", FRAME_LENGTH);
    frame_count = frame_count+1;
    %% dft
    Sl = fft(sl);
    
    %% store
    S_cmp(:,frame_count) = Sl;
    
    %% processing
%     Sl = Yl; % no processing 
    
    %% idft
%     sl = ifft(Sl);
    
    %% overlap
%     output = attach_frame(output, sl, "overlap_ratio", OVERLAP_RATIO);
    
end

%% see histogram
K = 40;
S_sample = S_cmp(K,:);
index = ~(abs(S_sample) <= 1e-3);
S_sample = S_sample(index); % filter out zero-value samples (speech absent)
S_mag = abs(S_sample);
S_pha = phase(S_sample);
S_real = real(S_sample);
S_imag = imag(S_sample);

figure()
subplot(2,2,1)
histogram(S_mag, 250,...
    "DisplayStyle", 'bar') %
subplot(2,2,2)
histogram(S_pha)
subplot(2,2,3)
histogram(S_real)
subplot(2,2,4)
histogram(S_imag)

%% deprecated
rayleigh_pd = fitdist(S_mag','rayleigh');
figure()
x_values = linspace(0,5,200);
y_values = pdf(rayleigh_pd, x_values);
plot(x_values, y_values)



%% histfit
figure()
pd_name = 'gp';
histfit(S_mag',250,pd_name)
pdf = fitdist(S_mag',pd_name);

% log: 
%   birnbaumsaunders is a nice fit
%   generalized pareto (gp) is also ok
%   lognormal is ok

%% logpdf maximum likelihood estimate
custlogpdf = @(data,beta,gamma_p,nu) log(gamma_p)+gamma_p*log(beta)-...
    log(gamma(nu))+(gamma_p*nu-1)*log(data)-beta*data.^gamma_p;

phat = mle(S_mag','logpdf',custlogpdf,'start',[0.5 2 1]);

%% get values
y=[];
for x = linspace(0,12,200)
    y = [y, custlogpdf(x,phat(1),phat(2),phat(2))];
end
plot(x,exp(y))
    

