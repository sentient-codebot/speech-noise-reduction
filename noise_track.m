function [sigma_N2,GLR,P_smooth,P_H1_post] = noise_track(Yl,sigma_N2_past,P_smooth_past,options)
% track noise PSD
% method:
%   MMSE based with SPP. Assuming N and S prior has complex Gaussian distribution
% input: 
%   Yk: Y_k(l)
% output:
%   sigma_N2 = \hat{sigma_{N,k}^2(l)}
%   GLR = generalized likelihood ratio
 
    arguments
        Yl (:,1) 
        sigma_N2_past (:,1) {mustBePositive} 
        P_smooth_past (:,1) = 0.5
        options.alpha (1,1) = 0.8 % according to literature
        options.SNR_H1 (:,1) {mustBePositive} = 31.62 % typical value = 31.62
        options.P_H1 (:,1) {mustBeNonnegative} = 0.5
        %options.P_H0 (1,1) === 1 - options.P_H1
            % NOTE: not in dB
    end 
    
    
    p_Y_on_H0 = 1./(sigma_N2_past*pi).*exp(-abs(Yl).^2./sigma_N2_past);
    
    p_Y_on_H1 = 1./(sigma_N2_past*pi.*(1+options.SNR_H1)).*...
        exp(-abs(Yl).^2./(sigma_N2_past.*(1+options.SNR_H1)));
    
    mu = 1./(1+options.SNR_H1).*...
        exp(options.SNR_H1./(1+options.SNR_H1).*abs(Yl).^2./sigma_N2_past);
    % to avoid DIV/0
    
    P_H1 = options.P_H1;
    P_H0 = 1 - P_H1;
    
    P_H1_post = 1-P_H0./(P_H1.*mu+P_H0);
    
    P_smooth = 0.9*P_smooth_past+0.1*P_H1_post;
    
    stagged_idx = P_smooth>=0.99;
    P_H1_post(stagged_idx) = min(0.99,P_H1_post(stagged_idx));
    
    P_H0_post = 1-P_H1_post;
    
    E_cond = P_H0_post.*abs(Yl).^2+P_H1_post.*sigma_N2_past;
    % E_cond = conditional mean of |Nk(l)|^2 on Yk(l)
    
    sigma_N2 = options.alpha*sigma_N2_past+(1-options.alpha)*E_cond; 
    
    GLR = P_H1./P_H0.*mu;


end