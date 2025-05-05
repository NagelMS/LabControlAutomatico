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

% 
% % Respuesta del modelo ante el estimulo
angle_y = lsim(angle_model,entrada,tiempo);
% 
% % Gráfica de la respuesta experimental y del modelo
% figure;
% plot(tiempo,angle_y,'LineWidth',1.5,'Color',[0.8 0.2 0.9],'LineStyle','-');
% hold on;
% plot(tiempo,angulo,'LineWidth',1.5,'Color',[0 0 0],'LineStyle','-');
% plot(tiempo,entrada,'LineWidth',2,'Color',[0.8 0 0.4])
% xlim([0 20])
% ylim([-0.7 10])
% title('Respuesta del sistema modelado en posicion','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Posicion','FontSize',14)
% legend('Angulo Modelada','Angulo Experimento','Entrada')
% grid on;
% grid minor;
% hold off;


%% Espacio de estados

ss_pos = canon(pos_model,'companion');

pos_FCC = ss_pos;
pos_FCC.A = ss_pos.A';
pos_FCC.B = ss_pos.C';
pos_FCC.C = ss_pos.B';

ss_angle = canon(angle_model,'companion');



angle_FCC = ss_angle;
angle_FCC.A = ss_angle.A';
angle_FCC.B = ss_angle.C';
angle_FCC.C = ss_angle.B';

carrito_ss = ss([0 1; 0 -1/Pos.Tp1],[0;Pos.Kp/Pos.Tp1], [1 0],0);
pendulo_ss = ss([0 1; -1/(Angle.Tw)^2 -(2*Angle.Zeta)/Angle.Tw],[0;1], [(Angle.Kp/(Angle.Tw)^2) Angle.Kp*Angle.Tz/Angle.Tw^2],0);

penduloFCO = canon(pendulo_ss,'companion');

pendulo_ss.A = penduloFCO.A';
pendulo_ss.B = penduloFCO.C';
pendulo_ss.C = penduloFCO.B';

%A = [0 0 1 0; 0 0 0 1; 0 0 pos_FCC.A(2,2) 0; 0 angle_FCC.A(2,1) 0 angle_FCC.A(2,2)];
%B = [0; angle_FCC.B(1); pos_FCC.B(2); angle_FCC.B(2)];
%C = [1 0 0 0; 0 1 0 0];

A1 = [0 0 1 0; 0 0 0 1; 0 0 carrito_ss.A(2,2) 0; 0 pendulo_ss.A(2,1) 0 pendulo_ss.A(2,2)];
B1 = [0; pendulo_ss.B(1); carrito_ss.B(2); pendulo_ss.B(2)];
C1 = [1 0 0 0; 0 1 0 0];

%model_ss = ss(A,B,C,0);

grua_ss = ss(A1,B1,C1,0);

y_ss = lsim(grua_ss,entrada,tiempo);

% Gráfica de la respuesta experimental y del modelo
% figure;
% subplot(2,1,1)
% plot(tiempo,pos_y,'LineWidth',2,'Color',[0.8 0 0.4],'LineStyle','-');
% hold on;
% xlim([0 3])
% ylim([-0.05 0.3])
% title('Respuesta del angulo modelado en función de transferencia','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Posicion','FontSize',14)
% grid on;
% grid minor;
% subplot(2,1,2)
% plot(tiempo,y_ss(:,1),'LineWidth',2,'Color',[0.8 0.2 0.9],'LineStyle','-');
% xlim([0 3])
% ylim([-0.05 0.3])
% title('Respuesta del angulo modelado en espacio de estados','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Posicion','FontSize',14)
% grid on;
% grid minor;
% hold off;



% Gráfica de la respuesta experimental y del modelo
% figure;
% subplot(2,1,1)
% plot(tiempo,angle_y,'LineWidth',2,'Color',[0.8 0 0.4],'LineStyle','-');
% hold on;
% xlim([0 20])
% ylim([-0.7 0.7])
% title('Respuesta del angulo modelado en función de transferencia','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Angulo','FontSize',14)
% grid on;
% grid minor;
% subplot(2,1,2)
% plot(tiempo,y_ss(:,2),'LineWidth',2,'Color',[0.8 0.2 0.9],'LineStyle','-');
% xlim([0 20])
% ylim([-0.7 0.7])
% title('Respuesta del angulo modelado en espacio de estados','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Angulo','FontSize',14)
% grid on;
% grid minor;
% hold off;

C = [1 0 0 0];

model_ss = ss(A,B,C,0);

%% Diseño de Control Ackerman

As = [A1 [0;0;0;0]; -C 0];
Bs = [B1; 0];

ts = 6;
zetaomegan = 4/ts;
Ps = [-0.7+0.5i -0.7-0.5i -3.5 -3.6 -3.7];

Ks = acker(As,Bs,Ps);

K = Ks(1:4);
Ki = -Ks(5);

%% Diseño Control LQR
Q = diag([400 1 200 1 400]);
%Q = diag([600 5 600 5 600])
R = 1;


Kq = lqr(As,Bs,Q,R);

K_q = Kq(1:4);
Ki_q = -Kq(5);

%% Guardando workspace
save('grua.mat');