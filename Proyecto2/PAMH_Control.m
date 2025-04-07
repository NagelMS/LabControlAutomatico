%% Identificación del sistema

% Cargando workspace
load('pamhws.mat');

% Cargando archivo csv
pamh = readtable('PAMH_steppert.csv');

% Guardando en matrices los atributos de pamh
tiempo = pamh.Tiempo;
angulo = pamh.ANGULO;
entrada = pamh.ESTIMULO;

% Gráfica de experimento completo
 %figure;
 %plot(tiempo,angulo,'LineWidth',1.5,'Color',[0.4 0.4 1],'LineStyle','-');
 %hold on;
 %plot(tiempo,entrada,'LineWidth',2,'Color',[0.8 0 0.4])
 %xlim([0 64])
 %ylim([-0.5 2])
 %title('Medición experimental del sistema PAMH','FontSize',14)
 %xlabel('Tiempo (s)','FontSize',14)
 %ylabel('Angulo (rad)','FontSize',14)
 %grid on;
 %grid minor;
 %hold off;
 %hold off;

% Tiempo de muestreo
deltaT = tiempo(2) - tiempo(1);
% 
%% Abriendo la sesión del identificador de sistemas
% ident('pamhIdent.sid','.');
% 
% Obteniendo los valores del sistema
zeta = P2DU.Zeta;
wn = P2DU.Tw;
kp = P2DU.Kp;

% Generación del sistema
s = tf('s');
model = (kp)/(1+2*zeta*wn*s+(wn*s)^2);
model = zpk(model);

% Respuesta del modelo ante el estimulo
y = lsim(model,entrada,tiempo);

% Gráfica de la respuesta experimental y del modelo
% figure;
% plot(tiempo,y,'LineWidth',1.5,'Color',[0.8 0.2 0.9],'LineStyle','-');
% hold on;
% plot(tiempo,entrada,'LineWidth',2,'Color',[0.8 0 0.4])
% xlim([0 64])
% ylim([-0.7 2])
% title('Respuesta del sistema modelado','FontSize',14)
% xlabel('Tiempo (s)','FontSize',14)
% ylabel('Amplitud','FontSize',14)
% legend('Angulo Modelado (rad)','Entrada')
% grid on;
% grid minor;
% hold off;
% hold off;

%% Espacio de Estados

modelmat = canon(model,'companion');
modelFCC = modelmat;
modelFCC.a = modelmat.a';
modelFCC.b = modelmat.c';
modelFCC.c = modelmat.b';

A = modelmat.a';
B = modelmat.c';
C = modelmat.b';

sysFCC = ss(A,B,C,0);

rank([A B; -C 0])

As = [A [0;0]; -C 0];
Bs = [B;0];

% Polo deseado

P = [-0.85+0.5i -0.85-0.5i -4];

Ks = acker(As,Bs,P);

K = Ks(:,1:2);
KI = -Ks(:,3:3);

Qs = diag([10 10 14.5]);
Rs = 1;

Kq = lqr(As,Bs,Qs,Rs);

K_q = Kq(:,1:2);
KI_q = -Kq(:,3:3);

%PID cancelacion polos
eig(model)
%Se saca C_PID con cancelacion de polos manual en sisotool 
sys_pid = tf(C_PID);
[num_pid, den_pid] = tfdata(sys_pid, 'v');
%Se saca C_PIDIMC con el IMC de sisotool
sys_pidimc = tf(C__PIDIMC);
[num_pidimc, den_pidimc] = tfdata(sys_pidimc, 'v');
%Se saca C_PIDtune con el PID tuning de sisotool
sys_pidt = tf(C_PIDtune);
[num_pidt, den_pidt] = tfdata(sys_pidt, 'v');