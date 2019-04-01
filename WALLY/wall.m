classdef wall
    %A wall for climbing, with creation and visualization utilities
    
properties
    holds
    
    width 
    height
    num_width
    num_height
    width_space
    height_space
    offset
    
    num_holds
    
    final_hold
    %holds: nx2 of [x,y] handhold coordinates in ABS
end

methods
    % constructor
    function this = wall(info, final_hold)
        %Set info settings
        if length(info) >= 7
            this.width = info(1);
            this.height = info(2);
            this.num_width = info(3);
            this.num_height = info(4);
            this.width_space = info(5);
            this.height_space = info(6);
            this.offset = info(7);
            this.final_hold = final_hold;
        end
        
        %Select random, uniform, or tiered wall
        if length(info) == 9
            this.num_holds = info(8);
            this.holds = this.tiered_wall();
        elseif length(info) == 8
            this.num_holds = info(8);
            this.holds = this.random_wall();
        elseif length(info) == 7
            this.holds = this.uniform_wall();
        elseif length(info) == 3 %create from CV
            this.final_hold = final_hold;
            this.holds = this.cv_wall(info{1}, this.final_hold);
            this.width = info{2};
            this.height = info{3};
        end
    end
    
    function my_holds = uniform_wall(this)
        %make a uniform wall
        my_holds = [];
        for x = this.offset:this.width_space:this.width_space*this.num_width+this.offset
            for y= this.offset:this.height_space:this.height_space*this.num_height+this.offset
                my_holds(end+1,:) = [x y];
            end
        end
        if ~ismember(this.final_hold,my_holds,'rows') %add final_hold if not already there
            my_holds(end+1,:) = this.final_hold;
        end
    end
    
    function my_holds = random_wall(this)
        %make a randomized wall
        my_holds = [];
        for i=1:1:this.num_holds
            my_holds(i,:) = [this.offset+(this.width-2*this.offset)*rand(), this.offset+(this.height-2*this.offset)*rand()];
        end
        if ~ismember(this.final_hold,my_holds,'rows') %add final_hold if not already there
            my_holds(end+1,:) = this.final_hold;
        end
    end
    
    function my_holds = tiered_wall(this)
        MIX = .6; %level of random offset, 1 is half spacing
        
        %make a wall with three tiers
        num_third = this.num_height/3;
        
        %bottom: uniform
        my_holds = [];
        for x = this.offset:this.width_space:this.width_space*this.num_width+this.offset
            for y= this.offset:this.height_space:this.height_space*(floor(num_third)-1)+this.offset
                my_holds(end+1,:) = [x y];
            end
        end
        
        %middle: uniform with random offset
        for x = this.offset:this.width_space:this.width_space*this.num_width+this.offset
            for y = this.height_space*(floor(num_third))+this.offset:this.height_space:this.height_space*2*floor(num_third)
                my_holds(end+1,:) = [x+this.width_space*(rand()-.5)*MIX y+this.height_space*(rand()-.5)*MIX];
            end
        end
       
        %top: uniform with more severe random offset
        this.offset+(this.width-2*this.offset)*rand();
        for i=1:this.num_holds
                my_holds(end+1,:) = [this.offset+(this.num_width*this.width_space)*rand()...
                                     this.height_space*(2*floor(num_third)) + this.height_space * (floor(num_third)+2) *rand()];
        end
        
%         for i=1:1:num_holds
%             my_holds(i,:) = [max_width*rand(), max_height*rand()];
%         end
        if ~ismember(this.final_hold,my_holds,'rows') %add final_hold if not already there
            my_holds(end+1,:) = this.final_hold;
        end
    end
    
    function my_holds = cv_wall(~, my_holds, final_hold)
        %make a wall from cv
        if ~ismember(final_hold,my_holds,'rows') %add final_hold if not already there
            my_holds(end+1,:) = final_hold;
        end
    end
    
    % utilities
    function output = plot_wall(this)
        hold on
        
        scatter(this.holds(:,1),this.holds(:,2),25,'black','o','LineWidth',1)
        axis equal
        axis([0 this.width 0 this.height]);
        pbaspect([1 1 1]);
        
        output = gcf;
    end
end

end