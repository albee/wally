% Run a simulation of wally

%% Setup
clc
clear
close all

%Input parameters
%M: [m1A m1B m1C m1D m2A m2B m2C m2D]
M = [1 1 1 1 1 1 1 1];

%L: [l1A l1B l1C l1D l2A l2B l2C l2D]
L = [3 3 3 3 3 3 3 3];

%I: [I1A I1B I1C I1D I2A I2B I2C I2D]
I = [1 1 1 1 1 1 1 1];

%shoulders_TORSO: [xA xB xC xD yA yB yC yD]
shoulders_TORSO = [-2 2 2 -2 2 2 -2 -2];

%Q: [q1A q1B q1C q1D q2A q2B q2C q2D]
Q = [135/180*pi,45/180*pi,-45/180*pi,-135/180*pi,0,0,0,0];

%QD: [qd1A qd1B qd1C qd1D qd2A qd2B qd2C qd2D]
QD = [1 1 1 1 1 1 1 1];

%hands_TORSO: [xA xB xC xD yA yB yC yD]
hands_TORSO = [-10 10 10 -10 10 10 -10 -10];

%TORSO_ABS: [x y theta]
TORSO_ABS = [0 0 0/180*pi];

%s_neutral_angle: [sna1, sna2, sna3, sna4, sna5, sna6, sna7, sna8] (rad)
OFFSET1 = -20;
OFFSET2 = 120;
s_na = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                   -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
 
%s_range: [minimum angle from sna, CW (deg), maximum angle from sna, CW
%(rad)
s_range = [-75, 75]/180*pi;

%% Run Limb Workspace Eval

% %set properties and IC of WALLY
% myWally = wally(M, L, I, shoulders_TORSO); % initialize WALLY
% myWally = myWally.set_TORSO_ABS(TORSO_ABS); % set WALLY's torso state
% myWally = myWally.set_Q(Q); % set WALLY's joint angles
% myWally = myWally.fk_hands(); % calculate WALLY's hand positions
% 
% %plot WALLY workspace, then plot WALLY
% cur_fig = myWally.workspace_eval(1);

%% Run Torso Workspace Eval
%set properties and IC of WALLY
myWally = wally(M, L, I, shoulders_TORSO,s_na,s_range); % initialize WALLY
myWally = myWally.set_TORSO_ABS(TORSO_ABS); % set WALLY's torso state
holds = [-4 4 4 -4 4 4 -4 -4]; % [xA xB xC xD yA yB yC yD], hands_ABS
myWally.calc_stance_workspace_w_plot(holds);

%plot WALLY workspace, then plot WALLY
% cur_fig = myWally.workspace_eval(1);