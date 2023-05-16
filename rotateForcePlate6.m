% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [rotatedCOP6] = rotateForcePlate6(originalCOP6, plateNum6)
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0];     
    %FP6
    xPos6 = [ 1014.66,  1014.86,  515.593,  517.035];
    yPos6 = [ 1.68741,   1.0025,  1.77259,  1.97398];
    zPos6 = [-462.369, -7.24348, -462.181, -9.21267];
    
    fpPos6(:,6) = [mean(xPos6); mean(yPos6); mean(zPos6)]; 
    % Perform the transform
    %FP2
    rotatedCOP6 = rotationMatrix*originalCOP6(:);
    rotatedCOP6 = rotatedCOP6 + fpPos6(:,plateNum6);
    
    rotatedCOP6 = rotatedCOP6';
end