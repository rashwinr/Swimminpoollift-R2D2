
function [outputArg1,outputArg2] = principlestresses(Fa,Fp,M,Section,Designation)
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
Sigma_T = (Fa/A)+(M*Crosssectionproperties.D(no)/(2*I));
Sigma_

end

