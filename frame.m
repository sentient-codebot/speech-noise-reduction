function [framed, next] = frame(target, start, options)

% input:
%   target = signal to be framed
%   start = start index of the output frame, default 1
%   options: name-value pairs
%       length = frame length, default 320 = 0.02s for fs=16kHz
%       overlap_ratio = how much to overlap, default 0.5
% output: 
%   framed = framed signal
%   next = start point for the next frame

    arguments
        target (:,1)
        start (1,1) = 1
        options.length (1,1) = 320
        options.overlap_ratio (1,1) = 0.5
    end
    if start+options.length-1 <= length(target)
        ending = start+options.length-1;
        framed = target(start:ending);
    else
        ending = length(target);
        framed = [target(start:ending); ...
            zeros(options.length-ending+start-1,1)];    
    end
        next = start + floor(options.length*(1-options.overlap_ratio));
    
end
        