function [r,v]=ISS_state(UTC_time1,UTC_time2)
addpath 'C:\Users\carlo\OneDrive\Documentos\UNIVERSIDAD\PROYECTOS PERSONALES\ISS Simulation\Data\OEM'
ruta = fullfile('Data/Data Analysis','ISS_OEM_4-10-2021.mat');
S=load(ruta);
Data_OEM=S.Data_OEM;
UTC_time=[UTC_time1,UTC_time2];
r=Data_OEM((UTC_time(1)/4+1):(UTC_time(end)/4+1),1:3);
v=Data_OEM((UTC_time(1)/4+1):(UTC_time(end)/4+1),4:6);
end