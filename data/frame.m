function [framed, next] = frame(target, start, options)

% input:
%   target = signal to be framed
%   start = start index of the output frame, default 1
%   options: name-value pairs
%       length = frame length, default 320 = 0.02s for fs=16kHz
% output: 
%   framed = framed signal
%   next = start point for the next frame

    arguments
        target (1,:)
        start (1,1) = 1
        options.length (1,1) = 320
    end
    
    framed = target(options.start:options.start+options.length-1);
    next = start + options.length;
    
end
        