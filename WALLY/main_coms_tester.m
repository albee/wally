% Run a simulation of wally. Arduino should be running coms_exec.ino.

%---
% Run a single movement: 
% (1) Setup; (2) Run; (3) Open Bluetooth coms;(4) Send a single bluetooth command

%---
% Run a sample wall climbing movement:
% (1) Setup; (2) Run; (3) Open Bluetooth coms; (4) Calc optimal path OR load
% a chunked path for coms; (5) Send path to Arduino; OPTIONAL: Plot the path
% returned, chunked or stances

%% Setup
clc
clear
close all

%Input parameters
%L: [l1A l1B l1C l1D l2A l2B l2C l2D]
L = [4 4 4 4 4 4 4 4];

%shoulders_TORSO: [xA xB xC xD yA yB yC yD]
shoulders_TORSO = [-2 2 2 -2 2 2 -2 -2];

%Q: [q1A q1B q1C q1D q2A q2B q2C q2D]
Q = [135/180*pi,45/180*pi,-45/180*pi,-135/180*pi,0,0,0,0];

%hands_TORSO: [xA xB xC xD yA yB yC yD]
hands_TORSO = [-4 4 4 -4 8 8 -4 -4];

%TORSO_ABS: [x y theta]
TORSO_ABS = [16 8 0/180*pi];
               
% Plotting stance            
OFFSET1 = 10;
OFFSET2 = 100;
check_angles = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                   -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;

% Neutral angles, change CONFIG to [-1,1,-1,1]
%s_neutral_angle: [sna1, sna2, sna3, sna4, sna5, sna6, sna7, sna8] (rad)
%inner limb neutral angles relative to horiz, out limb neutral angles
%relative to inner limb x-axis. All range 0 to 2pi.
OFFSET1 = 10;
OFFSET2 = 0;
s_na = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                   -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
 
%s_range: [2xn] of [min;max] of angles(rad) [q1A, ... q1D; q2A, ... q2D]
%max is always positive, min is always negative. Adheres to s_na angle convention
s_range = [-70, -70, -70, -70, -140, 0, -140, 0;
            70, 70, 70, 70, 0, 140, 0, 140]/180*pi;

%CONFIG: Configuration of A,B,C, and D. -1 is left-facing, 1 is right-facing
CONFIG = [-1,1,-1,1];

%move_prefs: [8x8] of suggested angles in the stance order N,NE,E,SE,S,SW,W,NW
move_prefs = calc_move_prefs();
converter = wally(L, shoulders_TORSO, s_na, s_range, move_prefs, CONFIG);
for i = 1:size(move_prefs,1)
    converter = converter.set_TORSO_ABS([0 0 0]);
    converter = converter.set_Q(move_prefs(i,:));
    converter = converter.fk_hands();
%     cur_fig = converter.plot_robot(1);
%     converter.plot_ws_body(2,cur_fig);
    move_prefs(i,:) = converter.get_hands_TORSO;
end

%final_TORSO_ABS: final goal for the TORSO to reach [x y theta]
final_hold = [16,60];

%% Run

%Generate a wall to climb
num_handholds = 500;
width = 12; % number width holds
height = 24; % number height holds
width_space = 4; %width space between holds, in
height_space = 4; %height space between holds, in
myWall = wall(width, height, width_space, height_space, final_hold);%, num_handholds);

%Set properties and IC of WALLY
myWally = wally(L, shoulders_TORSO, s_na, s_range, move_prefs, CONFIG);
myWally = myWally.set_TORSO_ABS(TORSO_ABS);
myWally = myWally.set_hands_TORSO(hands_TORSO);
myWally = myWally.ik_hands_TORSO();
start_node = w_node(myWally.get_hands_ABS, myWally.get_TORSO_ABS, null(1), 0, 0, 0, 0);

%% Open bluetooth coms
%     blue = connect_coms();

%% Send a single bluetooth command
% smpl_move = [10,20,10,20,0,0,0,0];%angles, written in 0 to 140 of servo frame
% smpl_move = [smpl_move,[1,1,1,1]]; %em, 1 if on, 0 if off
% for j=1:12
%     fwrite(blue,smpl_move(j));
% end
% while 1==1
%     if blue.BytesAvailable ~= 0
%         answer = fread(blue,1);
%         break
%     end
% end
% if answer == 1
%     disp('Command successful.');
% else
%     disp('Error in receive signal.');
% end
% return

%% Calc optimal path
% disp('Generating path...')
% [path] = myWally.calc_path(myWall, start_node, final_hold);
% disp('...complete.')

%% Calc intermediate chunked_path for communication
% load('up_climb2.mat');
% disp('Chunking path...')
% chk_path_coms = myWally.chunk_path_coms(path);
% chk_path_coms_prp = myWally.prep_coms(chk_path_coms);
% disp('...complete.')

%% Send path to Arduino via coms
% myWally.send_path(chk_path_coms_prp, blue);
% fclose(blue); %end bluetooth coms

%% Plot path returned
% handles1 = []; handles2 = [];
% cur_fig = myWall.plot_wall();
% scatter(TORSO_ABS(1),TORSO_ABS(2),'BLUE');
% scatter(final_hold(1),final_hold(2),'RED');
% 
% for i = 1:size(path,1)
%     myWally = myWally.set_hands_ABS(path{i,1});
%     myWally = myWally.set_TORSO_ABS(path{i,2});
%     myWally = myWally.ik_hands_ABS();
%     [cur_fig, handles1] = myWally.plot_robot(2,cur_fig);
%     [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
%     pause(1.5)
%     frame(i) = getframe(cur_fig);
%     delete(handles1); delete(handles2);
% end

%% Plot chunked path returned, coms
% handles1 = []; handles2 = []; handles3 = []; handles4 = [];
% cur_fig = myWall.plot_wall();
% scatter(TORSO_ABS(1),TORSO_ABS(2),'BLUE');
% scatter(final_hold(1),final_hold(2),'RED');
% %Set to the initial position
% myWally = myWally.set_TORSO_ABS(TORSO_ABS);
% myWally = myWally.set_hands_TORSO(hands_TORSO);
% myWally = myWally.ik_hands_TORSO();
% 
% for i = 1:size(chk_path_coms,1)
%     if isequal(chk_path_coms(i,9:12), [1 1 1 1]) % TORSO motion
%         myWally = myWally.set_Q(chk_path_coms(i,1:8));
%         myWally = myWally.fk_TORSO();
%     else % hand motion
%         myWally = myWally.set_Q(chk_path_coms(i,1:8));
%         myWally = myWally.fk_hands();
%     end
%     figure(cur_fig); hold on;
%     cur_holds = myWally.get_hands_ABS;
%     handles3 = scatter(cur_holds(1:4), cur_holds(5:8),'green');
%     if chk_path_coms(i,9) == 0; handles4 = scatter(cur_holds(1), cur_holds(5),'red'); end;
%     if chk_path_coms(i,10) == 0; handles4 = scatter(cur_holds(2), cur_holds(6),'red'); end;
%     if chk_path_coms(i,11) == 0; handles4 = scatter(cur_holds(3), cur_holds(7),'red'); end;
%     if chk_path_coms(i,12) == 0; handles4 = scatter(cur_holds(4), cur_holds(8),'red'); end;
%     [cur_fig, handles1] = myWally.plot_robot(2,cur_fig);
%     [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
%     frame(i) = getframe(cur_fig);
%     delete(handles1); delete(handles2); delete(handles3); delete(handles4);
% end