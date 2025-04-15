%% Cargando los valores

system = readtable("EquipoD_REILQR2.csv");

%% Organización de valores

tiempo = system.Tiempo;
control = system.CONTROL;
angle = system.ANGULO;
entrada = system.REFERENCIA;
perturb = system.PERTURBACION;

%% Graficación

colors = colormap(cool(10));

figure(1);
plot(tiempo,entrada,'LineWidth',2,'Color',colors(3,:));
hold on;
plot(tiempo,angle,'LineWidth',2.5,'Color',colors(5,:));
plot(tiempo,control,'LineWidth',2.5,'Color',colors(7,:));
plot(tiempo,perturb,'LineWidth',2.5,'Color',colors(9,:));
xlim([-0.4 36]);
ylim([-0.1 2]);
xlabel("Tiempo (s)","FontSize",12);
ylabel("Amplitud","FontSize",12);
title("Respuesta del PAMH con controlador")
legend("Entrada","Angulo","Control","Perturbación")
grid on;
grid minor;
hold off;