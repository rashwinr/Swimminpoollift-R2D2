function [vm1,vm2,vm3,vm4] = principlestresses(F_a,F_p,M,L,Section,Designation)
%PRINCIPLESTRESSES Summary of this function goes here
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
no = find(Crosssectionproperties.Section == Section & Crosssectionproperties.Designation == Designation)
if no== 0
    disp("Please enter the details accurately for section properties and section type")
end
SecArea =  Crosssectionproperties.A(no);
Ixx = Crosssectionproperties.Ix(no);
        Sigma_min = 0;
        Sigma_min_2 = 0;
switch Section
    case 'P'

        SecArea=SecArea*10^-4;
        Ixx=Ixx*10^-8;
        Sigma_T = F_a/SecArea;
        Sigma_M = (F_p*L)*(X/2)/Ixx*10^(-3);
        Sigma_MM = M*(X/2)/Ixx*10^(-3);
        Sigma_max = (Sigma_T+Sigma_M-Sigma_MM)/10^6;
        Sigma_max_2 = (Sigma_T-Sigma_M+Sigma_MM)/10^6;
        Sigma_max_In = Sigma_max;
        Sigma_min_In = 0;
        Sigma_max_In_2 = Sigma_max;
        Sigma_min_In_2 = 0;


    case 'B'

        SecArea=SecArea*10^-4;
        Ixx=Ixx*10^-8;
        Sigma_T = F_a/SecArea;
        Sigma_M = (F_p*L)*(X/2)/Ixx*10^(-3);
        Sigma_MM = M*(X/2)/Ixx*10^(-3);
        Sigma_max = (Sigma_T+Sigma_M-Sigma_MM)/10^6;
        Sigma_max_2 = (Sigma_T-Sigma_M+Sigma_MM)/10^6;
        
        Q = (Ty*Y)*(X/2-Ty/2)*10^(-9);
        tau = F_p*Q/Ixx/Tx/2*10^(3);
        Sigma_MM_2 = M*(X/2-Ty)/Ixx*10^(-3);
        Sigma_M_temp = (F_p*L)*(X/2-Ty)/Ixx*10^(-3)+Sigma_T-Sigma_MM_2;
        Sigma_M_temp_2 = -(F_p*L)*(X/2-Ty)/Ixx*10^(-3)+Sigma_T+Sigma_MM_2;
        Sigma_max_In = (Sigma_M_temp/2+sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;
        Sigma_min_In = (Sigma_M_temp/2-sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;
        Sigma_max_In_2 = (Sigma_M_temp_2/2+sqrt((Sigma_M_temp_2/2)^2+tau^2))/10^6;
        Sigma_min_In_2 = (Sigma_M_temp_2/2-sqrt((Sigma_M_temp_2/2)^2+tau^2))/10^6;
    case 'L'
        SecArea=SecArea*10^-4;
        Ixx=Ixx*10^-8;
        Sigma_T = F_a/SecArea;
        Sigma_M = (F_p*L)*(X/2)/Ixx*10^(-3);
        X=X-((Y*Ty^2/Tx+X^2-Ty^2)/(2*(Ty*Y/Tx-Ty+X)));
        Sigma_MM = M*(X)/Ixx*10^(-3);
        Sigma_max = (Sigma_T+Sigma_M-Sigma_MM)/10^6;
        Sigma_max_In = Sigma_max;
        Sigma_min_In = 0;

    case 'C'
        SecArea=SecArea*10^-4;
        Ixx=Ixx*10^-8;
        Sigma_T = F_a/SecArea;
        Sigma_M = (F_p*L)*(X/2)/Ixx*10^(-3);
        Sigma_MM = M*(X/2)/Ixx*10^(-3);
        Sigma_max = (Sigma_T+Sigma_M-Sigma_MM)/10^6;
        Sigma_max_2 = (Sigma_T-Sigma_M+Sigma_MM)/10^6;

        Q = (Ty*Y)*(X/2-Ty/2)*10^(-9);
        tau = F_p*Q/Ixx/Tx*10^(3);
        Sigma_MM_2 = M*(X/2-Ty)/Ixx*10^(-3);
        Sigma_M_temp = (F_p*L)*(X/2-Ty)/Ixx*10^(-3)+Sigma_T-Sigma_MM_2;
        Sigma_M_temp_2 = -(F_p*L)*(X/2-Ty)/Ixx*10^(-3)+Sigma_T+Sigma_MM_2;
        Sigma_max_In = (Sigma_M_temp/2+sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;
        Sigma_min_In = (Sigma_M_temp/2-sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;
        Sigma_max_In_2 = (Sigma_M_temp_2/2+sqrt((Sigma_M_temp_2/2)^2+tau^2))/10^6;
        Sigma_min_In_2 = (Sigma_M_temp_2/2-sqrt((Sigma_M_temp_2/2)^2+tau^2))/10^6;

    case 'I'
        SecArea=SecArea*10^-4;
        Ixx = Ixx*10^-8;
        Sigma_T = F_a/SecArea;
        Sigma_M = (F_p*L)*(X/2)/Ixx*10^(-3);
        Sigma_MM = M*(X/2)/Ixx*10^(-3);
        Sigma_max = (Sigma_T+Sigma_M-Sigma_MM)/10^6;
        Sigma_max_2 = (Sigma_T-Sigma_M+Sigma_MM)/10^6;

        Q = (Ty*Y)*(X/2-Ty/2)*10^(-9);
        tau = F_p*Q/Ixx/Tx*10^(3);
        Sigma_MM_2 = M*(X/2-Ty)/Ixx*10^(-3);
        Sigma_M_temp = (F_p*L)*(X/2-Ty)/Ixx*10^(-3)+Sigma_T-Sigma_MM_2;
        Sigma_M_temp_2 = -(F_p*L)*(X/2-Ty)/Ixx*10^(-3)+Sigma_T+Sigma_MM_2;
        Sigma_max_In = (Sigma_M_temp/2+sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;
        Sigma_min_In = (Sigma_M_temp/2-sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;
        Sigma_max_In_2 = (Sigma_M_temp_2/2+sqrt((Sigma_M_temp_2/2)^2+tau^2))/10^6;
        Sigma_min_In_2 = (Sigma_M_temp_2/2-sqrt((Sigma_M_temp_2/2)^2+tau^2))/10^6;
end
        vm1 = vonmises(Sigma_max,Sigma_min);
        vm2 = vonmises(Sigma_max_2,Sigma_min_2);
        vm3 = vonmises(Sigma_max_In,Sigma_min_In);
        vm4 = vonmises(Sigma_max_In_2,Sigma_min_In_2);
end
