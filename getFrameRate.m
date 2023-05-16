% Written by V Joshi & EK Klinkman
% v.20230131

function frameRate = getFrameRate()
    % Connect to QCM and get frame info
    [frameinfo, the3D] = QCM;
    
    % Use frame info to calculate current avg frame rate
    frameRate = double(frameinfo(1))/double(frameinfo(2)/1000000);
end