% function to poll QTM and stream every data packet
% written by Margo Donlin (donlinm@udel.edu) @ University of Delaware
% adapted by EK Klinkman
% version 2023-01-31
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function pollQTM(~,~)
a=QCM('event');
switch a
    case 8 % capture started; use 8 for RT play; use 3 for streaming
        % retrieve new frame of data from QTM
        [frameinfo the3D force]=QCM;
        disp(frameinfo(1)); % display frame number to confirm it is working
    case 9 % capture stopped; use 9 for RT play; use 4 for streaming
        stop(QTM_timer);
        QCM('disconnect') %disconnect from QTM
        % stop any other running things
%     while true
%         if a == 9; %use 9 for RT play; use 4 for streaming
%             break
%         end
%     end
end
end
