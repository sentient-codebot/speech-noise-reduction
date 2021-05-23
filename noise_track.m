function sigma_N2 = noise_track(Yl,sigma_N2_past,options)
% track noise PSD
% method:
%   MMSE based with SPP. Assuming N and S prior has complex Gaussian distribution
% input: 
%   Yk: Y_k(l)
% output:
%   sigma_N2 = \hat{sigma_{N,k}^2(l)}

    arguments
        Yl (:,1) 
        sigma_N2_past (:,1) {mustBePositive} 
        options.alpha (1,1) = 0.96
        options.SNR_H1 (:,1) {mustBePositive} = 10 % typical value, = ?
        options.P_H1 (:,1) {mustBeNonnegative} = 0.8
        %options.P_H0 (1,1) === 1 - options.P_H1
            % NOTE: not in dB
    end
    
    
    p_Y_on_H0 = 1./(sigma_N2_past*pi).*exp(-abs(Yl).^2./sigma_N2_past);
    
    p_Y_on_H1 = 1./(sigma_N2_past*pi.*(1+options.SNR_H1)).*...
        exp(-abs(Yl).^2./(sigma_N2_past.*(1+options.SNR_H1)));
    
    P_H1 = options.P_H1;
    P_H0 = 1 - P_H1;
    
    P_H1_post = P_H1.*p_Y_on_H1./(P_H1.*p_Y_on_H1+P_H0.*p_Y_on_H0);
    
    P_H0_post = 1-P_H1_post;
    
    E_cond = P_H0_post.*abs(Yl).^2+P_H1_post.*sigma_N2_past;
    
    sigma_N2 = options.alpha*sigma_N2_past+(1-options.alpha)*E_cond; 
        % E_cond = conditional mean of |Nk(l)|^2 on Yk(l)




end