% Written by EK Klinkman
% v.20230209

function [ force_all, CoP1, CoP2, CoP3, CoP4, CoP5, CoP6, CoP7, CoP_all_short ] = force_sample(~, rotateForcePlate)
        % Get force from QCM
        [force] = QCM;
        % Select second row of cell array
        force_lab = force(2,:);
        % convert & identify force from plates
        force1 = cell2mat(force_lab(1));
        force2 = cell2mat(force_lab(2));
        force3 = cell2mat(force_lab(3));
        force4 = cell2mat(force_lab(4));
        force5 = cell2mat(force_lab(5));
        force6 = cell2mat(force_lab(6));
        force7 = cell2mat(force_lab(7));
        %concatenate force
        force_all = horzcat(force1,force2force3,force4,force5,force6,force7);
        % CoP = rotatedCoP
        CoP1 = rotateForcePlate(force1(7:9),1);
        CoP2 = rotateForcePlate(force2(7:9),2);
        CoP3 = rotateForcePlate(force3(7:9),3);
        CoP4 = rotateForcePlate(force4(7:9),4);
        CoP5 = rotateForcePlate(force5(7:9),5);
        CoP6 = rotateForcePlate(force6(7:9),6);
        CoP7 = rotateForcePlate(force7(7:9),7);
        %Define CoPx, CoPy, CoPz
%         CoPx1 = CoP1(1);
%         CoPy1 = CoP1(2);
%         CoPz1 = CoP1(3);
%         %FP2
%         CoPx2 = CoP2(1);
%         CoPy2 = CoP2(2);
%         CoPz2 = CoP2(3);    
%         %FP3
%         CoPx3 = CoP3(1);
%         CoPy3 = CoP3(2);
%         CoPz3 = CoP3(3);
%         %FP4
%         CoPx4 = CoP4(1);
%         CoPy4 = CoP4(2);
%         CoPz4 = CoP4(3);    
%         %FP5
%         CoPx5 = CoP5(1);
%         CoPy5 = CoP5(2);
%         CoPz5 = CoP5(3);    
%         %FP6
%         CoPx6 = CoP6(1);
%         CoPy6 = CoP6(2);
%         CoPz6 = CoP6(3);    
%         %FP7
%         CoPx7 = CoP7(1);
%         CoPy7 = CoP7(2);
%         CoPz7 = CoP7(3);
        
        % Concatenate CoP
        CoP_all_short = horzcat(CoP1,CoP2,CoP3,CoP4,CoP5,CoP6,CoP7);
%         CoP_all_long = horzcat(CoPx1,CoPy1,CoPz1,CoPx2,CoPy2,CoPz2,CoPx3,CoPy3,CoPz3,...
%             CoPx4,CoPy4,CoPz4,CoPx5,CoPy5,CoPz5,CoPx6,CoPy6,CoPz6,CoPx7,CoPy7,CoPz7);
    end