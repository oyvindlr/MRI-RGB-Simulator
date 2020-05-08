classdef Event < matlab.mixin.Copyable
    properties 
        startTime {mustBeNumeric}
        endTime {mustBeNumeric}
        length {mustBeNumeric}
        amplitude {mustBeNumeric}
        offset {mustBeNumeric}
        axis {mustBeNumeric}
        type
        started
        active
        done        
    end    
    methods
        function ev = Event(type, startTime, length, amplitude, axis, offset)
            ev.type = type;
            ev.startTime = startTime;
            ev.length = length;
            ev.endTime = startTime + length;
            ev.started = false;
            ev.active = false;
            ev.done = false;
            if type == EventType.B1
                ev.amplitude = amplitude;
            elseif type == EventType.Gradient
                ev.amplitude = amplitude;
                ev.axis = axis;
                ev.offset = 0;
                if nargin > 5
                    ev.offset = offset;
                end
            end            
        end
        function ev = update(ev, t)
            if t == ev.startTime
                ev.started = true;
                ev.active = true;
            elseif t == ev.endTime
                ev.done = true;
                ev.active = false;
            end                
        end        
    end
        
end