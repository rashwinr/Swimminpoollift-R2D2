
function [p1,p2] = principlestresses(Fa,Fp,M,Section,Designation)
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
A =  Crosssectionproperties.A(no);
I = Crosssectionproperties.Ix(no);
Sigma_A = (Fa/A)+(M*Crosssectionproperties.D(no)/(2*I));
Sigma_T = 

end

%von mises = sqrt(s1^2-s1*s2+s2^2)
%%
function [Sigma_max,Sigma_min,Sigma_max_2,Sigma_min_2,Sigma_max_In,Sigma_min_In,Sigma_max_In_2,Sigma_min_In_2] = Stress_P(Section,Y,X,Tx,Ty,F_a,F_p,M,L)
        Sigma_min = 0;
        Sigma_min_2 = 0;
switch Section
    case 'P'
        [Ixx,ElstMod,SecArea]=crossectional_analysis(Section,Y,X,Tx,Ty);
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
        [Ixx,ElstMod,SecArea]=crossectional_analysis(Section,Y,X,Tx,Ty);
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
        [Ixx,ElstMod,SecArea]=crossectional_analysis(Section,Y,X,Tx,Ty);
        SecArea=SecArea*10^-4;
        Ixx=Ixx*10^-8;
        Sigma_T = F_a/SecArea;
        Sigma_M = (F_p*L)*(X/2)/Ixx*10^(-3);
        X=X-((Y*Ty^2/Tx+X^2-Ty^2)/(2*(Ty*Y/Tx-Ty+X)));
        Sigma_MM = M*(X)/Ixx*10^(-3);
        Sigma_max = (Sigma_T+Sigma_M-Sigma_MM)/10^6;
        

        Sigma_max_In = Sigma_max;
        Sigma_min_In = 0;
%         Q = (Ty*Y)*(X/2-Ty/2)*10^(-9);
%         tau = F_p*Q/Ixx/Tx*10^(3);
%         Sigma_MM_2 = M*(X/2-Ty)/Ixx*10^(-3);
%         Sigma_M_temp = (F_p*L)*(X/2-Ty)/Ixx*10^(-3)+Sigma_T-Sigma_MM_2;
%         Sigma_max_2 = (Sigma_M_temp/2+sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;
%         Sigma_min_2 = (Sigma_M_temp/2-sqrt((Sigma_M_temp/2)^2+tau^2))/10^6;


    case 'C'
        [Ixx,ElstMod,SecArea]=crossectional_analysis(Section,Y,X,Tx,Ty);
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
        [Ixx,ElstMod,SecArea]=crossectional_analysis(Section,Y,X,Tx,Ty);
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
A=[Sigma_max,Sigma_min,Sigma_max_2,Sigma_min_2,Sigma_max_In,Sigma_min_In,Sigma_max_In_2,Sigma_min_In_2];
Temporary=max(A);
Temporary2=abs(min(A));
Temporary=max(Temporary,Temporary2);
if Temporary==abs(Sigma_max)
        disp('Max stress occurs at the upper boundary and is given by :');
        disp(strcat(num2str(Sigma_max,'%.4f'),' MPa'));
elseif Temporary==abs(Sigma_max_2)
        disp('Max stress occurs at the lower boundary and is given by :');
        disp(strcat(num2str(Sigma_max_2,'%.4f'),' MPa'));
elseif Temporary==abs(Sigma_max_In)|| Temporary==abs(Sigma_min_In)
        disp('Max stress occurs at the point between the web and flange on the upper side and is given by');
        disp('Sigma_max');
        disp(strcat(num2str(Sigma_max_In,'%.4f'),' MPa'));
        disp('Sigma_min');
        disp(strcat(num2str(Sigma_min_In,'%.4f'),' MPa'));
elseif Temporary==abs(Sigma_max_In_2)|| Temporary==abs(Sigma_min_In_2)
        disp('Max stress occurs at the point between the web and flange on the lower side and is given by');
        disp('Sigma_max');
        disp(strcat(num2str(Sigma_max_In_2,'%.4f'),' MPa'));
        disp('Sigma_min');
        disp(strcat(num2str(Sigma_min_In_2,'%.4f'),' MPa'));
else
        disp('Something went wrong');
end
end