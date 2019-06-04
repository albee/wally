function [xwallyfinal_inches,ywallyfinal_inches,...
    temp_holds_in, final_hold, hands_ABS] = EndPointSelectiontape(points,holds_px,holds_in,holds_r,xmax,xmin,ymax,ymin,T)
%EndPointSelection Provides GUI for the user to select where they want
%Wally to climb to. Outputs are a number for the x coordinate in inches,
%another number for the y coordinate in inches, and a nx2 matrix of all of
%the (x,y) coordinates of the handholds on the wall

%INSTRUCTIONS:
%Double click the center of a handhold you wish to select as the final end
%point for wally


%set number of disks should see as check
disks = 154;
xwallyfinal_inches = 0;
ywallyfinal_inches = 0;


%See InitializingWallSetup for detailed comments on each section (this
%function is simply reexecuting it with values defined in that functions
%setup)
colorVid = videoinput('kinect',1,'BGR_1920x1080');
colorimg = getsnapshot(colorVid);
img = imrotate(colorimg,-90);
firstImg = flipdim(img,2);

%%%FOR TESTING PURPOSES
%%%firstImg = imread('firstImgTEST.jpg');
%%%firstImg = imread('magnetoffsetprep.jpg');
%%%imshow(firstImg);

% [firstcropx,firstcropy] = getpts;
% 
% %%%firstcropx = [2.390000000000001e+02;833;2.420000000000000e+02];
% %%%firstcropy = [9.319999999999999e+02;9.289999999999999e+02;1913];
% 
% firstImg = imcrop(firstImg,[firstcropx(1) firstcropy(1) firstcropx(2)-...
%     firstcropx(1) firstcropy(3)-firstcropy(1)]);
% figure, imshow(firstImg);
% %%impixelinfo;
dimensions = size(firstImg);
width1 = dimensions(2);
height1 = dimensions(1);
% 
% %The following is to determine the projection for the image
% [cornersx,cornersy] = getpts;
% U = [cornersx(1),cornersy(1);cornersx(2),cornersy(2);...
%     cornersx(3),cornersy(3);cornersx(4),cornersy(4)];
% X = [0,0;width1,0;0,height1;width1,height1];
% T = maketform('projective',U,X);
secondImg = imtransform(firstImg,T); 
figure, imshow(secondImg)
% %%impixelinfo;
% 
% %double click top left corner and bottom right corner
% [xmin,ymin] = getpts;
% [xmax,ymax] = getpts;
% 
%%%realImg = imcrop(secondImg,[xmin ymin xmax-xmin ymax-ymin]);


% firstImg = imcrop(firstImg,[firstcropx(1) firstcropy(1) firstcropx(2)-...
%     firstcropx(1) firstcropy(3)-firstcropy(1)]);
% 
%secondImg = imtransform(firstImg,T); 
% 
realImg = imcrop(secondImg,[xmin ymin xmax-xmin ymax-ymin]);
realImg = imresize(realImg,[1880 999]);
%%[xmin ymin width height]

%%%COMMENT OUT BELOW WHEN NOT TESTING
%%%realImg = imread('accurate_kinda_tape2.jpg');

imshow(realImg);
dimensions = size(realImg);
width2 = dimensions(2);
height2 = dimensions(1);


%search for handholds
closeness = 20;
X = [10 12];
[centers1, radii1, metric1] = imfindcircles(realImg,X,'Sensitivity',0.98,...
    'Method','twostage','EdgeThreshold',0.9);
[centers2, radii2, metric2] = imfindcircles(realImg,X,'Sensitivity',0.976,...
    'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.099);

%eliminate overlapping or double counted circles
for i = 1:size(centers2,1)
    j = 1;
    while j <= size(centers1,1)
        if norm(centers2(i,:) - centers1(j,:)) < closeness
            centers1(j,:) = [];
            radii1(j,:) = [];
        else
            j = j + 1;
        end
    end
end

%combine the two methods
handholds_centers = vertcat(centers1,centers2);
handholds_radii = vertcat(radii1,radii2);

%EDIT
%%[handholds_centers, handholds_radii, metric2] = imfindcircles(realImg,X,'Sensitivity',0.95,...
%    'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.09);

%scaling factors
%%width_of_wall = 28;
%little wall 28
width_of_wall = 48 + 1/16;
xscaling_factor = width_of_wall/width2;
%%height_of_wall = 46 + 15/16;
height_of_wall = 95 + 15/16;
yscaling_factor = height_of_wall/height2;


i = 1;
while i <= length(handholds_centers)
    if handholds_centers(i,1) > 929 && handholds_centers(i,2) < 359 ||...
            handholds_centers(i,1) < 30
        handholds_centers(i,:) = [];
        handholds_radii(i,:) = [];
    else
        i = i + 1;
    end
end

i = 1;
obstacles = [];
while i <= length(handholds_centers)
    %compute Euclidean distances:
    distances = sqrt(sum(bsxfun(@minus, points, handholds_centers(i,:)).^2,2));
    %find the smallest distance and use that as an index into B:
    closest = points((distances==min(distances)),:);
    %[~, xindex] = min(abs(points(:,1)-handholds_centers(i,1)));
    %[~, yindex] = min(abs(points(:,2)-handholds_centers(i,2)));
    
    %closestValues = points(index,:);
    
    if norm(handholds_centers(i,:)-closest) > closeness*.1
        realImg = insertText(realImg,[handholds_centers(i,1)-30 handholds_centers(i,2)-30],'X','FontSize',...
            30,'BoxColor','red','BoxOpacity',0.4,'TextColor','black');
        obstacles = [obstacles;handholds_centers(i,1) handholds_centers(i,2)];
%         if norm(position-closest) < closeness*1.5
%             handholds_centers(i,:) = [];
%             handholds_radii(i,:) = [];
%             canDelete2 = true;
%         end
        handholds_centers(i,:) = [];
        handholds_radii(i,:) = [];

%         if norm(position-closest) < closeness*1.5
%             handholds_centers(i,:) = [];
%             handholds_radii(i,:) = [];
%             canDelete2 = true;
%         end
    else
        i = i + 1;
    end
%     if canDelete1 == true && canDelete2 == true 
%         i = i - 2;
%     elseif canDelete1 == false && canDelete2 == false
%         i = i + 1;
%     end
end

imshow(realImg);
dimensions = size(realImg);
width2 = dimensions(2);
height2 = dimensions(1);

i = 1;
while i <= length(holds_px)
    %compute Euclidean distances:
    distances = sqrt(sum(bsxfun(@minus, obstacles, holds_px(i,:)).^2,2));
    %find the smallest distance and use that as an index into B:
    closest = obstacles((distances==min(distances)),:);
    %[~, xindex] = min(abs(points(:,1)-handholds_centers(i,1)));
    %[~, yindex] = min(abs(points(:,2)-handholds_centers(i,2)));
    
    %closestValues = points(index,:);
    
    if norm(holds_px(i,:)-closest) < closeness*2
%         if norm(position-closest) < closeness*1.5
%             handholds_centers(i,:) = [];
%             handholds_radii(i,:) = [];
%             canDelete2 = true;
%         end
        holds_px(i,:) = [];
        holds_r(i,:) = [];
    else
        i = i + 1;
    end
end


viscircles(holds_px, holds_r,'EdgeColor','b');


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


%convert handholds from pixels to inches
% for i = 1:length(handholds_centers)
%     handholds_centers(i,1) = handholds_centers(i,1)*xscaling_factor;
%     handholds_centers(i,2) = (height2-handholds_centers(i,2))*yscaling_factor;
%     if handholds_centers(i,2) > 60
%         handholds_centers(i,2) = handholds_centers(i,2)-0.28;
%         if handholds_centers(i,1) < 12
%             handholds_centers(i,1) = handholds_centers(i,1)+0.2;
%         elseif handholds_centers(i,1) > 39
%             handholds_centers(i,1) = handholds_centers(i,1)-0.27;
%         end
%     elseif handholds_centers(i,2) < 30
%         handholds_centers(i,2) = handholds_centers(i,2) + 0.21;
%         if handholds_centers(i,1) < 12
%             handholds_centers(i,1) = handholds_centers(i,1)+0.2;
%         elseif handholds_centers(i,1) > 39
%             handholds_centers(i,1) = handholds_centers(i,1)-0.27;
%         end
%     else
%         handholds_centers(i,2) = handholds_centers(i,2) - 0.1;
%     end
% end

temp_holds_in = holds_in;

end