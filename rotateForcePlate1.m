% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [rotatedCOP1] = rotateForcePlate1(originalCOP1, plateNum1)
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0];
                  
    % What is the position of the force plate in the lab frame?
    %FP1
    xPos1 = [ 1918.16,  1919.72,  1326.38,  1325.66];
    yPos1 = [0.695424, 0.786733,  1.27345,  1.29034];
    zPos1 = [-867.118, -475.354, -866.477,  -475.14];
    
    fpPos1(:,1) = [mean(xPos1); mean(yPos1); mean(zPos1)];
    
    % Perform the transform
    %FP1
    rotatedCOP1 = rotationMatrix*originalCOP1(:);
    rotatedCOP1 = rotatedCOP1 + fpPos1(:,plateNum1);
    
    rotatedCOP1 = rotatedCOP1';
end  