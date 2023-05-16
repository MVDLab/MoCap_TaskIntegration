% Weitten by EK Klinkman
% v.20230209

function [] = writeData(fileName)
    % Connect to QCM
    QCM('connect', '127.0.0.1', 'frameinfo', '3d forcesingle');
    dataTable = table;
    
    % keep running till end trigger
    while ~(QCM('event')==4 || QCM('event')==9)
        [frameInfo, the3D, force] = QCM; % Retrieve data
        
        
         
%         % How many rows of data are there?
%         numRows = size(force{2,1},2);
%         
%         if numRows == 9
%             numRows = size(force{2,1},1);
%             frameNum    = double(frameInfo(1))*ones(numRows,1);
%             currTime    = double(frameInfo(2))*ones(numRows,1);
%             forcePlate1 = force{2,1};
%             forcePlate2 = force{2,2};
%             forcePlate3 = force{2,3};
%             forcePlate4 = force{2,4};
%             forcePlate5 = force{2,5};
%             forcePlate6 = force{2,6};
%         else
%             frameNum    = double(frameInfo(1))*ones(wrnumRows,1);
%             currTime    = double(frameInfo(2))*ones(numRows,1);
%             forcePlate1 = force{2,1}';
%             forcePlate2 = force{2,2}';
%             forcePlate3 = force{2,3}';
%             forcePlate4 = force{2,4}';
%             forcePlate5 = force{2,5}';
%             forcePlate6 = force{2,6}';
%         end
        % Make a table
        newTable = table(frameNum, currTime, forcePlate1, forcePlate2, forcePlate3, forcePlate4, forcePlate5, forcePlate6);
        
        % Write the table
        dataTable = [dataTable; newTable];
    end
    
    writetable(dataTable,fileName);
end