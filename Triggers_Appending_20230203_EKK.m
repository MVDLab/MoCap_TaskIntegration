% Written by EK Klinkman
% v.20230203

% create messagebox
MessageBox = msgbox('Data Collection Running: End Feedback');
% draw messagebox
while ishandle(Messagebox)
    drawnow
   frame = frameinfo(1); 
end

% connect to QTM
QCM('connect', '127.0.0.1', 'frameinfo', '3d force')
[frameinfo, the3D, force] = QCM;



% create variables
% Do I want to create an empty structure for all force?
% or do I want to create one for each variable of interest?
t = 1;
frametrack = NAN(size,1);
Force5 = NAN(3,size);
CoP5 = NAN(3,size);
CoP5_AP = NAN;
CoP5_ML = NAN;
CoPsave = CoPsave + 1;



Frame = frameinfo(1);
FZthreshold = 10;
if Force5(3) >= FZthreshold
    frametrack1(t) = Frame;
    CoPNew = save(CoP_all)
elseif force5(3) < FZthreshold && t >10
end


