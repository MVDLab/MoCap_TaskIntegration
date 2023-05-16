% Timer button script to poll Qualisys data as long as timer is running
% Originally written by M. Donlin (donlinm@udel.edu) @ University of Delaware
% Adapted by EK Klinkman
% v. 20230131

% connect to QTM
QCM('connect','127.0.0.1','frameinfo','3d forcesingle');

% create user interface figure with button
f=uifigure;
button=uibutton(f,'state');
button.ValueChangedFcn=@(src,evt)ControlTimer(src,evt,QTM_timer);

% Define timer variable. Set the period to 1/(your frame rate) or faster 
% so it pulls every frame of data.
% Setting "taskstoexecute" to inf tells the timer to run until you tell 
% it to stop, which is good for applications that need to run for indeterminate times
QTM_timer=timer('period',0.001,'ExecutionMode','fixedrate','taskstoexecute',inf,'timerfcn',@(src,evt)pollQTM);

function ControlTimer(~,evt,QTM_timer)
switch evt.Value
    case 0 % button NOT clicked
        stop(QTM_timer);
    case 1 % button clicked
        start(QTM_timer);
end
end

function pollQTM(~,~)
% retrieve new frame of data from QTM
[frameInfo,markerInfo,forceInfo]=QCM;
disp(frameInfo(1)); % display frame number to confirm it is working
end