classdef MethodMetrics
    properties 
        Method
        Noise 
        MagnitudeMSE
        STOI
    end
    methods
        function obj = MethodMetrics(kwargs)
            arguments
                kwargs.Method (1,1) string = 'not specified'
                kwargs.Noise (1,1) string = 'not specified'
                kwargs.MagnitudeMSE (1,1) = -1
                kwargs.STOI (1,1) = -1
            end
            obj.Method = kwargs.Method;
            obj.Noise = kwargs.Noise;
            obj.MagnitudeMSE = kwargs.MagnitudeMSE;
            obj.STOI = kwargs.STOI;
        end
    end
end