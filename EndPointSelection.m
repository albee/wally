function [final_hold, hands_ABS] = EndPointSelection(holds_px, holds_in)
%EndPointSelection Provides GUI for the user to select where they want
%Wally to climb to. Outputs are a number for the x coordinate in inches,
%another number for the y coordinate in inches, and a nx2 matrix of all of
%the (x,y) coordinates of the handholds on the wall

%% Setup

%INSTRUCTIONS:
%Double click the center of a handhold you wish to select as the final end
%point for wally

%--------------------------------------------------------------------------
% Setup
%--------------------------------------------------------------------------
%scaling factors
% X = [10 12];
% 
CLOSENESS = 20;
height2 = 1880;
xscaling_factor = .0481;
yscaling_factor = .0509;
% 
% %Little Wall
% % WIDTH_OF_WALL = 28;
% % HEIGHT_OF_WALL = 46 + 15/16;
% 
% %Big Wall
% WIDTH_OF_WALL = 48 + 1/16;
% HEIGHT_OF_WALL = 95 + 15/16;
% 
% xscaling_factor = WIDTH_OF_WALL/width2;
% yscaling_factor = HEIGHT_OF_WALL/height2;
% 
% %set number of disks should see as check
% DISKS = 154;
% 
% %image acquisition
% try
%     colorVid = videoinput('kinect',1,'BGR_1920x1080');
%     colorimg = getsnapshot(colorVid);
%     img = imrotate(colorimg,-90);
%     firstImg = flipdim(img,2);
% catch
%     firstImg = imread('./testing_pics/newwallyTEST6.jpg');
%     imshow(firstImg)
% end

%--------------------------------------------------------------------------
% Computation
%--------------------------------------------------------------------------
%% Crop

% secondImg = imtransform(firstImg,T); 
% realImg = imcrop(secondImg,[xmin ymin xmax-xmin ymax-ymin]);

%---OPEN LOOP
realImg = imread('./testing_pics/cropped_real_img.jpg');
%---OPEN LOOP

imshow(realImg);

%% Show known holds
holds_px_r = 10*ones(1,length(holds_px));
viscircles(holds_px,holds_px_r,'EdgeColor','b');

%% Choose 4 start handhold points
[endeffectors_x,endeffectors_y] = getpts;
idxA = []; idxB = []; idxC = []; idxD = [];
hands_ABS = zeros(1,8);

for i = 1:length(endeffectors_x)
    smallest = inf;
    for j = 1:length(holds_px)
        if norm(holds_px(j,:) - [endeffectors_x(i),endeffectors_y(i)]) < smallest
            smallest = norm(holds_px(j,:) - [endeffectors_x(i),endeffectors_y(i)]);
            hands_ABS(i) = holds_in(j,1);
            hands_ABS(i+4) = holds_in(j,2);
            if i == 1; idxA = j;
            elseif i == 2; idxB = j;
            elseif i == 3; idxC = j;
            elseif i == 4; idxD = j;
            end
        end
    end
end
viscircles(holds_px(idxA,:), 5,'EdgeColor','g');
viscircles(holds_px(idxB,:), 5,'EdgeColor','g');
viscircles(holds_px(idxC,:), 5,'EdgeColor','g');
viscircles(holds_px(idxD,:), 5,'EdgeColor','g');

%% Choose final hold
%This where the final point is selected, only if you are within a certain
%distance of the center of a known hand point when you double click
[xwallyfinal,ywallyfinal] = getpts;
idx = [];
smallest = inf;

for i = 1:length(holds_px)
    if norm(holds_px(i,:) - [xwallyfinal,ywallyfinal]) < smallest
        smallest = norm(holds_px(i,:) - [xwallyfinal,ywallyfinal]);
        idx = i;
        final_hold = holds_in(i,:);
    end
end
viscircles(holds_px(idx,:), 10,'EdgeColor','r');

hold off

%% Find Handholds
%search for handholds
% [centers1, radii1, metric1] = imfindcircles(realImg,X,'Sensitivity',0.9,...
%     'Method','twostage','EdgeThreshold',0.9);
% [centers2, radii2, metric2] = imfindcircles(realImg,X,'Sensitivity',0.965,...
%     'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.09);

%eliminate overlapping or double counted circles
% for i = 1:size(centers2,1)
%     j = 1;
%     while j <= size(centers1,1)
%         if norm(centers2(i,:) - centers1(j,:)) < CLOSENESS
%             centers1(j,:) = [];
%             radii1(j,:) = [];
%         else
%             j = j + 1;
%         end
%     end
% end
% 
% %combine the two methods
%combine the two methods
% bad_handholds_centers = vertcat(centers1,centers2);
% bad_handholds_radii = vertcat(radii1,radii2);

%% Get Rid of Bad Handholds
%take out extraneous circles
% new_handholds_centers = [];
% handholds_radii = [];
% for i = 1:size(points,1)
%     j = 1;
%     while j <= size(bad_handholds_centers,1)
%         if norm(points(i,:) - bad_handholds_centers(j,:)) < CLOSENESS/2
%             new_handholds_centers = [new_handholds_centers;...
%                 points(i,:)];
%             handholds_radii = [handholds_radii;bad_handholds_radii(j,:)];
%             bad_handholds_centers(j,:) = [];
%             bad_handholds_radii(j,:) = [];            
%         else
%             j = j + 1;
%         end
%     end
% end
% 
% 
% hold on
% 
% ycorners = endeffector_points(:,2);
% ycorners = [ycorners(1)-100;ycorners(2)-100;ycorners(4)+100;ycorners(3)+100];
% xcorners = endeffector_points(:,1);
% xcorners = [xcorners(1)-100;xcorners(2)+100;xcorners(4)-100;xcorners(3)+100];
% 
% m1 = (ycorners(2)-ycorners(1))/(xcorners(2)-xcorners(1));
% b1 = ycorners(1)-xcorners(1)*m1;
% x1 = linspace(xcorners(1),xcorners(2), 100);
% y1 = b1+m1*x1;
% plot(x1,y1)
% m2 = (ycorners(3)-ycorners(1))/(xcorners(3)-xcorners(1));
% b2 = ycorners(1)-xcorners(1)*m2;
% x2 = linspace(xcorners(1),xcorners(3), 100);
% y2 = b2+m2*x2;
% plot(x2,y2)
% m3 = (ycorners(4)-ycorners(3))/(xcorners(4)-xcorners(3));
% b3 = ycorners(3)-xcorners(3)*m3;
% x3 = linspace(xcorners(4),xcorners(3), 100);
% y3 = b3+m3*x3;
% plot(x3,y3)
% m4 = (ycorners(4)-ycorners(2))/(xcorners(4)-xcorners(2));
% b4 = ycorners(2)-xcorners(2)*m4;
% x4 = linspace(xcorners(4),xcorners(2), 100);
% y4 = b4+m4*x4;
% plot(x4,y4)
% 
% j = 1;
% while j <= size(points,1)
%     if (points(j,1)*m1+b1 < points(j,2) | ...
%             points(j,1)*m3+b3 > ...
%             points(j,2) | (points(j,2)-b2)...
%             /m2 < points(j,1) | ...
%             (points(j,2)-b4)/m4 > points(j,1))
%         new_handholds_centers = [new_handholds_centers;points(j,:)];
%         handholds_radii = [handholds_radii;10];
%     end
%     j = j + 1;
% end
% 
% 
% %eliminate retreaded handholds
% [UniXY,Index]=unique(new_handholds_centers,'rows');
% DupIndex=setdiff(1:size(new_handholds_centers,1),Index);
% new_handholds_centers(DupIndex,:)=[];
% handholds_radii = [];
% for i=1:length(new_handholds_centers)
%     handholds_radii = [handholds_radii;10];
% end
% 
% viscircles(new_handholds_centers, handholds_radii,'EdgeColor','b');
% %%%viscircles(points, points_radii,'EdgeColor','r');

%convert handholds from pixels to inches
% for i = 1:length(new_handholds_centers)
%     new_handholds_centers(i,1) = new_handholds_centers(i,1)*xscaling_factor;
%     new_handholds_centers(i,2) = (height2-new_handholds_centers(i,2))*yscaling_factor;
% end

end