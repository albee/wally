classdef w_node < handle
    %A node storing WALLY's stance
    
properties
    holds_ABS
    TORSO_ABS
    children
    parent
    h1 %heuristic1 (straight line distance to goal)
    h2 %heuristic2 (distance from previous torso)
    h3 %heuristic3 (total distance traveled)
    h4 %heuristic4 (number of moves to get here)
end

methods
    % constructor
    function this = w_node(holds_ABS, TORSO_ABS, parent, h1, h2, h3, h4)
        this.holds_ABS = holds_ABS;
        this.TORSO_ABS = TORSO_ABS;
        this.parent = parent;
        this.h1 = h1;
        this.h2 = h2;
        this.h3 = h3;
        this.h4 = h4;
        this.children = {};
    end
end

end