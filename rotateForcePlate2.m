% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [rotatedCOP2] = rotateForcePlate2(originalCOP2, plateNum2)
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0];
    %FP2
    xPos2 = [ 1315.96,  1316.62,  723.032,  723.867];
    yPos2 = [0.726698, 0.958016,  1.64753,  1.99565];
    zPos2 = [-867.327, -476.441, -866.549, -474.464];
    
    fpPos2(:,2) = [mean(xPos2); mean(yPos2); mean(zPos2)];
    
    % Perform the transform
    %FP2
    rotatedCOP2 = rotationMatrix*originalCOP2(:);
    rotatedCOP2 = rotatedCOP2 + fpPos2(:,plateNum2);
    
    rotatedCOP2 = rotatedCOP2';
end 