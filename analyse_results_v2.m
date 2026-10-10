clear
clc
close all
%It is important to note that this code is prepared to analyse 10 computer
%costs data files for each time step
dt_values=[240,120,60,30,15,7.5,3.75,1.875];
Y_m=cell(1,length(dt_values));
[r,v]=ISS_state(0,1440);
Model=3; %Physical model used (1==twobodies, 2==twobodies_J2, 3==twobodies_J2_J3)
%Load data and calculate stadistic data for the Computer Cost
legend_fig1 = ["OEM Position Data"];
legend_fig2 = string.empty;
legend_fig3 = string.empty;
legend_fig4=string.empty;
legend_fig5 = string.empty;
for k=1:length(Model)
    CCD=[];
    t_c_means=[];
    Tpi_means=[];
    t_c_S=[];
    Tpi_S=[];
    t_c_max = [];
    Tpi_max = [];
    t_c_min = [];
    Tpi_min = [];
    Error_r=[];
    Error_v=[];
    max_Error_r=[];
    max_Error_v=[];
    for i=1:length(dt_values)
        for j=1:10
            file_name=sprintf("CCD_Model%d_timestep_%g_%d.mat", Model(k),dt_values(i), j);
            data = load(fullfile("Computer_Cost_Data",file_name));
            CCD(j,1,i)=data.computer_cost_data(1);
            CCD(j,2,i)=data.computer_cost_data(2);
            CCD(j,3,i)=data.computer_cost_data(3);
        end
        t_c_means(i)=mean(CCD(:,2,i));
        Tpi_means(i)=mean(CCD(:,3,i));
        t_c_S(i)=sqrt((sum((CCD(:,2,i)-t_c_means(i)).^2))/10);
        Tpi_S(i) = sqrt((sum((CCD(:,3,i) - Tpi_means(i)).^2)) / 10);
        t_c_max(i)=max(CCD(:,2,i));
        Tpi_max(i)=max(CCD(:,3,i));
        t_c_min(i)=min(CCD(:,2,i));
        Tpi_min(i)=min(CCD(:,3,i));
        file_name2=sprintf("StateVector_Model%d_timestep_%g.mat", Model(k), dt_values(i));
        load(fullfile("State_Vector_Data",file_name2));
        Y_m{i}=Y;
    end

    %Error calculations
    for i=1:length(dt_values)
        for j=1:length(r)
            index_step=4/(dt_values(i)/60);
            Calc_r=Y_m{i}(1:3,1:index_step:end);
            Error_r(i,j)=norm(r(j,1:3)-Calc_r(1:3,j)');
            Calc_v=Y_m{i}(4:6,1:index_step:end);
            Error_v(i,j)=norm(v(j,1:3)-Calc_v(1:3,j)');
        end
        max_Error_r(i)=max(Error_r(i,:));
        max_Error_v(i)=max(Error_v(i,:));
    end
    file_name_err=sprintf('Maximum_Position_Error_Values_Model%d.mat',Model(k));
    save(fullfile("Error_Data", file_name_err),"max_Error_r");
    file_name_erv=sprintf('Maximum_Velocity_Error_Values_Model%d.mat',Model(k));
    save(fullfile("Error_Data", file_name_erv),"max_Error_v");

    %ISS's position
    figure(1);
    grid on
    view(3);
    hold on
    title("ISS position")
    if k==1
        plot3(r(:,1),r(:,2),r(:,3));
    end
    for i=1:length(dt_values)
        plot3(Y_m{i}(1,:),Y_m{i}(2,:),Y_m{i}(3,:));
        legend_fig1(end+1)=sprintf("Model %d - dt = %g s",Model(k),dt_values(i));
    end
    legend(legend_fig1);
    xlabel('Position in X axis (m)');
    ylabel('Position in Y axis (m)');
    zlabel('Position in Z axis (m)');
    hold off

    figure(2)
    sgtitle('Error along time')
    for i=1:length(dt_values)
        subplot(1,2,1);
        hold on
        plot(0:240:86400,Error_r(i,:));
        legend_fig2(end+1)=sprintf("Model %d - dt = %g",Model(k),dt_values(i));

        subplot(1,2,2);
        hold on
        plot(0:240:86400,Error_v(i,:));

    end
    subplot(1,2,1);
    title('Position Error')
    grid on
    legend(legend_fig2,'Location','best');
    xlabel('Time (s)');
    ylabel('Error (m)');
    subplot(1,2,2);
    grid on
    title('Velocity Error')
    legend(legend_fig2,'Location','best');
    xlabel('Time (s)');
    ylabel('Error (m/s)');

    figure(3)
    legend_str1=[];
    sgtitle("Maximum Error vs Time Step")
    subplot(1,2,1);
    grid on
    title("Position Error");
    hold on
    for i=1:length(dt_values)
        loglog(dt_values(i),max(Error_r(i,:)),'o');
        legend_fig3(end+1)=sprintf("Model %d - dt = %g s",Model(k),dt_values(i));
    end
    legend(legend_fig3,'Location','best');
    xlabel('Time Step(s)');
    ylabel('Error (m)');
    subplot(1,2,2);
    grid on
    xlabel('Time Step(s)');
    ylabel('Error (m/s)');
    title("Velocity Error");
    hold on
    for i=1:length(dt_values)
        loglog(dt_values(i),max(Error_v(i,:)),'o');
    end
    legend(legend_fig3,'Location','best');

    figure(4)
    hold on
    title("Computation Time for each Time Step")
    errorbar(dt_values,t_c_means,t_c_S,'ro-');
    legend_fig4(end+1)=sprintf("Model %d",Model(k));
    if k==length(Model)
        plot(dt_values,1./dt_values,'b-');
        legend_fig4(end+1)="Theoric Form";
    end
    xlabel("Time Step (s)");
    ylabel("Computing Time (s)");
    grid on
    legend(legend_fig4,'Location','best');

    figure(5)
    sgtitle("Maximum Error vs Computation Time");
    subplot(1,2,1);
    title("Position Error");
    grid on
    hold on
    for i=1:length(dt_values)
        errorbar(t_c_means(i),max_Error_r(i),[],t_c_S(i),'o');
        legend_fig5(end+1)=sprintf("Model %d - dt = %g s",Model(k),dt_values(i));
    end
    set(gca,'YScale','log');
    legend(legend_fig5,'Location','best');
    xlim([min(t_c_means)*0.99-0.01,max(t_c_means)*1.01]);
    ylim([min(max_Error_r)*0.99,max(max_Error_r)*1.01])
    xlabel('Computation Time (s)');
    ylabel('Error (m)')
    subplot(1,2,2);
    grid on
    hold on
    for i=1:length(dt_values)
        errorbar(t_c_means(i),max_Error_v(i),[],t_c_S(i),'o');
    end
    legend(legend_fig5,'Location','best');
    set(gca,'YScale','log');
    xlim([min(t_c_means)*0.99-0.01,max(t_c_means)*1.01]);
    ylim([min(max_Error_v)*0.99,max(max_Error_v)*1.01]);
    xlabel('Computation Time (s)');
    ylabel('Error (m/s)');
    title("Velocity Error");
end

