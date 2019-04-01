% % Neutral angles, change CONFIG to [-1,1,-1,1]
% OFFSET1 = 10;
% OFFSET2 = 100;
% s_na = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
%                    -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
% 
% %Nomral              
% OFFSET1 = 25;
% OFFSET2 = 120;
% check_angles = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
%                    -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;

function move_prefs = calc_move_prefs()
    %Create suggestions for WALLY moves
    %Normal              
    OFFSET1 = 25;
    OFFSET2 = 120;
    normal = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                   -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
    
    %N
    OFFSET1 = 40;
    OFFSET2 = 35;
    OFFSET3 = 60;
    OFFSET4 = -110;
    N = [180-OFFSET1, OFFSET1, OFFSET2, 180-OFFSET2,...
                       -OFFSET3, OFFSET3, OFFSET4, -OFFSET4]/180*pi;
    %S
    OFFSET1 = -35;
    OFFSET2 = -40;
    OFFSET3 = 110;
    OFFSET4 = -60;
    S = [180-OFFSET1, OFFSET1, OFFSET2, 180-OFFSET2,...
                       -OFFSET3, OFFSET3, OFFSET4, -OFFSET4]/180*pi;
    %E             
    OFFSET1 = 45;
    OFFSET2 = 25;
    OFFSET3 = 110;
    OFFSET4 = 30;
    E = [180-OFFSET1, OFFSET2, -OFFSET2, 180+OFFSET1,...
                       -OFFSET3, OFFSET4, -OFFSET4, OFFSET3]/180*pi;
    %W                          
    OFFSET1 = 25;
    OFFSET2 = 45;
    OFFSET3 = 30;
    OFFSET4 = 110;
    W = [180-OFFSET1, OFFSET2, -OFFSET2, 180+OFFSET1,...
                       -OFFSET3, OFFSET4, -OFFSET4, OFFSET3]/180*pi;

    %Diags              
    OFFSET1 = 25;
    OFFSET2 = 100;
    diags = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
    move_prefs = [N;diags;E;diags;S;diags;W;diags];
%     move_prefs = [neutral;neutral;neutral;neutral;neutral;neutral;neutral;neutral];
end