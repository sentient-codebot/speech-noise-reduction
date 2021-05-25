% plot generalized gamma distribution density function

para_gamma = 1;
nu = 1;
beta = 1; % default

ggd = @(a,para_gamma,nu,beta) a.^(para_gamma.*nu-1).*(para_gamma.*beta.^nu)./gamma(nu).*exp(-beta.*a.^para_gamma);

x=linspace(0,12,200);
y=ggd(x,para_gamma,nu,beta);

plot(x,y)