% MVD MoCap Task
% Lean (ln), weight-shift (ws), and step (st)
% written by EK Klinkman
% v.20230207
% adapted from Scarfe Lab PTB demos
% some parts adapted from Robin Shafer, KU Brain Lab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear Matlab and Prepare for Experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;
                                                                                        
version_num = '02072023'; % ddmmyyyy of updates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
% Get the screen numbers
screens = Screen('Screens');
% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);
% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% screen settings...
% Open an on screen window and color it black
Screen('Preference', 'ConserveVRAM', 4096);  % Tells PsychToolbox to always enable the timing test 'workaround' when the beamposition timing test fails (this will happen in Windows 10)
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[screenXpixels, screenYpixels] = Screen('WindowSize', window); % Get the size of the on screen window in pixels. For help see: Screen WindowSize?
[xCenter, yCenter] = RectCenter(windowRect); % Get the centre coordinate of the window in pixels. For help see: help RectCenter

% Get the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% We will be presenting each of our text screens for 10 seconds each
presSecs = 10;
waitframes = round(presSecs / ifi);
% We change the color of the number every "nominalFrameRate" frames
colorChangeCounter = 0;
% Randomise a start color
color = rand(1, 3);
% Starting number
currentNumber = 10;
% Stimulus Screen Priority = Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Timing and sizing calculations (refresh rate to stimulus presentation, pixels to mm)
screen_hz = Screen('FrameRate', window);%refresh rate of stimulus monitor
res = Screen('Resolution', screenNumber); %resolution of stimulus monitor in pixels
disp(res);
[mm_screen_w, mm_screen_h] = Screen('DisplaySize', screenNumber); % width and height of screen in mm

% Keyboard ID, bring command window to front, and hide the mouse
KbID = -1; %keyboard ID: -1 is any connected keyboard
commandwindow; %brings the command window to the front (admin screen)
HideCursor; % hides the mouse from view

% Here we load in an arrow image from file
ArrowL = imread('left_arrow.png');
ArrowR = imrotate(ArrowL, 180);
% Make image into a texture
imageTexture1 = Screen('MakeTexture', window, ArrowL);
imageTexture2 = Screen('MakeTexture', window, ArrowR);
% Get an initial screen flip for timing
vbl = Screen('Flip', window);
%Specify number of repeated trials
n = 4;
c = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Connect to Qualisys track manager (QTM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local IP (if running MATLAB on same device): 127.0.0.1
% Data we're querying from QTM:
%       'frameinfo' = Frame information that is shared among all data components, except for Analog, Force and Gaze Vector.
%           [0] = frame number
%           [1] = timestamp (μs - microseconds
%       'the3D' = 3D marker data (30x3 double)
%           [0] = X
%           [1] = Y
%           [2] = Z
%       'forcesingle' = Force data, only containing one sample (the latest)
%       per channel
%           - double array; refer to below values ('force') for indexing
%       'force' = force plate data; cell array containing 2 cells per force
%                 plate. The first cell contains the force sample number, which is 
%                 the sequence number of the first sample in the frame. 
%                 The second cell contains a n x 9 double matrix (n is force count) 
%                 with the force data, see below. Values are set to NaN if there is no data available.
%           [0] = Force X 
%           [1] = Force Y
%           [2] = Force Z
%           [3] = Moment X
%           [4] = Moment Y
%           [5] = Moment Z
%           [6] = Application point X
%           [7] = Application point Y
%           [8] = Application point Z
QCM('connect', '127.0.0.1', 'frameinfo', '3d force')
[frameinfo, the3D, force] = QCM; % Retrieve data
frameRate = getFrameRate(); % internal function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup connection to Trigger device (NI DAQ or QTM external trigger)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NI DAQ can be coded straight into MATLAB
%       See following code: 
%       C:\Users\QTM\MATLAB\Projects\MVD_Lab\Robin\Test_EEG_Gain8s_Full_Task_wFunction_20230120.m
% QTM wired trigger (SKB has 2)
%       Might only work with QTM Real-Time Server???
% EXAMPLE CODE: *Netstation is the force software Robin's lab uses

%connect to National Instruments DIN device
% dq = [];
% 
% host = '10.10.10.42';
% port = 55513;
% if ~DEBUG_EEG %identify port
%     
%     dq = daq('ni');
%     addoutput(dq, 'Dev1', 'port0/line0:7', 'Digital');
% 
%     trig_0 = str2num(dec2bin(0,8)')';
% 
% end %if ~DEBUG_EEG %identify port
%     
% %connect to Netstation
% if ~DEBUG_EEG %connect to NS
%     [NSstat, NSerror] = NetStation('Connect', host, port); %check function name - NetStationNewest was the function David gave when we needed the updated PTB function but couldn't update all of PTB
%     WaitSecs(0.2);
%         
%     if NSstat ~= 0
%         disp('error during connecting');
%         disp(NSerror);
%     end %if NSstat ~= 0
%         
% end %if ~DEBUG_EEG %connect to NS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Experimental parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
task_name = 'MVD_MoCap'; %task name as indicated in the filename
namelength = length(task_name);
run = 1;
visit = 1;
trials_per_block = 4; % # of trials per block; # of reps
blocks_per_cond = 1; % # blocks for each experimental condition
force_threshold = 10; %(N) threshold to register force application; anything below = 0
%% CoP_accel_threshold = XX; % (m/s^2) threshold to register still body to trigger task progression

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data storage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_folder = 'C:\Users\QTM\MATLAB\Projects\MVD_Lab\Data\'; % location of data folder
% column_header_format = [repmat('%s\t',[1,nc]),'\r\n']; %format for writing data column headers to file; nc = number of columns. Based on which and how many data to write
% column_headers = {'Block','TrialNum', 'TrialNumTotal','Timestamp','Force', 'MVC', 'Percent MVC', 'Hand', 'Gain', 'Event
% Marker', 'Flags','Task Version'}; %column headers for data file. **Must match # 'nc' 
% data_format = ['%d\t%d\t%d\t%10.4f\t%10.4f\t%10.4f\t%10.4f\t%s\t%10.4f\t%d\t%d\t%s\r\n']; %format for writing data to file
%%  %s\t (string), %d\t (integer), %10.4f\t (floating point decimal number w/ 10 digits to the left and 4 digits to the right of the decimal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Command window prompts to obtain Participant MVD ID number, run number, order of blocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
check = 1;

while check
repeat = 1;
    while repeat % Participant MVD ID number
        inputPrompt = '<strong>\n\nEnter the participant ID number: </strong>';
        [subjNum] = input(inputPrompt);
        subject_folder = [num2str(subjNum),'\'];
        if isempty(subjNum) || ~subjNum == round(subjNum) || subjNum < 100 || subjNum > 999
            disp('\n\nThe value you entered is not acceptable. The participant ID must be a three-digit number.');
            repeat = 1;  
        else 
               repeat = 0;
        end %if isempty(subjNum) || ~subjNum == round(subjNum) || subjNum < 1000 || subjNum > 9999
    end % while repeat % Subject ID
    repeat = 1;
    while repeat % Identify whether participant already has data file for the above entered conditions
        if exist(strcat(data_folder,subject_folder))==7
            if visit == 1 && run == 1
                file_name = [task_name, '_', num2str(subjNum), 'x*', '_r', '*_gn', '*_', num2str(MVC_percent),'_' hand_str, '_', tv_str, '*.txt']; % *EDIT FOR MVD
                d = dir(fullfile(data_folder,subject_folder,file_name));
                %dName{j,1} = {d.name};
                dName = {d.name};
                %end %for j = 1:length(gain_order)
                % If participant already has data, do you want to do a new visit/run?
                disp(' ');
                disp(['<strong>Participant ', num2str(subjNum),' already has the following data files:</strong>']);
                cellstr(dName);
                disp(dName(:))
            
                visit_y_n = input(['<strong>Is this a new visit?</strong>' '\n\nEnter y or n: '],'s');
                    
                if visit_y_n == 'y'
                    visit = input(['\n\n <strong>Please enter the new visit number.</strong>\n\n']);
                    repeat = 1;

                elseif visit_y_n == 'n'
                    run_y_n = input(['<strong>Is this a new run?</strong>' '\n\nEnter y or n: '],'s');
                    
                    if run_y_n == 'y'
                        run = input(['\n\n <strong>Please enter the new run number.</strong>\n\n']);
                        repeat = 1;
                        
                    elseif run_y_n == 'n'
                        repeat = 0;
                        
                    end %if run_y_n == 'y'
                    
                end %if visit_y_n == 'y'
             
            elseif visit > 1 || run > 1
                
                %Identify whether participant already has data file for the above entered conditions
                file_name_visit = [task_name, '_', num2str(subjNum), 'x', num2str(visit), '_r', num2str(run) '_gn', '*_', num2str(MVC_percent),'_' hand_str, '_', tv_str, '*.txt'];
                d = dir(fullfile(data_folder,subject_folder,file_name_visit));     
                dName = {d.name};

                if length(dName) > 0
                    disp(' ');
                    disp(['<strong>Participant ', num2str(subjNum),' already has the following data files:</strong>']);
                    disp(dName(:))
                    visit_y_n = input(['The participant already has <strong>Visit ', num2str(visit), ' Run ', num2str(run), '\nIs this a new visit?</strong>' '\n\nEnter y or n: '],'s');

                    if visit_y_n == 'y'
                        visit = input(['\n\n <strong>Please enter the new visit number.</strong>\n\n']);
                        repeat = 1;

                    elseif visit_y_n == 'n'
                        run_y_n = input(['<strong>Is this a new run?</strong>' '\n\nEnter y or n: '],'s');

                        if run_y_n == 'y'
                            run = input(['\n\n <strong>Please enter the new run number.</strong>\n\n']);
                            repeat = 1;

                        elseif run_y_n == 'n'
                            repeat = 0;

                        end %if run_y_n == 'y'

                    end%if visit_y_n == 'y'

                elseif isempty(dName)
                    repeat = 0;

                end %if length(dName) > 0
                    
            end % if visit == 1 && run == 1 
            
        else
            %create participant data folder
            mkdir(data_folder,subject_folder)

            repeat = 0;
            
        end %if exist(strcat(data_folder,subjNum))==7
        
    end %while repeat 
    % Confirm that information entered is correct       
    disp(' ')
    disp('Please check the participant''s information:');
    disp(' ')
    disp(['    ID: <strong>', num2str(subjNum), '    </strong> Visit: <strong> ', num2str(visit), '    </strong> Run: <strong>', num2str(run)])

    check_prompt = ['\nIs this correct? Enter y or n: '];
    check_y_n = input(check_prompt,'s');
    
    if check_y_n == 'y'
        check = 0;
        
    else
            check = 1;
            
    end %if check_y_n == 'y'
         
end % while check

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prompt administrator to start task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DrawFormattedText(window,'Please wait for the administrator to start the task.\n\n', 'center', 'center', white); %Text for stimulus display
vbl = Screen('Flip', window, vbl + (waitframes - .5)*ifi); %refresh stimulus display with text
disp(' ');
disp('Press <strong>SPACE</strong> to start task.'); %command line message to admin
KbStrokeWait(KbID); % wait for key press
disp('');
disp('Task is running.'); % status update to command line

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Start Force/3D Kinematic/Eye tracking Recording
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NI DAQ can be coded straight into MATLAB
%       See following code: 
%       C:\Users\QTM\MATLAB\Projects\MVD_Lab\Robin\Test_EEG_Gain8s_Full_Task_wFunction_20230120.m
% QTM wired trigger (SKB has 2)
%       Might only work with QTM Real-Time Server???
% EXAMPLE CODE: *Netstation is the force software Robin's lab uses

% %Zero DIN port for first trigger
% if ~DEBUG_EEG %zero port
%     write(dq,trig_0); %zero the port for retriggering
%     
% end %if ~DEBUG_EEG %zero port
% 
% WaitSecs(0.1);
%     
% % Start EEG recording
% if ~DEBUG_EEG % start recording
%     [NSstat, NSerror] = NetStation('StartRecording'); %start recording %NetStationNewest()
%     WaitSecs(0.2);
%     
%     if NSstat ~= 0
%         disp('error during start recording');
%         disp(NSerror);
%     
%     end %if NSstat ~= 0
%     
% end %if ~DEBUG_EEG % start recording
%   
% % Synchronize clocks for stimulus and NetStation computers
% if ~DEBUG_EEG %synch clocks
%     [NSstat, NSerror] = NetStation('Synchronize'); %start recording %NetStationNewest
%     WaitSecs(0.2);
%     
%     if NSstat ~= 0
%         disp('error during synchronization');
%         disp(NSerror);
%         
%     end %if NSstat ~= 0
%     
% end %if ~DEBUG_EEG %synch clocks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stimuli and experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start screen and print instructions
line1 = 'Stand still with your feet glued to the ground.';
line2 = '\n The next screen will tell you to lean your body';
line3 = '\n\n If you see LEFT, lean to the left';
line4 = '\n\n If you see RIGHT lean to the right';
line5 = 'Stop leaning';
line6 = '\n Stand up straight';


Screen('TextSize', window, 80);
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels * 0.25, white);
%flip to the screen
vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);

%% Collect data
% Wait till trigger
while ~(QTM('event')==3)
end

% Loop till capture stops
conditionNum = 4;
while ~(QTM('event')==4)
    [frameinfo, the3D, force] = QCM; % Retrieve data
         
    % Check conditions
    if conditionNum == 4 %Some sort of COP acceleration check to trigger stim
        
    end
end

%Lean left 4x
for t = 1:n
    % Display LEFT arrow
    Screen('DrawTexture', window, imageTexture1, [], [], 0);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    %back to middle
    Screen('TextSize', window, 100);
    DrawFormattedText(window, [line5 line6],...
        'center', screenYpixels * 0.25, white);
    %flip to the screen
    vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);
end
%Lean right 4x
for t = 1:n
    % Display RIGHT arrow
    Screen('DrawTexture', window, imageTexture2, [], [], 0);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    %back to middle
    Screen('TextSize', window, 100);
    DrawFormattedText(window, [line5 line6],...
        'center', screenYpixels * 0.25, white);
    %flip to the screen
    vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Weight Shift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start screen and print instructions
line1 = 'Stand still with your feet glued to the ground.';
line2 = '\n The next screen will tell you to shift your body';
line3 = '\n\n If you see LEFT, shift your body to the left foot';
line4 = '\n\n If you see RIGHT shift your body to the right foot';
line5 = 'Back to center';
line6 = '\n Stand up straight';

Screen('TextSize', window, 80);
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels * 0.25, white);
%flip to the screen
vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);

%WS left 4x
for t = 1:n
    % Display LEFT arrow
    Screen('DrawTexture', window, imageTexture1, [], [], 0);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    %back to middle
    Screen('TextSize', window, 100);
    DrawFormattedText(window, [line5 line6],...
        'center', screenYpixels * 0.25, white);
    %flip to the screen
    vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);
end
%WS right 4x
for t = 1:n
    % Display RIGHT arrow
    Screen('DrawTexture', window, imageTexture2, [], [], 0);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    %back to middle
    Screen('TextSize', window, 100);
    DrawFormattedText(window, [line5 line6],...
     'center', screenYpixels * 0.25, white);
    %flip to the screen
    vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stepping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start screen and print instructions
line1 = 'Stand still with your feet glued to the ground.';
line2 = '\n The next screen will tell you to take a step';
line3 = '\n\n If you see LEFT, take a step to the left';
line4 = '\n\n If you see RIGHT, take a step to the right';
line5 = 'Step back to the center';
line6 = '\n Stand up straight';

Screen('TextSize', window, 80);
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels * 0.25, white);
%flip to the screen
vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);

%Step left 4x
for t = 1:n
    % Display LEFT arrow
    Screen('DrawTexture', window, imageTexture1, [], [], 0);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    %back to middle
    Screen('TextSize', window, 100);
    DrawFormattedText(window, [line5 line6],...
        'center', screenYpixels * 0.25, white);
    %flip to the screen
    vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);
end
% Step right 4x
for t = 1:n
    % Display RIGHT arrow
    Screen('DrawTexture', window, imageTexture2, [], [], 0);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    %back to middle
    Screen('TextSize', window, 100);
    DrawFormattedText(window, [line5 line6],...
        'center', screenYpixels * 0.25, white);
    %flip to the screen
    vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);
    % Clear the screen
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m-CTSIB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start screen and print instructions
line1fi = 'Stand on the FLOOR with your feet glued to the ground';
line1fo = ' Stand on the FOAM with your feet glued to the ground';
line2eo = '\n With your eyes OPEN, stand as still as a statue';
line2ec = '\n With your eyes CLOSED, stand as still as a statue';
line2do = '\n With the DOME over your head, stand as still as a statue';

% EO FIRM
Screen('TextSize', window, 80);
DrawFormattedText(window, [line1fi line2eo],'center', screenYpixels * 0.25, white);
%flip to the screen
vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);
for t = 1:c
    % Display countdown
    Screen('DrawTexture', window, imageTexture1, [], [], 0);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    % 10 second countdown display
    while currentNumber >= 0
    % Convert our current number to display into a string
    numberString = num2str(currentNumber);
    % Draw our number to the screen
    DrawFormattedText(window, numberString, 'center', 'center', color);
    % Flip to the screen
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    % New random colour for the next number
    color = rand(1, 3);
    % Increment the number
    currentNumber = currentNumber - 1;
    end
end
% EC FIRM
Screen('TextSize', window, 80);
DrawFormattedText(window, [line1fi line2ec],'center', screenYpixels * 0.25, white);
%flip to the screen
vbl = Screen('Flip',window, vbl + (waitframes - 0.5)*ifi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End of Task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present "thank you for participating" text at end of task
DrawFormattedText(window,'You have completed the activity.\n\n Thank you for participating!', 'center', 'center', white);
vbl = Screen('Flip', window, vbl + (waitframes - .5)*ifi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Close out connections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Qualisys
if %DAQ or trigger = 'stop recording'
    QCM('disconnect');
end

%PupilLabs????

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Close out of PsychToolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Wait for keyboard press to close out of task program
    disp('Task is complete. Press <strong>SPACE</strong> to close task program.');
    KbStrokeWait(KbID);
    
    Screen('CloseAll');
    Priority(0);
    ShowCursor; %makes the mouse visible again
% WaitSecs(presSecs);
% sca;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Internal Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get frame rate from Qualisys MoCap system
    function frameRate = getFrameRate()
        % Get frame info from QCM
        [frameinfo] = QCM;
        % Use frame info to calculate current avg frame rate
        frameRate = double(frameinfo(1))/double(frameinfo(2)/1000000);
    end

% Convert Force data cell array
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

% Rotate force plate
% Transforms the COP data from a single force plate...
% to the global lab frame from the local force plate frame
% written by V Joshi & EK Klinkman 2022-01-16
    function [rotatedCOP] = rotateForcePlate(originalCOP, plateNum)
        % What's the transform from force plate axes to global frame?
        rotationMatrix = [0   1   0;
                          0   0   1;
                          -1  0   0];

        % What is the position of the force plate in the lab frame?
        %FP1
        xPos1 = [ 1918.16,  1919.72,  1326.38,  1325.66];
        yPos1 = [0.695424, 0.786733,  1.27345,  1.29034];
        zPos1 = [-867.118, -475.354, -866.477,  -475.14];

        fpPos(:,1) = [mean(xPos1); mean(yPos1); mean(zPos1)];

        %FP2
        xPos2 = [ 1315.96,  1316.62,  723.032,  723.867];
        yPos2 = [0.726698, 0.958016,  1.64753,  1.99565];
        zPos2 = [-867.327, -476.441, -866.549, -474.464];

        fpPos(:,2) = [mean(xPos2); mean(yPos2); mean(zPos2)];

        %FP3
        xPos3 = [ 712.383,  714.053,  123.821,  124.009];
        yPos3 = [ 1.36522,  1.89194,  1.95467,  1.99109];
        zPos3 = [-867.122, -475.086, -865.453, -474.016];

        fpPos(:,3) = [mean(xPos3); mean(yPos3); mean(zPos3)];   

        %FP4
        xPos4 = [ 2038.47,  2037.81,  1538.69,  1539.42];
        yPos4 = [0.820645, 0.646729, 0.655088,  1.13868];
        zPos4 = [-462.638,  -9.2051, -463.469, -9.70235];

        fpPos(:,4) = [mean(xPos4); mean(yPos4); mean(zPos4)]; 

        %FP5
        xPos5 = [ 1525.49,  1526.37,  1025.97,  1027.63];
        yPos5 = [0.838643, 0.484344,  1.87654, 0.977315];
        zPos5 = [-463.746, -7.35339, -462.522,  -5.5285];

        fpPos(:,5) = [mean(xPos5); mean(yPos5); mean(zPos5)]; 

        %FP6
        xPos6 = [ 1014.66,  1014.86,  515.593,  517.035];
        yPos6 = [ 1.68741,   1.0025,  1.77259,  1.97398];
        zPos6 = [-462.369, -7.24348, -462.181, -9.21267];

        fpPos(:,6) = [mean(xPos6); mean(yPos6); mean(zPos6)]; 

        %FP7
        xPos7 = [ 503.632,  504.095,  4.63596,  5.09201];
        yPos7 = [ 1.73205,  1.52884,  2.57499,  1.85976];
        zPos7 = [-461.798, -9.17788, -457.711, -8.42745];

        fpPos(:,7) = [mean(xPos7); mean(yPos7); mean(zPos7)];

        % Perform the transform
        rotatedCOP = rotationMatrix*originalCOP(:);
        rotatedCOP = rotatedCOP + fpPos(:,plateNum);

        rotatedCOP = rotatedCOP';
    end