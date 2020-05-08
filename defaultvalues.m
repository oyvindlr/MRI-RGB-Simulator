function d = defaultvalues()

d.B0 = 1.5; %Tesla
d.B1amplitude = 30e-6; %30 microTesla
d.B1amplitude_full = 30e-4; %3000 microTesla
d.Gradient = 0.04; %40 milliTesla/m
d.alpha = pi/2; %90 degrees flip angle
K = 1.38e-23; % Boltzmann constant in J/K
logK = log(1.38)+23*log(0.1);
d.Temperature = 300; %Kelvin
d.gamma = 42.58e+6; %Hz/Tesla
logGamma = log(42.58)+6*log(10);
gammabar = 2*pi*42.58e+6;
h = 6.626e-34; %Joules/second
hbar = 1.054e-34;
logHbar = log(1.054)+34*log(0.1);
d.Ns = 1e+21;
logNs = 21*log(10);

d.larmor = d.gamma * d.B0;

logMz = 2*logGamma+2*logHbar+log(d.B0)+logNs-log(4)-logK-log(d.Temperature);
d.Mz = exp(logMz);

d.T1 = 0.920;
d.T2 = 0.100;
%T2star = d.T2;
d.TE = 0.05;
d.TR = 1.0;
%fs = 1e6;

d.picname = 'No file selected';

d.Gradients = d.Gradient * ones(3,1);
d.px = [215, 121, 1];
d.fov = [0.2, 0.2, 0.2];

d.T1mid = 0.920;
d.T1basedOn = 'R';
d.T1plusminus = 0.95;
d.T2mid = 0.100;
d.T2basedOn = 'G';
d.T2plusminus = 0.95;
d.protondensitysource = 'B';
d.FOV(1) = 0.2;

