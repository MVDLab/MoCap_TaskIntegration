% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [rotatedCOP7] = rotateForcePlate7(originalCOP7, plateNum7)
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0]; 
    %FP7
    xPos7 = [ 503.632,  504.095,  4.63596,  5.09201];
    yPos7 = [ 1.73205,  1.52884,  2.57499,  1.85976];
    zPos7 = [-461.798, -9.17788, -457.711, -8.42745];
    
    fpPos7(:,7) = [mean(xPos7); mean(yPos7); mean(zPos7)];
                  
    % Perform the transform
    %FP7
    rotatedCOP7 = rotationMatrix*originalCOP7(:);
    rotatedCOP7 = rotatedCOP7 + fpPos7(:,plateNum7);
    
    rotatedCOP7 = rotatedCOP7';
end 