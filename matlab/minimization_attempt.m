clc
clear all
close all
theta = 90+[-15:5:50];
Mass = 100;
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
fun = @(x)1200*(x(1)*0.9659+L_GJ)-x(2)*x(3)*sind(x(4)*sind((105-atand(x(5)/sqrt(x(4)*x(4)-x(5)*x(5)))/sqrt(x(3)*x(3)+x(4)*x(4)-2*x(3)*x(4)*cosd(105-acosd(x(5)/sqrt(x(4)*x(4)-x(5)*x(5))))))));
lb = [0.85,1000,0.4,0.6,0.2];
ub = [1,2000,0.7,0.6,0.3];
A = [];
b = [];
Aeq = [];
Beq = [];
x0 = [L_CG,Fs,L_CK,L_CE,0.203];
x = fmincon(fun,x0,A,b,Aeq,Beq,lb,ub);
disp(x)