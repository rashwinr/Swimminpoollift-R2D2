clc
clear all
close all
%% Reaction force calculations
Link_length = 0.880;
mg = 250;
Mg = mg+1200;
Seat_offset = 0.30093;
Spring_mount_distance = 0.665;
Spring_orig_distance = 0.60978;
Spring_force = 1500;
Link_distance = 0.15207;
theta = 90+[-15:1:50];
subtend_angle = atand(110/105);
% Moment conservation about G
% Sum(M) => Link_distance x R (downward)*sine(theta-46.33) + Seat_offset x Mg
for i=1:length(theta)
    Reaction_H(i) = Seat_offset*Mg/(Link_distance*sind(theta(i)-subtend_angle));
    %Fx for top four bar connector = 0
    Force_G_X(i) = Mg*cosd(180-theta(i))-Reaction_H(i);
    %Fy for top four bar connector = 0
    Force_G_Y(i) = Mg*sind(180-theta(i));
end


figure(1)
plot(theta,Reaction_H,'*-','LineWidth',1)
hold on
plot(theta,Force_G_X,'*-','LineWidth',1)
plot(theta,Force_G_Y,'*-','LineWidth',1)
xlabel('\theta [deg]','FontSize',15);
ylabel('Force [Newton]','FontSize',15)
legend('{R_3}','F_{GX}','F_{GY}','FontSize',12,'Orientation','Horizontal','Location','northeast','NumColumns',2)
hold off
%Gas spring distances and computing instantaneous length of gas spring
Extra_angle = atand(203/575);
Instantaneous_Length_of_gas_spring = sqrt(Spring_mount_distance^2 + Spring_orig_distance^2-2*Spring_orig_distance*Spring_mount_distance*cosd(theta-Extra_angle));

figure(2)
plot(theta,Instantaneous_Length_of_gas_spring,'*-','LineWidth',1.5)
hold on
xlabel('\theta [deg]','FontSize',15);
ylabel('\Gas spring length [deg]','FontSize',15)
hold off

for i=1:length(theta)
    Phi_angle(i) = asind(Spring_orig_distance*sind(theta(i)-Extra_angle)/Instantaneous_Length_of_gas_spring(i));
end

figure(3)
plot(theta,Phi_angle,'*-','LineWidth',1.5)
hold on
xlabel('\theta [deg]','FontSize',15);
ylabel('\phi [deg]','FontSize',15)
hold off

%Internal reaction forces on the non-truss link
% Sum of force along link = 0
for i = 1:length(theta)
    Force_C_X(i) = Force_G_X(i) - Spring_force*cosd(Phi_angle(i));
    Force_C_Y(i) = Spring_force*sind(Phi_angle(i))-Force_G_Y(i);
end

figure(4)
plot(theta,Force_C_X,'*-','LineWidth',1)
hold on
plot(theta,Force_C_Y,'*-','LineWidth',1)
xlabel('\theta [deg]','FontSize',15);
ylabel('Force [Newton]','FontSize',15)
legend('F_{CX}','F_{CY}','FontSize',12,'Orientation','Horizontal','Location','southeast','NumColumns',2)
hold off

%Torque calculations
% T = mg*(L+so)-Fs*A
for i=1:length(theta)
    Torque(i) = (Mg*(Link_length*cosd(theta(i)-90)+Seat_offset)-Spring_force*Spring_mount_distance*sind(Phi_angle(i)));
    Torque1(i) = Force_G_Y(i)*Link_length-Spring_force*Spring_mount_distance*sind(Phi_angle(i));
end


%Reaction forces on A:
Lac = 0.5905;
Lad = 0.493;
for i=1:length(theta)
    Force_A_X(i) = Reaction_H(i)*cosd(theta(i)-90)+Force_C_X(i)*cosd(90-theta(i))-Force_C_Y(i)*cosd(180-theta(i));
    Force_A_Y(i) = 5000+Reaction_H(i)*sind(theta(i)-90)+Force_C_X(i)*sind(theta(i)-90)-Force_C_Y(i)*sind(180-theta(i));
    Moment_A(i) = Torque1(i)+Lac*Force_C_X(i)*sind(theta(i))+Lac*Force_C_Y(i)*sind(theta(i)-90)+Lad*Reaction_H(i)*sind(theta(i));
end




figure(5)
plot(theta,Torque,'*-','LineWidth',1)
hold on
plot(theta,Torque1,'*-','LineWidth',1)
plot(theta,Moment_A,'*-','LineWidth',1)
xlabel('\theta [deg]','FontSize',15);
ylabel('Torque [N-m]','FontSize',15)
legend('T_{theory}','T_{practical}','M_{A}','FontSize',12,'Orientation','Horizontal','Location','southeast','NumColumns',2)
hold off

figure(6)
plot(theta,Force_A_X,'*-','LineWidth',1)
hold on
plot(theta,Force_A_Y,'*-','LineWidth',1)
xlabel('\theta [deg]','FontSize',15);
ylabel('Force [N]','FontSize',15)
legend('F_{AX}','F_{AY}','FontSize',12,'Orientation','Horizontal','Location','southeast','NumColumns',2)
hold off

[stress_Cpin,pind] = pinfind(Force_C_X,Force_C_Y,3,2);             %0.9 Lx20x3
[stress_Cpin2,pind] = pinfind(Force_C_X,Force_C_Y,4,2);            %1.1 Lx20x4
[stress_Cpin1,pind] = pinfind(Force_C_X,Force_C_Y,2.0,4);          %1.8 Bx32x2.0
[stress_Cpin3,pind] = pinfind(Force_C_X,Force_C_Y,2.6,4);          %2.26 Bx32x2.6
[stress_Cpin4,pind] = pinfind(Force_C_X,Force_C_Y,3.2,4);          %2.69 Bx32x3.2
[stress_Apin,pind] = pinfind(Force_A_X,Force_A_Y,3,4);             %3mm plt
[stress_Apin2,pind] = pinfind(Force_A_X,Force_A_Y,5,4);            %5mm plt
[stress_DHpin,pind] = pinfind(Reaction_H,zeros(size(Reaction_H)),3,2);    %0.9 Lx20x3
[stress_DHpin1,pind] = pinfind(Reaction_H,zeros(size(Reaction_H)),4,2);   %1.1 Lx20x4
[stress_DHpin2,pind] = pinfind(Reaction_H,zeros(size(Reaction_H)),5,2);   %1.8 Lx25x5 
[stress_DHpin3,pind] = pinfind(Reaction_H,zeros(size(Reaction_H)),2.6,4); %2.26 Bx32x2.6

Sy = ones(size(pind))*230/6;

figure(7)
plot(pind,Sy,'LineWidth',1)
hold on
plot(pind,stress_Cpin,'LineWidth',1)
plot(pind,stress_Cpin2,'LineWidth',1)
plot(pind,stress_Cpin1,'LineWidth',1)
plot(pind,stress_Cpin3,'LineWidth',1)
plot(pind,stress_Cpin4,'LineWidth',1)
xlabel('Pin Diameter [mm]','FontSize',15);
ylabel('Stress [N/mm^{2} or MPa]','FontSize',15)
legend('\sigma_{Y}/6','\sigma_{pinG_{Lx20x3}}','\sigma_{pinG_{Lx20x4}}','\sigma_{pinG_{Bx32x2}}','\sigma_{pinG_{Bx32x2.6}}','\sigma_{pinG_{Bx32x3.2}}','FontSize',15,'Orientation','Horizontal','Location','northeast','NumColumns',3)

figure(8)
plot(pind,Sy,'LineWidth',1)
hold on
plot(pind,stress_Apin,'LineWidth',1)
plot(pind,stress_Apin2,'LineWidth',1)
xlabel('Pin Diameter [mm]','FontSize',15);
ylabel('Stress [N/mm^{2} or MPa]','FontSize',15)
legend('\sigma_{Y}/6','\sigma_{pinA_{3mm-plt}}','\sigma_{pinA_{5mm-plt}}','FontSize',15,'Orientation','Horizontal','Location','northeast','NumColumns',3)

figure(9)
plot(pind,Sy,'LineWidth',1)
hold on
plot(pind,stress_DHpin,'LineWidth',1)
plot(pind,stress_DHpin1,'LineWidth',1)
plot(pind,stress_DHpin2,'LineWidth',1)
plot(pind,stress_DHpin3,'LineWidth',1)
xlabel('Pin Diameter [mm]','FontSize',15);
ylabel('Stress [N/mm^{2} or MPa]','FontSize',15)
legend('\sigma_{Y}/6','\sigma_{pinDH_{Lx20x3}}','\sigma_{pinDH_{Lx20x4}}','\sigma_{pinDH_{Lx25x5}}','\sigma_{pinDH_{Bx32x2.6}}','FontSize',15,'Orientation','Horizontal','Location','northeast','NumColumns',3)

A_DH = [1.12,1.45,2.16,2.25,2.88];    % L20x3, L20x4, L25x5               
A_CG = [1.12,1.45,2.30,2.88,3.42];
A_AC = [12.2,8.65,9.55,10.1,8.64];    % MCP100, L 90 x 60 x 6, L 100 x 65 x 6, L 100 x 75 x 6, Box 96 x 48 x 3.20, 
for i=1:length(A_DH)
[stress_DH(i,:),Uy,mass_DH(i)] = vonmises(Reaction_H,zeros(size(Reaction_H)),A_DH(i),'MS');   %0.9 Lx20x3
end

for i=1:length(A_CG)
[stress_CG(i,:),Uy,mass_CG(i)] = vonmises(Force_C_X,Force_C_Y,A_CG(i),'MS');
end

for i=1:length(A_AC)
[stress_AC(i,:),Uy,mass_AC(i)] = vonmises(Force_A_X,Force_A_Y,A_AC(i),'MS');
end

mass_DH = mass_DH*0.950;
mass_CG = mass_CG*0.950;
mass_AC = mass_AC*0.60;

figure(10)
plot(mass_DH,62.5*ones(size(A_DH)),'LineWidth',1)
hold on
plot(mass_DH,36.25*ones(size(A_DH)),'LineWidth',1)
plot(mass_DH,stress_DH,'LineWidth',1)
xlabel('Mass [Kg]','FontSize',15);
ylabel('Stress [MPa]','FontSize',15)
legend('\sigma_{Axial_{MS}}/4','\sigma_{shear_{MS}}/4','\sigma_{Axial_{DH}}','\sigma_{Shear_{DH}}','FontSize',15,'Orientation','Horizontal','Location','northeast','NumColumns',3)


figure(11)
plot(mass_CG,62.5*ones(size(A_CG)),'LineWidth',1)
hold on
plot(mass_CG,36.25*ones(size(A_CG)),'LineWidth',1)
plot(mass_CG,stress_CG,'LineWidth',1)
xlabel('Mass [Kg]','FontSize',15);
ylabel('Stress [MPa]','FontSize',15)
legend('\sigma_{Axial_{MS}}/4','\sigma_{shear_{MS}}/4','\sigma_{Axial_{CG}}','\sigma_{Shear_{CG}}','FontSize',15,'Orientation','Horizontal','Location','northeast','NumColumns',3)

figure(12)
plot(mass_AC,Uy*ones(size(A_AC)),'LineWidth',1)
hold on
plot(mass_AC,36.25*ones(size(A_AC)),'LineWidth',1)
plot(mass_AC,stress_AC,'LineWidth',1)
xlabel('Mass [Kg]','FontSize',15);
ylabel('Stress [MPa]','FontSize',15)
legend('\sigma_{Axial_{MS}}/4','\sigma_{shear_{MS}}/4','\sigma_{Axial_{AC}}','\sigma_{Shear_{AC}}','FontSize',15,'Orientation','Horizontal','Location','northeast','NumColumns',3)


function [stress,pindia] = pinfind(Fx,Fy,Thickness,no_of_contact)

pindia = [5:1:25];
for i=1:length(Fx)
    Resultant(i) = sqrt(Fx(i)*Fx(i)+Fy(i)*Fy(i));
end

F = max(Resultant);
for i=1:length(pindia)
stress(i) = F/(no_of_contact*Thickness*pindia(i));
end

end


function [Sv,Sy1,kgm] = vonmises(Fa,Fs,A,material)
    switch material
        case 'Al'
            rho = 2630;
            G = 26;
            Sy = (230*230+130*130-230*130)/(6*G);
        case 'MS'
            rho = 7860;
            G = 77.2;
            Sy = (250*250+145*145-250*145)/(6*G);
        case 'SS'
            rho = 7920;
            G = 75;
            Sy = (260*260+150*150-260*150)/(6*G);
    end
    
    Sa = max(abs(Fa))/(A*100);
    Ss = max(abs(Fs))/(A*100);
%   Sv = (Sa*Sa+Ss*Ss-Sa*Ss)/(6*G);
    Sv = [Sa;Ss];
    Sy1 = Sy;
    kgm = rho*A*1/10000;
end


