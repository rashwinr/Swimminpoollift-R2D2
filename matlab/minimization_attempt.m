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
lb = [0.75,500,0.4,0.6,0.2,75];
ub = [0.9,5000,0.7,5,1,140];
Fs = 1500;
A = [];
b = [];
Aeq = [];
Beq = [];
x0 = [L_CG,Fs,L_CK,L_CE,0.203,90];
Mass = 10;
fun = @(x)Mass*g*(x(1)*0.9659+L_GJ)-x(2)*x(3)*sind(x(4)*sind((x(6)-atand(x(5)/sqrt(x(4)*x(4)-x(5)*x(5)))/sqrt(x(3)*x(3)+x(4)*x(4)-2*x(3)*x(4)*cosd(x(6)-acosd(x(5)/sqrt(x(4)*x(4)-x(5)*x(5))))))));

% Maximum mass
Mass = 120+10;         %10Kg extra mass added for the link!
x_max = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
disp(x_max)

% Average mass
Mass = 75+10;
% fun = @(x)Mass*g*(x(1)*0.9659+L_GJ)-x(2)*x(3)*sind(x(4)*sind((x(6)-atand(x(5)/sqrt(x(4)*x(4)-x(5)*x(5)))/sqrt(x(3)*x(3)+x(4)*x(4)-2*x(3)*x(4)*cosd(105-acosd(x(5)/sqrt(x(4)*x(4)-x(5)*x(5))))))));
x_avg = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
disp(x_avg)

% Average mass
Mass = 50+10;
% fun = @(x)Mass*g*(x(1)*0.9659+L_GJ)-x(2)*x(3)*sind(x(4)*sind((x(6)-atand(x(5)/sqrt(x(4)*x(4)-x(5)*x(5)))/sqrt(x(3)*x(3)+x(4)*x(4)-2*x(3)*x(4)*cosd(105-acosd(x(5)/sqrt(x(4)*x(4)-x(5)*x(5))))))));
x_avg1 = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
disp(x_avg1)

% Minimum mass
Mass = 0+10;
% fun = @(x)Mass*g*(x(1)*0.9659+L_GJ)-x(2)*x(3)*sind(x(4)*sind((x(6)-atand(x(5)/sqrt(x(4)*x(4)-x(5)*x(5)))/sqrt(x(3)*x(3)+x(4)*x(4)-2*x(3)*x(4)*cosd(105-acosd(x(5)/sqrt(x(4)*x(4)-x(5)*x(5))))))));
x_min = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
disp(x_min)