clc
clear all
close all
theta = 90+[-15:5:50];
Mass = 120;
Mass = Mass+20;         %10Kg extra mass added for the link!
g = 9.81;

L_CG = 0.880;
L_GJ = 0.30093;
L_CK = 0.665;
L_CD = 0.15207;
L_CE = 0.60978;
L_AC = 0.5905;
L_AD = 0.493;
n=10;
L_div = 0.0:L_CG/(n-1):L_CG;

Fs = 1500;

[R3H_A,R3_A_L_theta] = reactionforceslink3(Mass*g,theta,L_CD,L_GJ);

[R2C_A,R2C_S,Torque1,R2G_A,R2G_S,R3D_A] = reactionforceslink2(Mass*g,Fs,theta,L_CG,L_CK,L_CD,L_CE,L_GJ);
% figure(1)
% plot(theta,R2C_S,'*-','LineWidth',1.5)
% hold on
% plot(theta,R2G_S,'*-','LineWidth',1.5)
[X,Y] = meshgrid(L_div,theta);
[V3,A3,M3]=reactionforceslink2_length(Fs,R2C_A/2,R2C_S/2,R2G_A/2,R2G_S/2,theta,L_CG,L_CE,L_CK);

% 
% figure(2)
% plot(L_div,V3(1,:))
% hold on
% plot(L_div,M3(1,:))
% plot(L_div,A3(1,:))

figure(3)
surf(X,Y,V3)
xlabel('{L}_{CG}','FontSize',15)
ylabel('\theta','FontSize',15)
zlabel('V_{S}','FontSize',15)

figure(4)
surf(X,Y,M3)
xlabel('{L}_{CG}','FontSize',15)
ylabel('\theta','FontSize',15)
zlabel('M','FontSize',15)

figure(5)
surf(X,Y,A3)
xlabel('{L}_{CG}','FontSize',15)
ylabel('\theta','FontSize',15)
zlabel('F_{A}','FontSize',15)

% vm1 = zeros(14,10);
% vm2 = zeros(14,10);
% vm3 = zeros(14,10);
% vm4 = zeros(14,10);
for i = 1:length(theta)
    for j=1:length(L_div)
        [vm1(i,j),vm2(i,j),vm3(i,j),vm4(i,j)] = principlestresses(A3(i,j),V3(i,j),M3(i,j),L_CG,'B','50 X 25 X 2.9');
    end
end  

figure(6)
surf(X,Y,vm1)
xlabel('{L}_{CG}','FontSize',15)
ylabel('\theta','FontSize',15)
zlabel('\sigma_{V}','FontSize',15)

figure(7)
surf(X,Y,vm2)
xlabel('{L}_{CG}','FontSize',15)
ylabel('\theta','FontSize',15)
zlabel('\sigma_{V}','FontSize',15)

figure(8)
surf(X,Y,vm3)
xlabel('{L}_{CG}','FontSize',15)
ylabel('\theta','FontSize',15)
zlabel('\sigma_{V}','FontSize',15)

figure(9)
surf(X,Y,vm4)
xlabel('{L}_{CG}','FontSize',15)
ylabel('\theta','FontSize',15)
zlabel('\sigma_{V}','FontSize',15)

[R4A_A,R4A_S,M_A,T] = reactionforceslink4(Mass*g,Fs,theta,L_CG,L_CK,L_CD,L_CE,L_GJ,L_AC,L_AD);


% Reaction force calculations at link 3

function [R_H_theta,R_3_L_theta] = reactionforceslink3(Mg,theta,L_CD,L_GJ)
n = 10;
subtend_angle = atand(110/105);
for i=1:length(theta)
    R_H_theta(i) = L_GJ*Mg/(L_CD*sind(theta(i)-subtend_angle));
end
size(R_H_theta);
for i=1:n
    R_3_L_theta(:,i) = R_H_theta';
end
end


% Reaction force calculations at link 2

function [R_C_X,R_C_Y,T1,R_G_X,R_G_Y,R_H] = reactionforceslink2(Mg,Fs,theta,L_CG,L_CK,L_CD,L_CE,L_GJ)
subtend_angle = atand(110/105);
for i=1:length(theta)
    R_H(i) = L_GJ*Mg/(L_CD*sind(theta(i)-subtend_angle));
    %Fx for top four bar connector = 0
    R_G_X(i) = Mg*cosd(180-theta(i))-R_H(i);
    %Fy for top four bar connector = 0
    R_G_Y(i) = Mg*sind(180-theta(i));
end
L_AE = 203;
L_AC = 575;
Extra_angle = atand(L_AE/L_AC);
Instantaneous_Length_of_gas_spring = sqrt(L_CK^2 + L_CE^2-2*L_CE*L_CK*cosd(theta-Extra_angle));
for i=1:length(theta)
    Phi_angle(i) = asind(L_CE*sind(theta(i)-Extra_angle)/Instantaneous_Length_of_gas_spring(i));
end

R_C_X = zeros(size(theta));
R_C_Y = zeros(size(theta));

for j = 1:length(theta)
    R_C_X(j) = - R_G_X(j) - Fs*cosd(Phi_angle(j));
    R_C_Y(j) = Fs*sind(Phi_angle(j))-R_G_Y(j);
    T1(j) = R_G_Y(j)*L_CG-Fs*L_CK*sind(Phi_angle(j));
end

end

function [V3,A3,M3]=reactionforceslink2_length(Fs,R2C_A,R2C_S,R2G_A,R2G_S,theta,L_CG,L_CE,L_CK)

n=10;
L_div = 0.0:L_CG/(n-1):L_CG;
L_div = round(L_div,2);
V3 = zeros(length(theta),n);
A3 = zeros(length(theta),n);
M3 = zeros(length(theta),n);
Extra_angle = atand(203/575);

Instantaneous_Length_of_gas_spring = sqrt(L_CK^2 + L_CE^2-2*L_CE*L_CK*cosd(theta-Extra_angle));

for i=1:length(theta)
    Phi(i) = asind(L_CE*sind(theta(i)-Extra_angle)/Instantaneous_Length_of_gas_spring(i));
end

for i=1:n
    if L_div(i)>=L_CK
        V3(:,i) = -R2G_S;
        M3(:,i) = -R2G_S(:)*(L_CG-L_div(i));
        A3(:,i) = R2G_A;
    end
    if L_div(i)<=L_CK
        V3(:,i) = -R2C_S';
        M3(:,i) = (R2G_S*(L_CG-L_div(i))-Fs*sind(Phi)*(L_CK-L_div(i)))';
        A3(:,i) = R2G_A+Fs*cosd(Phi);
    end
end

end


% Reaction force calculations at link 4

function [R_A_X,R_A_Y,M_A,T1] = reactionforceslink4(Mg,Fs,theta,L_CG,L_CK,L_CD,L_CE,L_GJ,L_AC,L_AD)

subtend_angle = atand(110/105);

[R_C_X,R_C_Y,~,R_G_X,R_G_Y,R_H] = reactionforceslink2(Mg,Fs,theta,L_CG,L_CK,L_CD,L_CE,L_GJ);

EA = atand(203/575);

Instantaneous_Length_of_gas_spring = sqrt(L_CK^2 + L_CE^2-2*L_CE*L_CK*cosd(theta-EA));

for i=1:length(theta)
    Phi(i) = asind(L_CE*sind(theta(i)-EA)/Instantaneous_Length_of_gas_spring(i));
end

for j = 1:length(theta)
    R_C_X(j) = - R_G_X(j) - Fs*cosd(Phi(j));
    R_C_Y(j) = Fs*sind(Phi(j))-R_G_Y(j);
    T1(j) = R_G_Y(j)*L_CG-Fs*L_CK*sind(Phi(j));
end

for i=1:length(theta)
    R_A_X(i) = R_H(i)*cosd(theta(i)-90)+R_C_X(i)*cosd(90-theta(i))-R_C_Y(i)*cosd(180-theta(i));
    R_A_Y(i) = R_H(i)*sind(theta(i)-90)+R_C_X(i)*sind(theta(i)-90)-R_C_Y(i)*sind(180-theta(i));
    M_A(i) = T1(i)+L_AC*R_C_X(i)*sind(theta(i))+L_AC*R_C_Y(i)*sind(theta(i)-90)+L_AD*R_H(i)*sind(theta(i));
end

end



