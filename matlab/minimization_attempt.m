% clc
% clear all
% close all
% theta = 90+[-15:5:50];
% g = 9.81;
% 
% L_CG = 0.880;
% L_GJ = 0.30093;
% L_CK = 0.665;
% L_CD = 0.15207;
% L_CE = 0.60978;
% L_AC = 0.5905;
% L_AD = 0.493;
% L_AE = 0.203;
% n=10;
% L_div = 0.0:L_CG/(n-1):L_CG;
% lb = [500,0.4,0.2];
% ub = [5000,0.8,0.5];
% Fs = 1500;
% A = [];
% b = [];
% Aeq = [];
% Beq = [];
% x0 = [Fs,L_CK,L_AE];
% Mass = 10;
% thetaangle = 75;
% 
% 
% % Maximum mass
% Mass = 100+10;         %10Kg extra mass added for the link!
% for i = 1:length(theta)
%     thetaangle = theta(i);
%     fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%     x_max(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
%     for j = 1:length(theta)
%         thetaangle = theta(j);
%         fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%         tau_max(j,i) = feval(fun,x_max(:,i));
%     end
% end
% 
% % disp(x_max)
% 
% % Average mass
% Mass = 75+10;
% for i = 1:length(theta)
%     thetaangle = theta(i);
%     fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%     x_avg(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
%     for j = 1:length(theta)
%         thetaangle = theta(j);
%         fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%         tau_avg(j,i) = feval(fun,x_avg(:,i));
%     end
% end
% 
% % Average mass
% Mass = 50+10;
% for i = 1:length(theta)
%     thetaangle = theta(i);
%     fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%     x_avg1(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);    
%     for j = 1:length(theta)
%         thetaangle = theta(j);
%         fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%         tau_avg1(j,i) = feval(fun,x_avg1(:,i));
%     end
% end
% 
% % Minimum mass
% Mass = 0+10;
% for i = 1:length(theta)
%     thetaangle = theta(i);
%     fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%     x_min(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
%     for j = 1:length(theta)
%         thetaangle = theta(j);
%         fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%         tau_min(j,i) = feval(fun,x_min(:,i));
%     end
% end
% 
% %phi = asind(L_CE*sind(theta(i)-Extra_angle)/Instantaneous_Length_of_gas_spring(i))
% %Extra_angle = atand(L_AE/L_AC);
% %Instantaneous_Length_of_gas_spring = sqrt(L_CK^2 + L_CE^2-2*L_CE*L_CK*cosd(theta-Extra_angle));
% figure(1)
% for i=1:length(theta)
% subplot(7,2,i)
% plot(theta,tau_min(i,:))
% title([strcat('Fs = ',num2str(x_min(1,i))),strcat(' ,L_{CK} = ',num2str(x_min(2,i))),strcat(' , L_{AE}= ',num2str(x_min(3,i)))]);
% end
% sgtitle('Minimum Mass (0 kgs) \tau vs. \theta')
% 
% figure(2)
% for i=1:length(theta)
% subplot(7,2,i)
% plot(theta,tau_max(i,:))
% title([strcat('Fs = ',num2str(x_max(1,i))),strcat(' ,L_{CK} = ',num2str(x_max(2,i))),strcat(' , L_{AE}= ',num2str(x_max(3,i)))]);
% end
% sgtitle('Maximum Mass (120 kgs) \tau vs. \theta')
% 
% figure(3)
% for i=1:length(theta)
% subplot(7,2,i)
% plot(theta,tau_avg(i,:))
% title([strcat('Fs = ',num2str(x_avg(1,i))),strcat(' ,L_{CK} = ',num2str(x_avg(2,i))),strcat(' , L_{AE}= ',num2str(x_avg(3,i)))]);
% end
% sgtitle('Maximum Mass (75 kgs) \tau vs. \theta')
% 
% figure(4)
% for i=1:length(theta)
% subplot(7,2,i)
% plot(theta,tau_avg1(i,:))
% title([strcat('Fs = ',num2str(x_avg1(1,i))),strcat(' ,L_{CK} = ',num2str(x_avg1(2,i))),strcat(' , L_{AE}= ',num2str(x_avg1(3,i)))]);
% end
% sgtitle('Maximum Mass (50 kgs) \tau vs. \theta')

%%
% fun = @(x)abs(x(1)^2-x(2)^2)
% lb = [-5,-5];
% ub = [5,5];
% A = [];
% b = [];
% Aeq = [];
% Beq = [];
% x0 = [2,3];
% fmincon(fun,x0,A,b,Aeq,Beq,lb,ub)
% x = [-5:1:5];
% y = [-5:1:5];
% [x1,x2] = meshgrid(x,y);
% for i=1:length(x)
%     for j = 1:length(y)
% s(i,j) = feval(fun,[x(i),y(j)]);
%     end
% end
% surf(x1,x2,s)

%% Minimization with arrays
clc
clear all
close all
theta = 90+[-15:5:50];
g = 9.81;
L_CG = 0.880;
L_GJ = 0.30093;
L_CK = 0.665;
L_CD = 0.15207;
L_CE = 0.60978;
% L_AC = 0.5905;
L_AC = 0.5905;
L_AD = 0.493;
L_AE = 0.203;
n=10;
L_div = 0.0:L_CG/(n-1):L_CG;
lb = [0,0.4,0.2,0.3];
ub = [5000,0.8,0.5,0.8];
Fs = 1500;
A = [];
b = [];
Aeq = [];
Beq = [];
x0 = [Fs,L_CK,L_AE,L_AC];
Mass = 10;
thetaangle = 75;


% Maximum massS
Mass = 0+10;         %10Kg extra mass added for the link!
% for i = 1:length(theta)
    fun = @(x)max(abs(Mass*g*(L_CG*sind(theta)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+x(4)*x(4))*sind(theta-(atand(x(3)/x(4))./sqrt(x(2)^2+x(3)^2+x(4)^2-2*sqrt(x(3)^2+x(4)^2)*x(2)*cosd(theta-atand(x(3)/x(4))))))))));
    fun1 = @(x)((Mass*g*(L_CG*sind(theta)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+x(4)*x(4))*sind(theta-(atand(x(3)/x(4))./sqrt(x(2)^2+x(3)^2+x(4)^2-2*sqrt(x(3)^2+x(4)^2)*x(2)*cosd(theta-atand(x(3)/x(4))))))))));   
    x_max = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub)
    tau_max = feval(fun1,x_max);
%     sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(theta-atand(x(3)/L_AC)))
%     for j = 1:length(theta)
%         thetaangle = theta(j);
%         fun = @(x)abs(Mass*g*(L_CG*cosd(thetaangle)+L_GJ)-x(1)*x(2)*sind(asind(sqrt(x(3)*x(3)+L_AC*L_AC)*sind(thetaangle-atand(x(3)/L_AC)/sqrt(x(2)^2+x(3)^2+L_AC^2-2*sqrt(x(3)^2+L_AC^2)*x(2)*cosd(thetaangle-atand(x(3)/L_AC)))))));
%         tau_max(j,i) = feval(fun,x_max(:,i));
%     end
% end
figure(1)
plot(theta,tau_max)
