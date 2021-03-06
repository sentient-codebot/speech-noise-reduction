function gain = mmse_gain(GLR,SNR_priori,SNR_posteriori)
%calculate mmse_gain on A being Rayleigh distributed
%
%
%
    arguments
        GLR (:,1) 
        SNR_priori (:,1) 
        SNR_posteriori (:,1) 
    end
%     x = SNR_posteriori.*(SNR_priori./(1+SNR_priori));
%     gain = GLR./(1+GLR).*sqrt(pi)/2.*...
%         sqrt(1./SNR_posteriori.*SNR_priori./(1+SNR_priori)).*...
%         exp(-x/2).*...
%         ((1+x).*besseli(0,x/2)+x.*besseli(1,x/2));
    v = SNR_posteriori.*(SNR_priori./(1+SNR_priori));
    gain = gamma(1.5).*sqrt(v)./SNR_posteriori.*exp(-v/2).*...
        ((1+v).*besseli(0,v/2)+v.*besseli(1,v/2));
    
end