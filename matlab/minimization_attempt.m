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
L_AC = 0.5905;
L_AD = 0.493;
n=10;
L_div = 0.0:L_CG/(n-1):L_CG;
lb = [500,0.4,0.6,0.2];
ub = [5000,0.8,1,1];
Fs = 1500;
A = [];
b = [];
Aeq = [];
Beq = [];
x0 = [Fs,L_CK,L_CE,0.203];
Mass = 10;
thetaangle = 75;
fun = @(x)Mass*g*(L_CG*0.9659+L_GJ)-x(1)*x(2)*sind(x(3)*sind((thetaangle-atand(x(4)/sqrt(x(3)*x(3)-x(4)*x(4)))/sqrt(x(2)*x(2)+x(3)*x(3)-2*x(2)*x(3)*cosd(thetaangle-acosd(x(4)/sqrt(x(3)*x(3)-x(4)*x(4))))))));

% Maximum mass
Mass = 120+10;         %10Kg extra mass added for the link!
for i = 1:length(theta)
    thetaangle = theta(i);
    x_max(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
end

disp(x_max)

% Average mass
Mass = 75+10;
for i = 1:length(theta)
    thetaangle = theta(i);
    x_avg(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
end
% Average mass
Mass = 50+10;
for i = 1:length(theta)
    thetaangle = theta(i);
    x_avg1(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
end

% Minimum mass
Mass = 0+10;
for i = 1:length(theta)
    thetaangle = theta(i);
    x_min(:,i) = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
end