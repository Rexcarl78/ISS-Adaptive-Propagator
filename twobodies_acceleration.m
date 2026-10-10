function a=twobodies_acceleration(r,mu)
    a=-(mu/norm(r)^3).*r;
end