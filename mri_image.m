function p = mri_image(img, sequence, vars, fs, progress)
 
p = zeros(vars.px(1), vars.px(2));
[n, m] = size(img);
resx = vars.fov(1)/m;
resy = vars.fov(2)/n;
ymin = -vars.fov(2)/2;
y = ymin +((0:n-1)*resy);
xmin = -vars.fov(1)/2;
x = xmin + ((0:m-1)*resx);
relDensity = double(img);
M0 = zeros(3, n*m);
Mz = relDensity(:)' * vars.Mz;
M0(3,:) = Mz;
[coordsx, coordsy] = meshgrid(x, y);
coords = [coordsx(:)'; coordsy(:)';zeros(1, n*m)];
if nargin < 5
    progress.Value = 0; %Dummy variable
end
T1 = vars.T1;
T2 = vars.T2;
if isscalar(T1)
    T1 = T1 * ones(1, n*m);
end
if isscalar(T2)
    T2 = T2 * ones(2, n*m);
end
p = mri_signal_sum(M0, Mz, vars.gamma, coords, T1, T2, fs, sequence.copy(), vars.px(2), vars.px(1), progress);
