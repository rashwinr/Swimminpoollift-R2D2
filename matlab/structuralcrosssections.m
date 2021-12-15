% [A,B,C] = crossectional_analysis('PIPE',21.3,21.3,3.2,3.2);
% [A,B,C] = crossectional_analysis('BOX',40,60,2.6,2.6);
% [A,B,C] = crossectional_analysis('L',25,25,5,5)
[A,B,C,M] = crossectional_analysis('I',100,100,6,10)

disp(C)
disp(A)
disp(B)

function [Ixx,ElstMod,SecArea] = crossectional_analysis(Section,X,Y,Tx,Ty)
switch Section
    case 'PIPE'
        SecArea = (pi*X*Y-pi*(X-2*Tx)*(Y-2*Ty))/400;
        Ixx = pi*(X*Y*X*Y-(X-2*Tx)^4)/640000;
        ElstMod = 20*Ixx/X;

    case 'BOX'
        SecArea = 2*Tx*((X-4*Tx)+(Y-4*Tx)+(3*pi*Tx/2))/100;
        Ixx =  ((X*Y*Y*Y)-(X-2*Tx)*(Y-2*Ty)^3)/120000;
        %         Ixx =  (T*(Y-4*T)^3/6)+ (( ((B-4T)*T^3/3)+(T*(B-4T)*(D-T)^2))/2) + (pi*t^4(405-(3136/pi^2))/108)+(3*pi*T^2)*((9*pi*(Y-4*T)+56*T)/18*pi)^2;
        ElstMod = 20*Ixx/Y;

    case 'L'
        SecArea = ((X-Tx)*Ty+(Y-Ty)*Tx+Tx*Ty)/100;
        Ixx = ((Tx*(Y-Ty)^3/12)+(X*Ty^3/12)+(X*Ty*(X-Ty)*(X-Ty)/4))/10000;
        ElstMod = 20*Ixx/Y;

    case 'C'
        SecArea = (2*X*Ty+(Y-2*Ty)*Tx)/100;
        Ixx = ((Tx*(Y-2*Ty)^3/12)+2*((Ty*Ty*Ty*X/12)+(Ty*X*(Y-Ty)*(Y-Ty)/4)))/10000;
        ElstMod = 20*Ixx/Y;

    case 'I'
        SecArea = (2*X*Ty+(Y-2*Ty)*Tx)/100;
        Ixx = (Tx*(Y-2*Ty)^3/12)+2*((Ty*Ty*Ty*X/12)+(Ty*X*(Y-Ty)*(Y-Ty)/4));
        Ixx = Ixx/10000;
        ElstMod = 20*Ixx/Y;

end

end
