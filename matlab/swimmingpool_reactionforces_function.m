clc
clear all
close all
theta = 90+[-15:5:50];
Mass = 100;
g = 10;
Spring_force = 1500;
weight = Mass*g;
R3a = reactionforces3(weight,Spring_force);
R3s = zeros(size(R3a));
[Ixx3,Elst3,Area3] = crossectional_analysis('BOX',25,25,2,2);
[Sa3,Ss3,Sv3,Sy13,kgm3] = vonmises(R3a,R3s,Area3,'MS');
M3 = kgm3*0.880;

[R2a,R2s] = reactionforces2(weight,Spring_force);
[Ixx2,Els2,Area2] = crossectional_analysis('BOX',25,25,2,2);
[Sa2,Ss2,Sv2,Sy12,kgm2] = vonmises(R2a,R2s,Area2,'MS');
M2 = kgm3*0.880;

[R4a,R4s,M,T] = reactionforces4(weight,Spring_force);

% Reaction force calculations

function [Reaction_H] = reactionforces3(Mg,Spring_force)
Mg = Mg+100; % stationery mass of 10 Kgs
Link_length = 0.880;
Seat_offset = 0.30093;
Spring_mount_distance = 0.665;
Spring_orig_distance = 0.60978;
Link_distance = 0.15207;
theta = 90+[-15:5:50];
subtend_angle = atand(110/105);
for i=1:length(theta)
    Reaction_H(i) = Seat_offset*Mg/(Link_distance*sind(theta(i)-subtend_angle));
end
end

function [Force_C_X,Force_C_Y] = reactionforces2(Mg,Spring_force)

Mg = Mg+100; % stationery mass of 10 Kgs
Link_length = 0.880;
Seat_offset = 0.30093;
Spring_mount_distance = 0.665;
Spring_orig_distance = 0.60978;
Link_distance = 0.15207;
theta = 90+[-15:5:50];
subtend_angle = atand(110/105);
for i=1:length(theta)
    Reaction_H(i) = Seat_offset*Mg/(Link_distance*sind(theta(i)-subtend_angle));
    %Fx for top four bar connector = 0
    Force_G_X(i) = Mg*cosd(180-theta(i))-Reaction_H(i);
    %Fy for top four bar connector = 0
    Force_G_Y(i) = Mg*sind(180-theta(i));
end
Extra_angle = atand(203/575);
Instantaneous_Length_of_gas_spring = sqrt(Spring_mount_distance^2 + Spring_orig_distance^2-2*Spring_orig_distance*Spring_mount_distance*cosd(theta-Extra_angle));
for i=1:length(theta)
    Phi_angle(i) = asind(Spring_orig_distance*sind(theta(i)-Extra_angle)/Instantaneous_Length_of_gas_spring(i));
end
Force_C_X = zeros(size(theta));
Force_C_Y = zeros(size(theta));
for j = 1:length(theta)
    Force_C_X(j) = - Force_G_X(j) - Spring_force*cosd(Phi_angle(j));
    Force_C_Y(j) = Spring_force*sind(Phi_angle(j))-Force_G_Y(j);
    Torque1(j) = Force_G_Y(j)*Link_length-Spring_force*Spring_mount_distance*sind(Phi_angle(j));
end

end

function [Force_A_X,Force_A_Y,Moment_A,Torque1] = reactionforces4(Mg,Spring_force)
Mg = Mg+100; % stationery mass of 10 Kgs
Link_length = 0.880;
Seat_offset = 0.30093;
Spring_mount_distance = 0.665;
Spring_orig_distance = 0.60978;
Link_distance = 0.15207;
theta = 90+[-15:5:50];
subtend_angle = atand(110/105);
for i=1:length(theta)
    Reaction_H(i) = Seat_offset*Mg/(Link_distance*sind(theta(i)-subtend_angle));
    %Fx for top four bar connector = 0
    Force_G_X(i) = Mg*cosd(180-theta(i))-Reaction_H(i);
    %Fy for top four bar connector = 0
    Force_G_Y(i) = Mg*sind(180-theta(i));
end
Extra_angle = atand(203/575);
Instantaneous_Length_of_gas_spring = sqrt(Spring_mount_distance^2 + Spring_orig_distance^2-2*Spring_orig_distance*Spring_mount_distance*cosd(theta-Extra_angle));
for i=1:length(theta)
    Phi_angle(i) = asind(Spring_orig_distance*sind(theta(i)-Extra_angle)/Instantaneous_Length_of_gas_spring(i));
end
Force_C_X = zeros(size(theta));
Force_C_Y = zeros(size(theta));
for j = 1:length(theta)
    Force_C_X(j) = - Force_G_X(j) - Spring_force*cosd(Phi_angle(j));
    Force_C_Y(j) = Spring_force*sind(Phi_angle(j))-Force_G_Y(j);
    Torque1(j) = Force_G_Y(j)*Link_length-Spring_force*Spring_mount_distance*sind(Phi_angle(j));
end
Lac = 0.5905;
Lad = 0.493;
for i=1:length(theta)
    Force_A_X(i) = Reaction_H(i)*cosd(theta(i)-90)+Force_C_X(i)*cosd(90-theta(i))-Force_C_Y(i)*cosd(180-theta(i));
    Force_A_Y(i) = 5000+Reaction_H(i)*sind(theta(i)-90)+Force_C_X(i)*sind(theta(i)-90)-Force_C_Y(i)*sind(180-theta(i));
    Moment_A(i) = Torque1(i)+Lac*Force_C_X(i)*sind(theta(i))+Lac*Force_C_Y(i)*sin(theta(i)-90)+Lad*Reaction_H(i)*sind(theta(i));
end
end


%rho = 7860 for MS and 7920 for SS 2630 to 2800 for Al
%G = 77.2 for MS and 75 for SS and 26 to 28 for Al
%Sigma{Y} = 230 for MS 520 for SS (CR) and 240 upto 400 for Al 45 for nylon
%Sigma_{Y compressive} = 28 for concrete
%Compute the von mises stresses on the body
%FOS = 6

function [Sa,Ss,Sv,Sy1,kgm] = vonmises(Fa,Fs,A,material)
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
    for i=1:length(Fa)
    Sa(i) = 6*abs(Fa(i))/(A*100);
    Ss(i) = 6*abs(Fs(i))/(A*100);
    Sv(i) = (Sa(i)*Sa(i)+Ss(i)*Ss(i)-Sa(i)*Ss(i))/(6*G);
    Sy1(i) = Sy;
    end
    kgm = rho*A*1/10000;
end


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
