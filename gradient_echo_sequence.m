function [events, kcoords, fs, n] = gradient_echo_sequence(vars)

readoutPeriod = 1/(2*vars.gamma*vars.Gradients(1)*0.5*vars.fov(1));
fs = 1/readoutPeriod;

phaseOnTime = vars.px(2)/(4*vars.gamma*(0.5*vars.fov(2))*vars.Gradients(2));
phaseOnTimeSamples = fs*phaseOnTime;
phaseStep = 2*vars.Gradients(2)/vars.px(2);
curphaseamp = -vars.Gradients(2);

tau = vars.alpha/(2*pi*vars.gamma*vars.B1amplitude);
taud = round(tau*fs);
TRs = fs*vars.TR;
TEsamp = round(fs*vars.TE);

n = vars.px(1);



for yline = 1:vars.px(2)
    pno = (yline-1)*6;
    events(pno + 1) = Event(EventType.B1, TRs*(yline - 1) + 1, taud, vars.B1amplitude);
    events(pno + 2) = Event(EventType.Gradient, events(pno + 1).startTime, taud, vars.Gradients(3), 3);
    events(pno + 3) = Event(EventType.Gradient, events(pno + 1).endTime, phaseOnTimeSamples, curphaseamp, 2);
    events(pno + 4) = Event(EventType.Gradient, events(pno + 1).endTime, n/2, -vars.Gradients(1), 1);
    events(pno + 5) = Event(EventType.Recording, events(pno + 1).startTime + TEsamp, n);
    events(pno + 6) = Event(EventType.Gradient, events(pno + 5).startTime, events(pno + 5).length, vars.Gradients(1), 1);
    curphaseamp = curphaseamp + phaseStep;
end

kcoords = [];