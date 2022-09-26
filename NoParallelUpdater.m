classdef NoParallelUpdater
    %NOPARALLELUPDATER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hWaitbar,NbrePts,Msg
    end
    
    methods
        function obj = NoParallelUpdater(hWaitbar,NbrePts,Msg)
            %NOPARALLELUPDATER Construct an instance of this class
            %   Detailed explanation goes here
            obj.hWaitbar = hWaitbar;
            obj.NbrePts = NbrePts;
            obj.Msg = Msg;
        end
        
        function send(obj,~)
            ParForWaitbarProgressMH(obj.hWaitbar,obj.NbrePts,obj.Msg);
        end
    end
end

