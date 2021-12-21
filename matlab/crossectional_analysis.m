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