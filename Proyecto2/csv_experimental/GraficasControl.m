%%
%Elegir archivo


%% Definir colores pastel
pastel_colors = [
    0.486, 0.533, 0.933;  % pastel cyan
    0.560, 0.386, 0.691;  % pastel lavender
    0.957, 0.543, 0.376;  % pastel orange
    0.678, 0.847, 0.902;  % pastel blue
    0.496, 0.784, 0.596;  % pastel green
    0.980, 0.502, 0.447;  % pastel red
];

%% Graficación

figure(1);
plot(Tiempo, CARRITO, 'LineWidth', 3, 'Color', pastel_colors(1,:));
hold on;
plot(Tiempo, REI, 'LineWidth', 2.5, 'Color', pastel_colors(2,:));
plot(Tiempo, ANGULO, 'LineWidth', 3, 'Color', pastel_colors(5,:));
plot(Tiempo, REFERENCIA, 'LineWidth', 3, 'Color', pastel_colors(6,:));
%plot(Tiempo, V_CARRITO, 'LineWidth', 2.5, 'Color', pastel_colors(5,:));
%plot(Tiempo, V_ANGULAR, 'LineWidth', 2.5, 'Color', pastel_colors(6,:));
xlim([-0.1 13.9]);
xlabel("Tiempo (s)", "FontSize", 12);
ylabel("Amplitud", "FontSize", 12);
title("Respuesta de la grúa con controlador Ackerman")
legend("Salida", "Acción de control", "Ángulo", "Referencia", ...
       "Velocidad Carrito", "Velocidad Angular", ...
       'FontSize', 20, 'Location', 'best');
grid on;
grid minor;
hold off;
