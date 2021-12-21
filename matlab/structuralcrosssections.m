clc
clear all
close all
opts = spreadsheetImportOptions("NumVariables", 12);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:L273";

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
figure(3)
plot(errortable.Var8)
figure(4)
plot(errortable.Var9)

function [Ixx,R,SecArea] = crossectional_analysis(Section,X,Y,Tx,Ty)
switch Section
    case 'P'
        SecArea = (pi*X*Y-pi*(X-2*Tx)*(Y-2*Ty))/400;
        Ixx = pi*(X*Y*X*Y-(X-2*Tx)^4)/640000;
        R = sqrt(Ixx/SecArea);

    case 'B'
        SecArea = 2*Tx*((X-4*Tx)+(Y-4*Tx)+(3*pi*Tx/2))/100;
        Ixx =((Tx*(Y-4*Ty)^3/6)+((((X-4*Tx)*Ty^3/3)+((X-4*Tx)*(Y-Tx)^2*Tx))/2)+(pi*Tx^4*(405-(3136/pi^2))/108)+(3*pi*Tx^2*((9*pi*(Y-4*Tx)+56*Tx)/(18*pi))^2));
        Ixx = Ixx/10000;
        R = sqrt(Ixx/SecArea);
        
    case 'L'
        SecArea = ((X-Tx)*Ty+(Y-Ty)*Tx+Tx*Ty)/100;
        Ixx = ((Tx*(Y-Ty)^3/12)+(X*Ty^3/12)+(X*Ty*(X-Ty)*(X-Ty)/4))/10000;
        R = sqrt(Ixx/SecArea);

    case 'C'
        SecArea = (2*X*Ty+(Y-2*Ty)*Tx)/100;
        Ixx = ((Tx*(Y-2*Ty)^3/12)+2*((Ty*Ty*Ty*X/12)+(Ty*X*(Y-Ty)*(Y-Ty)/4)))/10000;
        R = sqrt(Ixx/SecArea);

    case 'I'
        SecArea = (2*X*Ty+(Y-2*Ty)*Tx)/100;
        Ixx = (Tx*(Y-2*Ty)^3/12)+2*((Ty*Ty*Ty*X/12)+(Ty*X*(Y-Ty)*(Y-Ty)/4));
        Ixx = Ixx/10000;
        R = sqrt(Ixx/SecArea);

end
end

function errortable = tableerror(Crosssectionproperties)
for i=1:height(Crosssectionproperties)
        [Ixx(i),B,SecArea(i)] = crossectional_analysis(Crosssectionproperties.Section(i),Crosssectionproperties.B(i),Crosssectionproperties.D(i),Crosssectionproperties.t(i),Crosssectionproperties.T(i));
        Aerr(i) = (SecArea(i)-Crosssectionproperties.A(i))*100/Crosssectionproperties.A(i);
        Ierr(i) = (Ixx(i)-Crosssectionproperties.Ix(i))*100/Crosssectionproperties.Ix(i);
end

errortable = table(Crosssectionproperties.Section(:),Crosssectionproperties.D(:),Crosssectionproperties.B(:),Crosssectionproperties.A(:),Crosssectionproperties.Ix(:),SecArea(:),Ixx(:),Ierr(:),Aerr(:));

end

