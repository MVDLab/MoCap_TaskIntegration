%Data Integration; 1600 MoCap Task Development Code
%Motor & Visual Development Lab// PI Haylie Miller
%Emily K Klinkman
%Version 20221207
%FUNCTION .m file
%% okay I think if we use '127.0.0.1' for a local IP and don't worry about 
% specific IP we should be okay, as long as MATLAB is running on the same device as QTM. 
%But if we aren't, we can use TCP??? The base port number is 22222, FYI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   QCM Function
%
%   Getting frame info, 3D, 6DOF and forcesingle, one sample at a time.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [frameinfo, forcesingle] = QCM_MVD(ip)        % n is the amount of frames the demo should retrieve before disconnecting.

% Loop flag
keyPress = 0;

figure(1)
set(gcf, 'KeyPressFcn', @stopLooping)

% Loop termination function
function stopLooping(~,~)
    keyPress = 1;
    disp("Stop streaming")
end

% Function QMCdemo(n, ip)
% 
% Input arguments:
% - n:  The amount of frames the demo should retrieve before disconnecting.
% - ip: The IP adress of the computer running QTM. If no IP is specified 
%       '127.0.0.1' (localhost) is used.

% if (nargin < 2)
%     ip = '127.0.0.1';
%     %n = 1000;
% end


QCM('connect', '127.0.0.1', 'frameinfo', '3d 6d forcesingle'); % Connects to QTM and keeps the connection alive.

the3dlabels = QCM('3dlabels');
the6doflabels = QCM('6doflabels');

while ~keyPress % i = 1:n
    [frameinfo the3D the6DOF forcesingle] = QCM; % Gather data from QTM. This configuration gets the frame info and
                                                 % three different types of data from QTM. Note that the number of
                                                 % inputs must be the same as the number of data types.
    pause(0.00001)
    pause(1)
%     display(frameinfo(2))
    
    display(forcesingle(6:7,7:9))
    
    rotatedCOP = rotateForcePlate(forcesingle(7,7:9),7);
    display(rotatedCOP)
end


QCM('disconnect');
close(1)
end