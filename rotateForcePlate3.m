% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [rotatedCOP3] = rotateForcePlate3(originalCOP3, plateNum3)    
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0];    
    %FP3
    xPos3 = [ 712.383,  714.053,  123.821,  124.009];
    yPos3 = [ 1.36522,  1.89194,  1.95467,  1.99109];
    zPos3 = [-867.122, -475.086, -865.453, -474.016];
    
    fpPos3(:,3) = [mean(xPos3); mean(yPos3); mean(zPos3)];   
    % Perform the transform
    %FP2
    rotatedCOP3 = rotationMatrix*originalCOP3(:);
    rotatedCOP3 = rotatedCOP3 + fpPos3(:,plateNum3);
    
    rotatedCOP3 = rotatedCOP3';
end 