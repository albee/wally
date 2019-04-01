% Run a simulation of wally

%% Setup
clc
clear
close all

%Input parameters
%M: [m1A m1B m1C m1D m2A m2B m2C m2D]
%m1A: mass, first limb A (kg)
%m1B: mass, first limb B (kg)
%m1C: mass, first limb C (kg)
%m1D: mass, first limb D (kg)
%m2A: mass, second limb A (kg)
%m2B: mass, second limb B (kg)
%m2C: mass, second limb C (kg)
%m2D: mass, second limb D (kg)
m1A = 1;
m1B = 1;
m1C = 1;
m1D = 1;
m2A = 1;
m2B = 1;
m2C = 1;
m2D = 1;
M = [m1A m1B m1C m1D m2A m2B m2C m2D];

%L: [l1A l1B l1C l1D l2A l2B l2C l2D]
%l1A: length, first limb A (m)
%l1B: length, first limb B (m)
%l1C: length, first limb C (m)
%l1D: length, first limb D (m)
%l2A: length, second limb A (m)
%l2B: length, second limb B (m)
%l2C: length, second limb C (m)
%l2D: length, second limb D (m)
l1A = 1;
l1B = 1;
l1C = 1;
l1D = 1;
l2A = 1;
l2B = 1;
l2C = 1;
l2D = 1;
L = [l1A l1B l1C l1D l2A l2B l2C l2D];

%I: [I1A I1B I1C I1D I2A I2B I2C I2D]
%I1A: length, first limb A (kg-m2)
%I1B: length, first limb B (kg-m2)
%I1C: length, first limb C (kg-m2)
%I1D: length, first limb D (kg-m2)
%I2A: length, second limb A (kg-m2)
%I2B: length, second limb B (kg-m2)
%I2C: length, second limb C (kg-m2)
%I2D: length, second limb D (kg-m2)
I1A = 1;
I1B = 1;
I1C = 1;
I1D = 1;
I2A = 1;
I2B = 1;
I2C = 1;
I2D = 1;
I = [I1A I1B I1C I1D I2A I2B I2C I2D];

%limb_base_R: [xA xB xC xD yA yB yC yD]
xA = -.5;
xB = .5;
xC = .5;
xD = -.5;
yA = .5;
yB = .5;
yC = -.5;
yD = -.5;
shoulders_TORSO = [xA xB xC xD yA yB yC yD];

%Q: [q1A q1B q1C q1D q2A q2B q2C q2D]
%q1A: joint angle, first limb A (rad)
%q1B: joint angle, first limb B (rad)
%q1C: joint angle, first limb C (rad)
%q1D: joint angle, first limb D (rad)
%q2A: joint angle, second limb A (rad)
%q2B: joint angle, second limb B (rad)
%q2C: joint angle, second limb C (rad)
%q2D: joint angle, second limb D (rad)
q1A = 135/180*pi;
q1B = 45/180*pi;
q1C = -45/180*pi;
q1D = -135/180*pi;
q2A = 0;
q2B = 0;
q2C = 0;
q2D = 0;
Q = [q1A q1B q1C q1D q2A q2B q2C q2D];

%QD: [qd1A qd1B qd1C qd1D qd2A qd2B qd2C qd2D]
%qd1A: joint angle, first limb A (rad/s)
%qd1B: joint angle, first limb B (rad/s)
%qd1C: joint angle, first limb C (rad/s)
%qd1D: joint angle, first limb D (rad/s)
%qd2A: joint angle, second limb A (rad/s)
%qd2B: joint angle, second limb B (rad/s)
%qd2C: joint angle, second limb C (rad/s)
%qd2D: joint angle, second limb D (rad/s)
qd1A = 0;
qd1B = 0;
qd1C = 0;
qd1D = 0;
qd2A = 0;
qd2B = 0;
qd2C = 0;
qd2D = 0;
QD = [qd1A qd1B qd1C qd1D qd2A qd2B qd2C qd2D];

%EE_limbs_R: [xA xB xC xD yA yB yC yD]
%xA: x position in robot frame, limb A (m)
%xB: x position in robot frame, limb B (m)
%xC: x position in robot frame, limb C (m)
%xD: x position in robot frame, limb D (m)
%yA: y position in robot frame, limb A (m)
%yB: y position in robot frame, limb B (m)
%yC: y position in robot frame, limb C (m)
%yD: y position in robot frame, limb D (m)
xA = -.9;
xB = 1.2;
xC = .5;
xD = -1.1;
yA = 1.5;
yB = 1.7;
yC = -1.6;
yD = -1;
hands_TORSO = [xA xB xC xD yA yB yC yD];

xbody = 0;
ybody = 0;
theta = 0/180*pi;
TORSO_ABS = [xbody ybody theta];

%% Run

%set properties and IC of stumpy
% myWally = wally(M, L, I, limb_base_R);
% myWally = myWally.setEE_body(EE_body);
% myWally = myWally.setEE_limbs(EE_limbs);
% myWally = myWally.ik_body();
% myWally.plot_robot()
% myWally = myWally.setEE_body([0 0 0]);
% myWally = myWally.ik_body();
% myWally.plot_robot()

% animate wally climbing
myWally = wally(M, L, I, shoulders_TORSO);

%%Dynamics Test
% myWally.dynamics()

%% Trajectories
% Climb straight up
% body_start = [0 -1 0];
% 
% myWally = myWally.setEE_body(body_start);
% myWally = myWally.setEE_limbs_R(EE_limbs_R);
% myWally = myWally.ik_body();
% frame(1) = getframe(myWally.plot_robot(0));
% 
% for i= 1:1:5
%     %move up
%     for i = 1:13
%         last_body = myWally.getEE_body;
%         last_body(2) = last_body(2)+.1;
%         myWally = myWally.setEE_body(last_body);
%         myWally = myWally.ik_body();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('Up complete...');
% 
%     % EE_limbs_R = [xA xB xC xD yA yB yC yD];
%     %move A
%     for i = 1:13
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(5) = last_limbs(5)+.1;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('A complete...');
% 
%     %move B
%     for i = 1:13
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(6) = last_limbs(6)+.1;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('B complete...');
% 
%     %move C
%     for i = 1:13
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(7) = last_limbs(7)+.1;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('C complete...');
% 
%     %move D
%     for i = 1:13
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(8) = last_limbs(8)+.1;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('D complete...');
% end

% Climb sideways
body_start = [0 0 0];

myWally = myWally.set_TORSO_ABS(body_start);
myWally = myWally.set_hands_TORSO(hands_TORSO);
myWally = myWally.ik_body();
frame(1) = getframe(myWally.plot_robot(0));
% 
% for i= 1:1:9
%     %move up
%     for i = 1:10
%         last_body = myWally.getEE_body;
%         last_body(2) = last_body(2)+.05;
%         last_body(1) = last_body(1)+.05;
%         myWally = myWally.setEE_body(last_body);
%         myWally = myWally.ik_body();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('Up complete...');
% 
%     % EE_limbs_R = [xA xB xC xD yA yB yC yD];
%     %move A
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(5) = last_limbs(5)+.05;
%         last_limbs(1) = last_limbs(1)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('A complete...');
% 
%     %move B
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(6) = last_limbs(6)+.05;
%         last_limbs(2) = last_limbs(2)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('B complete...');
% 
%     %move C
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(7) = last_limbs(7)+.05;
%         last_limbs(3) = last_limbs(3)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('C complete...');
% 
%     %move D
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(8) = last_limbs(8)+.05;
%         last_limbs(4) = last_limbs(4)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('D complete...');
% end
% 
%circle body
    last_body = myWally.get_TORSO_ABS;
    for i = 1:1:120
        last_body(2) = last_body(2)+.08*sin(i/30*2*pi);
        last_body(1) = last_body(1)+.08*cos(i/30*2*pi);
        myWally = myWally.set_TORSO_ABS(last_body);
        myWally = myWally.ik_body();
        frame = [frame getframe(myWally.plot_robot(0))];
        i
    end
    disp('Circle complete...'); 
 movie2avi(frame,'climb_new');
% %wiggle body
%     %move C and D down

%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(7) = last_limbs(7)-.05;
%         last_limbs(8) = last_limbs(8)-.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('C and D down...');

% last_body = myWally.getEE_body;
% for i = 1:60
%     if i<10
%         last_body(3) = last_body(3)+pi/60;
%     elseif i<30
%         last_body(3) = last_body(3)-pi/60;
%     elseif i<45
%         last_body(3) = last_body(3)+pi/60;
%     elseif i<55
%         last_body(3) = last_body(3)-pi/60;
%     else
%         last_body(3) = last_body(3)+pi/60;
%     end
%     myWally = myWally.setEE_body(last_body);
%     myWally = myWally.ik_body();
%     frame = [frame getframe(myWally.plot_robot(0))];
%     i
% end
% disp('Wiggle complete...');
%     %move C and D up
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(7) = last_limbs(7)+.05;
%         last_limbs(8) = last_limbs(8)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
% disp('C and D down');
% 
% for i= 1:1:8
%     %move up
%     for i = 1:10
%         last_body = myWally.getEE_body;
%         last_body(2) = last_body(2)+.05;
%         last_body(1) = last_body(1)+.05;
%         myWally = myWally.setEE_body(last_body);
%         myWally = myWally.ik_body();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('Up complete...');
% 
%     % EE_limbs_R = [xA xB xC xD yA yB yC yD];
%     %move A
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(5) = last_limbs(5)+.05;
%         last_limbs(1) = last_limbs(1)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('A complete...');
% 
%     %move B
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(6) = last_limbs(6)+.05;
%         last_limbs(2) = last_limbs(2)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('B complete...');
% 
%     %move C
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(7) = last_limbs(7)+.05;
%         last_limbs(3) = last_limbs(3)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('C complete...');
% 
%     %move D
%     for i = 1:10
%         last_limbs = myWally.getEE_limbs_R;
%         last_limbs(8) = last_limbs(8)+.05;
%         last_limbs(4) = last_limbs(4)+.05;
%         myWally = myWally.setEE_limbs_R(last_limbs);
%         myWally = myWally.ik_limbs();
%         frame = [frame getframe(myWally.plot_robot(0))];
%     end
%     disp('D complete...');
% end
% movie2avi(frame,'climb_new');