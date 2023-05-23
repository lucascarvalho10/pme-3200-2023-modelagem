% Animação e Gráficos do Problema
%
% Lucas Carvalho, Poli-USP

% Função que cria uma animação da variação da orientação de uma peça em forma de "T" (T-handle) ao longo do tempo. 
% As dimensões da peça são especificadas no início da função.

function animate_t_handle(psi, theta, phi, dt)

% Especifica as dimensões da peça T-handle:
LAG = 0.5; % cm
LBC = 4; % cm
LAD = 2; % cm

% A orientação do T-handle varia ao longo do tempo de acordo com a evolução da base corotacional principal {e1, e2, e3}. 
% Resolve-se como {e1, e2, e3} variam no tempo. 
% Também se mantém o controle dos pontos da peça T-handle que são necessários para animar seu movimento.

for k = 1:length(psi)
    R1 = [cos(psi(k)), sin(psi(k)), 0;              %  3-1-3 set of 
          -sin(psi(k)), cos(psi(k)), 0;             %  Euler angles
          0, 0, 1];
    R2 = [1, 0, 0;                                  
          0, cos(theta(k)), sin(theta(k));
          0, -sin(theta(k)), cos(theta(k))];   
    R3 = [cos(phi(k)), sin(phi(k)), 0;
          -sin(phi(k)), cos(phi(k)), 0;
          0, 0, 1];
    e1(:,k) = ([1, 0, 0]*(R3*R2*R1))';              %  e1
    e2(:,k) = ([0, 1, 0]*(R3*R2*R1))';              %  e2
    e3(:,k) = ([0, 0, 1]*(R3*R2*R1))';              %  e3
    xA(k,1) = -LAG*e2(1,k);                         %  cm
    yA(k,1) = -LAG*e2(2,k);                         %  cm                        
    zA(k,1) = -LAG*e2(3,k);                         %  cm 
    xB(k,1) = xA(k) + LBC/2*e1(1,k);                %  cm
    yB(k,1) = yA(k) + LBC/2*e1(2,k);                %  cm                                
    zB(k,1) = zA(k) + LBC/2*e1(3,k);                %  cm
    xC(k,1) = xA(k) - LBC/2*e1(1,k);                %  cm
    yC(k,1) = yA(k) - LBC/2*e1(2,k);                %  cm                                
    zC(k,1) = zA(k) - LBC/2*e1(3,k);                %  cm 
    xD(k,1) = xA(k) + LAD*e2(1,k);                  %  cm 
    yD(k,1) = yA(k) + LAD*e2(2,k);                  %  cm                                 
    zD(k,1) = zA(k) + LAD*e2(3,k);                  %  cm 
end

%  Set up the figure window:

figure
set(gcf, 'color', 'w')
plot3(0, 0, 0);
xlabel('\itX\rm (cm)')
set(gca, 'xdir', 'reverse')
ylabel('\itY\rm (cm)')
set(gca, 'ydir', 'reverse')
zlabel('\itZ\rm (cm)            ', 'rotation', 0)
axis equal
xlim(LBC*[-1, 1]);
ylim(LBC*[-1, 1]);
zlim(LAD*[-1, 1]);
grid on

%  Draw the T-handle:

AD = line('xdata', [xA(1), xD(1)], 'ydata', [yA(1), yD(1)], 'zdata', [zA(1), zD(1)], 'color', 'k', 'linewidth', 5);
BC = line('xdata', [xB(1), xC(1)], 'ydata', [yB(1), yC(1)], 'zdata', [zB(1), zC(1)], 'color', 'k', 'linewidth', 5);

%  Animate the T-handle's motion by updating the figure with its current 
%  orientation:

pause

animation = VideoWriter('t-handle.avi');
animation.FrameRate = 1/dt;       
open(animation);

for k = 1:length(psi)
    set(AD, 'xdata', [xA(k), xD(k)], 'ydata', [yA(k), yD(k)], 'zdata', [zA(k), zD(k)]);
    set(BC, 'xdata', [xB(k), xC(k)], 'ydata', [yB(k), yC(k)], 'zdata', [zB(k), zC(k)]);
    drawnow
    writeVideo(animation, getframe(gcf));
end

close(animation);