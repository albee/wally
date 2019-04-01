classdef wally
%WALLY's kinematics/dynamics information and utilities

% set properties of wally
properties
    move_prefs
    %move_prefs: [8x8] of suggested holds_TORSO in the order N,NE,E,SE,S,SW,W,NW
    
    CONFIG = [-1,1,-1,1];
    %CONFIG: Configuration of A,B,C, and D. -1 is left-facing, 1 is right-facing
    
    L
    %L: [l1A l1B l1C l1D l2A l2B l2C l2D]

    %l1A: length, first limb A (cm)
    %l1B: length, first limb B (cm)
    %l1C: length, first limb C (cm)
    %l1D: length, first limb D (cm)
    %l2A: length, second limb A (cm)
    %l2B: length, second limb B (cm)
    %l2C: length, second limb C (cm)
    %l2D: length, second limb D (cm)
    
    shoulders_TORSO
    %shoulders_TORSO: [xA xB xC xD yA yB yC yD]
    %xA: position of limb A joint 1 in TORSO frame, x (cm)
    %xB: position of limb B joint 1 in TORSO frame, x (cm)
    %xC: position of limb C joint 1 in TORSO frame, x (cm)
    %xD: position of limb D joint 1 in TORSO frame, x (cm)
    %yA: position of limb A joint 1 in TORSO frame, y (cm)
    %yB: position of limb B joint 1 in TORSO frame, y (cm)
    %yC: position of limb C joint 1 in TORSO frame, y (cm)
    %yD: position of limb D joint 1 in TORSO frame, y (cm)
    
    s_na % Neutral angle of the servos, measured CW from the 
    %horizontal for the shoulder and CW from the upper arm for the elbow.
    %s_neutral_angle: [sna1A, sna1B, sna1C, sna1D, sna2A, sna2B, sna2C,
    %sna2D] (rad). All range [0 2*pi].
    
    s_range % Servo range, measured about the neutral angle
    %s_range: [minimum angle from sna CW inner(deg), maximum angle from sna CW inner, "outer, "outer]
    %(rad).
end

% private properties of wally
properties (Access = private)    
    Q
    %Q: [q1A q1B q1C q1D q2A q2B q2C q2D], range: [0,2*pi]

    %q1A: joint angle, first limb A (rad)
    %q1B: joint angle, first limb B (rad)
    %q1C: joint angle, first limb C (rad)
    %q1D: joint angle, first limb D (rad)
    %q2A: joint angle, second limb A (rad)
    %q2B: joint angle, second limb B (rad)
    %q2C: joint angle, second limb C (rad)
    %q2D: joint angle, second limb D (rad)
    
    hands_TORSO % end effector position in TORSO frame
    %hands_TORSO: [xA xB xC xD yA yB yC yD]
    %xA: x position in TORSO frame, limb A (m)
    %xB: x position in TORSO frame, limb B (m)
    %xC: x position in TORSO frame, limb C (m)
    %xD: x position in TORSO frame, limb D (m)
    %yA: y position in TORSO frame, limb A (m)
    %yB: y position in TORSO frame, limb B (m)
    %yC: y position in TORSO frame, limb C (m)
    %yD: y position in TORSO frame, limb D (m)

    hands_ABS % EE positions in absolute frame
    %hands_ABS: [xA xB xC xD yA yB yC yD]
    %xA: x position in absolute frame, limb A (m)
    %xB: x position in absolute frame, limb B (m)
    %xC: x position in absolute frame, limb C (m)
    %xD: x position in absolute frame, limb D (m)
    %yA: y position in absolute frame, limb A (m)
    %yB: y position in absolute frame, limb B (m)
    %yC: y position in absolute frame, limb C (m)
    %yD: y position in absolute frame, limb D (m)

    TORSO_ABS % body frame in absolute frame
    %TORSO_ABS: [x y theta]
    %x: x position in absolute frame
    %y: y position in absolute frame
    %theta: orientation in absolute frame

    ABS % Absolute origin. The body is specified in these coordinates
    %ABS: (absolute x, absolute y)
end

methods  
    % constructor
    function this = wally(L, shoulders_TORSO, s_na, s_range, move_prefs, CONFIG)
        if nargin > 0
            this.L = L;
            this.shoulders_TORSO = shoulders_TORSO;
            this.ABS = [0,0];
            this.s_na = s_na;
            this.s_range = s_range;
            this.move_prefs = move_prefs;
            this.CONFIG = CONFIG;
        end
    end

    % setter
    function this = set_Q(this,value)
        this.Q = value;
    end

    function this = set_TORSO_ABS(this,value)
        this.TORSO_ABS = value;
    end

    function this = set_hands_TORSO(this,value)
        % If hands_TORSO is updated, hands_ABS is also updated
        this.hands_TORSO = value;
        this.hands_ABS = this.calc_TORSO_to_ABS(value);
    end

    function this = set_hands_ABS(this,value)
        % If hands_ABS is updated, hands_TORSO is also updated
        this.hands_ABS = value;
        this.hands_TORSO = this.calc_ABS_to_TORSO(value);
    end

    % getter
    function Q = get_Q(this)
        Q = this.Q;
    end

    function TORSO_ABS = get_TORSO_ABS(this)
        TORSO_ABS = this.TORSO_ABS;
    end

    function hands_TORSO = get_hands_TORSO(this)
        hands_TORSO = this.hands_TORSO;
    end

    function hands_ABS = get_hands_ABS(this)
        hands_ABS = this.hands_ABS;
    end

    % kinematics
    function this = fk_hands(this)
        % Given Q, find hands_TORSO and hands_ABS
        l1A = this.L(1); l1B = this.L(2); l1C = this.L(3); l1D = this.L(4); l2A = this.L(5); l2B = this.L(6); l2C = this.L(7); l2D = this.L(8);
        q1A = this.Q(1); q1B = this.Q(2); q1C = this.Q(3); q1D = this.Q(4); q2A = this.Q(5); q2B = this.Q(6); q2C = this.Q(7); q2D = this.Q(8);

        % A
        EE(1) = l1A*cos(q1A) + l2A*cos(q1A+q2A) + this.shoulders_TORSO(1);
        EE(5) = l1A*sin(q1A) + l2A*sin(q1A+q2A) + this.shoulders_TORSO(5);

        % B
        EE(2) = l1B*cos(q1B) + l2B*cos(q1B+q2B) + this.shoulders_TORSO(2);
        EE(6) = l1B*sin(q1B) + l2B*sin(q1B+q2B) + this.shoulders_TORSO(6);

        % C
        EE(3) = l1C*cos(q1C) + l2C*cos(q1C+q2C) + this.shoulders_TORSO(3);
        EE(7) = l1C*sin(q1C) + l2C*sin(q1C+q2C) + this.shoulders_TORSO(7);

        % D
        EE(4) = l1D*cos(q1D) + l2D*cos(q1D+q2D) + this.shoulders_TORSO(4);
        EE(8) = l1D*sin(q1D) + l2D*sin(q1D+q2D) + this.shoulders_TORSO(8);
        
        this.hands_TORSO = EE;
        this.hands_ABS = this.calc_TORSO_to_ABS(EE);
    end

    function this = ik_hands_TORSO(this)
        CONFIG = this.CONFIG; %configuration of A,B,C, and D. -1 is left-facing, 1 is right-facing
        
        % Given hands_TORSO, find Q
        l1A = this.L(1); l1B = this.L(2); l1C = this.L(3); l1D = this.L(4); l2A = this.L(5); l2B = this.L(6); l2C = this.L(7); l2D = this.L(8);
        xA = this.hands_TORSO(1) - this.shoulders_TORSO(1); xB = this.hands_TORSO(2) - this.shoulders_TORSO(2); xC = this.hands_TORSO(3) - this.shoulders_TORSO(3); xD = this.hands_TORSO(4) - this.shoulders_TORSO(4); yA = this.hands_TORSO(5) - this.shoulders_TORSO(5); yB = this.hands_TORSO(6) - this.shoulders_TORSO(6); yC = this.hands_TORSO(7) - this.shoulders_TORSO(7); yD = this.hands_TORSO(8) - this.shoulders_TORSO(8);
        sna = this.s_na;
        sr =  this.s_range;
        
        %A
        D = (xA^2 + yA^2 - l1A^2 - l2A^2) / (2*l1A*l2A);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_ABS = NaN; return;
        end
        q2A = mod(atan2(CONFIG(1)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1A = mod(atan2(yA,xA) - atan(l2A*sin(q2A)/(l1A+l2A*cos(q2A))),2*pi);  

        %B
        D = (xB^2 + yB^2 - l1B^2 - l2B^2) / (2*l1B*l2B);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_ABS = NaN; return;
        end
        q2B = mod(atan2(CONFIG(2)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1B = mod(atan2(yB,xB) - atan(l2B*sin(q2B)/(l1B+l2B*cos(q2B))),2*pi);

        %C
        D = (xC^2 + yC^2 - l1C^2 - l2C^2) / (2*l1C*l2C);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_ABS = NaN; return;
        end
        q2C = mod(atan2(CONFIG(3)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1C = mod(atan2(yC,xC) - atan(l2C*sin(q2C)/(l1C+l2C*cos(q2C))),2*pi);

        %D
        D = (xD^2 + yD^2 - l1D^2 - l2D^2) / (2*l1D*l2D);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_ABS = NaN; return;
        end
        q2D = mod(atan2(CONFIG(4)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1D = mod(atan2(yD,xD) - atan(l2D*sin(q2D)/(l1D+l2D*cos(q2D))),2*pi);
        
        % Check if the sol'n exceeds range of motion (must check in two different ways because of modulo)
        %sr(2,~) is max, sr(1,~) is min
        Q = [q1A q1B q1C q1D q2A q2B q2C q2D];
        
        for i = 1:8
            %check while the maximum is greater in mod(2*pi)
            if (mod(sna(i)+sr(2,i),2*pi) > mod(sna(i)+sr(1,i),2*pi)) && (Q(i) > mod(sna(i)+sr(2,i),2*pi) || Q(i) < mod(sna(i)+sr(1,i),2*pi))
                this.Q = NaN; return;
            %check while the minimum is greater in mod(2*pi)
            elseif (mod(sna(i)+sr(2,i),2*pi) < mod(sna(i)+sr(1,i),2*pi)) && (Q(i) > mod(sna(i)+sr(2,i),2*pi) && Q(i) < mod(sna(i)+sr(1,i),2*pi))
                this.Q = NaN; return;
            end
        end
        
        this.Q = Q;
        
        % Check if the sol'n has limb collision
        if q1B > 3*pi/2 && q1C < pi/2 && -(q1B-2*pi) + q1C > 30/180*pi
            this.Q = NaN; return;
        elseif 3*pi/2 > q1A && q1A > pi &&  pi > q1D && q1D > pi/2 && (q1A-pi) + (pi-q1D) > 30/180*pi
            this.Q = NaN; return;
        end
%         mdpts = this.calc_midpoints();
%         if mdpts(5) < mdpts(8) || mdpts(6) < mdpts(7)
%             this.Q = NaN; return;
%         end;
        
        this.hands_TORSO = this.calc_ABS_to_TORSO(this.hands_ABS);
    end
    
    function this = ik_hands_ABS(this)
        %Given TORSO_ABS and hands_ABS, find Q and hands_TORSO
        CONFIG = this.CONFIG; %configuration of A,B,C, and D. -1 is left-facing, 1 is right-facing
        
        %Renaming for usability
        l1A = this.L(1); l1B = this.L(2); l1C = this.L(3); l1D = this.L(4); l2A = this.L(5); l2B = this.L(6); l2C = this.L(7); l2D = this.L(8);
        sna = this.s_na;
        sr =  this.s_range;

        shoulder_ABS = this.calc_TORSO_to_ABS(this.shoulders_TORSO);

        xA = this.hands_ABS(1) - shoulder_ABS(1); xB = this.hands_ABS(2) - shoulder_ABS(2); xC = this.hands_ABS(3) - shoulder_ABS(3); xD = this.hands_ABS(4) - shoulder_ABS(4);
        yA = this.hands_ABS(5) - shoulder_ABS(5); yB = this.hands_ABS(6) - shoulder_ABS(6); yC = this.hands_ABS(7) - shoulder_ABS(7); yD = this.hands_ABS(8) - shoulder_ABS(8);

        %A
        D = (xA^2 + yA^2 - l1A^2 - l2A^2) / (2*l1A*l2A);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_TORSO = NaN; return
        end
        q2A = mod(atan2(CONFIG(1)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1A = mod(atan2(yA,xA) - atan(l2A*sin(q2A)/(l1A+l2A*cos(q2A))) - this.TORSO_ABS(3),2*pi);

        %B
        D = (xB^2 + yB^2 - l1B^2 - l2B^2) / (2*l1B*l2B);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_TORSO = NaN; return
        end
        q2B = mod(atan2(CONFIG(2)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1B = mod(atan2(yB,xB) - atan(l2B*sin(q2B)/(l1B+l2B*cos(q2B))) - this.TORSO_ABS(3),2*pi);

        %C
        D = (xC^2 + yC^2 - l1C^2 - l2C^2) / (2*l1C*l2C);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_TORSO = NaN; return
        end
        q2C = mod(atan2(CONFIG(3)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1C = mod(atan2(yC,xC) - atan(l2C*sin(q2C)/(l1C+l2C*cos(q2C))) - this.TORSO_ABS(3),2*pi);

        %D
        D = (xD^2 + yD^2 - l1D^2 - l2D^2) / (2*l1D*l2D);
        if (1-D^2 < 0)
            this.Q = NaN; this.hands_TORSO = NaN; return
        end
        q2D = mod(atan2(CONFIG(4)*sqrt(1-D^2),D),2*pi); % only 1 possible solution, change sqrt sign for other
        q1D = mod(atan2(yD,xD) - atan(l2D*sin(q2D)/(l1D+l2D*cos(q2D))) - this.TORSO_ABS(3),2*pi);

        % Check if the sol'n exceeds range of motion (must check in two different ways because of modulo)
        Q = [q1A q1B q1C q1D q2A q2B q2C q2D];
        
        for i = 1:8
            %check while the maximum is greater in mod(2*pi)
            if (mod(sna(i)+sr(2,i),2*pi) > mod(sna(i)+sr(1,i),2*pi)) && (Q(i) > mod(sna(i)+sr(2,i),2*pi) || Q(i) < mod(sna(i)+sr(1,i),2*pi))
                this.Q = NaN; return;
            %check while the minimum is greater in mod(2*pi)
            elseif (mod(sna(i)+sr(2,i),2*pi) < mod(sna(i)+sr(1,i),2*pi)) && (Q(i) > mod(sna(i)+sr(2,i),2*pi) && Q(i) < mod(sna(i)+sr(1,i),2*pi))
                this.Q = NaN; return;
            end
        end
        
        this.Q = Q;
        
        % Check if the sol'n has limb collision
        if q1B > 3*pi/2 && q1C < pi/2 && -(q1B-2*pi) + q1C > 30/180*pi
            this.Q = NaN; return;
        elseif 3*pi/2 > q1A && q1A > pi &&  pi > q1D && q1D > pi/2 && (q1A-pi) + (pi-q1D) > 30/180*pi
            this.Q = NaN; return;
        end
%         mdpts = this.calc_midpoints();
%         if mdpts(5) < mdpts(8) || mdpts(6) < mdpts(7)
%             this.Q = NaN; return;
%         end;
        
        this.hands_TORSO = this.calc_ABS_to_TORSO(this.hands_ABS);
    end
    
    function this = ik_hands_ABS_ws(this)
        %Given TORSO_ABS and hands_ABS, find Q and hands_TORSO. Speedup for
        %calculation
        %Renaming for usability
        CONFIG = this.CONFIG; %configuration of A,B,C, and D. -1 is left-facing, 1 is right-facing
        
        l1A = this.L(1); l1B = this.L(2); l1C = this.L(3); l1D = this.L(4); l2A = this.L(5); l2B = this.L(6); l2C = this.L(7); l2D = this.L(8);
        sna = this.s_na;
        sr =  this.s_range;
        
        if this.TORSO_ABS(3) == 0
            shoulder_ABS = [this.shoulders_TORSO(1:4)+this.TORSO_ABS(1) this.shoulders_TORSO(5:8)+this.TORSO_ABS(2)];
        else
            shoulder_ABS = this.calc_TORSO_to_ABS(this.shoulders_TORSO);
        end

        xA = this.hands_ABS(1) - shoulder_ABS(1); xB = this.hands_ABS(2) - shoulder_ABS(2); xC = this.hands_ABS(3) - shoulder_ABS(3); xD = this.hands_ABS(4) - shoulder_ABS(4);
        yA = this.hands_ABS(5) - shoulder_ABS(5); yB = this.hands_ABS(6) - shoulder_ABS(6); yC = this.hands_ABS(7) - shoulder_ABS(7); yD = this.hands_ABS(8) - shoulder_ABS(8);

        DA = (xA^2 + yA^2 - l1A^2 - l2A^2) / (2*l1A*l2A);
        DB = (xB^2 + yB^2 - l1B^2 - l2B^2) / (2*l1B*l2B);
        DC = (xC^2 + yC^2 - l1C^2 - l2C^2) / (2*l1C*l2C);
        DD = (xD^2 + yD^2 - l1D^2 - l2D^2) / (2*l1D*l2D);
        if (1-DA^2 < 0) || (1-DB^2 < 0) || (1-DC^2 < 0) || (1-DD^2 < 0)
            this.Q = NaN; this.hands_TORSO = NaN; return
        end
        
        %A
        q2A = mod(atan2(CONFIG(1)*sqrt(1-DA^2),DA),2*pi); % only 1 possible solution, change sqrt sign for other
        q1A = mod(atan2(yA,xA) - atan(l2A*sin(q2A)/(l1A+l2A*cos(q2A))) - this.TORSO_ABS(3),2*pi);

        %B
        q2B = mod(atan2(CONFIG(2)*sqrt(1-DB^2),DB),2*pi); % only 1 possible solution, change sqrt sign for other
        q1B = mod(atan2(yB,xB) - atan(l2B*sin(q2B)/(l1B+l2B*cos(q2B))) - this.TORSO_ABS(3),2*pi);

        %C
        q2C = mod(atan2(CONFIG(3)*sqrt(1-DC^2),DC),2*pi); % only 1 possible solution, change sqrt sign for other
        q1C = mod(atan2(yC,xC) - atan(l2C*sin(q2C)/(l1C+l2C*cos(q2C))) - this.TORSO_ABS(3),2*pi);

        %D
        q2D = mod(atan2(CONFIG(4)*sqrt(1-DD^2),DD),2*pi); % only 1 possible solution, change sqrt sign for other
        q1D = mod(atan2(yD,xD) - atan(l2D*sin(q2D)/(l1D+l2D*cos(q2D))) - this.TORSO_ABS(3),2*pi);

        % Check if the sol'n exceeds range of motion (must check in two
        % different ways because of modulo)
        Q = [q1A q1B q1C q1D q2A q2B q2C q2D];
        
        for i = 1:8
            %check while the maximum is greater in mod(2*pi)
            if (mod(sna(i)+sr(2,i),2*pi) > mod(sna(i)+sr(1,i),2*pi)) && (Q(i) > mod(sna(i)+sr(2,i),2*pi) || Q(i) < mod(sna(i)+sr(1,i),2*pi))
                this.Q = NaN; return;
            %check while the minimum is greater in mod(2*pi)
            elseif (mod(sna(i)+sr(2,i),2*pi) < mod(sna(i)+sr(1,i),2*pi)) && (Q(i) > mod(sna(i)+sr(2,i),2*pi) && Q(i) < mod(sna(i)+sr(1,i),2*pi))
                this.Q = NaN; return;
            end
        end
        
        this.Q = Q;
        
        % Check if the sol'n has limb collision
        if q1B > 3*pi/2 && q1C < pi/2 && -(q1B-2*pi) + q1C > 30/180*pi
            this.Q = NaN; return;
        elseif 3*pi/2 > q1A && q1A > pi &&  pi > q1D && q1D > pi/2 && (q1A-pi) + (pi-q1D) > 30/180*pi
            this.Q = NaN; return;
        end
%         mdpts = this.calc_midpoints();
%         if mdpts(5) < mdpts(8) || mdpts(6) < mdpts(7)
%             this.Q = NaN; return;
%         end;
        
        this.hands_TORSO = this.calc_ABS_to_TORSO(this.hands_ABS);
    end
    
    function this = fk_TORSO(this) % WARNING: CURRENTLY ASSUMES THETA=0
        % Given Q and hands_ABS, find TORSO_ABS
        % WARNING: CURRENTLY ASSUMES THETA=0
        l1A = this.L(1); l1B = this.L(2); l1C = this.L(3); l1D = this.L(4); l2A = this.L(5); l2B = this.L(6); l2C = this.L(7); l2D = this.L(8);
        q1A = this.Q(1); q1B = this.Q(2); q1C = this.Q(3); q1D = this.Q(4); q2A = this.Q(5); q2B = this.Q(6); q2C = this.Q(7); q2D = this.Q(8);
        
        TORSO_x_ABS = this.hands_ABS(1) - (l1A*cos(q1A) + l2A*cos(q1A+q2A) + this.shoulders_TORSO(1));
        TORSO_y_ABS = this.hands_ABS(5) - (l1A*sin(q1A) + l2A*sin(q1A+q2A) + this.shoulders_TORSO(5));
        this = this.set_TORSO_ABS([TORSO_x_ABS, TORSO_y_ABS, 0]);
    end

    % path planning
    function [feasible, TORSO_workspace] = calc_stance_workspace(this, hands_ABS)
        %Calculates whether a stance is feasible given a set of four
        %handholds. Generates the stance workspace if it is feasible.
        %Stance workspace is given in discrete increments so it can be
        %compared to that of other stances. Uses WALLY servo limits and
        %neutral angles.
        %INPUT:
        %hands = 1x8 of hands_ABS
        %torso = 1x3 of TORSO_ABS
        %OUTPUT: 
        %feasible = 1 if feasible, 0 if infeasible
        %TORSO_workspace = [x,y,theta; ...] nx3 matrix of possible
        %x,y,theta coordinates

        this = this.set_hands_ABS(hands_ABS);
        
        guess_x_TORSO_ABS = mean([this.hands_ABS(1),this.hands_ABS(2),this.hands_ABS(3),this.hands_ABS(4)]);
        guess_y_TORSO_ABS = mean([this.hands_ABS(5),this.hands_ABS(6),this.hands_ABS(7),this.hands_ABS(8)]);
        min_x = this.shoulders_TORSO(1)*2.5+guess_x_TORSO_ABS;
        max_x = this.shoulders_TORSO(2)*2.5+guess_x_TORSO_ABS;
        min_y = this.shoulders_TORSO(7)*2.5+guess_y_TORSO_ABS;
        max_y = this.shoulders_TORSO(6)*2.5+guess_y_TORSO_ABS;
        
        POINTS_PER_TORSO = 10;
        uniform_dist = this.shoulders_TORSO(2)*2; %width of body
        spacing = uniform_dist/(POINTS_PER_TORSO-1); %spacing to be used for all ws calcs
        
        % Test a range of TORSO positions, currently theta = 0
        cntr = 1;
        feasible = 1;
        TORSO_workspace = [];
        
        % Ensure that points generated are on the grid so that overlapping stances are recognized
        min_x = min_x - mod(min_x,spacing); 
        min_y = min_y - mod(min_y,spacing); 
%           cur_fig = this.plot_robot(1);
        for x_TORSO = min_x:spacing:max_x;
            for y_TORSO = min_y:spacing:max_y;
                this = this.set_TORSO_ABS([x_TORSO, y_TORSO, 0]);
                this = this.ik_hands_ABS_ws();
                if  length(this.get_Q()) > 1
                    TORSO_workspace(cntr,:) = [x_TORSO, y_TORSO, 0];
                    cntr = cntr+1;
                end
%                 hold on
%                 figure(cur_fig);
%                 scatter(x_TORSO,y_TORSO,'GREEN');
%                 pause(.01);
            end
        end
        if isempty(TORSO_workspace)
            feasible = 0;
            return
        end
    end
            
    function [feasible] = calc_ws_feasible(this, hands_ABS, new_TORSO_ABS)
        %Calculates whether a stance is feasible given a set of four
        %handholds. Only needs to verify that ws contains new_TORSO_ABS. Uses WALLY servo limits and
        %neutral angles.
        %INPUT:
        %hands = 1x8 of hands_ABS
        %new_TORSO_ABS = 1x3 of new TORSO_ABS pos to verify
        %OUTPUT: 
        %feasible = 1 if feasible, 0 if infeasible
        
        this = this.set_hands_ABS(hands_ABS);
        
%         guess_x_TORSO_ABS = mean([this.hands_ABS(1),this.hands_ABS(2),this.hands_ABS(3),this.hands_ABS(4)]);
%         guess_y_TORSO_ABS = mean([this.hands_ABS(5),this.hands_ABS(6),this.hands_ABS(7),this.hands_ABS(8)]);
%         min_x = this.shoulders_TORSO(1)*1+guess_x_TORSO_ABS;
%         max_x = this.shoulders_TORSO(2)*1+guess_x_TORSO_ABS;
%         min_y = this.shoulders_TORSO(7)*1+guess_y_TORSO_ABS;
%         max_y = this.shoulders_TORSO(6)*1+guess_y_TORSO_ABS;
        
        %Test a range of TORSO positions, currently theta = 0
        feasible = 0;
%         chk_pts = [guess_x_TORSO_ABS,guess_y_TORSO_ABS; min_x,guess_y_TORSO_ABS; max_x,guess_y_TORSO_ABS;...
%                    guess_x_TORSO_ABS,min_y; guess_x_TORSO_ABS,max_y; new_TORSO_ABS(1),new_TORSO_ABS(2)];
        
        %Check 5 common points; okay if any exists; also check that this workspace contains the new_TORSO_ABS
%         cur_fig = this.plot_robot(1);
        this = this.set_TORSO_ABS(new_TORSO_ABS);
        this = this.ik_hands_ABS_ws();
        if  length(this.get_Q()) == 8 % if any point is valid, the ws is feasible
            feasible = 1;
            return
        end
%             hold on
%             figure(cur_fig);
%             scatter(chk_pts(i,1), chk_pts(i,2), 'GREEN');
%             pause(.5);
    end
    
    function [A_holds, B_holds, C_holds, D_holds] = calc_nearby_holds(this, holds_ABS, TORSO_ABS)
        %Returns the set of reasonable nearby 4-holds to search.
        %INPUT: holds = [nx2] set of all observed handholds in ABS
        %       torso = [1x3] of TORSO_ABS to search about
        %OUTPUT: X_holds = [nx2] of ABS filtered holds within X quadrant. No repeats between sets.
        %searching [xA xB xC xD yA yB yC yD]
        this = this.set_TORSO_ABS(TORSO_ABS);
        
        %Filter the set of holds to reasonable ones only (roughly, within reach)
        f_holds = []; % nx2 of holds
        diagonal = this.dist([min(this.shoulders_TORSO(2)),min(this.shoulders_TORSO(6))],[0,0]); %diagonal of body center to shoulder
        center_dist = diagonal + 1.5*(min(this.L(1:4)) + min(this.L(5:8)));
        center = [this.TORSO_ABS(1),this.TORSO_ABS(2)];
        for i = 1:size(holds_ABS,1)
            if this.dist([holds_ABS(i,1), holds_ABS(i,2)], center) < center_dist % add if less than circle of minimum distance about TORSO center
                f_holds = [f_holds; holds_ABS(i,:)]; 
            end
        end

%         scatter(f_holds(:,1),f_holds(:,2),'RED');

        %Generate suitable sets for A, B, C, D to search (partition into quadrants)
        A_holds = []; B_holds = []; C_holds = []; D_holds = [];
%         min_x = min(f_holds(:,1)); max_x = max(f_holds(:,1));
%         min_y = min(f_holds(:,2)); max_y = max(f_holds(:,2));
%         x_cut = (max_x - min_x)/2 + min_x; y_cut = (max_y - min_y)/2 + min_y;
        %--must be changed if the body is not a zero theta
        x_low_cut = this.shoulders_TORSO(1)+this.TORSO_ABS(1);
        x_high_cut = this.shoulders_TORSO(2)+this.TORSO_ABS(1);
        y_low_cut = this.shoulders_TORSO(7)+this.TORSO_ABS(2);
        y_high_cut = this.shoulders_TORSO(6)+this.TORSO_ABS(2);
        for i = 1:size(f_holds,1)
            if f_holds(i,1) < x_high_cut && f_holds(i,2) > y_low_cut
                A_holds(end+1,:) = f_holds(i,:);
            elseif f_holds(i,1) > x_low_cut && f_holds(i,2) > y_low_cut
                B_holds(end+1,:) = f_holds(i,:);
            elseif f_holds(i,1) > x_low_cut && f_holds(i,2) < y_high_cut
                C_holds(end+1,:) = f_holds(i,:);
            elseif f_holds(i,1) < x_high_cut && f_holds(i,2) < y_high_cut
                D_holds(end+1,:) = f_holds(i,:);
            end;
        end
        %Create possible sets of four
%         f_hold_set = []; % nx8 of possible 4-hold sets, generated from f_holds
%         for i = 1:size(A_f_holds,1) % A
%             A_hold = A_f_holds(i,:);
% %             if A_hold(1) > shldr(2) && A_hold(2) < shldr(8); continue; end; % check if hold is in the correct quadrant
%             for j = 1:size(B_f_holds,1) % B
%                 B_hold = B_f_holds(j,:);
%                 if B_hold(1) <= A_hold(1); continue; end; % check if hold is in the correct quadrant
%                 for k = 1:size(C_f_holds,1) % C
%                     C_hold = C_f_holds(k,:);
%                     if C_hold(2) >= B_hold(2); continue; end; % check if hold is in the correct quadrant
%                     for l = 1:size(D_f_holds,1) % D
%                         D_hold = D_f_holds(l,:);
%                         if D_hold(1) >= C_hold(1) || D_hold(2) >= A_hold(2); continue; % check if hold is in the correct quadrant
%                         else
%                             %Add to the possible hold_set
%                             f_hold_set = [f_hold_set;[A_hold(1), B_hold(1), C_hold(1), D_hold(1), A_hold(2), B_hold(2), C_hold(2), D_hold(2)]];
%                         end
%                     end
%                 end
%             end
%         end
    end
    
    function child_TORSO_ABS = calc_stance_overlap(~, parent_ws, child_ws,final_TORSO_ABS)
        %Calculates whether two given stances overlap. Uses a heuristic to
        %guess the best point of workspace overlap to output as
        %best_TORSO_ABS
        %INPUT: parent_ws = nx3 matrix of TORSO_ABS workspace
        %       child_ws = nx3 matrix of TORSO_ABS workspace
        %OUTPUT: child_TORSO_ABS = best x,y,theta of torso overlap. NaN if
        %doesn't exist.
        %
        %        dist = distance between the center of one stance and the
        %        center of another
        overlap = intersect(parent_ws, child_ws,'rows');
        if length(overlap) == 0; child_TORSO_ABS = []; return; % return empty TORSO ABS
        else % return the best overlap point
            min_dist = Inf;
            for i = 1:size(overlap,1)
                dist = sqrt((overlap(1)-final_TORSO_ABS(1))^2+(overlap(2)-final_TORSO_ABS(2))^2);
                if dist < min_dist
                    min_dist = dist;
                    child_TORSO_ABS = overlap(i,:);
                end
            end   
        end
        
    end
    
    function [new_TORSO_ABS, ideal_holds] = calc_moves(this, bound, hands_ABS, TORSO_ABS)
        %Attempt to move a few inches up, bring distance down a few times if out of range
        %INPUT: bound, TORSO_ABS
        %OUTPUT: new_TORSO_ABS: [nx3], rows go: N; NE; E; SE; S; SW; W; NW
        
        this = this.set_TORSO_ABS(TORSO_ABS);
        move = [1,2,3,4,5,6]; %works best if they're multiples of each other, smaller length=faster solving
%         move = [6,5,4,3,2,1,.5]; % move_dists: descending options for distance of move
        new_TORSO_ABS = [];
        ideal_holds = [];
 
        for i = 1:8
            switch i
                case 1 %N
                    for j = 1:length(move) % if j reaches the end and not satisfied, this is a dud move. Do not add to new_TORSO_ABS
                        new_x = this.TORSO_ABS(1);
                        new_y = this.TORSO_ABS(2)+move(j);
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                        elseif j > 1
                            new_x = this.TORSO_ABS(1);
                            new_y = this.TORSO_ABS(2)+move(j-1);
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
                case 2 %NE
                    for j = 1:length(move)
                        new_x = this.TORSO_ABS(1)+move(j)*sqrt(2)/2;
                        new_y = this.TORSO_ABS(2)+move(j)*sqrt(2)/2;
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1 
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                       elseif j > 1
                            new_x = this.TORSO_ABS(1)+move(j-1)*sqrt(2)/2;
                            new_y = this.TORSO_ABS(2)+move(j-1)*sqrt(2)/2;
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
                case 3 %E
                    for j = 1:length(move)
                        new_x = this.TORSO_ABS(1)+move(j);
                        new_y = this.TORSO_ABS(2);
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                        elseif j > 1
                            new_x = this.TORSO_ABS(1)+move(j-1);
                            new_y = this.TORSO_ABS(2);
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
                case 4 %SE
                    for j = 1:length(move)
                        new_x = this.TORSO_ABS(1)+move(j)*sqrt(2)/2;
                        new_y = this.TORSO_ABS(2)-move(j)*sqrt(2)/2;
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                        elseif j > 1
                            new_x = this.TORSO_ABS(1)+move(j-1)*sqrt(2)/2;
                            new_y = this.TORSO_ABS(2)-move(j-1)*sqrt(2)/2;
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
                case 5 %S
                    for j = 1:length(move)
                        new_x = this.TORSO_ABS(1);
                        new_y = this.TORSO_ABS(2)-move(j);
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                        elseif j > 1
                            new_x = this.TORSO_ABS(1);
                            new_y = this.TORSO_ABS(2)-move(j-1);
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
                case 6 %SW
                    for j = 1:length(move)
                        new_x = this.TORSO_ABS(1)-move(j)*sqrt(2)/2;
                        new_y = this.TORSO_ABS(2)-move(j)*sqrt(2)/2;
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                        elseif j > 1
                            new_x = this.TORSO_ABS(1)-move(j-1)*sqrt(2)/2;
                            new_y = this.TORSO_ABS(2)-move(j-1)*sqrt(2)/2;
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
                case 7 %W
                    for j = 1:length(move)
                        new_x = this.TORSO_ABS(1)-move(j);
                        new_y = this.TORSO_ABS(2);
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                        elseif j > 1
                            new_x = this.TORSO_ABS(1)-move(j-1);
                            new_y = this.TORSO_ABS(2);
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
                case 8 %NW
                    for j = 1:length(move)
                        new_x = this.TORSO_ABS(1)-move(j)*sqrt(2)/2;
                        new_y = this.TORSO_ABS(2)+move(j)*sqrt(2)/2;
                        new_theta = 0;
                        if inpolygon(new_x,new_y,bound(:,1),bound(:,2)) && this.calc_ws_feasible(hands_ABS, [new_x,new_y,new_theta])==1
                            if j == length(move)
                                new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                                ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                                break
                            else
                                continue
                            end
                        elseif j > 1
                            new_x = this.TORSO_ABS(1)-move(j-1)*sqrt(2)/2;
                            new_y = this.TORSO_ABS(2)+move(j-1)*sqrt(2)/2;
                            new_TORSO_ABS(end+1,:) = [new_x new_y new_theta];
                            ideal_holds(end+1,:) = [this.move_prefs(i,1:4)+new_x this.move_prefs(i,5:8)+new_y];
                            break
                        else
                            break
                        end
                    end
            end
        end
    end

    function good_holds = calc_good_holds(this, holds, new_TORSO_ABS, cur_hands_ABS, ideal_holds, final_hold)
        %For each new TORSO_ABS, find some feasible holds. Test if the
        %workspaces are connected. If so, accept. If not, reduce the
        %distance and try again. Do not use current holds.
        %INPUT: X_holds, new_TORSO_ABS
        %OUTPUT: good_holds, [8x8] of possible holds for the movements
        
        good_holds = [];
        RESTARTS = 1;
        
        for i = 1:size(new_TORSO_ABS,1)
            %Find handhold possibilites near this new TORSO position
            [A_holds, B_holds, C_holds, D_holds] = this.calc_nearby_holds(holds, new_TORSO_ABS(i,:));
            if isempty(A_holds) || isempty(B_holds) || isempty(C_holds) || isempty(D_holds) %keep the row all zeros if impossible
                good_holds(i,:) = zeros(1,8);
                continue
            end
            
            cntr = 0;
            while cntr <= RESTARTS
                %A
                [is_final,loc] = ismember(final_hold,A_holds,'rows');
                if is_final == 1 %immediately select final_hold if in checking distance
                    idA = loc;
                else
                    [~,idA] = min(pdist2([ideal_holds(i,1) ideal_holds(i,5)],[A_holds(:,1) A_holds(:,2)])); 
                end     
                %B
                [is_final,loc] = ismember(final_hold,B_holds,'rows');
                if is_final == 1 %immediately select final_hold if in checking distance
                    idB = loc;
                else
                    [~,idB] = min(pdist2([ideal_holds(i,2) ideal_holds(i,6)],[B_holds(:,1) B_holds(:,2)]));
                end
                %C
                [is_final,loc] = ismember(final_hold,C_holds,'rows');
                if is_final == 1 %immediately select final_hold if in checking distance
                    idC = loc;
                else
                    [~,idC] = min(pdist2([ideal_holds(i,3) ideal_holds(i,7)],[C_holds(:,1) C_holds(:,2)]));
                end
                %D
                [is_final,loc] = ismember(final_hold,D_holds,'rows');
                if is_final == 1 %immediately select final_hold if in checking distance
                    idD = loc;
                else
                    [~,idD] = min(pdist2([ideal_holds(i,4) ideal_holds(i,8)],[D_holds(:,1) D_holds(:,2)]));
                end
            
                %If not feasible, try again to get a new 4-hold-set
                cntr = cntr+1;
                tmp_holds = [A_holds(idA,1),B_holds(idB,1),C_holds(idC,1),D_holds(idD,1),A_holds(idA,2),B_holds(idB,2),C_holds(idC,2),D_holds(idD,2)];
                if length(tmp_holds) ~= 8
                        good_holds(i,:) = zeros(1,8);
                        break
                else
                    feasible = this.calc_ws_feasible(tmp_holds, new_TORSO_ABS(i,:));
                end
                if feasible == 1 %feasible, set good_holds
                    good_holds(i,:) = tmp_holds;
                    break
                elseif cntr > RESTARTS %infeasible, limit reached: set a dud row, exit next iteration
                    good_holds(i,:) = zeros(1,8);
                else %infeasible, limit not reached: try again without final_hold
                    if isempty(A_holds) || isempty(B_holds) || isempty(C_holds) || isempty(D_holds)
                        good_holds(i,:) = zeros(1,8);
                        break
                    end
                    
                    if ismember(final_hold,A_holds,'rows')
                        A_holds(idA,:) = [];
                    elseif ismember(final_hold,B_holds,'rows')
                        B_holds(idB,:) = [];
                    elseif ismember(final_hold,C_holds,'rows')
                        C_holds(idC,:) = [];
                    elseif ismember(final_hold,D_holds,'rows')
                        D_holds(idD,:) = [];
                    end
                end
            end

            %Dud move if wants to keep same handholds as before--not worth exploring other options
            if isequal(cur_hands_ABS,good_holds(i,:))
                good_holds(i,:) = zeros(1,8);
            end
            
%             ---plot tester
%             this = this.set_TORSO_ABS(new_TORSO_ABS(i,:));
%             this = this.set_hands_ABS(ideal_holds(i,:));
%             this = this.ik_hands_ABS();
%             this.plot_robot(1);
%             scatter(ideal_holds(i,1:4),ideal_holds(i,5:8),'RED')
%             scatter(good_holds(1,1:4),good_holds(1,5:8),'GREEN')
%             pause(3)
        end 
    end
        
    function children = expand_stance(this, wall, cur_node)
        %Generate 8 feasible children, given possible holds for each limb
        %and the starting TORSO_ABS. Modifies the cur_node by reference.
        %INPUT: X_holds, [nx2] of holds near that limb
        %       bound, [mx2] of x,y boundary points of current stance workspace in ABS
        %       TORSO_ABS, final_TORSO_ABS
        %OUTPUT: children, {nx4} of {[4-hold-set],[TORSO_ABS],[ws_size],[TORSO_dist]}
        
        %Unpack wall and WALLY
        this = this.set_TORSO_ABS(cur_node.TORSO_ABS);
        this = this.set_hands_ABS(cur_node.holds_ABS);
        holds = wall.holds;
        final_hold = wall.final_hold;
  
        ws1 = []; % extra info for testing
        ws2 = {}; % extra info for testing 
        
        %Compute current workspace and its boundary
        [~, cur_ws] = this.calc_stance_workspace(this.hands_ABS);
        if isempty(cur_ws); return; end %CONFLICT BETWEEN CALC_STANCE_WS AND CALC_WS_FEASIBLE
        x = cur_ws(:,1); y = cur_ws(:,2);
        k = boundary(x, y);
        bound = [x(k), y(k)];
        %If the workspace is a single point, return no children. CAN MODIFY THIS TO SEEK CHILDREN FOR SINGLE POINT
        if isempty(bound); return; end
        
        %Generate 8 directions of possible movement
        %new_TORSO_ABS: [nx3], rows go: N; NE; E; SE; S; SW; W; NW
        %ideal_holds: [nx8], rows go: N; NE; E; SE; S; SW; W; NW
        [new_TORSO_ABS, ideal_holds] = this.calc_moves(bound, this.hands_ABS, this.TORSO_ABS);
        
        %---PLOT tester
        figure()
        plot(bound(:,1),bound(:,2),'GREEN');
        axis equal
        hold on
        scatter(new_TORSO_ABS(:,1),new_TORSO_ABS(:,2),'RED')
        scatter(ideal_holds(1,1:4),ideal_holds(1,5:8),'GREEN')
        pause(1)
        disp('good_holds')
        %---PLOT tester

        %For each new TORSO_ABS, find some feasible holds 
        good_holds = this.calc_good_holds(holds, new_TORSO_ABS, this.hands_ABS, ideal_holds, final_hold); % good_holds = [8x8] of feasible next holds
        %Create a new w_node for each in children, and add it to the current w_node's child list
        for i = 1:size(good_holds,1)
            if good_holds(i,:) == zeros(1,8) %skip if a dud move
                continue
            end
            TORSO_dist = this.dist(new_TORSO_ABS(i,1:2),this.TORSO_ABS(1:2)); %h2
            h1 = this.dist([new_TORSO_ABS(i,1),new_TORSO_ABS(i,2)],[final_hold(1),final_hold(2)]);
            h2_TORSO_dist = TORSO_dist;
            h3_total_dist = cur_node.h3+h2_TORSO_dist;
            h4_total_moves = cur_node.h4+1;
            %w_node: of ([4-hold-set],[TORSO_ABS],parent_node,[h1:final_hold_found],[h2: TORSO_dist], h3, h4)
            cur_node.children{end+1} = w_node(good_holds(i,:),new_TORSO_ABS(i,:),cur_node,h1,h2_TORSO_dist,h3_total_dist, h4_total_moves);
        end  
    end
        
    function path = calc_path(this, wall, start_node)
        %Given a final goal for TORSO_ABS, compute the path up the wall
        %using A*
        %INPUT: holds, an [nx2] of available wall holds
        %final_TORSO_ABS, which is the desired final position of the TORSO
        %OUTPUT: path {nx2} where n is the path length and
        %the columns are: {[xA xB xC xD yA yB yC yD] [xTORSO,yTORSO,theta]}

        path = {};
        
        frontier = start_node;
        explored = w_node.empty;
        
        %---PLOT
        cur_fig = wall.plot_wall();
        hold on
        scatter(start_node.TORSO_ABS(1),start_node.TORSO_ABS(2),'BLUE');
        scatter(wall.final_hold(1),wall.final_hold(2),'RED');
        %---PLOT
        
        while ~isempty(frontier)
            %sort frontier list by minimum distance to goal
            dists = [];
            for i = 1:length(frontier)
                %Chose heuristics and weights carefully--different combos emphasize different motion types
                dists(i) = frontier(i).h1 + .7*frontier(i).h3; %3*frontier(i).h4; %.7*frontier(i).h3; %
%                            frontier(i).h3 +...
%                            frontier(i).h4 * 2+...
%                            frontier(i).h1;
            end
            [dists,idx] = sort(dists);
            frontier = frontier(idx);
            
            %deleteMin on frontier, add the node to explored 
            cur_node = frontier(1); frontier = frontier(2:end);
            explored(end+1) = cur_node;
            
            %---PLOT
            this = this.set_hands_ABS(cur_node.holds_ABS);
            this = this.set_TORSO_ABS(cur_node.TORSO_ABS);
            this = this.ik_hands_ABS_ws();
%             try [cur_fig, handles2] = this.plot_ws_body(2,cur_fig); catch; continue; end %catch calc_stance and ws_feasible conflict
            [cur_fig, handles1] = this.plot_robot(2,cur_fig);
            pause(.0001)
            delete(handles1); %delete(handles2);
            %---PLOT
            
            %goal test
            if this.goal_test(cur_node, wall.final_hold) == 1; 
                path=this.string_path(cur_node); 
                return
            end

            %expand the current node
            skip_child = 0;
            this.expand_stance(wall, cur_node); %~99% of computation time is here
            for i = 1:length(cur_node.children)
                child = cur_node.children{i};
                for j = 1:length(frontier) % check if in frontier
                    if isequal(child.TORSO_ABS,frontier(j).TORSO_ABS) && isequal(child.holds_ABS,frontier(j).holds_ABS)
                        skip_child = 1;
                        break
                    end
                end
                for k = 1:length(explored) % check if in explored
                    %choose on of the two, first one allows reptition of
                    %old stances
%                     if isequal(child.TORSO_ABS,explored(k).TORSO_ABS)
                    if isequal(child.TORSO_ABS,explored(k).TORSO_ABS) && isequal(child.holds_ABS,explored(k).holds_ABS)
                        skip_child = 2;
                    end
                end
                if skip_child == 0
                    frontier(end+1) = child;
                elseif skip_child == 1 % decrease key if already in frontier
                    if child.h3 < frontier(j).h3 %if new node has better h3, update the frontier
                        frontier(j) = child;
                    end
                end
                skip_child = 0;
            end
        end    
    end
    
    function is_goal = goal_test(~, cur_node, final_hold)
        %OUTPUT: is_goal: 1 if near the final TORSO_ABS, 0 otherwise
        is_goal = 0;
        holds = cur_node.holds_ABS;
        for i=1:4
%             if this.dist([cur_node.TORSO_ABS(1),cur_node.TORSO_ABS(2)],[final_hold(1),final_hold(2)]) < 2
            if isequal([holds(i),holds(i+4)], final_hold)
                is_goal = 1;
            end
        end
    end
    
    function path = string_path(~, end_node)
        %Puts together the set of stances to follow to get to the desired
        %end state
        %OUTPUT: path {nx2} where n is the path length and
        %the columns are: {[xA xB xC xD yA yB yC yD] [xTORSO,yTORSO,theta]}
        path = {};
        cur_node = end_node;

        while isempty(cur_node) ~= 1
            path{end+1,2} = cur_node.TORSO_ABS; path{end,1} = cur_node.holds_ABS;
            cur_node = cur_node.parent;
        end
        path = flip(path,1);
    end
    
    function [feasible, TORSO_workspace] = calc_stance_workspace_w_plot(this, holds, torso)
        %Calculates whether a stance is feasible given a set of four
        %handholds. Generates the stance workspace if it is feasible.
        %Stance workspace is given in discrete increments so it can be
        %compared to that of other stances. Uses WALLY servo limits and
        %neutral angles.
        %INPUT:
        %holds = 1x8 of hands_ABS
        %torso = 1x3 of TORSO_ABS
        %OUTPUT: 
        %feasible = 1 if feasible, 0 if infeasible
        %TORSO_workspace = [x,y,theta; ...] nx3 matrix of possible
        %x,y,theta coordinates
        
        % Test a range of TORSO positions, currently theta = 0
        this = this.set_hands_ABS(holds);
        this = this.set_TORSO_ABS(torso);
        min_x = min(holds(1:4)); max_x = max(holds(1:4)); min_y = min(holds(5:8)); max_y = max(holds(5:8));

        %Plotting setup
        fig_no_robot = this.plot_robot(3);
%         this.plot_robot(4,fig_no_robot);
        handles = [];
        hold on
     
        %Calculation setup
        XSPACING = 15;
        YSPACING = 15;
        cntr = 1;
        feasible = 1;
        TORSO_workspace = [];
        %TORSO_workspace = zeros(XSPACING*YSPACING,3);
        
        %Test a range of TORSO positions, currently theta = 0
        for x_TORSO = linspace(min_x,max_x,XSPACING)
            for y_TORSO = linspace(min_y,max_y,YSPACING)
                this = this.set_TORSO_ABS([x_TORSO, y_TORSO, 0]);
                this = this.ik_hands_ABS_ws();
                this.get_Q()
%                 [~, handles] = this.plot_robot(4, fig_no_robot);
                if  length(this.get_Q()) > 1
                    TORSO_workspace(cntr,:) = [x_TORSO, y_TORSO, 0];
                    
                    delete(handles)
                    figure(fig_no_robot);
                    scatter(TORSO_workspace(cntr,1),TORSO_workspace(cntr,2),'GREEN');
                    [~, handles] = this.plot_robot(2,fig_no_robot);
                    pause(.01)                    
                    %frame(cntr) = getframe(fig_no_robot);
                    
                    cntr = cntr+1;
                end
            end
        end
        if isempty(TORSO_workspace)
            feasible = 0;
            return
        end
        figure(fig_no_robot);
        x = TORSO_workspace(:,1); 
        y = TORSO_workspace(:,2);
        bound = boundary(x, y);
        plot(x(bound),y(bound),'GREEN');
        hold off
%         movie2avi(frame,'body1');
    end
    
    % communication
    function chunked_path = chunk_path(this, path)
        %Given the planned path between stances, construct intermediate
        %moves for animation/movement commands
        %OUTPUT: chunked_path {nx2} where n is the path length and
        %the columns are: {[xA xB xC xD yA yB yC yD] [xTORSO,yTORSO,theta]}
        %INPUT: path {nx2} where n is the path length and
        %the columns are: {[xA xB xC xD yA yB yC yD] [xTORSO,yTORSO,theta]}
        
        SPACING = 5;
        chunked_path = {};
        for i=1:(size(path,1)-1)
            %Move TORSO
            priority = ['A','B','D','C'];
            chunked_path(end+1,:) = path(i,:);
            start_TORSO = path{i,2}; stop_TORSO = path{i+1,2};
            inter_pts = this.linear_move(start_TORSO, stop_TORSO, SPACING);
            for j=1:size(inter_pts,1)
                chunked_path(end+1,:) = {path{i,1},[inter_pts(j,1),inter_pts(j,2),0]};
            end
            chunked_path(end+1,:) = {path{i,1},path{i+1,2}}; %stop_TORSO with the start holds
            
            %Check if any start holds and stop holds are shared: if so, set a new order for limb motion
            %Also check for hands that don't move, and remove them from chunking
            for j=1:4 %old hold
                for k =1:4 %new hold
                    if path{i+1,1}(j) == path{i,1}(k) && path{i+1,1}(j+4) == path{i,1}(k+4) && j ~= k %set new priority if overlap
                        if k==1; priority = strrep(priority,'A',''); priority = strcat('A',priority); end;
                        if k==2; priority = strrep(priority,'B',''); priority = strcat('B',priority); end;
                        if k==3; priority = strrep(priority,'C',''); priority = strcat('C',priority); end;
                        if k==4; priority = strrep(priority,'D',''); priority = strcat('D',priority); end;
                    elseif path{i+1,1}(j) == path{i,1}(k) && path{i+1,1}(j+4) == path{i,1}(k+4) && j == k %strip non-moving hands
                        if k==1; priority = strrep(priority,'A',''); end;
                        if k==2; priority = strrep(priority,'B',''); end;
                        if k==3; priority = strrep(priority,'C',''); end;
                        if k==4; priority = strrep(priority,'D',''); end;
                    end
                end
            end
            
            %Get start and stop q values
            this = this.set_hands_ABS(path{i,1}); this = this.set_TORSO_ABS(path{i+1,2}); this = this.ik_hands_ABS_ws(); %stop_TORSO with the start holds
            start_q = this.get_Q;
            this = this.set_hands_ABS(path{i+1,1}); this = this.set_TORSO_ABS(path{i+1,2}); this = this.ik_hands_ABS_ws(); %stop_TORSO with the stop holds
            stop_q = this.get_Q;
            
            %Adjust start and stop q for Q limited to [0, 2*pi]. This affects q1B and q1C. Prevents incorrect direction of movement,both CW and CCW through 0
            if stop_q(2) < start_q(2) && start_q(2) >= 3/2*pi && stop_q(2) <= pi %CCW through zero
                stop_q(2) = stop_q(2)+2*pi;
            elseif stop_q(2) > start_q(2) && start_q(2) <= pi && stop_q(2) >= 3/2*pi %CW through zero
                start_q(2) = start_q(2)+2*pi;
            end
            if stop_q(3) < start_q(3) && start_q(3) >= pi && stop_q(3) <= pi/2 %CCW through zero
                stop_q(3) = stop_q(3)+2*pi;
            elseif  stop_q(3) > start_q(3) && start_q(3) <= pi/2 && stop_q(3) >= pi %CW through zero
                start_q(3) = start_q(3)+2*pi;
            end
            
            %---plot workspace tester
%             cur_fig = this.plot_robot(1);
%             cur_fig = this.plot_ws_body(2,cur_fig);
%             figure(cur_fig);
%             hold on
%             scatter(path{i,1}(1:4),path{i,1}(5:8),'RED');
%             scatter(path{i+1,2}(1),path{i+1,2}(2),'GREEN');
            
            %Get linearly spaced q values between start and stop
            q1A = linspace(start_q(1),stop_q(1),SPACING+2); q1A = q1A(2:end);
            q2A = linspace(start_q(5),stop_q(5),SPACING+2); q2A = q2A(2:end);
            q1B = mod(linspace(start_q(2),stop_q(2),SPACING+2),2*pi); q1B = q1B(2:end);
            q2B = linspace(start_q(6),stop_q(6),SPACING+2); q2B = q2B(2:end);
            q1C = mod(linspace(start_q(3),stop_q(3),SPACING+2),2*pi); q1C = q1C(2:end);
            q2C = linspace(start_q(7),stop_q(7),SPACING+2); q2C = q2C(2:end);
            q1D = linspace(start_q(4),stop_q(4),SPACING+2); q1D = q1D(2:end);
            q2D = linspace(start_q(8),stop_q(8),SPACING+2); q2D = q2D(2:end);
            
            %Update hand values in the specified order; skip hands that don't move between stances
            tmp_Q = start_q;
            for j=1:length(priority)
                move = priority(j);
                switch move
                    case 'A'
                        [chunked_path, tmp_Q] = add_hand_moves(this, chunked_path, tmp_Q, q1A, q2A, 'A');
                    case 'B'
                        [chunked_path, tmp_Q] = add_hand_moves(this, chunked_path, tmp_Q, q1B, q2B, 'B');
                    case 'C'
                        [chunked_path, tmp_Q] = add_hand_moves(this, chunked_path, tmp_Q, q1C, q2C, 'C');
                    case 'D'
                        [chunked_path, tmp_Q] = add_hand_moves(this, chunked_path, tmp_Q, q1D, q2D, 'D');
                end
            end
        end
    end
    
    function chunked_path = chunk_path_coms(this, path)
        %Given the planned path between stances, construct intermediate
        %moves for animation/movement commands
        %OUTPUT: chunked_path [nx12] where n is the chunked path length and
        %the columns are: [q1A q1B q1C q1D q2A q2B q2C q2D emA emB, emC, emD]
        %qxx are the angles from [0 2*pi] as defined in ik, emx is 0 (off) or 1 (on)
        %INPUT: path {nx2} where n is the path length and
        %the columns are: {[xA xB xC xD yA yB yC yD] [xTORSO,yTORSO,theta]}
        
        SPACING_TORSO = 30; %number of moves between torso stances (between start to center, then again for center to final
        SPACING_ARM = 0; %number of moves between arm stances (not counting transition step)
        chunked_path = [];
        
        for i=1:(size(path,1)-1)
            %% Move TORSO
            em = [1 1 1 1];
            priority = ['A','B','D','C'];
            this = this.set_TORSO_ABS(path{i,2}); this = this.set_hands_ABS(path{i,1}); this = this.ik_hands_ABS_ws();
            chunked_path(end+1,:) = [this.Q em]; % start_TORSO
            start_TORSO = path{i,2}; stop_TORSO = path{i+1,2};
            inter_pts = this.linear_move(start_TORSO, stop_TORSO, SPACING_TORSO);
            this.get_TORSO_ABS
            this.get_hands_ABS
            for j=1:size(inter_pts,1) % intermediate TORSO motion (move to center, then to point)
                this = this.set_TORSO_ABS([inter_pts(j,1),inter_pts(j,2),0]); this = this.ik_hands_ABS_ws();
                chunked_path(end+1,:) = [this.Q em];
                this.get_TORSO_ABS
                this.get_hands_ABS
            end
            this = this.set_TORSO_ABS(path{i+1,2}); this = this.ik_hands_ABS_ws();
            chunked_path(end+1,:) = [this.Q em]; %stop_TORSO, with the start holds

            %Check if any start holds and stop holds are shared: if so, set a new order for limb motion
            %Also check for hands that don't move, and remove them from chunking
            for j=1:4 %old hold
                for k =1:4 %new hold
                    if path{i+1,1}(j) == path{i,1}(k) && path{i+1,1}(j+4) == path{i,1}(k+4) && j ~= k %set new priority if overlap
                        if k==1; priority = strrep(priority,'A',''); priority = strcat('A',priority); end;
                        if k==2; priority = strrep(priority,'B',''); priority = strcat('B',priority); end;
                        if k==3; priority = strrep(priority,'C',''); priority = strcat('C',priority); end;
                        if k==4; priority = strrep(priority,'D',''); priority = strcat('D',priority); end;
                    elseif path{i+1,1}(j) == path{i,1}(k) && path{i+1,1}(j+4) == path{i,1}(k+4) && j == k %strip non-moving hands
                        if k==1; priority = strrep(priority,'A',''); end;
                        if k==2; priority = strrep(priority,'B',''); end;
                        if k==3; priority = strrep(priority,'C',''); end;
                        if k==4; priority = strrep(priority,'D',''); end;
                    end
                end
            end
            
            %% Move Arms
            %Get start and stop q values
            this = this.set_hands_ABS(path{i,1}); this = this.set_TORSO_ABS(path{i+1,2}); this = this.ik_hands_ABS_ws(); %stop_TORSO with the start holds
            start_q = this.get_Q;
            this = this.set_hands_ABS(path{i+1,1}); this = this.set_TORSO_ABS(path{i+1,2}); this = this.ik_hands_ABS_ws(); %stop_TORSO with the stop holds
            stop_q = this.get_Q;
            
            %Adjust start and stop q for Q limited to [0, 2*pi]. This affects q1B and q1C. Prevents incorrect direction of movement,both CW and CCW through 0
            if stop_q(2) < start_q(2) && start_q(2) >= 3/2*pi && stop_q(2) <= pi %CCW through zero
                stop_q(2) = stop_q(2)+2*pi;
            elseif stop_q(2) > start_q(2) && start_q(2) <= pi && stop_q(2) >= 3/2*pi %CW through zero
                start_q(2) = start_q(2)+2*pi;
            end
            if stop_q(3) < start_q(3) && start_q(3) >= pi && stop_q(3) <= pi/2 %CCW through zero
                stop_q(3) = stop_q(3)+2*pi;
            elseif  stop_q(3) > start_q(3) && start_q(3) <= pi/2 && stop_q(3) >= pi %CW through zero
                start_q(3) = start_q(3)+2*pi;
            end
            
            %---plot workspace tester
%             cur_fig = this.plot_robot(1);
%             cur_fig = this.plot_ws_body(2,cur_fig);
%             figure(cur_fig);
%             hold on
%             scatter(path{i,1}(1:4),path{i,1}(5:8),'RED');
%             scatter(path{i+1,2}(1),path{i+1,2}(2),'GREEN');
            
            %Get linearly spaced q values between start and stop
            q1A = linspace(start_q(1),stop_q(1),SPACING_ARM+2); q1A = q1A(2:end);
            q2A = linspace(start_q(5),stop_q(5),SPACING_ARM+2); q2A = q2A(2:end);
            q1B = mod(linspace(start_q(2),stop_q(2),SPACING_ARM+2),2*pi); q1B = q1B(2:end);
            q2B = linspace(start_q(6),stop_q(6),SPACING_ARM+2); q2B = q2B(2:end);
            q1C = mod(linspace(start_q(3),stop_q(3),SPACING_ARM+2),2*pi); q1C = q1C(2:end);
            q2C = linspace(start_q(7),stop_q(7),SPACING_ARM+2); q2C = q2C(2:end);
            q1D = linspace(start_q(4),stop_q(4),SPACING_ARM+2); q1D = q1D(2:end);
            q2D = linspace(start_q(8),stop_q(8),SPACING_ARM+2); q2D = q2D(2:end);
            
            %Update hand values in the specified order; skip hands that don't move between stances
            tmp_Q = start_q;
            for j=1:length(priority)
                move = priority(j);
                switch move
                    case 'A'
                        [chunked_path, tmp_Q] = add_hand_moves_coms(this, chunked_path, tmp_Q, q1A, q2A, 'A');
                    case 'B'
                        [chunked_path, tmp_Q] = add_hand_moves_coms(this, chunked_path, tmp_Q, q1B, q2B, 'B');
                    case 'C'
                        [chunked_path, tmp_Q] = add_hand_moves_coms(this, chunked_path, tmp_Q, q1C, q2C, 'C');
                    case 'D'
                        [chunked_path, tmp_Q] = add_hand_moves_coms(this, chunked_path, tmp_Q, q1D, q2D, 'D');
                end
            end
        end
    end
    
    function chunked_path = chunk_path_plot(this, path)
        %Given the planned path between stances, construct intermediate
        %moves for animation/movement commands
        %OUTPUT: chunked_path {nx2} where n is the path length and
        %the columns are: {[xA xB xC xD yA yB yC yD] [xTORSO,yTORSO,theta]}
        %INPUT: path {nx2} where n is the path length and
        %the columns are: {[xA xB xC xD yA yB yC yD] [xTORSO,yTORSO,theta]}
        
        SPACING_TORSO = 30; %number of moves between torso stances (between start to center, then again for center to final
        SPACING_ARM = 0; %number of moves between arm stances (not counting transition step)
        chunked_path = {};
        for i=1:(size(path,1)-1)
            %Move TORSO
            priority = ['A','B','D','C'];
            chunked_path(end+1,:) = path(i,:);
            start_TORSO = path{i,2}; stop_TORSO = path{i+1,2};
            inter_pts = this.linear_move(start_TORSO, stop_TORSO, SPACING_TORSO);
            for j=1:size(inter_pts,1)
                chunked_path(end+1,:) = {path{i,1},[inter_pts(j,1),inter_pts(j,2),0]};
            end
            chunked_path(end+1,:) = {path{i,1},path{i+1,2}}; %stop_TORSO with the start holds
            
            %Check if any start holds and stop holds are shared: if so, set a new order for limb motion
            %Also check for hands that don't move, and remove them from chunking
            for j=1:4 %old hold
                for k =1:4 %new hold
                    if path{i+1,1}(j) == path{i,1}(k) && path{i+1,1}(j+4) == path{i,1}(k+4) && j ~= k %set new priority if overlap
                        if k==1; priority = strrep(priority,'A',''); priority = strcat('A',priority); end;
                        if k==2; priority = strrep(priority,'B',''); priority = strcat('B',priority); end;
                        if k==3; priority = strrep(priority,'C',''); priority = strcat('C',priority); end;
                        if k==4; priority = strrep(priority,'D',''); priority = strcat('D',priority); end;
                    elseif path{i+1,1}(j) == path{i,1}(k) && path{i+1,1}(j+4) == path{i,1}(k+4) && j == k %strip non-moving hands
                        if k==1; priority = strrep(priority,'A',''); end;
                        if k==2; priority = strrep(priority,'B',''); end;
                        if k==3; priority = strrep(priority,'C',''); end;
                        if k==4; priority = strrep(priority,'D',''); end;
                    end
                end
            end
            
            %Get start and stop q values
            this = this.set_hands_ABS(path{i,1}); this = this.set_TORSO_ABS(path{i+1,2}); this = this.ik_hands_ABS_ws(); %stop_TORSO with the start holds
            start_q = this.get_Q;
            this = this.set_hands_ABS(path{i+1,1}); this = this.set_TORSO_ABS(path{i+1,2}); this = this.ik_hands_ABS_ws(); %stop_TORSO with the stop holds
            stop_q = this.get_Q;
            
            %Adjust start and stop q for Q limited to [0, 2*pi]. This affects q1B and q1C. Prevents incorrect direction of movement,both CW and CCW through 0
            if stop_q(2) < start_q(2) && start_q(2) >= 3/2*pi && stop_q(2) <= pi %CCW through zero
                stop_q(2) = stop_q(2)+2*pi;
            elseif stop_q(2) > start_q(2) && start_q(2) <= pi && stop_q(2) >= 3/2*pi %CW through zero
                start_q(2) = start_q(2)+2*pi;
            end
            if stop_q(3) < start_q(3) && start_q(3) >= pi && stop_q(3) <= pi/2 %CCW through zero
                stop_q(3) = stop_q(3)+2*pi;
            elseif  stop_q(3) > start_q(3) && start_q(3) <= pi/2 && stop_q(3) >= pi %CW through zero
                start_q(3) = start_q(3)+2*pi;
            end
            
            %---plot workspace tester
%             cur_fig = this.plot_robot(1);
%             cur_fig = this.plot_ws_body(2,cur_fig);
%             figure(cur_fig);
%             hold on
%             scatter(path{i,1}(1:4),path{i,1}(5:8),'RED');
%             scatter(path{i+1,2}(1),path{i+1,2}(2),'GREEN');
            
            %Get linearly spaced q values between start and stop
            q1A = linspace(start_q(1),stop_q(1),SPACING_ARM+2); q1A = q1A(2:end);
            q2A = linspace(start_q(5),stop_q(5),SPACING_ARM+2); q2A = q2A(2:end);
            q1B = mod(linspace(start_q(2),stop_q(2),SPACING_ARM+2),2*pi); q1B = q1B(2:end);
            q2B = linspace(start_q(6),stop_q(6),SPACING_ARM+2); q2B = q2B(2:end);
            q1C = mod(linspace(start_q(3),stop_q(3),SPACING_ARM+2),2*pi); q1C = q1C(2:end);
            q2C = linspace(start_q(7),stop_q(7),SPACING_ARM+2); q2C = q2C(2:end);
            q1D = linspace(start_q(4),stop_q(4),SPACING_ARM+2); q1D = q1D(2:end);
            q2D = linspace(start_q(8),stop_q(8),SPACING_ARM+2); q2D = q2D(2:end);
            
            %Update hand values in the specified order; skip hands that don't move between stances
            tmp_Q = start_q;
            for j=1:length(priority)
                move = priority(j);
                switch move
                    case 'A'
                        [chunked_path, tmp_Q] = add_hand_moves_plot(this, chunked_path, tmp_Q, q1A, q2A, 'A');
                    case 'B'
                        [chunked_path, tmp_Q] = add_hand_moves_plot(this, chunked_path, tmp_Q, q1B, q2B, 'B');
                    case 'C'
                        [chunked_path, tmp_Q] = add_hand_moves_plot(this, chunked_path, tmp_Q, q1C, q2C, 'C');
                    case 'D'
                        [chunked_path, tmp_Q] = add_hand_moves_plot(this, chunked_path, tmp_Q, q1D, q2D, 'D');
                end
            end
        end
    end
    
    function chk_path_coms = prep_coms(this, chk_path_coms)
        %Convert WALLY angle convention to servo angle convention, in
        %degrees
        %INPUT/OUTPUT: chk_path_coms, [nx13] of q and em on/off with ind command in first column
        chk_path_coms = [zeros(size(chk_path_coms,1),1),chk_path_coms];
        for i=1:size(chk_path_coms,1)
            cur_Q = chk_path_coms(i,2:9);
            
            %--EXPERIMENTAL
            this = this.set_Q(cur_Q);
            this = this.set_TORSO_ABS([0 0 0]);
            this = this.fk_hands();
            tmp_hands_ABS = this.get_hands_ABS;
            tmp_hands_ABS = [tmp_hands_ABS(1:4) tmp_hands_ABS(5:8)+.2]; %Change upward offset here
            this = this.set_hands_ABS(tmp_hands_ABS);
            this = this.ik_hands_ABS;
            if length(this.get_Q) == 8
                cur_Q = this.get_Q;
            end
            %--EXPERIMENTAL
            
            for j=1:8
                q = round(rad2deg(cur_Q(j)));
                %% TowerPro Servos
%                 if j<=4 %convert inner angles
%                     if j==1
%                         new_q = -(q-180)+60;
%                     elseif j==2
%                         if q > 270; q = q-360; end;
%                         new_q = -(q)+80;
%                     elseif j==3
%                         if q > 180; q = q-360; end;
%                         new_q = -(q)+60;
%                     elseif j==4
%                         new_q = -(q-180)+80;
%                     end
%                 else %convert outer angles
%                     if j==5
%                         new_q = -(q-360);
%                     elseif j==6
%                         new_q = -(q-140);
%                     elseif j==7
%                         new_q = -(q-360);
%                     elseif j==8
%                         new_q = -(q-140);
%                     end
%                 end
                %% HiTec Servos
                if j<=4 %convert inner angles
                    if j==1
                        new_q = q-70;
                    elseif j==2
                        if q > 270; q = q-360; end;
                        new_q = q+90;
                    elseif j==3
                        if q > 180; q = q-360; end;
                        new_q = q+110 + 2;
                    elseif j==4
                        new_q = q-90 - 2;
                    end
                else %convert outer angles
                    if j==5
                        new_q = 170 - (360-q) -2;
                    elseif j==6
                        new_q = (q+30) -2;
                    elseif j==7
                        new_q = 170 - (360-q) +2;
                    elseif j==8
                        new_q = (q+30) -4;
                    end
                end
                
                %fine tuning: [0 0 +2 -2 -2 -2 +2 -4]
                cur_Q(j) = new_q;
            end
            chk_path_coms(i,2:9) = cur_Q;
            
            %% Add Indicator
            chk_path_coms(i,1) = 1;
            if i > 1 %assumes first move is always a torso motion
                if (i<size(chk_path_coms,1)... %parallel_done
                   && isequal(chk_path_coms(i,10:13),[1,1,1,1])...
                   && isequal(chk_path_coms(i-1,10:13),[1,1,1,1])...
                   && ~isequal(chk_path_coms(i+1,10:13),[1,1,1,1]))
                        chk_path_coms(i,1) = 6;
                end
                for j = 10:13
                    if chk_path_coms(i-1,j) < chk_path_coms(i,j) %em_pause_on
                        chk_path_coms(i,1) = 4;
                    elseif chk_path_coms(i-1,j) > chk_path_coms(i,j) %em_pause_off
                        chk_path_coms(i,1) = 5;
                    end
                end
            else
                chk_path_coms(i,1) = 1;
            end
        end
    end
    
    function inter_pts = linear_move(this, start, stop, n)
        %Generate n intermediate points for 2D linear move from start to
        %stop
        %INPUT: start, [1x2] stop, [1x2] of x,y
        %OUTPUT: [nx2] of intermediate points
        dist = this.dist(start,stop);
        x = linspace(0,dist,n+2);
        y = zeros(1,n+2);
        
        theta = atan2(stop(2)-start(2), stop(1)-start(1));
        rot = [cos(theta), -sin(theta); sin(theta), cos(theta)];
        for i=2:n+2
            inter_pts(i,:) = (rot*[x(i);y(i)])' + [start(1),start(2)];
        end
        inter_pts = inter_pts(2:end-1,:);
    end
    
    function inter_pts = center_move(this, start, stop, n)
        %Generate n intermediate points for 2D center move from start to
        %center to stop
        %INPUT: start, [1x2] stop, [1x2] of x,y
        %OUTPUT: [nx2] of intermediate points
        dist = this.dist(start,stop);
        x = linspace(0,dist,n+2);
        y = zeros(1,n+2);
        
        theta = atan2(stop(2)-start(2), stop(1)-start(1));
        rot = [cos(theta), -sin(theta); sin(theta), cos(theta)];
        for i=2:n+2
            inter_pts(i,:) = (rot*[x(i);y(i)])' + [start(1),start(2)];
        end
        inter_pts = inter_pts(2:end-1,:);
    end
    
    function [chunked_path, tmp_Q] = add_hand_moves(this, chunked_path, tmp_Q, q1x, q2x, x)
        %Adds to chunked_path based on the designated limb to move. this.TORSO_ABS must be correctly preset
        %INPUT: chunked_path
        %       tmp_Q, [1x8] of temporary intermediate values based on what has moved
        %       q1x, q2x [1xn] of q values to move through
        %       x, limb string to update
        
        for j=1:length(q1x) % update path for designated limb motion
            if strcmp('A',x) == 1
                tmp_Q(1) = q1x(j); tmp_Q(5) = q2x(j);
            elseif strcmp('B',x) == 1
                tmp_Q(2) = q1x(j); tmp_Q(6) = q2x(j);
            elseif strcmp('C',x) == 1
                tmp_Q(3) = q1x(j); tmp_Q(7) = q2x(j);
            elseif strcmp('D',x) == 1
                tmp_Q(4) = q1x(j); tmp_Q(8) = q2x(j);
            end
            this = this.set_Q(tmp_Q); this = this.fk_hands();
            chunked_path(end+1,:) = {this.hands_ABS, this.TORSO_ABS};
        end
    end
    
    function [chunked_path, tmp_Q] = add_hand_moves_coms(~, chunked_path, tmp_Q, q1x, q2x, x)
        %Adds to chunked_path based on the designated limb to move, updates with coms format. this.TORSO_ABS must be correctly preset
        %INPUT: chunked_path
        %       tmp_Q, [1x8] of temporary intermediate values based on what has moved
        %       q1x, q2x [1xn] of q values to move through
        %       x, limb string to update
        
        em = []; % magnet activation
        for j=1:length(q1x)+1 % update path for designated limb motion
            if j < length(q1x)+1
                if strcmp('A',x) == 1
                    tmp_Q(1) = q1x(j); tmp_Q(5) = q2x(j);
                    if j==1; em = [0 1 1 1]; end; %turn off em the first time, and reactivate when done
                elseif strcmp('B',x) == 1
                    tmp_Q(2) = q1x(j); tmp_Q(6) = q2x(j);
                    if j==1; em = [1 0 1 1]; end;
                elseif strcmp('C',x) == 1
                    tmp_Q(3) = q1x(j); tmp_Q(7) = q2x(j);
                    if j==1; em = [1 1 0 1]; end;
                elseif strcmp('D',x) == 1
                    tmp_Q(4) = q1x(j); tmp_Q(8) = q2x(j);
                    if j==1; em = [1 1 1 0]; end;
                end
            else %reactivate when done
                if strcmp('A',x) == 1 
                    tmp_Q(1) = q1x(end); tmp_Q(5) = q2x(end);
                elseif strcmp('B',x) == 1
                    tmp_Q(2) = q1x(end); tmp_Q(6) = q2x(end);
                elseif strcmp('C',x) == 1
                    tmp_Q(3) = q1x(end); tmp_Q(7) = q2x(end);
                elseif strcmp('D',x) == 1
                    tmp_Q(4) = q1x(end); tmp_Q(8) = q2x(end);
                end
                em = [1 1 1 1];
            end
            chunked_path(end+1,:) = [tmp_Q em];
        end
    end
    
    function [chunked_path, tmp_Q] = add_hand_moves_plot(this, chunked_path, tmp_Q, q1x, q2x, x)
        %Adds to chunked_path based on the designated limb to move, updates with coms format. this.TORSO_ABS must be correctly preset
        %INPUT: chunked_path
        %       tmp_Q, [1x8] of temporary intermediate values based on what has moved
        %       q1x, q2x [1xn] of q values to move through
        %       x, limb string to update
        
        for j=1:length(q1x)+1 % update path for designated limb motion
            if j < length(q1x)+1
                if strcmp('A',x) == 1
                    tmp_Q(1) = q1x(j); tmp_Q(5) = q2x(j);
                elseif strcmp('B',x) == 1
                    tmp_Q(2) = q1x(j); tmp_Q(6) = q2x(j);
                elseif strcmp('C',x) == 1
                    tmp_Q(3) = q1x(j); tmp_Q(7) = q2x(j);
                elseif strcmp('D',x) == 1
                    tmp_Q(4) = q1x(j); tmp_Q(8) = q2x(j);
                end
            else %reactivate when done
                if strcmp('A',x) == 1 
                    tmp_Q(1) = q1x(end); tmp_Q(5) = q2x(end);
                elseif strcmp('B',x) == 1
                    tmp_Q(2) = q1x(end); tmp_Q(6) = q2x(end);
                elseif strcmp('C',x) == 1
                    tmp_Q(3) = q1x(end); tmp_Q(7) = q2x(end);
                elseif strcmp('D',x) == 1
                    tmp_Q(4) = q1x(end); tmp_Q(8) = q2x(end);
                end
            end
            this = this.set_Q(tmp_Q); this = this.fk_hands();
            chunked_path(end+1,:) = {this.hands_ABS, this.TORSO_ABS};
        end
    end
    
    function send_path(this, path_prp, blue)
        % Sends the final path to the Arduino via Bluetooth. Sends in
        % chunks until end reached. Pauses if CV checking encounters
        % problem, then adjusts the path to send. Relies on communication
        % from Arduino sketch to proceed.
        %INPUT: path_prp, the prepped, chunked path in local servo angles
        %       blue, bluetooth object
        %       path_plot, the path to be plotted out to the GUI
        
        try path_plot = evalin('base','path_plot'); catch; end %read in the plotting info
        flag = 1; %1: normal move, 2: remove, 3: place, 4: em_on_pause, 5: em_off_pause
        answer = 0;
        handles1 = [];
        flushinput(blue); %flush any erroneous input
        GUI_pause = 0; GUI_stop = 0; GUI_remove = 0;
    
        % Write the current move
        for i=1:size(path_prp,1);
            %Send command to Arduino
            fwrite(blue,path_prp(i,1)); %write ind
            for j=2:13
                fwrite(blue,path_prp(i,j));
            end
            
            %Wait for Arduino response. 1: chunk complete, begin next chunk
            while 1==1
                if blue.BytesAvailable ~= 0
                    answer = fread(blue,1);
                    break
                end
            end
            if answer == 1
                answer = 0; %error checking here if desired, move is complete
            else
                answer
                disp('Error in receive signal.');
                return
            end
            
            %GUI flags
            i
            GUI_pause = evalin('base','GUI_pause');
            GUI_stop = evalin('base','GUI_stop');
            GUI_remove = evalin('base','GUI_remove');
            pause(.0001); drawnow;
            if GUI_stop == 1 && isequal(path_prp(i,9:12),[1,1,1,1])
                %stop execution, only stop if on a torso move
                disp('Stopped.');
                return
            elseif GUI_pause == 1
                %wait until the move has been resumed
                disp('Paused.');
                while evalin('base','GUI_pause') ~= 0
                    pause(.0001)
                end
                disp('Resuming...');
            elseif  GUI_remove == 1
                disp('Stopped. REMOVE ACTIVATED');
                return
            end
            
            %GUI wave info
            assignin('base','Q',path_prp(i,2:9));
            
            % Plot the position that WALLY will move to
            try
                %---PLOT, currently updates every chunked move;
                pause(.001);
                delete(handles1);
                cur_ax = evalin('base','cur_ax');
                this = this.set_hands_ABS(path_plot{i,1});
                this = this.set_TORSO_ABS(path_plot{i,2});
                this = this.ik_hands_ABS_ws();
                [cur_ax, handles1] = this.plot_robot(5, cur_ax);
                assignin('base','cur_fig',cur_ax);
                %---PLOT
            catch 
            end
            drawnow;
        end
    end
    
    function send_line(~, line, blue)
        % Sends a single line to the Arduino. Relies on communication
        % from Arduino sketch to proceed. Does not expect response.
        %INPUT: line, a valid [1x13] line command, where 1 is the indicator flag
        %       blue, bluetooth object
        
        ind = line(1);
        % Write the current move
        fwrite(blue,ind);
        for j=2:13
            fwrite(blue,line(j));
        end
    end
    
    % helper
    function midpoints = calc_midpoints(this)
        % Returns q1 joint position in TORSO frame
        % OUTPUT:
        % midpoints = [xA,xB,xC,xD,yA,yB,yC,yD]
        l1A = this.L(1);
        l1B = this.L(2);
        l1C = this.L(3);
        l1D = this.L(4);

        q1A = this.Q(1);
        q1B = this.Q(2);
        q1C = this.Q(3);
        q1D = this.Q(4);

        % A
        midpoints(1) = l1A*cos(q1A) + this.shoulders_TORSO(1);
        midpoints(5) = l1A*sin(q1A) + this.shoulders_TORSO(5);

        % B
        midpoints(2) = l1B*cos(q1B) + this.shoulders_TORSO(2);
        midpoints(6) = l1B*sin(q1B) + this.shoulders_TORSO(6);

        % C
        midpoints(3) = l1C*cos(q1C) + this.shoulders_TORSO(3);
        midpoints(7) = l1C*sin(q1C) + this.shoulders_TORSO(7);

        % D
        midpoints(4) = l1D*cos(q1D) + this.shoulders_TORSO(4);
        midpoints(8) = l1D*sin(q1D) + this.shoulders_TORSO(8);
    end

    function xy_coord_ABS = calc_TORSO_to_ABS(this,xy_coord)
        % Returns a set of TORSO coordinates in the absolute frame
        % INPUT
        % xy_coord: [xA xB xC xD yA yB yC yD]
        % xy_coord is a set of coordinates in the robot frame
        % OUTPUT
        % xy_coord_O: xy_coord in the absolute frame
        xA = xy_coord(1);
        xB = xy_coord(2);
        xC = xy_coord(3);
        xD = xy_coord(4);
        yA = xy_coord(5);
        yB = xy_coord(6);
        yC = xy_coord(7);
        yD = xy_coord(8);
  
        x10 = this.TORSO_ABS(1);
        y10 = this.TORSO_ABS(2);
        theta = this.TORSO_ABS(3);

        rot10 = [cos(theta),-sin(theta);
                 sin(theta), cos(theta)];

        AO = rot10*[xA;yA] + [x10;y10];
        BO = rot10*[xB;yB] + [x10;y10];
        CO = rot10*[xC;yC] + [x10;y10];
        DO = rot10*[xD;yD] + [x10;y10];

        xy_coord_ABS = [AO(1) BO(1) CO(1) DO(1) AO(2) BO(2) CO(2) DO(2)];
    end

    function xy_coord_TORSO = calc_ABS_to_TORSO(this, xy_coord)
        % Returns a set of absolute coordinates in the body
        % INPUT
        % xy_coord: [xA xB xC xD yA yB yC yD]
        % xy_coord is a set of coordinates in the absolute frame
        % OUTPUT
        % xy_coord_O: xy_coord in the body frame
        xA = xy_coord(1);
        xB = xy_coord(2);
        xC = xy_coord(3);
        xD = xy_coord(4);
        yA = xy_coord(5);
        yB = xy_coord(6);
        yC = xy_coord(7);
        yD = xy_coord(8);

        x01 = -this.TORSO_ABS(1);
        y01 = -this.TORSO_ABS(2);
        theta = this.TORSO_ABS(3);

        rot01 = [cos(theta),sin(theta);
                 -sin(theta), cos(theta)];

        AO = rot01*[xA;yA] + [x01;y01];
        BO = rot01*[xB;yB] + [x01;y01];
        CO = rot01*[xC;yC] + [x01;y01];
        DO = rot01*[xD;yD] + [x01;y01];

        xy_coord_TORSO = [AO(1) BO(1) CO(1) DO(1) AO(2) BO(2) CO(2) DO(2)];
    end
    
    function xy_coord_TORSO = calc_ABS_to_TORSO_2(this, xy_coord)
        % Returns a set of absolute coordinates in the TORSO frame
        % INPUT
        % xy_coord: [x y]
        % xy_coord is a set of coordinates in the absolute frame
        % OUTPUT
        % xy_coord_TORSO: xy_coord in the TORSO frame [x y]
        x01 = -this.TORSO_ABS(1);
        y01 = -this.TORSO_ABS(2);
        theta = this.TORSO_ABS(3);

        rot01 = [cos(theta),sin(theta);
                 -sin(theta), cos(theta)];
             
        xy_coord_TORSO = (rot01*[xy_coord(1);xy_coord(2)] + [x01;y01])';
    end

    % utility
    function [cur_fig, handles] = plot_robot(this, show, varargin)
        % Plots the current configuration based on Q and TORSO_ABS
        % Currently assumes theta = 0;
        % Show == 0: Plot the robot, do not display the figure
        % Show == 1: Plot the robot, display the figure
        % Show == 2: Plot the robot, display on top of given figure
        % Show == 3: Do not plot the robot, only create proper dimensioned figure
        % Show == 4: Only plot the handholds, display on top of given figure
        % Show == 5: Plot on axes
        handles = [];
        
        shoulders_ABS = this.calc_TORSO_to_ABS(this.shoulders_TORSO);
        %A coordinates
        x0(1) = shoulders_ABS(1); y0(1) = shoulders_ABS(5); 
        %B coordinates
        x0(2) = shoulders_ABS(2); y0(2) = shoulders_ABS(6);
        %C coordinates
        x0(3) = shoulders_ABS(3); y0(3) = shoulders_ABS(7);
        %D coordinates
        x0(4) = shoulders_ABS(4); y0(4) = shoulders_ABS(8);
        
        %Input handling
        if show == 5
            axes(varargin{1});
        elseif show == 4
            cur_fig = varargin{1};
            figure(cur_fig(1))
            axis([-1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(1) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(1) -1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(2) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(2)]);
            pbaspect([1 1 1]);
            hold on
            handles(end+1) = scatter(this.hands_ABS(1:4),this.hands_ABS(5:8),'BLACK');
            handles(end+1) = plot([x0(1) x0(2)],[y0(1) y0(2)],'color','bla','linewidth',2);
            handles(end+1) = plot([x0(2) x0(3)],[y0(2) y0(3)],'color','bla','linewidth',2);
            handles(end+1) = plot([x0(3) x0(4)],[y0(3) y0(4)],'color','bla','linewidth',2);
            handles(end+1) = plot([x0(4) x0(1)],[y0(4) y0(1)],'color','bla','linewidth',2);
            hold off
            cur_fig = gcf;
            return
        elseif show == 3
            figure('visible', 'off');
            axis([-1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(1) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(1) -1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(2) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(2)]);
            pbaspect([1 1 1]);
            cur_fig = gcf;
            return
        elseif show == 2
            cur_fig = varargin{1};
            
            figure(cur_fig(1))
            axis equal
            axis([-1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(1) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(1) -1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(2) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(2)]);
            
            pbaspect([1 1 1]);
        elseif show == 1
            figure
            axis equal
            axis([-1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(1) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(1) -1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(2) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(2)]);
            pbaspect([1 1 1]);
        elseif show == 0
            figure('visible', 'off');
            axis([-1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(1) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(1) -1*(abs(this.shoulders_TORSO(1))*5)+this.TORSO_ABS(2) abs(this.shoulders_TORSO(1))*5+this.TORSO_ABS(2)]);
            pbaspect([1 1 1]);
        end
        
        %Misc coordinates
        midpoints = calc_midpoints(this);
        midpoints_ABS = this.calc_TORSO_to_ABS(midpoints);
        %A coordinates
        x1(1) = midpoints_ABS(1); y1(1) = midpoints_ABS(5); x2(1) = this.hands_ABS(1); y2(1) = this.hands_ABS(5);
        %B coordinates
        x1(2) = midpoints_ABS(2); y1(2) = midpoints_ABS(6); x2(2) = this.hands_ABS(2); y2(2) = this.hands_ABS(6);        
        %C coordinates
        x1(3) = midpoints_ABS(3); y1(3) = midpoints_ABS(7); x2(3) = this.hands_ABS(3); y2(3) = this.hands_ABS(7);
        %D coordinates
        x1(4) = midpoints_ABS(4); y1(4) = midpoints_ABS(8); x2(4) = this.hands_ABS(4); y2(4) = this.hands_ABS(8);      
        
        hold on
        for i=1:4
            %Plot r1
            handles(end+1) = plot([x0(i) x1(i)],[y0(i) y1(i)],'color','b','linewidth',2);
            %Plot r2
            handles(end+1) = plot([x1(i) x2(i)],[y1(i) y2(i)],'color','r','linewidth',2);
        end

        %Plot body
        handles(end+1) = plot([x0(1) x0(2)],[y0(1) y0(2)],'color','bla','linewidth',2);
        handles(end+1) = plot([x0(2) x0(3)],[y0(2) y0(3)],'color','bla','linewidth',2);
        handles(end+1) = plot([x0(3) x0(4)],[y0(3) y0(4)],'color','bla','linewidth',2);
        handles(end+1) = plot([x0(4) x0(1)],[y0(4) y0(1)],'color','bla','linewidth',2);

        cur_fig = gcf;
    end
    
    function cur_fig = plot_ws_arm(this, show, varargin)
        % Set up plot
        if show == 2
            cur_fig = varargin{1};
            figure(cur_fig(1))
        elseif show == 1
            figure
            axis([-1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3 -1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3]);
            pbaspect([1 1 1]);
        else
            figure('visible', 'off');
            axis([-1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3 -1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3]);
            pbaspect([1 1 1]);
        end

        % Generate workspace over discrete end effector points
        %A
        cntr = 1;
        for angle1 = linspace(0,360,30)/180*pi
            this.Q(1) = angle1;
            for angle2 = linspace(0,360,30)/180*pi
                % get FK at this new angle
                this.Q(5) = angle2;
                this = this.fk_hands();
                xA(cntr) = this.hands_ABS(1);
                yA(cntr) = this.hands_ABS(5);
               cntr = cntr+1;
            end
        end
        %B
        cntr = 1;
        offset1 = -45;
        offset2 = 90;
        for angle1 = linspace(0+offset1,120+offset1,50)/180*pi
            this.Q(2) = angle1;
            for angle2 = linspace(0+offset2,120+offset2,50)/180*pi
                % get FK at this new angle
                this.Q(6) = angle2;
                this = this.fk_hands();
                xB(cntr) = this.hands_ABS(2);
                yB(cntr) = this.hands_ABS(6);
               cntr = cntr+1;
            end
        end
        %C
        cntr = 1;
        for angle1 = linspace(0,360,30)/180*pi
            this.Q(3) = angle1;
            for angle2 = linspace(0,360,30)/180*pi
                % get FK at this new angle
                this.Q(7) = angle2;
                this = this.fk_hands();
                xC(cntr) = this.hands_ABS(3);
                yC(cntr) = this.hands_ABS(7);
               cntr = cntr+1;
            end
        end
        %D
        cntr = 1;
        for angle1 = linspace(0,360,30)/180*pi
            this.Q(4) = angle1;
            for angle2 = linspace(0,360,30)/180*pi
                % get FK at this new angle
                this.Q(8) = angle2;
                this = this.fk_hands();
                xD(cntr) = this.hands_ABS(4);
                yD(cntr) = this.hands_ABS(8);
               cntr = cntr+1;
            end
        end
        
        xA = xA';
        yA = yA';
        xB = xB';
        yB = yB';
        xC = xC';
        yC = yC';
        xD = xD';
        yD = yD';
        
        % Plot the hand workspace boundaries
        hold on
%         k = boundary(xA,yA);
%         polyarea(xA(k),yA(k))
%         plot(xA(k),yA(k));
%         scatter(xA,yA);
        
        k = boundary(xB,yB);
        plot(xB(k),yB(k));
        scatter(xB,yB);
        
%         k = boundary(xC,yC);
%         plot(xC(k),yC(k));
%          scatter(xC,yC);
%         
%         k = boundary(xD,yD);
%         plot(xD(k),yD(k));
%         scatter(xD,yD);
        
        cur_fig = gcf;
    end
    
    function [cur_fig, handles] = plot_ws_body(this, show, varargin)
        %Plot the TORSO workspace based on given IC
        %show = 3: plot workspace based on given ws
        %show = 2: plot workspace based on calculated ws
        %show = 1: plot workspace based on given ws, set up plot
        'here'
        handles = [];
        
        %Set up plot
        if show == 3
            cur_fig = varargin{1};
            ws = varargin{2};
            figure(cur_fig(1))
        elseif show == 2
            cur_fig = varargin{1};
            figure(cur_fig(1))
        elseif show == 1
            ws = varargin{1};
            cur_fig = figure;
            axis([-1*(abs(this.hands_TORSO(1))*5)+this.TORSO_ABS(1) abs(this.hands_TORSO(1))*5+this.TORSO_ABS(1) -1*(abs(this.hands_TORSO(1))*5)+this.TORSO_ABS(2) abs(this.hands_TORSO(1))*5+this.TORSO_ABS(2)]);
            pbaspect([1 1 1]);
        elseif show == 4
            cur_fig = figure;
            axis([-1*(abs(this.hands_TORSO(1))*5)+this.TORSO_ABS(1) abs(this.hands_TORSO(1))*5+this.TORSO_ABS(1) -1*(abs(this.hands_TORSO(1))*5)+this.TORSO_ABS(2) abs(this.hands_TORSO(1))*5+this.TORSO_ABS(2)]);
            pbaspect([1 1 1]);
            figure(cur_fig(1))
        end
        
        if show == 3
            hold on
            x = ws(:,1); 
            y = ws(:,2);
            bound = boundary(x, y);
            handles(end+1) = fill(x(bound),y(bound),'GREEN');
            hold off  
        end
        
        if show == 2 || show == 4
            [~, ws] = this.calc_stance_workspace(this.hands_ABS);
            hold on
            x = ws(:,1); 
            y = ws(:,2);
            bound = boundary(x, y);
            if length(bound) == 0
                for i = 1:size(ws,1)
                    handles(end+1) = scatter(x(i),y(i),'GREEN','filled');
                end
            else
                handles(end+1) = fill(x(bound),y(bound),'GREEN');
                end
            hold off  
        end
        
        if show == 1
            [~, ws] = this.calc_stance_workspace(this.hands_ABS);
            hold on
            x = ws(:,1); 
            y = ws(:,2);
            bound = boundary(x, y);
            handles(end+1) = fill(x(bound),y(bound),'GREEN');
            hold off  
        end
    end
            
    function cur_fig = workspace_eval(this, s_na, s_range, show, varargin)
        % Produce plots to evaluate the optimal neutral angle servo
        % position to generate useful workspace
        % Set up plot
        if show == 2
            cur_fig = varargin{1};
            figure(cur_fig(1))
        elseif show == 1
            cur_fig = this.plot_robot(3);
            figure(cur_fig);
            axis([-1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3 -1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3]);
            pbaspect([1 1 1]);
        else
            figure('visible', 'off');
            axis([-1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3 -1*(abs(this.hands_TORSO(1))*3) abs(this.hands_TORSO(1))*3]);
            pbaspect([1 1 1]);
        end
        
        % Generate workspace over discrete end effector points
        xA=[]; yA=[]; xB=[]; yB=[]; xC=[]; yC=[]; xD=[]; yD=[];frame=getframe;
        
        for i = linspace(s_range(1),s_range(2),10)
            this.Q(1) = s_na(1)+i;
            this.Q(2) = s_na(2)+i;
            this.Q(3) = s_na(3)+i;
            this.Q(4) = s_na(4)+i;
            for j = linspace(s_range(1),s_range(2),10)
                this.Q(5) = s_na(5)+j;
                this.Q(6) = s_na(6)+j;
                this.Q(7) = s_na(7)+j;
                this.Q(8) = s_na(8)+j;
                this = this.fk_hands(); % get FK at this new angle
                xA(end+1) = this.hands_ABS(1); yA(end+1) = this.hands_ABS(5);
                xB(end+1) = this.hands_ABS(2); yB(end+1) = this.hands_ABS(6);
                xC(end+1) = this.hands_ABS(3); yC(end+1) = this.hands_ABS(7);
                xD(end+1) = this.hands_ABS(4); yD(end+1) = this.hands_ABS(8);
                [cur_fig,handles] = this.plot_robot(2,cur_fig);
                pause(.01)
                frame(end+1) = getframe;
                delete(handles)
            end
        end

        % Plot the workspace boundaries
        hold on
        scatter(xA,yA,'green');
        pause(1);
        scatter(xB,yB,'red');
        pause(1);
        scatter(xC,yC,'blue');
        pause(1);
        scatter(xD,yD,'green');
        this = this.set_Q(s_na);
        this = this.fk_hands();
        this.plot_robot(2,cur_fig);
        cur_fig = gcf;
        v = VideoWriter('tester2.mp4','MPEG-4'); open(v); writeVideo(v,frame); close(v);
    end
    
    function distance = dist(~, xy1, xy2)
        %Computes the distance between xy1, [x1,y1], and xy2, [x2,y2]
        x1 = xy1(1); y1 = xy1(2);
        x2 = xy2(1); y2 = xy2(2);
        distance = sqrt((x2-x1)^2 + (y2-y1)^2);
    end
end
end

%--Stockpile
%   function send_path(this, path_prp, blue)
%         % Sends the final path to the Arduino via Bluetooth. Sends in
%         % chunks until end reached. Pauses if CV checking encounters
%         % problem, then adjusts the path to send. Relies on communication
%         % from Arduino sketch to proceed.
%         %INPUT: path_prp, the prepped, chunked path in local servo angles
%         %       blue, bluetooth object
%         
%         CHUNK_SIZE = 10;
%         len = CHUNK_SIZE;
%         idx = 1;
%         
%         %Get size of next chunk to send
%         cur_len = size(path_prp(idx:end,:),1); %amount of path remaining to send
%         total_len = cur_len;
%         while idx < total_len
%             if cur_len < CHUNK_SIZE
%                 disp('Sending final chunk.')
%                 len = cur_len;
% %                 fprintf(blue,'%f\n',len);
%                   fwrite(blue,len);
%                 for i=idx:idx+len-1
%                     fwrite(blue,path_prp(i,:)); %write the final len-sized chunk
% %                     fprintf(blue,'%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n',path_prp(i,:));
%                 end
%                 idx = idx+len;
%             else
% %                 fprintf(blue,'%f\n',len);
%                 disp('Sending next chunk')
%                 fwrite(blue,len);
%                 for i=idx:idx+len-1
%                     fwrite(blue,path_prp(i,:)); %write a CHUNK_SIZE chunk
% %                     fprintf(blue,'%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n',path_prp(i,:));
%                 end
%                 idx = idx+len;
%             end
%             cur_len = size(path_prp(idx:end,:),1);
%             
%             %wait for Arduino response
% %             0: x moves complete, perform CV error check
% %             1: chunk complete, begin next chunk
% %             ---turned off for testing
%             while 1==1
%                 if blue.BytesAvailable ~= 0
%                     answer = fread(blue,blue.BytesAvailable);
%                 end
%                 pause(.05);
%             end
%             answer
%             
%             if answer == 0 %perform error check
%                 %CV error check here
%             elseif answer ==1
%                 continue
%             end
%         end
%     end

%Get the set of possible nearby four-holds, arranged by feasible limb reach
%         [A_holds, B_holds, C_holds, D_holds] = this.calc_nearby_holds(holds, this.TORSO_ABS);
%         %--plot the holds for testing
%         A_holds, B_holds, C_holds, D_holds
%         figure
%         scatter(A_holds(:,1),A_holds(:,2),'RED')=
%         hold on
%         scatter(B_holds(:,1),B_holds(:,2),'BLUE')
%         scatter(C_holds(:,1),C_holds(:,2),'GREEN')
%         scatter(D_holds(:,1),D_holds(:,2),'YELLOW')