%rho = 7860 for MS and 7920 for SS 2630 to 2800 for Al
%G = 77.2 for MS and 75 for SS and 26 to 28 for Al
%Sigma{Y} = 230 for MS 520 for SS (CR) and 240 upto 400 for Al 45 for nylon
%Sigma_{Y compressive} = 28 for concrete
%Compute the von mises stresses on the body
%FOS = 6

function [kgm,G,Sy] = Material_prop(A,material)
    switch material
        case 'Al'
            rho = 2630;
            G = 26;
            Sy = 240;
        case 'MS'
            rho = 7860;
            G = 77.2;
            Sy = 230;
        case 'SS'
            rho = 7920;
            G = 75;
            Sy = 520;
    end
    kgm = rho*A*1/10000;
end