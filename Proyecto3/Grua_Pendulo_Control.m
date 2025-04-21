%% Identificación del sistema

% Cargando workspace
load('grua.mat');

% Cargando archivo csv
grua = readtable('Grua_I_2025.csv');

% Guardando en matrices los atributos de la grua
tiempo = grua.Tiempo;
entrada = grua.Entrada;
angulo = grua.ANGULO;
posicion = grua.POSICION;

%Gráfica de experimento completo
% figure;
% plot(tiempo,angulo,'LineWidth',1.5,'Color',[0.4 0.4 1],'LineStyle','-');
% hold on;
% plot(tiempo,entrada,'LineWidth',2,'Color',[0.8 0 0.4])
% plot(tiempo,posicion,'LineWidth',2,'Color',[0.8 0.4 0.4])
% xlim([0 10])
% ylim([-2 8])
% title('Medición experimental del sistema de la grua','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Magnitud','FontSize',14)
% grid on;
% grid minor;
% hold off;
% hold off;

% Tiempo de muestreo
deltaT = tiempo(2) - tiempo(1);

%% Abriendo la sesión del identificador de sistemas
% ident('grua.sid','.');

pos_model = zpk(Pos);
angle_model = zpk(Angle);


%% Comparando modelo y experimento

% Respuesta del modelo ante el estimulo
pos_y = lsim(pos_model,entrada,tiempo);

% % Gráfica de la respuesta experimental y del modelo
% figure;
% plot(tiempo,pos_y,'LineWidth',1.5,'Color',[0 0 0],'LineStyle','-');
% hold on;
% plot(tiempo,entrada,'LineWidth',2,'Color',[0.8 0 0.4])
% plot(tiempo,posicion,'LineWidth',3,'Color',[0.8 0.2 0.9],'LineStyle','-');
% xlim([0 3])
% ylim([0 0.3])
% title('Respuesta del sistema modelado en posicion','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Posicion','FontSize',14)
% legend('Posición Modelada','Posicion Experimento','Entrada')
% grid on;
% grid minor;
% hold off;
% hold off;
% 
% % Respuesta del modelo ante el estimulo
% angle_y = lsim(angle_model,entrada,tiempo);
% 
% % Gráfica de la respuesta experimental y del modelo
% figure;
% plot(tiempo,angle_y,'LineWidth',1.5,'Color',[0.8 0.2 0.9],'LineStyle','-');
% hold on;
% plot(tiempo,angulo,'LineWidth',1.5,'Color',[0 0 0],'LineStyle','-');
% plot(tiempo,entrada,'LineWidth',2,'Color',[0.8 0 0.4])
% xlim([0 20])
% ylim([-0.7 0.7])
% title('Respuesta del sistema modelado en posicion','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Posicion','FontSize',14)
% legend('Angulo Modelada','Angulo Experimento','Entrada')
% grid on;
% grid minor;
% hold off;
% hold off;


ss_pos = canon(pos_model,'companion');

pos_FCC = ss_pos;
pos_FCC.a = ss_pos.A';
pos_FCC.b = ss_pos.c';
pos_FCC.c = ss_pos.b';

ss_angle = canon(angle_model,'companion');

angle_FCC = ss_angle;
angle_FCC.a = ss_angle.A';
angle_FCC.b = ss_angle.c';
angle_FCC.c = ss_angle.b';

%% Guardando workspace
save('grua.mat');