%% CMPA
%  Diode Paramater Extraction
%
%  Author: Ragini Bakshi, March 2021
%  Structure and Problem provided by: Professor Smy, 2021

set(0,'DefaultFigureWindowStyle','docked')
set(0, 'defaultaxesfontsize', 12)
set(0, 'defaultaxesfontname', 'Times New Roman')
set(0, 'DefaultLineLineWidth',2);

clear all
close all

%% Given
Is = 0.01e-12; % A; was 0.01pA
Ib = 0.1e-12; % A; was 0.1pA
Vb = 1.3; % Volts
Gp = 0.1;

%% Task 1: Data generation and plots
V = linspace(-1.95,0.7,200);
I = Is * (exp((1.2.*V)/0.25) - 1) + Gp.*V - Ib * (exp((-1.2/0.25).*(V + Vb)) - 1) ;
a = -1;
b = 1;
r = (b-a).*rand(200,1) + a;

I_rand = I + 0.2.*(r'); % 20% random variation in the current

figure(1)
plot (V,I);
title('Linear V vs I (and noise)');
hold on
plot (V, I_rand);
legend('Current', 'Current with noise');
xlabel('Voltage (V)');
ylabel('Current (A)');
hold off;

figure(2)
grid on;
semilogy(V, abs(I));
hold on;
semilogy(V, abs(I_rand));
legend('Current', 'Current with noise');
title('Log V vs I (and noise)');
xlabel('Voltage (V)');
ylabel('Current (A)');
hold off

%% Task 2: Polynomial Fitting
polynomial_4 = polyfit(V, I_rand, 4);
poly_plot_4 = polyval(polynomial_4, V);
polynomial_8 = polyval(V, I_rand, 8);
poly_plot_8 = polyval(polynomial_8, V);

figure(3);
subplot(1,2,1)
plot (V, I_rand);
grid on
hold on
plot(V, poly_plot_4);
hold on
title('Linear V vs I polyfits');
legend('Noise Current','Polynomial 4');
xlabel('Voltage (V)');
ylabel('Current (A)');
subplot(1,2,2)
plot (V, I_rand);
grid on
hold on
plot(V, poly_plot_8);
hold on
title('Linear V vs I polyfits');
legend('Noise Current','Polynomial 8');
xlabel('Voltage (V)');
ylabel('Current (A)');

figure(4);
semilogy(V, abs(I_rand));
hold on
semilogy(V, abs(poly_plot_4));
hold on
semilogy(V, abs(poly_plot_8));
hold on
title('Log V vs I polyfits');
legend('Current with noise','Polynomial 4', 'Polynomial 8');
xlabel('Voltage (V)');
ylabel('Current (A)');
hold off;

%% Task 3: Non-linear curve fitting

fo_BD = fittype('A.*(exp(1.2*x/25e-3)-1)+0.1.*x-C*(exp(1.2*(-(x+1.3))/25e-3)-1)'); %setting B and D
fitted_BD = fit(V.',I.',fo_BD);

fo_D = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)'); %setting D
fitted_D = fit(V.',I.',fo_D);

fo_all = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)'); %fitting all four
fo_all = fit(V.',I.',fo_all);


%% Task 4: Neutral Net fitting
% Requires Deep Learning Toolbox to run properly
% inputs = V.';
% targets = I.';
% hiddenLayerSize = 10;
% net = fitnet(hiddenLayerSize);
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;
% net.divideParam.testRatio = 15/100;
% [net,tr] = train(net,inputs,targets);
% outputs = net(inputs);
% errors = gsubtract(outputs,targets);
% performance = perform(net,targets,outputs)
% view(net)
% Inn = outputs