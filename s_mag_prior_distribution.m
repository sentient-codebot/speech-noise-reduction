%   p(a|beta) = a^(gamma*nu-1)*(gamma*beta^nu)/Gamma(nu)*exp(-beta*a^nu)
%       (hyper)parameters: gamma, nu
%       parameter: beta
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