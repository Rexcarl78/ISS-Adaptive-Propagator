function [r,v]=ISS_state_v2(UTC_time1,UTC_time2)
ruta = fullfile('Data/Data Analysis','ISS_OEM_4-10-2021.mat');
S=load(ruta);
Data_OEM=S.Data_OEM;
UTC_time=[UTC_time1,UTC_time2];
r=Data_OEM((UTC_time(1)/4+1):(UTC_time(end)/4+1),1:3);
v=Data_OEM((UTC_time(1)/4+1):(UTC_time(end)/4+1),4:6);
end