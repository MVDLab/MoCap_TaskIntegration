% Written by EK Klinkman
% v.20230209

function [COPf] = combineForcePlates(F1, F2, COP1, COP2)

    COPf = (((abs(F1)).*COP1) + ((abs(F2))).*COP2)./(((abs(F1))+((abs(F2)))));

end