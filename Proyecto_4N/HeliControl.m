%% Heli - Control

% Cargando workspace
load('heli.mat');

% Cargando archivo csv
heli_pitch = readtable('ExperimentoPITCH_2.csv');
heli_yaw = readtable('ExperimentoYAW.csv');

% Guardando en matrices los atributos del pitch
tiempo_pitch = heli_pitch.Tiempo;
entrada_pitch = heli_pitch.E_PITCH;
entrada_yaw = heli_pitch.E_YAW;
pitch_pitch = heli_pitch.PITCH;
yaw_pitch = heli_pitch.YAW;

%Gráfica de experimento completo

% figure;
% subplot(3,1,1)
% plot(tiempo_pitch,entrada_pitch,'LineWidth',1.5,'Color',[0.8 0.4 1],'LineStyle','-');
% hold on;
% plot(tiempo_pitch,entrada_yaw,'LineWidth',1.5,'Color',[0.2 0.2 1],'LineStyle','-');
% hold off;
% xlim([-0.4 36])
% ylim([-2 20])
% legend('E-Pitch','E-Yaw')
% title('Entrada generada en los motores','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Tensión (V)','FontSize',14)
% grid on;
% grid minor;
% subplot(3,1,2)
% plot(tiempo_pitch,pitch_pitch,'LineWidth',2,'Color',[0.8 0 0.4])
% xlim([-0.4 36])
% ylim([0 1.1])
% title('Medición experimental del pitch','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Angulo (rad)','FontSize',14)
% grid on;
% grid minor;
% subplot(3,1,3)
% plot(tiempo_pitch,yaw_pitch,'LineWidth',2,'Color',[0.8 0.4 0.4])
% xlim([-0.4 36])
% ylim([-2 20])
% title('Medición experimental del yaw','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Angulo (rad)','FontSize',14)
% grid on;
% grid minor;

delta_T_pitch = tiempo_pitch(2) - tiempo_pitch(1);



% Guardando en matrices los atributos del pitch
tiempo_yaw = heli_yaw.Tiempo;
entrada_ypitch = heli_yaw.E_PITCH;
entrada_yyaw = heli_yaw.E_YAW;
pitch_yaw = heli_yaw.PITCH;
yaw_yaw = heli_yaw.YAW;

%Gráfica de experimento completo

% figure;
% subplot(3,1,1)
% plot(tiempo_yaw,entrada_ypitch,'LineWidth',1.5,'Color',[0.8 0.4 1],'LineStyle','-');
% hold on;
% plot(tiempo_yaw,entrada_yyaw,'LineWidth',1.5,'Color',[0.2 0.2 1],'LineStyle','-');
% hold off;
% xlim([-0.4 57])
% ylim([-2 7])
% legend('E-Pitch','E-Yaw')
% title('Entrada generada en los motores','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Tnesión (V)','FontSize',14)
% grid on;
% grid minor;
% subplot(3,1,2)
% plot(tiempo_yaw,pitch_yaw,'LineWidth',2,'Color',[0.8 0 0.4])
% xlim([-0.4 57])
% ylim([0 0.5])
% title('Medición experimental del pitch','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Angulo (rad)','FontSize',14)
% grid on;
% grid minor;
% subplot(3,1,3)
% plot(tiempo_yaw,yaw_yaw,'LineWidth',2,'Color',[0.8 0.4 0.4])
% xlim([-0.4 57])
% ylim([-150 2])
% title('Medición experimental del yaw','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Angulo (rad)','FontSize',14)
% grid on;
% grid minor;

delta_T_yaw = tiempo_yaw(2) - tiempo_yaw(1);

%% Abriendo la sesión del identificador de sistemas
% ident('heli.sid','.');


pitch2_model = zpk(PiPi)
pitchyaw_model = zpk(YaPi)
yawyaw_model = zpk(YaYaw)


%% Comparando modelo y experimento

% Respuesta del modelo ante el estimulo
pp_y = lsim(pitch2_model,entrada_pitch,tiempo_pitch);

% Gráfica de la respuesta experimental y del modelo
figure;
plot(tiempo_pitch,pp_y,'LineWidth',1.5,'Color',[0 0 0],'LineStyle','-');
hold on;
plot(tiempo_pitch,entrada_pitch,'LineWidth',2,'Color',[0.8 0 0.4])
plot(tiempo_pitch,pitch_pitch,'LineWidth',3,'Color',[0.8 0.2 0.9],'LineStyle','-');
xlim([0 12])
ylim([0 1.1])
title('Respuesta del sistema modelado en posicion','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Posicion','FontSize',14)
legend('Pitch-Pitch Modelado','Entrada','Pitch-Pitch Experimento')
grid on;
grid minor;
hold off;


% Respuesta del modelo ante el estimulo
py_y = lsim(pitchyaw_model,entrada_pitch,tiempo_pitch);

% Gráfica de la respuesta experimental y del modelo
figure;
plot(tiempo_pitch,py_y,'LineWidth',1.5,'Color',[0 0 0],'LineStyle','-');
hold on;
plot(tiempo_pitch,entrada_pitch,'LineWidth',2,'Color',[0.8 0 0.4])
plot(tiempo_pitch,yaw_pitch,'LineWidth',3,'Color',[0.8 0.2 0.9],'LineStyle','-');
xlim([0 12])
ylim([0 20])
title('Respuesta del sistema modelado en posicion','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Posicion','FontSize',14)
legend('EPitch-Yaw Modelado','Entrada','EPitch-Yaw Experimento')
grid on;
grid minor;
hold off;

% Respuesta del modelo ante el estimulo
yy_y = lsim(yawyaw_model,entrada_yyaw,tiempo_yaw);

% Gráfica de la respuesta experimental y del modelo
figure;
plot(tiempo_yaw,yy_y,'LineWidth',1.5,'Color',[0 0 0],'LineStyle','-');
hold on;
plot(tiempo_yaw,entrada_yyaw,'LineWidth',2,'Color',[0.8 0 0.4])
plot(tiempo_yaw,yaw_yaw,'LineWidth',3,'Color',[0.8 0.2 0.9],'LineStyle','-');
xlim([0 12])
ylim([-20 1])
title('Respuesta del sistema modelado en posicion','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Posicion','FontSize',14)
legend('EYaw-Yaw Modelado','Entrada','EYaw-Yaw Experimento')
grid on;
grid minor;
hold off;

%% Guardando workspace
save('heli.mat');

