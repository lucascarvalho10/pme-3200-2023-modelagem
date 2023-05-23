% Simulação do movimento de um T-handle em rotação e plota várias propriedades físicas relevantes ao longo do tempo.
%
% Lucas Carvalho, Poli-USP

clc

% Carrega as funções simbólicas para as equações de estado na forma de matriz de massa, M(t,Y)*Y'(t) = F(t,Y):
load t_handle_ODEs

% Parâmetros físicos:
lambda1 = 0.2;          % momento de inércia ao redor do eixo x (kg-m^2)
lambda2 = 0.3;          % momento de inércia ao redor do eixo y (kg-m^2)
lambda3 = 0.4;          % momento de inércia ao redor do eixo z (kg-m^2)

% Parâmetros de simulação:
tf = 10;                        % tempo final (s)
dt = 0.005;                     % passo de tempo (s)
tsim = (0 : dt : tf)';          % vetor de tempo (s)
tol = 1e-6;                     % tolerância

omega10 = 0.1;                  % velocidade angular inicial em torno do eixo x (rad/s)
omega20 = 15;                   % velocidade angular inicial em torno do eixo y (rad/s)
omega30 = 0.1;                  % velocidade angular inicial em torno do eixo z (rad/s)
psi0 = 0;                       % ângulo inicial de Euler em torno do eixo z (rad)
theta0 = 90*(pi/180);           % ângulo inicial de Euler em torno do eixo y (rad)
phi0 = 0;                       % ângulo inicial de Euler em torno do eixo x (rad)

Y0 = [omega10, omega20, omega30, psi0, theta0, phi0]'; % vetor de condições iniciais

% Parâmetros de plotagem:
span = [0.8, 1.2]; % fator de escala para os limites do eixo y nos gráficos

% Converte M(t,Y) e F(t,Y) em funções puramente numéricas para integração numérica:
M = @(t, Y) M(t, Y, lambda1, lambda2, lambda3);
F = @(t, Y) F(t, Y, lambda1, lambda2, lambda3);

% Integra numericamente as equações de estado:
options = odeset('mass', M, 'abstol', tol, 'reltol', tol);
[t, Y] = ode45(F, tsim, Y0, options);

% Extrai os resultados:
omega1 = Y(:,1);        % velocidade angular em torno do eixo x (rad/s)
omega2 = Y(:,2);        % velocidade angular em torno do eixo y (rad/s)
omega3 = Y(:,3);        % velocidade angular em torno do eixo z (rad/s)
psi = Y(:,4);           % ângulo de Euler em torno do eixo z (rad)
theta = Y(:,5);         % ângulo de Euler em torno do eixo y (rad)
phi = Y(:,6);           % ângulo de Euler em torno do eixo x (rad)

% Calcula e plota a energia mecânica total da alça em T ao longo do tempo:

E = 1/2*(lambda1*omega1.^2 + lambda2*omega2.^2 + ...        % J
         lambda3*omega3.^2);

figure
set(gcf, 'color', 'w')
plot(t, E, '-b', 'linewidth', 2)
xlabel('Tempo (s)')
ylabel('Energia mecânica total (J)')
ylim([min(min(E)*span), max(max(E)*span)])

% Calcula e plota as componentes do momento angular em relação ao centro de massa e o momento angular total ao longo do tempo:

H1 = lambda1*omega1;                        % kg-m^2/s
H2 = lambda2*omega2;                        % kg-m^2/s
H3 = lambda3*omega3;                        % kg-m^2/s
H = sqrt(H1.^2 + H2.^2 + H3.^2);            % kg-m^2/s

figure
set(gcf, 'color', 'w')
plot(t, H1, t, H2, t, H3, t, H, 'linewidth', 2)
xlabel('Tempo (s)')
ylabel('Momento Angular em Relação ao Centro de Massa (kg-m^2/s)')
legend(' \bf{H}\rm \cdot \bf{e}\rm_{1}', ...
       ' \bf{H}\rm \cdot \bf{e}\rm_{2}', ...
       ' \bf{H}\rm \cdot \bf{e}\rm_{3}', ...
       ' ||\bf{H}\rm||')