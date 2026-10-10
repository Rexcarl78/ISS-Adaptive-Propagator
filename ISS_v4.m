clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%//CONSTANTS AND INITIALIZATION//
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:11
    G=6.6743e-11; %Gravitational constant
    ang_ve=7.292*1e-5; %Earth's angular velocity
    Re=6371000;
    Me= 5.9722*1e24; %Earth's mass
    m_tot=420000;%ISS mass (kg)
    mu=G*Me;
    %Initial conditions
    dt=1.875;%Time step
    Model=3; %Physical model used (1==twobodies, 2==twobodies_J2, 3==twobodies_J2_J3)
    to=0; %Initial time
    T=86400; %Final time of simulation
    t=to:dt:T;
    N=length(t);% Iterations
    %Prelocate the data vectors
    v=zeros(1,N);
    d=zeros(1,N);
    latitude=zeros(1,N);
    longitude=zeros(1,N);
    altitude=zeros(1,N);
    Y=zeros(6,N); %State vector (position and velocity)
    Y(1,1)=-5.1274*1e6;
    Y(2,1)=3.6055*1e6;
    Y(3,1)=-2.6384*1e6;
    Y(4,1)=-4.7550*1e3;
    Y(5,1)=-2.9520*1e3;
    Y(6,1)=5.2242*1e3;
    rel_x(1)=Y(1,1);
    rel_y(1)=Y(2,1);
    d(1)=sqrt(Y(1,1)^2+Y(2,1)^2+Y(3,1)^2);
    v(1)=sqrt(Y(4,1)^2+Y(5,1)^2+Y(6,1)^2);
    altitude(1)=d(1)-Re;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %//Fourth-order Runge-Kutta implementation//
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch Model
        case 1
            tic
            for i=1:(N-1)
                [Y(1:3,i+1),Y(4:6,i+1)]=RK4(@twobodies_acceleration,Y(1:3,i),Y(4:6,i),dt,mu);
                v(i+1) =sqrt(Y(4,i+1)^2+Y(5,i+1)^2 +Y(6,i+1)^2);
                d(i+1) = sqrt(Y(1,i+1)^2 + Y(2,i+1)^2 + Y(3,i+1)^2);
                if (d(i+1)-Re)<0 %Crash break
                    d(i+1)=Re;
                    disp('Error');
                    break;
                end
            end
            t_c=toc;
        case 2
            tic
            for i=1:(N-1)
                [Y(1:3,i+1),Y(4:6,i+1)]=RK4(@twobodies_J2_acceleration,Y(1:3,i),Y(4:6,i),dt,mu);
                v(i+1) =sqrt(Y(4,i+1)^2+Y(5,i+1)^2 +Y(6,i+1)^2);
                d(i+1) = sqrt(Y(1,i+1)^2 + Y(2,i+1)^2 + Y(3,i+1)^2);
                if (d(i+1)-Re)<0 %Crash break
                    d(i+1)=Re;
                    disp('Error');
                    break;
                end
            end
            t_c=toc;
        case 3
            tic
            for i=1:(N-1)
                [Y(1:3,i+1),Y(4:6,i+1)]=RK4(@twobodies_J2_J3_acceleration,Y(1:3,i),Y(4:6,i),dt,mu);
                v(i+1) =sqrt(Y(4,i+1)^2+Y(5,i+1)^2 +Y(6,i+1)^2);
                d(i+1) = sqrt(Y(1,i+1)^2 + Y(2,i+1)^2 + Y(3,i+1)^2);
                if (d(i+1)-Re)<0 %Crash break
                    d(i+1)=Re;
                    disp('Error');
                    break;
                end
            end
            t_c=toc;
    end
    if j>1
    Tpi=t_c/N; %Time per iteration
    computer_cost_data=[N,t_c,Tpi];
    file1 = sprintf("CCD_Model%d_timestep_%g_%d.mat", Model,dt, j-1);
    save(fullfile("Computer_Cost_Data", file1), "computer_cost_data");
    end
end
file2 = sprintf("StateVector_Model%d_timestep_%g.mat", Model,dt);
save(fullfile("State_Vector_Data", file2), "Y");
 plot3(Y(1,:),Y(2,:),Y(3,:));