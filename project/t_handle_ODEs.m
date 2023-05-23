% Equações de estado para modelagem e simulação do problema
%
% Lucas Carvalho, Poli-USP
clc


% Especificação dos parâmetros simbólicos e variáveis simbólicas que são funções do tempo:

syms omega1(t) omega2(t) omega3(t) psi(t) theta(t) phi(t)
syms lambda1 lambda2 lambda3
assume((lambda1 > 0) & (lambda2 > 0) & (lambda3 > 0))

% (1) Balanço do momento angular em relação ao centro de massa da alça T:

% Avaliação da derivada temporal absoluta do momento angular em relação ao
% centro de massa:

H = diag([lambda1, lambda2, lambda3])*[omega1; omega2; omega3];
omegaRF = [omega1; omega2; omega3];

DH = diff(H) + cross(omegaRF, H);

% Soma dos momentos em relação ao centro de massa:

sumM = [0, 0, 0]';

% Construção das equações diferenciais ordinárias (ODEs) para o movimento rotacional da alça T:

ODEs1 = DH == sumM;

% (2) Cinemática da velocidade angular:

% Relação da base fixa no espaço {E1,E2,E3} com a base principal corotacional {e1,e2,e3} usando o conjunto de ângulos de Euler 3-1-3:

R1 = [cos(psi), sin(psi), 0;
-sin(psi), cos(psi), 0;
0, 0, 1];

R2 = [1, 0, 0;
0, cos(theta), sin(theta);
0, -sin(theta), cos(theta)];

R3 = [cos(phi), sin(phi), 0;
-sin(phi), cos(phi), 0;
0, 0, 1];

% Expressão do vetor de velocidade angular em termos de {e1,e2,e3}:

omega = (R3*R2*R1)*[0; 0; diff(psi)] + (R3*R2)*[diff(theta); 0; 0] + ...
R3*[0; 0; diff(phi)];

% Construção das equações diferenciais ordinárias (ODEs) para a orientação da alça T:

ODEs2 = [omega1; omega2; omega3] == omega;

% (3) Manipulação do sistema de equações diferenciais ordinárias (ODEs) para uma forma adequada à integração numérica:

% As equações diferenciais ordinárias (ODEs) já estão em forma de primeira ordem, então basta compilar as equações de estado e organizar as variáveis de estado:

StateEqns = simplify([ODEs1; ODEs2]);

StateVars = [omega1; omega2; omega3; psi; theta; phi];

% Expressão das equações de estado na forma da matriz de massa, M(t,Y)*Y'(t) = F(t,Y):

[Msym, Fsym] = massMatrixForm(StateEqns, StateVars);

Msym = simplify(Msym);
Fsym = simplify(Fsym);

% Conversão de M(t,Y) e F(t,Y) em funções simbólicas com os parâmetros de entrada especificados:

M = odeFunction(Msym, StateVars, lambda1, lambda2, lambda3);  
F = odeFunction(Fsym, StateVars, lambda1, lambda2, lambda3); 

%  Save M(t,Y) and F(t,Y):

save t_handle_ODEs.mat Msym Fsym StateVars M F