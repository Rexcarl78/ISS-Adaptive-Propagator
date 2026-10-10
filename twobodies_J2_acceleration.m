function a=twobodies_J2_acceleration(r,mu)
    J2=1.0826*1e-3;
    R=6371000;
    a=-(mu/norm(r)^3).*r- 3/2.* ((J2*mu*R^2)/norm(r)^5)*((1-5*(r(3)/norm(r))^2).*r+[0;0;1].*2.*r(3));
end