function [r_next,v_next]=RK4(acceleration,r,v,dt,mu)
    a_1=acceleration(r,mu);

    r_2=r+dt/2.*v;
    v_2=v+dt/2.*a_1;
    a_2=acceleration(r_2,mu);

    r_3=r+dt/2.*v_2;
    v_3=v+dt/2.*a_2;
    a_3=acceleration(r_3,mu);

    r_4=r+dt.*v_3;
    v_4=v+dt.*a_3;
    a_4=acceleration(r_4,mu);

    r_next = r + dt/6 * (v + 2*v_2 + 2*v_3 + v_4);
    v_next = v + dt/6 * (2*a_2 + 2*a_3 + a_4 + a_1);
end

