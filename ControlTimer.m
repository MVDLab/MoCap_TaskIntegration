% function to control timer popup
% written by Margo Donlin (donlinm@udel.edu) @ University of Delaware
% adapted by EK Klinkman
% version 2023-01-31
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function ControlTimer(~,evt,QTM_timer)
switch evt.Value
    case 0 % button NOT clicked
        stop(QTM_timer);
    case 1 % button clicked
        start(QTM_timer);
end
end