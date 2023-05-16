% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [rotatedCOP5] = rotateForcePlate5(originalCOP5, plateNum5)
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0]; 
    %FP5
    xPos5 = [ 1525.49,  1526.37,  1025.97,  1027.63];
    yPos5 = [0.838643, 0.484344,  1.87654, 0.977315];
    zPos5 = [-463.746, -7.35339, -462.522,  -5.5285];
    
    fpPos5(:,5) = [mean(xPos5); mean(yPos5); mean(zPos5)]; 
    % Perform the transform
    %FP2
    rotatedCOP5 = rotationMatrix*originalCOP5(:);
    rotatedCOP5 = rotatedCOP5 + fpPos5(:,plateNum5);
    
    rotatedCOP5 = rotatedCOP5';
end