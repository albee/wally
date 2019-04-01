function [myWally, myWall, start_node] = prep_open_loop(hands_ABS, holds, final_hold, width, height)
    %% WALLY Params
    
    % clc; clear; close all

    %L: [l1A l1B l1C l1D l2A l2B l2C l2D]
    L = [4 4 4 4 4 4 4 4];

    %shoulders_TORSO: [xA xB xC xD yA yB yC yD]
    shoulders_TORSO = [-2 2 2 -2 2 2 -2 -2];

    %Q: [q1A q1B q1C q1D q2A q2B q2C q2D]
    Q = [135/180*pi,45/180*pi,-45/180*pi,-135/180*pi,0,0,0,0]; %---NOT CURRENTLY USED, ANGLES AREN'T READ

    %hands_TORSO: [xA xB xC xD yA yB yC yD] %---GET THIS FROM CV

    %TORSO_ABS: [x y theta] %---GET THIS FROM CV

    %s_neutral_angle: [sna1, sna2, sna3, sna4, sna5, sna6, sna7, sna8] (rad)
    %inner limb neutral angles relative to horiz, out limb neutral angles
    %relative to inner limb x-axis. All range 0 to 2pi.
    %CONFIG for normal WALLY is [-1,1,-1,1].
    OFFSET1 = 10;
    OFFSET2 = 0;
    s_na = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;

    %s_range: [2xn] of [min;max] of angles(rad) [q1A, ... q1D; q2A, ... q2D]
    %max is always positive, min is always negative. Adheres to s_na angle convention
%     s_range = [-70, -70, -70, -70, -140, 0, -140, 0;
%                 70, 70, 70, 70, 0, 140, 0, 140]/180*pi;
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

    %check_angles: for plotting tester only %---NOT CURRENTLY USED        
    OFFSET1 = 10;
    OFFSET2 = 100;
    check_angles = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;

    %% Wall Params
    %Generate a wall to climb
    %final_hold: final goal for a hand to reach [x_ABS, y_ABS] %---GET THIS FROM CV

%     num_handholds = 200; % number of handholds if random wall
%     width = 48; % width
%     height = 96; % height
%     num_width = 10; % number width holds
%     num_height = 22; % number height holds
%     width_space = 4; %width space between holds, in
%     height_space = 4; %height space between holds, in
%     offset = 4; %exterior spacing
    %info = {} %make this one something else if want to make unique wall
    
    info = {holds, width, height};% create from CV or picture

    %% Generate wall, WALLY, and w_node

    %Create wall with final_hold
    myWall = wall(info, final_hold);

    %Create WALLY
    hands_ABS = [hands_ABS(1),hands_ABS(2),hands_ABS(3),hands_ABS(4),hands_ABS(5),hands_ABS(6),hands_ABS(7),hands_ABS(8)];
    TORSO_ABS = [mean(hands_ABS(1:4)), mean([hands_ABS(5:8)]), 0];
    myWally = wally(L, shoulders_TORSO, s_na, s_range, move_prefs, CONFIG);
    myWally = myWally.set_TORSO_ABS(TORSO_ABS); %adjust shoulders_ABS to TORSO_ABS
    myWally = myWally.set_hands_ABS(hands_ABS);
    myWally = myWally.ik_hands_ABS();

    assignin('base','TORSO_ABS',TORSO_ABS)
    assignin('base','hands_ABS',hands_ABS)
    assignin('base','hands_TORSO',myWally.get_hands_TORSO)
    assignin('base','final_hold',final_hold)

    %Create w_node
    start_node = w_node(myWally.get_hands_ABS, myWally.get_TORSO_ABS, null(1), 0, 0, 0, 0);
end