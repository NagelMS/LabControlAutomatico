close all;
%%%%%%%%%%%%%%%%%%%% MODELO DE VELOCIDAD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaT = Tiempo(2)-Tiempo(1);
%systemIdentification;

s=tf('s');
modelov = 14.87/(s+10.4)

%TimeDomainData (ENTRADA - VELOCIDAD - MotorCD_V - 0 - deltaT)
% TimePlot:
% Estimate: Process Models
% Model Output
% Workspace
%modelov = zpk(P1)
y= lsim(modelov, ENTRADA,Tiempo);

figure;
Figura1 = plot(Tiempo, ENTRADA, Tiempo, VELOCIDAD, Tiempo, y);
xlabel("Tiempo (s)");
ylabel("Amplitud");
legend("Entrada","Velocidad","Velocidad modelo");
set(Figura1,{'LineWidth'},{2;2;2})
%%%%%%%%%%%%%%%%%%%%% MODELO DE CORRIENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TimeDomainData (ENTRADA - CORRIENTE - MotorCD_V - 0 - deltaT)
% TimePlot:
% Estimate: Process Models
% Model Output
% Workspace
modeloc = zpk(P2)
x= lsim(modeloc, ENTRADA,Tiempo);

figure;
Figura2 = plot(Tiempo, ENTRADA, Tiempo, CORRIENTE, Tiempo, x);
xlabel("Tiempo (s)");
ylabel("Amplitud");
legend("Entrada","Corriente","Corriente modelo")
set(Figura2,{'LineWidth'},{2;2;2})
%%%%%%%%%%%%%%%%%%%%%%%%% MODELO CON PI %%%%%%%%%%%%%%%%%%%%%%%%%

%sisotool('rlocus', modelov);
Compensador = modelov * C;
C
[num den] = tfdata(C, 'v');
[r,p,k] = residue(num,den)