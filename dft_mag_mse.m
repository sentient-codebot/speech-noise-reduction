function output = dft_mag_mse(x, y, options)

    arguments
        x (:,1)
        y (:,1)
        options.length (1,1) = 320
        options.overlap_ratio (1,1) = 0.5
    end
    
    % normalizing 
    y = mean(abs(x))/mean(abs(y))*y;
    
    next = 1;
    frame_count = 0;
    square_error = [];
    while next<min(length(x),length(y))
        %% frame
        frame_count = frame_count+1;
        [xl, ] = frame(x, next, "overlap_ratio", options.overlap_ratio);
        [yl, next] = frame(y, next, "overlap_ratio", options.overlap_ratio);
        
        %% dft
        Xl = fft(xl.*hann(320));
        Yl = fft(yl.*hann(320));

        %% mse
        square_error = [square_error; norm((abs(Xl)-abs(Yl)),2)];

    end
    
    output = mean(square_error);
end