function [ forces ] = QCM_Example

forces=[];

% connect to QTM
QCM('connect','127.0.0.1','frameinfo','3d forcesingle');

% create user interface figure with button
f=uifigure;
button=uibutton(f,'state');
button.ValueChangedFcn=@(src,evt)ControlTimer(src,evt);
circ=uilamp(f,'Color','k','Position',[200 200 75 75]);

% define timer variable. Set the period to 1/(your frame rate) or faster so it pulls every frame of data
% setting "taskstoexecute" to inf tells the timer to run until you tell it to stop, which is good for
% applications that need to run for indeterminate times
QTM_timer=timer('period',0.001,'ExecutionMode','fixedrate','taskstoexecute',inf,'timerfcn',@(src,evt)pollQTM);

    function ControlTimer(~,evt)
        switch evt.Value
            case 0 % button NOT clicked
                stop(QTM_timer);
                assignin('base','forces',forces)
            case 1 % button clicked
                start(QTM_timer);
        end % button state switch statement
    end % ControlTimer

    function pollQTM(~,~)
        a=QCM('event');
        switch a
            case 3 % capture started
                % retrieve new frame of data from QTM
                [frameInfo,markerInfo,forceInfo]=QCM;
                disp(frameInfo(1)); % display frame number to confirm it is working
                forces(end+1,1)=forceInfo(1,3);
                detectEvents;
            case 4 % capture stopped
                stop(QTM_timer);
                % maybe disconnect from QTM here, if that's what you want
                % stop any other running things
        end % event switch statement
    end % pollQTM

    function detectEvents
        if forces(end)>=20
            circ.Color='g';
        elseif forces(end)<20
            circ.Color='r';
        else
            circ.Color='k';
        end
    end

end % overall function