%% Identificación del sistema
close all;

% Cargando archivo csv (ya con el workspace no es necesario)
% pitch_model = readtable('ExperimentoPITCH_1.csv');
% yaw_model   = readtable('ExperimentoYAW.csv');

% Cargando workspace
load('HeliWorkspace.mat');

% Tiempo de muestreo
deltaTp = Tiempo_pitch(2) - Tiempo_pitch(1);
deltaTy = deltaTp;

% Generación de zpk
s = tf('s');
pitch_model_p = zpk(Pitch_modelp);
yaw_model_y = zpk(Yaw_modely);
yawpitch_model_py = zpk(Yaw_Pitch_modelyp);

% Respuestas de modelos
r_pitch_model_p = lsim(pitch_model_p, E_PITCH_pitch, Tiempo_pitch);
r_yaw_model_y = lsim(yaw_model_y, E_YAW_yaw, Tiempo_yaw);
r_yawpitch_model_py = lsim(yawpitch_model_py, E_PITCH_yaw, Tiempo_yaw);

%Gráficas del modelo 1
figure;
plot(Tiempo_pitch,r_pitch_model_p,'LineWidth',1.5);
hold on;
plot(Tiempo_pitch,E_PITCH_pitch,'LineWidth',1.5)
plot(Tiempo_pitch,PITCH_pitch,'LineWidth',1.5)
%xlim([0 373])
%ylim([-0.7 2])
title('Respuesta del sistema modelado','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Amplitud','FontSize',14)
legend('Algo modelado','Entrada', 'Algo Experimental')
grid on;
grid minor;
hold off;

%Gráficas del modelo 1
figure;
plot(Tiempo_yaw,r_yaw_model_y,'LineWidth',1.5);
hold on;
plot(Tiempo_yaw,E_YAW_yaw,'LineWidth',1.5)
plot(Tiempo_yaw,YAW_yaw,'LineWidth',1.5)
%xlim([0 373])
%ylim([-0.7 2])
title('Respuesta del sistema modelado','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Amplitud','FontSize',14)
legend('Algo modelado','Entrada', 'Algo Experimental')
grid on;
grid minor;
hold off;

%Gráficas del modelo 1
figure;
plot(Tiempo_pitch,r_pitch_model_p,'LineWidth',1.5);
hold on;
plot(Tiempo_pitch,E_PITCH_pitch,'LineWidth',1.5)
plot(Tiempo_pitch,PITCH_pitch,'LineWidth',1.5)
%xlim([0 373])
%ylim([-0.7 2])
title('Respuesta del sistema modelado','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Amplitud','FontSize',14)
legend('Algo modelado','Entrada', 'Algo Experimental')
grid on;
grid minor;
hold off;




save('HeliWorkspace.mat');