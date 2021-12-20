clc
clear all
close all
opts = spreadsheetImportOptions("NumVariables", 12);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:L277";

% Specify column names and types
opts.VariableNames = ["Designation", "Section", "D", "B", "t", "T", "M", "A", "Ix", "Iy", "Rx", "Ry"];
opts.VariableTypes = ["string", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, "Designation", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Designation", "Section"], "EmptyFieldRule", "auto");

% Import the data
Crosssectionproperties = readtable("C:\Users\Ashwin Raj Kumar\MATLAB Drive\Projects\Swimmingpoollift\data\Cross section properties.xlsx", opts, "UseExcel", false);

clear opts


% [A,B,C] = crossectional_analysis('P',21.3,21.3,3.2,3.2,Crosssectionproperties);
% disp('Pipe of dia P15')
% disp(strcat('A = ',num2str(C,'%.2f')))
% disp(strcat('Ixx = ',num2str(A,'%.2f')))
% [A,B,C] = crossectional_analysis('B',60,40,2.9,2.9,Crosssectionproperties);
% disp('Box of 60 x 40')
% disp(strcat('A = ',num2str(C,'%.2f')))
% disp(strcat('Ixx = ',num2str(A,'%.2f')))
% [A,B,C] = crossectional_analysis('C',75,40,4.8,7.5,Crosssectionproperties);
% disp('C channel of 75 x 40')
% disp(strcat('A = ',num2str(C,'%.2f')))
% disp(strcat('Ixx = ',num2str(A,'%.2f')))
% [A,B,C] = crossectional_analysis('I',100,100,6,10,Crosssectionproperties);
% disp('I channel of 75 x 45')
% disp(strcat('A = ',num2str(C,'%.2f')))
% disp(strcat('Ixx = ',num2str(A,'%.2f')))
errortable = tableerror(Crosssectionproperties);
figure(1)
plot(errortable.Var4)
hold on
plot(errortable.Var6)
figure(2)
plot(errortable.Var5)
hold on
plot(errortable.Var7)
function [Ixx,R,SecArea] = crossectional_analysis(Section,X,Y,Tx,Ty)
switch Section
    case 'P'
        SecArea = (pi*X*Y-pi*(X-2*Tx)*(Y-2*Ty))/400;
        Ixx = pi*(X*Y*X*Y-(X-2*Tx)^4)/640000;
        R = 20*Ixx/X;

    case 'B'
        SecArea = 2*Tx*((X-4*Tx)+(Y-4*Tx)+(3*pi*Tx/2))/100;
        Ixx =  ((X*Y*Y*Y)-(X-2*Tx)*(Y-2*Ty)^3)/120000;
        %         Ixx =  (T*(Y-4*T)^3/6)+ (( ((B-4T)*T^3/3)+(T*(B-4T)*(D-T)^2))/2) + (pi*t^4(405-(3136/pi^2))/108)+(3*pi*T^2)*((9*pi*(Y-4*T)+56*T)/18*pi)^2;
        R = 20*Ixx/Y;

    case 'L'
        SecArea = ((X-Tx)*Ty+(Y-Ty)*Tx+Tx*Ty)/100;
        Ixx = ((Tx*(Y-Ty)^3/12)+(X*Ty^3/12)+(X*Ty*(X-Ty)*(X-Ty)/4))/10000;
        R = 20*Ixx/Y;

    case 'C'
        SecArea = (2*X*Ty+(Y-2*Ty)*Tx)/100;
        Ixx = ((Tx*(Y-2*Ty)^3/12)+2*((Ty*Ty*Ty*X/12)+(Ty*X*(Y-Ty)*(Y-Ty)/4)))/10000;
        R = 20*Ixx/Y;

    case 'I'
        SecArea = (2*X*Ty+(Y-2*Ty)*Tx)/100;
        Ixx = (Tx*(Y-2*Ty)^3/12)+2*((Ty*Ty*Ty*X/12)+(Ty*X*(Y-Ty)*(Y-Ty)/4));
        Ixx = Ixx/10000;
        R = 20*Ixx/Y;

end

end


function errortable = tableerror(Crosssectionproperties)
for i=1:height(Crosssectionproperties)
        [Ixx(i),B,SecArea(i)] = crossectional_analysis(Crosssectionproperties.Section(i),Crosssectionproperties.D(i),Crosssectionproperties.B(i),Crosssectionproperties.t(i),Crosssectionproperties.T(i));
        Aerr(i) = (SecArea(i)-Crosssectionproperties.A(i))*100/Crosssectionproperties.A(i);
        Ierr(i) = (Ixx(i)-Crosssectionproperties.Ix(i))*100/Crosssectionproperties.Ix(i);
end

errortable = table(Crosssectionproperties.Section(:),Crosssectionproperties.D(:),Crosssectionproperties.B(:),Crosssectionproperties.A(:),Crosssectionproperties.Ix(:),SecArea(:),Ixx(:),Ierr(:),Aerr(:));

end


%113.5 X 113.5 X 6	B	113.50	113.50	6.00	6.00	19.53	24.81	469.81	469.81	4.35	4.35
%113.5 X 1133 X 5.4	B	113.50	1133.00	5.40	5.40	17.74	22.60	432.58	432.58	4.38	4.38
%113.5 X 113.5 X 4.5	B	113.50	113.50	4.50	4.50	14.99	19.10	372.88	372.88	4.42	4.42
