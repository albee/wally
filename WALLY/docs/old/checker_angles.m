% % Normal angles, change CONFIG to [-1,1,-1,1]
% OFFSET1 = 10;
% OFFSET2 = 100;
% s_na = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
%                    -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
% 
% %Neutral              
% OFFSET1 = 25;
% OFFSET2 = 120;
% check_angles = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
%                    -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;

function move_prefs = calc_move_prefs()
    %Create suggestions for WALLY moves
    %N
    OFFSET1 = 25;
    OFFSET2 = 120;
    N = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2+30, OFFSET2-30, -OFFSET2-10, OFFSET2+10]/180*pi;
    %S              
    OFFSET1 = 25;
    OFFSET2 = 120;
    S = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2-10, OFFSET2+10, -OFFSET2+30, OFFSET2-30]/180*pi;
    %E             
    OFFSET1 = 10;
    OFFSET2 = 90;
    E = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2-40, OFFSET2, -OFFSET2, OFFSET2+40]/180*pi;
    %W             
    OFFSET1 = 10;
    OFFSET2 = 90;
    W = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2, OFFSET2+40, -OFFSET2-40, OFFSET2]/180*pi;

    %Diags              
    OFFSET1 = 15;
    OFFSET2 = 120;
    diags = [180-OFFSET1, OFFSET1, -OFFSET1, 180+OFFSET1,...
                       -OFFSET2, OFFSET2, -OFFSET2, OFFSET2]/180*pi;
    move_prefs = [N;diags;E;diags;S;diags;W;diags];
end