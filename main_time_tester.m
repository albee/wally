% Run multiple simulation of WALLY for time comparison.

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
hands_TORSO = [-4 4 4 -4 8 8 -8 -8];

%TORSO_ABS: [x y theta]
TORSO_ABS = [0 0 0/180*pi];
               
%s_neutral_angle: [sna1, sna2, sna3, sna4, sna5, sna6, sna7, sna8] (rad)
%inner limb neutral angles relative to horiz, out limb neutral angles
%relative to inner limb x-axis. All range 0 to 2pi.
%CONFIG for normal WALLY is [-1,1,-1,1].
% OFFSET1 = 10;
% OFFSET2 = 0;
% s_na = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
%                    -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;

%test for 120
OFFSET1 = 10;
OFFSET2 = 0;
s_na = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                   -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
 
%s_range: [2xn] of [min;max] of angles(rad) [q1A, ... q1D, q2A, ... q2D; ...]
%max is always positive, min is always negative. Adheres to s_na angle convention
s_range = [-70, -70, -70, -70, -140, 0, -140, 0;
            70, 70, 70, 70, 0, 140, 0, 140]/180*pi;

%test for 120
% s_range = [-60, -60, -60, -60, -120, 0, -120, 0;
%             60, 60, 60, 60, 0, 120, 0, 120]/180*pi;
        
% s_range = [-60, -60, -60, -60, -110, -10, -110, 0;
%             60, 60, 60, 60, 10, 110, 10, 110]/180*pi;


%CONFIG: Configuration of A,B,C, and D. -1 is left-facing, 1 is right-facing
CONFIG = [-1,1,-1,1];

%move_prefs: [8x8] of suggested angles in the stance order N,NE,E,SE,S,SW,W,NW
move_prefs = calc_move_prefs();
converter = wally_demo(L, shoulders_TORSO, s_na, s_range, move_prefs, CONFIG);

% big_subplot = figure;

for i = 1:size(move_prefs,1)
    converter = converter.set_TORSO_ABS([0 0 0]);
    converter = converter.set_Q(move_prefs(i,:));
    converter = converter.fk_hands();
%     cur_fig = converter.plot_robot(1);
%     converter.plot_ws_body(2,cur_fig);

%     cur_fig = converter.plot_ws_body(4);
%     converter.plot_robot(2,cur_fig);

%     axis off;
%     ax = gca;
%     ax_copy = copyobj(ax,big_subplot);
%     subplot(2,4,i,ax_copy)
    
    move_prefs(i,:) = converter.get_hands_TORSO;
end

%check_angles: for plotting tester only            
OFFSET1 = 10;
OFFSET2 = 100;
check_angles = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                   -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;

%final_hold: final goal for a hand to reach [x_ABS, y_ABS]
final_hold = [44,16];

%% Run
for k=1:100
    %Generate a wall to climb
    num_handholds = 500;
    width = 48; % width
    height = 96; % height
    num_width = 10; % number width holds
    num_height = 22; % number height holds
    width_space = 4; %width space between holds, in
    height_space = 4; %height space between holds, in
    offset = 4; %exterior spacing
    info = [width, height, num_width, num_height, width_space, height_space, offset, num_handholds];

    %Real Wall
    % load('real_wall_ws/real_holds2.mat');
    % holds = holds_in;
    % final_hold = [36 60];
    final_hold = [36 90];
    TORSO_ABS = [12 12 0/180*pi];
    hands_TORSO = [-4 4 4 -4 8 8 -8 -4];

    % info = {holds,48,96};

    %Set properties and IC of WALLY
    myWally = wally_demo(L, shoulders_TORSO, s_na, s_range, move_prefs, CONFIG);
    myWally = myWally.set_TORSO_ABS(TORSO_ABS);
    myWally = myWally.set_hands_TORSO(hands_TORSO);
    myWally = myWally.ik_hands_TORSO();
    start_node = w_node(myWally.get_hands_ABS, myWally.get_TORSO_ABS, null(1), 0, 0, 0, 0);

    %Create WALL
    myWall = wall(info, final_hold);%, num_handholds);
%     figure()
%     myWall.plot_wall()
    tic;
    [path, iters] = myWally.calc_path(myWall, start_node);
    if isempty(path)
        len(k) = 0;
        time(k) = 0;
        iters_cnt(k) = 0;
    else
        len(k) = size(path,1);
        time(k) = toc;
        iters_cnt(k) = iters;
    end
    len(end)
    time(end)
    iters_cnt(end)
end

% TORSO_ABS = [19.0993   67.3133                  0];
% hands_ABS = [14.9688   21.0313   25.1875   11.6250   73.0000   74.6250   63.8750   64.2500]; 
% myWally = myWally.set_TORSO_ABS(TORSO_ABS);
% myWally = myWally.set_hands_ABS(hands_ABS);
% myWally = myWally.ik_hands_ABS();
% myWally.get_Q
% % myWally = myWally.set_Q([180 -25 0 180 30 0 0 -30]/180*pi);
% % myWally = myWally.fk_hands();
% % myWally = myWally.ik_hands_ABS();
% cur_fig = myWally.plot_robot(1);
% cur_fig = myWally.plot_ws_body(2,cur_fig);
% hold on
% scatter(19.0993,   67.3133       ,'RED');
% hold on
% scatter( 19.1678,   67.3817      ,'BLUE');
% return

%% Open bluetooth coms
%     disp('Connecting coms...')
%     blue = Bluetooth('HC-05',1);
%     fopen(blue);
%     disp('...complete.')

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

%% Show test stance
% myWally = myWally.set_TORSO_ABS(TORSO_ABS);
% myWally = myWally.set_Q(check_angles);
% myWally = myWally.fk_hands();
% cur_fig = myWally.plot_robot(1);
% myWally.plot_ws_body(2,cur_fig);

%% Calc optimal path
% disp('Generating path...')
% tic
% load('bad_case1.mat')
% path = myWally.calc_path(myWall, start_node);
% size(path,1)
% toc
% disp('...complete.')

%% Calc intermediate chunked_path
% load('path6.mat');
% chk_path = myWally.chunk_path(path);

%% Calc intermediate chunked_path for communication
% load('up_climb1.mat');
% disp('Chunking path...')
% chk_path_coms = myWally.chunk_path_coms(path);
% chk_path_coms_prp = myWally.prep_coms(chk_path_coms);
% disp('...complete.')

%% Send path to Arduino via coms
% myWally.send_path(chk_path_coms_prp, blue);
% fclose(blue); %end bluetooth coms


% Plotting utilities

%% Plot workspaces of solution
% handles1 = []; handles2 = [];
% cur_fig = myWall.plot_wall();
% % scatter(TORSO_ABS(1),TORSO_ABS(2),'BLUE');
% % scatter(final_hold(1),final_hold(2),'RED');
% 
% for i = 1:size(path,1)
%     myWally = myWally.set_hands_ABS(path{i,1});
%     myWally = myWally.set_TORSO_ABS(path{i,2});
%     myWally = myWally.ik_hands_ABS();
% %     [cur_fig, handles1] = myWally.plot_robot(2,cur_fig);
%     axis off
%     [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
% %     pause(.2)
%     frame(i) = getframe(cur_fig);
%     delete(handles1); 
% %     delete(handles2);
% end

%% Plot path
% handles1 = []; handles2 = [];
% cur_fig = myWall.plot_wall();
% % scatter(TORSO_ABS(1),TORSO_ABS(2),'BLUE');
% scatter(final_hold(1),final_hold(2),'RED');
% 
% for i = 1:size(path,1)
%     myWally = myWally.set_hands_ABS(path{i,1});
%     myWally = myWally.set_TORSO_ABS(path{i,2});
%     myWally = myWally.ik_hands_ABS();
%     [cur_fig, handles1] = myWally.plot_robot(2,cur_fig);
%     [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
%     pause(.2)
%     frame(i) = getframe(cur_fig);
%     delete(handles1); delete(handles2);
% end

%% Plot chk_path
% handles1 = []; handles2 = [];
% cur_fig = myWall.plot_wall();
% scatter(TORSO_ABS(1),TORSO_ABS(2),'BLUE');
% scatter(final_hold(1),final_hold(2),'RED');
% 
% for i = 1:size(chunked_path,1)
%     myWally = myWally.set_hands_ABS(chunked_path{i,1});
%     myWally = myWally.set_TORSO_ABS(chunked_path{i,2});
%     myWally = myWally.ik_hands_ABS();
%     [cur_fig, handles1] = myWally.plot_robot(2,cur_fig);
%     [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
%     pause(.001)
%     frame(i) = getframe(cur_fig);
%     delete(handles1); delete(handles2);
% end

%% Plot chk_path_coms
% handles1 = []; handles2 = []; handles3 = []; handles4 = [];
% cur_fig = myWall.plot_wall();
% scatter(TORSO_ABS(1),TORSO_ABS(2),'BLUE');
% scatter(final_hold(1),final_hold(2),'RED');
% %Set to the initial position
% myWally = myWally.set_TORSO_ABS(TORSO_ABS);
% % myWally = myWally.set_hands_ABS(hands_ABS);
% % myWally = myWally.ik_hands_ABS();
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
%     [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
%     [cur_fig, handles1] = myWally.plot_robot(2,cur_fig);
%     frame(i) = getframe(cur_fig);
%     delete(handles1); delete(handles2); delete(handles3); delete(handles4);
% end

%% Plot the available children returned
% handles1 = []; handles2 = [];
% cur_fig = myWall.plot_wall();
% 
% for i = 1:size(ws1,1)
%     scatter(ws1(i,1),ws1(i,2),'RED');
% end
% 
% for i = 1:size(children,1)
%     myWally = myWally.set_hands_ABS(children{i,1});
%     myWally = myWally.set_TORSO_ABS(children{i,2});
%     myWally = myWally.ik_hands_ABS();
%     [cur_fig, handles1] = myWally.plot_robot(2,cur_fig);
%     [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
%     pause(.1)
%     frame(i) = getframe(cur_fig);
%     delete(handles1); delete(handles2);
% end

%% Plot local workspace
% [cur_fig = myWally.plot_robot(2,cur_fig);
% [cur_fig, handles2] = myWally.plot_ws_body(2,cur_fig);
% cur_fig = myWally.plot_ws_body(1,ws2);

% cur_fig = myWally.plot_robot(2,cur_fig);
% cur_fig = myWally.plot_ws_body(3,cur_fig, ws1);
% cur_fig = myWally.plot_ws_body(3,cur_fig, ws2);

%% Plot holds searched
% hold on
% % scatter(f_holds(:,1),f_holds(:,2),'RED')
% handle = [];
% for i = 1:size(near_holds,1)
%     handle(1) = scatter(near_holds(i,1),near_holds(i,5),100,'BLUE','filled');
%     handle(2) = scatter(near_holds(i,2),near_holds(i,6),100,'RED','filled');
%     handle(3) = scatter(near_holds(i,3),near_holds(i,7),100,'BLACK','filled');
%     handle(4) = scatter(near_holds(i,4),near_holds(i,8),100,'YELLOW','filled');
%     pause(.2);
%     frame(i) = getframe(cur_fig);
%     delete(handle)
%     i
% end

%% Around Town
% last_body = myWally.get_TORSO_ABS;
% Q = [];
% cur_fig = myWally.plot_robot(1);
% for i = 1:1:240
%     last_body(2) = last_body(2)+.07*sin(i/60*2*pi);
%     last_body(1) = last_body(1)+.07*cos(i/60*2*pi);
%     myWally = myWally.set_TORSO_ABS(last_body);
%     myWally = myWally.ik_hands_TORSO();
%     cur_fig = myWally.plot_robot(2,cur_fig);
%     cur_fig = myWally.plot_ws_body(2,cur_fig);
%     pause(.001)
%     Q(i,:) = myWally.get_Q;
% end

%% Wiggle
% cur_fig = myWally.plot_robot(1);
% last_body = [0 0 0];
% for i = 1:120
%     if i<15
%         last_body(3) = last_body(3)+pi/120;
%     elseif i<45
%         last_body(3) = last_body(3)-pi/120;
%     elseif i<75
%         last_body(3) = last_body(3)+pi/120;
%     elseif i<105
%         last_body(3) = last_body(3)-pi/120;
%     else
%         last_body(3) = last_body(3)+pi/120;
%     end
%     myWally = myWally.set_TORSO_ABS(last_body);
%     myWally = myWally.ik_hands_TORSO();
%     cur_fig = myWally.plot_robot(2,cur_fig);
%     cur_fig = myWally.plot_ws_body(2,cur_fig);
%     pause(.001)
%     Q(i,:) = myWally.get_Q;
% end

%% Make a movie
% v = VideoWriter('full_climb4.mp4','MPEG-4');open(v);writeVideo(v,frame);close(v);
