function R = rotmat(angle, axis)

a = [cos(angle/2); sin(angle/2)*axis/norm(axis)];
R = zeros(3,3);
aa =a*a';
R(1,1) = aa(1, 1)+aa(2,2)-aa(3,3)-aa(4,4);
R(1,2) = 2*(aa(2,3)-aa(1,4));
R(1,3) = 2*(aa(2,4)+aa(1,3));
R(2,1) = 2*(aa(2,3)+aa(1,4));
R(2,2) = aa(1,1)-aa(2,2)+aa(3,3)-aa(4,4);
R(2,3) = 2*(aa(3,4) -aa(1,2));
R(3,1) = 2*(aa(2, 4) - aa(1,3));
R(3,2) = 2*(aa(3,4) + aa(1, 2));
R(3,3) = aa(1,1) -aa(2,2) - aa(3,3) + aa(4,4);