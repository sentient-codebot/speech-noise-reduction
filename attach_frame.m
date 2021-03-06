function attached = attach_frame(target, new_frame, options)
%attach_frame   attach a new frame to target signal
%   attached = attach_frame(target, new_frame, options)
%
%   input:
%       target: to be attached
%       new_framed: to be attached to target
%       options: name-value pairs
%           overlap_ratio: how much to overlap. default 0.5
%   output:
%       attached: attached target

    arguments
        target (:,1)
        new_frame (:,1)
        options.overlap_ratio (1,1) = 0.5
    end
    
    
    overlap_length = floor(length(new_frame)*options.overlap_ratio);
    if length(target)-overlap_length+1 <= 0
        overlap_length = length(target);
    end
    append_length = length(new_frame) - overlap_length; 
    
    overlapped = 0.5*(target(end-overlap_length+1:end)+new_frame(1:overlap_length));
    appended = new_frame(overlap_length+1:end);
    
    target(end-overlap_length+1:end+append_length) = [overlapped;appended];
    
    attached = target;

end