function a = twobodies_J2_J3_acceleration(r,mu)
    J2=1.0826*1e-3;
    J3=-2.52*1e-6;
    R=6371000;
  a_J3 = 5/2.*((J3*mu*(R^3)*r(3))/(norm(r)^7))*((7*r(3)^2)/(norm(r)^2)-3).*r + 3/2.*((J3*mu*R^3)/(norm(r)^5))*(1-5*(r(3)^2)/(norm(r)^2))*[0;0;1];
    a=-(mu/norm(r)^3).*r- 3/2.* ((J2*mu*R^2)/norm(r)^5)*((1-5*(r(3)/norm(r))^2).*r+[0;0;1].*2.*r(3))+a_J3;
end