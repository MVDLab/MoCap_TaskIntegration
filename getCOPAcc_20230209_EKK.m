% Written by EK Klinkman, V Joshi
% v.20230209

% function [copAcc] = getCOPAcc()

    % Connect to QCM
    QCM('connect', '127.0.0.1', 'frameinfo', '3d forcesingle');
    dataTable = table;

    figure(1)
    set(gcf,'color','w')
    copPlot = plot(0,0,'o');
    xlabel('X position of COP')
    ylabel('Z position of COP')
    
    figure(2)
    set(gcf,'color','w')
    copAccPlot = plot(0,0,'o');
    xlabel('Time (s)')
    ylabel('Total COP acceleration (m/s^2)')

    % Keep getting data till capture stops
    while ~(QCM('event')==4 || QCM('event')==9)       
        [frameInfo, the3D, force] = QCM; % Retrieve data

        % Format data
        currTime    = double(frameInfo(2))/1e6;

        % Initialize cop locations
        copX = zeros(7,1);
        copZ = zeros(7,1);

        % Calcalate COP position on each force plate
        for fpNum = 1:7
            currCOP = rotateForcePlate(force(fpNum,7:9),fpNum);

            copX(fpNum) = currCOP(1)/1000;
            copZ(fpNum) = currCOP(3)/1000;
        end

        % Use vertical force along leg to calculate net cop location        
        totalWeight = sum(force(:,3));
        copXNet = sum(force(:,3).*copX)/totalWeight;
        copZNet = sum(force(:,3).*copZ)/totalWeight;

        copXVelocity = 0;
        copZVelocity = 0;
        copXAcc = 0;
        copZAcc = 0;

        % Need at least 2 points of data to get velocity and acceleration
        if height(dataTable) > 6
           % Calculate the frame to frame movement of the COP
           copXDisplacement = diff(dataTable.copXNet);
           copZDisplacement = diff(dataTable.copZNet);

           % Calculate the change in velocity
           copXVelocityChange = diff(dataTable.copXVelocity);
           copZVelocityChange = diff(dataTable.copZVelocity);

           % Find the time difference between the each frame
           delTime = diff(dataTable.currTime);

           % Use the last 2 frames to get velocity
           copXVelocity =  mean(copXDisplacement(end-5:end)./delTime(end-5:end));
           copZVelocity =  mean(copZDisplacement(end-5:end)./delTime(end-5:end));
           copXAcc = mean(copXVelocityChange(end-5:end)./delTime(end-5:end));
           copZAcc = mean(copZVelocityChange(end-5:end)./delTime(end-5:end));
        end


        % Make a table
        newTable = table(currTime, copXNet, copZNet, copXVelocity, copZVelocity, copXAcc, copZAcc);        

        % Store the data
        dataTable = [dataTable; newTable];

        copPlot.XData = dataTable.copXNet;
        copPlot.YData = -dataTable.copZNet;

        copAccPlot.XData = dataTable.currTime;
        copAccPlot.YData = sqrt(dataTable.copXAcc.^2 + dataTable.copZAcc.^2);

        drawnow;
    end

    
    
    
% end