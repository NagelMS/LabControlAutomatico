%% Identificación del sistema
close all;

% Cargando workspace
load('GruaWorkspace.mat');

% Cargando archivo csv
g_model = readtable('Grua_I_2025.csv');

% Guardando en matrices los atributos de la grua
tiempo = g_model.Tiempo;
posicion = g_model.POSICION;
angulo = g_model.ANGULO;
entrada = g_model.Entrada;

% Tiempo de muestreo
deltaT = Tiempo(2) - Tiempo(1);
% 
%% Abrir el identificador de sistemas
% ident('GruaIdent.sid','.');

% Obteniendo los valores del modelo posicion
K_pos   = Modelo_pos.K;
Tz_pos  = Modelo_pos.Tz;
Tp1_pos = Modelo_pos.Tp1;
% Obteniendo los valores del modelo angulo
K_ang    = Modelo_ang.K;
Tz_ang   = Modelo_ang.Tz;
zeta_ang = Modelo_ang.Zeta;
Tw_ang   = Modelo_ang.Tw;

% Generación del modelo posicion
s = tf('s');
model_p = K_pos*(1+Tz_pos*s)/(s*(1+Tp1_pos*s));
model_p = zpk(model_p);

% Generación del modelo angulo
model_a = K_ang*(1+Tz_ang*s)/(1+2*zeta_ang*Tw_ang*s+(Tw_ang*s)^2);
model_a = zpk(model_a);

% Respuesta del modelo posicion ante el estimulo
y_pos = lsim(model_p, Entrada, Tiempo);

% Respuesta del modelo posicion ante el estimulo
y_ang = lsim(model_a, Entrada, Tiempo);

% Gráfica del modelo posicion
figure;
plot(Tiempo,y_pos,'LineWidth',1.5);
%plot(Tiempo,y_pos,'LineWidth',1.5,'Color',[0.8 0.2 0.9],'LineStyle','-');
hold on;
plot(Tiempo,Entrada,'LineWidth',1.5);
%plot(Tiempo,Entrada,'LineWidth',2,'Color',[0.8 0 0.4])
plot(Tiempo,posicion,'LineWidth',1.5);
%plot(Tiempo,posicion,'LineWidth',1.5,'Color',[0.8 0.2 0.9],'LineStyle','-');
xlim([0 3])
ylim([0 0.5])
title('Respuesta del sistema modelado','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Amplitud','FontSize',14)
legend('Posición Modelada','Entrada', 'Posición Experimental')
grid on;
grid minor;
hold off;
hold off;

% Gráfica del modelo angulo
figure;
plot(Tiempo,y_ang,'LineWidth',1.5);
%plot(Tiempo,y_ang,'LineWidth',1.5,'Color',[0.8 0.2 0.9],'LineStyle','-');
hold on;
plot(Tiempo,Entrada,'LineWidth',1.5)
%plot(Tiempo,Entrada,'LineWidth',2,'Color',[0.8 0 0.4])
plot(Tiempo,angulo,'LineWidth',1.5)
%plot(Tiempo,Entrada,'LineWidth',2,'Color',[0.8 0 0.4])
xlim([0 373])
%ylim([-0.7 2])
title('Respuesta del sistema modelado','FontSize',14)
xlabel('Tiempo (s)','FontSize',14)
ylabel('Amplitud','FontSize',14)
legend('Angulo Modelado (rad)','Entrada', 'Angulo Experimental (rad)')
grid on;
grid minor;
hold off;
hold off;

%Creacion del modelo SISO del carro
carro_siso = ss([0 1; 0 -9.431] , [0 ; 0.23092], [1 0], 0);
zpk(carro_siso);

%Creacion del modelo SISO del angulo
pendulo_siso = ss([0 1; -35.31 -0.01401], [0 ; 1], [(-0.29689*4.952) -0.29689], 0);
zpk(pendulo_siso);

%Modelo de pendulo en forma canonica observable
penduloFCO = canon(pendulo_siso,'companion');
pendulo_siso.a = penduloFCO.a';
pendulo_siso.b = penduloFCO.c';
pendulo_siso.c = penduloFCO.b';
zpk(pendulo_siso);

%% Matriz general del sistema
A = [0 0 1 0; 0 0 0 1; 0 0 -9.431 0; 0 -35.31 0 -0.01401];
B = [0 ; -0.2969 ; 0.23092; -1.4660];
C = [1 0 0 0; 0 1 0 0];
grua_siso = ss(A,B,C,0);

step(grua_siso,4)




save('GruaWorkspace.mat');

