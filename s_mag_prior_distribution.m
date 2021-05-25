%   p(a|beta) = a^(gamma*nu-1)*(gamma*beta^nu)/Gamma(nu)*exp(-beta*a^gamma)
%       parameters: gamma, nu, beta
%       special forms: 
%           if gamma=2, nu=1
%           then p(a|beta) = 2*beta*a*exp(-beta*a^2)
%               if we let beta=1/(2*sigma_s^2)
%               then p(a|beta) = a/sigma^2*exp(-a^2/(2*sigma_s^2)), which
%                   is Rayleigh distribution. 
%                   mode = sigma_s = sqrt(2*beta) (maximum likelihood)
%                   var = (4-pi)/2*sigma_s^2. 
%
%   reference: exponential family
%       p(x) = h(x)*g(theta)*exp(n(theta)*t(x))    

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
histogram(S_mag, 250,...
    "DisplayStyle", 'bar') %


%% histfit
figure()
pd_name = 'rayleigh';
histfit(S_mag',250,pd_name)
pdf = fitdist(S_mag',pd_name);

% log: 
%   birnbaumsaunders is a nice fit
%   generalized pareto (gp) is also ok
%   lognormal is ok

%% logpdf maximum likelihood estimate
custlogpdf = @(data,beta,gamma_p,nu) log(gamma_p)+gamma_p*log(beta)-...
    log(gamma(nu))+(gamma_p*nu-1)*log(data)-beta*data.^gamma_p;

phat = mle(S_mag','logpdf',custlogpdf,'start',[1 0.5 2]);

%% get values
y=[];
x=linspace(0,12,200);
for i = x
    y = [y, custlogpdf(i,phat(1),phat(2),phat(2))];
end
plot(x,exp(y))
    

