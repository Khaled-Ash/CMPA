% PA 8  Diode Paramater Extraction
% Khaled AbouShaban 101042658


% Parameters to be extracted 

% Is: Forward bias saturation current. Ib: Breakdown saturation current. Vb: Breakdown volatage.
% Gp: Parasitic parallel conductance.
% parallel resistor
% breakdown

% 3 methods of fitting curves to diode data:
% 1. Polynomial fitting using polyfit() and polyval().
% 2. Non-linear curve fitting using fit()
% 3. Neural net fitting using the matlab Neural Net toolbox.

set(0, 'DefaultFigureWindowStyle', 'docked');
close all;


Is = 0.0e-12; %A
Ib = 0.1e-12; %A
Vb = 1.3; % V
Gp = 0.1; %  Ω−1


V = (linspace(-1.95, 0.7, 200));
I = Is.*(exp(V.*1.2/0.025)-1)+ Gp.*V - Ib.*(exp(-(V+Vb).*1.2/0.025)-1);
I_2 = I + I .* 0.2.*rand(1,200);


P4 = polyval(polyfit (V,I,4),V);
P8 = polyval(polyfit (V,I,8),V);
I_2_P4 = polyval(polyfit(V,I_2,4), V);
I_2_P8 = polyval(polyfit(V,I_2,8), V);
 

%fit 1 non-linear curve
fo1 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff1 = fit(V', I',fo1);
If1 = ff1(V);
%fit 2
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff2 = fit(V' ,I',fo2);
If2 = ff2(V);
%fit 3
fo3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff3 = fit(V' ,I',fo3);
If3 = ff3(V);


% Plots

subplot(3,2,1);
hold on;
plot(V,I); 
plot(V,P4);
plot(V,P8);
xlabel('V'), 
ylabel('I');
legend('I', 'poly 4', 'poly 8');

subplot(3,2,2);
hold on;
semilogy(V,I_2); 
semilogy(V,I_2_P4);
semilogy(V,I_2_P8);
xlabel('V'), 
ylabel('I');
legend('I', 'poly 4', 'poly 8');
 
subplot(3,2,3); plot(V,I); 
subplot(3,2,3); plot(V,If1);
subplot(3,2,3); plot(V,If2);
subplot(3,2,3); plot(V,If3);
legend ('data','fit 1','fit 2','fit 3');
 
subplot(3,2,4); semilogy(V,abs(I)); 
subplot(3,2,4); semilogy(V,abs(If1));
subplot(3,2,4); semilogy(V,abs(If2));
subplot(3,2,4); semilogy(V,abs(If3));
legend ('data','fit 1','fit 2','fit 3');
 
% Neural-Network Fitting
inputs = V.';
targets = I_2.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net);
Inn = outputs;

subplot(3,2,5)
plot(V,Inn);
title('NN Fit');
hold on;

subplot(3,2,6)
semilogy(V,abs(Inn));
title('Abs NN Fit');
hold on;
