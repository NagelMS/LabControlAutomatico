%% Identificación del sistema
close all;

% Cargando workspace
load('GruaWorkspace.mat');

% Cargando archivo csv (ya con el workspace no es necesario)
% g_model = readtable('Grua_I_2025.csv');

% Guardando en matrices los atributos de la grua
tiempo = g_model.Tiempo;
posicion = g_model.POSICION;
angulo = g_model.ANGULO;
entrada = g_model.Entrada;

% Tiempo de muestreo
deltaT = Tiempo(2) - Tiempo(1);

% Abrir el identificador de sistemas
% ident('GruaIdent.sid','.');

%% Obteniendo los valores del modelo posicion
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

%% Gráfica del modelo posicion
%figure;
%plot(Tiempo,y_pos,'LineWidth',1.5);
%hold on;
%plot(Tiempo,Entrada,'LineWidth',1.5);
% %plot(Tiempo,posicion,'LineWidth',1.5);
% %xlim([0 3])
% %ylim([0 0.5])
% title('Respuesta del sistema modelado','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Amplitud','FontSize',14)
% legend('Posición Modelada','Entrada', 'Posición Experimental')
% grid on;
% grid minor;
% hold off;
% hold off;

% % Gráfica del modelo angulo
% %figure;
% %plot(Tiempo,y_ang,'LineWidth',1.5);
% hold on;
% %plot(Tiempo,Entrada,'LineWidth',1.5)
% %plot(Tiempo,angulo,'LineWidth',1.5)
% xlim([0 373])
% %ylim([-0.7 2])
% title('Respuesta del sistema modelado','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Amplitud','FontSize',14)
% legend('Angulo Modelado (rad)','Entrada', 'Angulo Experimental (rad)')
% grid on;
% grid minor;
% hold off;
% hold off;

%% Creacion del modelo SISO del carro
carro_siso = ss([0 1; 0 -9.431] , [0 ; 0.23092], [1 0], 0);
zpk(carro_siso);

% Creacion del modelo SISO del angulo
pendulo_siso = ss([0 1; -35.31 -0.01401], [0 ; 1], [(-0.29689*4.952) -0.29689], 0);
zpk(pendulo_siso);

%Modelo de pendulo en forma canonica observable
penduloFCO = canon(pendulo_siso,'companion');
pendulo_siso.a = penduloFCO.a';
pendulo_siso.b = penduloFCO.c';
pendulo_siso.c = penduloFCO.b';
zpk(pendulo_siso);

% Matriz general del sistema
A = [0 0 1 0; 0 0 0 1; 0 0 -9.431 0; 0 -35.31 0 -0.01401];
B = [0 ; -0.2969 ; 0.23092; -1.4660];
C = [1 0 0 0; 0 1 0 0];
grua_siso = ss(A,B,C,0);

%step(grua_siso,20)

%% Obtencion del controlador REI po ubicacion de polos
C1 = [1 0 0 0];
As = [A [0;0;0;0]; -C1 0];
Bs = [B;0];
ts = 5;
zetaomegan = 4/ts; %+ Mas rapido pero más angulo
%+polos Más rapido pero más angulo, +aux Mas rapido pero más angulo
aux=3;
Ps = [-zetaomegan+0.37i -zetaomegan-0.37i (-aux) (-aux-0.1) (-aux-0.2)];
ZETA = 0.7448;
rad2deg(acos(ZETA));
degree = rad2deg(atan(0.5/0.7));
cos(deg2rad(degree));
Ks = acker(As,Bs,Ps);
K = Ks(1:4);
Ki = -Ks(5);

%% REI LQR 
Mx = [A B; -[1 0 0 0], 0];
AsL = [A [0;0;0;0];-C1 0];
BsL = [B;0];
CsL = [C1 0];
Q = eye(5);
R=1;
KsL = lqr(AsL, BsL, Q, R);
KL = KsL(1:4);
KiL = -KsL(5); 
eig(AsL-BsL*KsL)

%% Diseño de Control Ackerman
A_a = 2.1*A;
As1 = [A_a [0;0;0;0]; -C1 0];
Bs1 = [B; 0];

Ps1 = [-0.7+0.5i -0.7-0.5i -3.5 -3.6 -3.7];

Ks1 = acker(As1,Bs1,Ps1);

K1  = 0.98*Ks1(1:4);
Ki1 = -Ks1(5);


%% Diseño Control LQR

Q = diag([200 50 50 50 200]);
R = 1;

AL = 3*A;
Kq = lqr(3*As,Bs,Q,R);

K_q = Kq(1:4)*0.8;
Ki_q = -Kq(5)*1.2;
C2 = [1 0 0 0; 0 1 0 0];







save('GruaWorkspace.mat');