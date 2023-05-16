% Transforms the COP data from a single force plate to the global lab frame
% from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-16

function [rotatedCOP] = rotateForcePlate(originalCOP, plateNum)
    % What's the transform from force plate axes to global frame?
    rotationMatrix = [0   1   0;
                      0   0   1;
                      -1  0   0];
                  
    % What is the position of the force plate in the lab frame?
    %FP1
    xPos1 = [ 1918.16,  1919.72,  1326.38,  1325.66];
    yPos1 = [0.695424, 0.786733,  1.27345,  1.29034];
    zPos1 = [-867.118, -475.354, -866.477,  -475.14];
    
    fpPos(:,1) = [mean(xPos1); mean(yPos1); mean(zPos1)];
    
    %FP2
    xPos2 = [ 1315.96,  1316.62,  723.032,  723.867];
    yPos2 = [0.726698, 0.958016,  1.64753,  1.99565];
    zPos2 = [-867.327, -476.441, -866.549, -474.464];
    
    fpPos(:,2) = [mean(xPos2); mean(yPos2); mean(zPos2)];
    
    %FP3
    xPos3 = [ 712.383,  714.053,  123.821,  124.009];
    yPos3 = [ 1.36522,  1.89194,  1.95467,  1.99109];
    zPos3 = [-867.122, -475.086, -865.453, -474.016];
    
    fpPos(:,3) = [mean(xPos3); mean(yPos3); mean(zPos3)];   
    
    %FP4
    xPos4 = [ 2038.47,  2037.81,  1538.69,  1539.42];
    yPos4 = [0.820645, 0.646729, 0.655088,  1.13868];
    zPos4 = [-462.638,  -9.2051, -463.469, -9.70235];
    
    fpPos(:,4) = [mean(xPos4); mean(yPos4); mean(zPos4)]; 
    
    %FP5
    xPos5 = [ 1525.49,  1526.37,  1025.97,  1027.63];
    yPos5 = [0.838643, 0.484344,  1.87654, 0.977315];
    zPos5 = [-463.746, -7.35339, -462.522,  -5.5285];
    
    fpPos(:,5) = [mean(xPos5); mean(yPos5); mean(zPos5)]; 
    
    %FP6
    xPos6 = [ 1014.66,  1014.86,  515.593,  517.035];
    yPos6 = [ 1.68741,   1.0025,  1.77259,  1.97398];
    zPos6 = [-462.369, -7.24348, -462.181, -9.21267];
    
    fpPos(:,6) = [mean(xPos6); mean(yPos6); mean(zPos6)]; 
    
    %FP7
    xPos7 = [ 503.632,  504.095,  4.63596,  5.09201];
    yPos7 = [ 1.73205,  1.52884,  2.57499,  1.85976];
    zPos7 = [-461.798, -9.17788, -457.711, -8.42745];
    
    fpPos(:,7) = [mean(xPos7); mean(yPos7); mean(zPos7)];
                  
    % Perform the transform
    rotatedCOP = rotationMatrix*originalCOP(:);
    rotatedCOP = rotatedCOP + fpPos(:,plateNum);
    
    rotatedCOP = rotatedCOP';
    
end