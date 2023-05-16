% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [rotatedCOP4] = rotateForcePlate4(originalCOP4, plateNum4)
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0]; 
    %FP4
    xPos4 = [ 2038.47,  2037.81,  1538.69,  1539.42];
    yPos4 = [0.820645, 0.646729, 0.655088,  1.13868];
    zPos4 = [-462.638,  -9.2051, -463.469, -9.70235];
    
    fpPos4(:,4) = [mean(xPos4); mean(yPos4); mean(zPos4)]; 
    % Perform the transform
    %FP2
    rotatedCOP4 = rotationMatrix*originalCOP4(:);
    rotatedCOP4 = rotatedCOP4 + fpPos4(:,plateNum4);
    
    rotatedCOP4 = rotatedCOP4';
end 