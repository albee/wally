function [handholds_centers,handholds_radii,T,xmin,ymin,xmax,ymax,...
          width2,height2,realImg,off_by_roughly,...
          points] = InitializingWallSetup()
%InitializingWallSetup Call this at the beginning of a wall usage to setup
%the correct guidelines for viewing the wall given the tripod/wall setup.
%The outputs are necessary as inputs for following functions for
%streamlining

%% Setup

%INSTRUCTIONS:
%First Image (first crop for easier selection)
%(1) click the top left corner of the image you want to crop
%(2) click the top right corner of the image you want to crop
%(3) double click the bottom left corner of the image you want to crop
%Second Image (projection to make 2D)
%(1) click the four corners of the physical wall, starting with the top
%left corner, then the top right, then bottom left, then bottom right
%(double clicking the bottom right one)
%Third Image (final crop)
%(1) double click the top left corner of the physical wall
%(2) double click the bottom right corner of the physical wall
%Accuracy Check
%(1) click in the center of the bottom left handhold
%(2) double click in the center of the top right handhold


%AS A GENERAL COMMENT: I WANT TO PUT A CHECK IN HERE WHERE IT WILL ONLY
%ALLOW YOU TO PROCEDE IF FOUR (OR SOME OTHER NUMBER) OF THE POINTS ARE
%WITHIN AN ACCEPTABLE INCH DISTANCE OF THEIR KNOWN (PREMEASURED) VALUE,
%ALSO THE RIGHT NUMBER OF HANDHOLDS (LENGTH CHECK)

%width of test wall is 28 and 3/16 inch
%height of test wall is 46 and 15/16 inch
%distance from back of kinect to wall ~57 inches

%--------------------------------------------------------------------------
% Setup
%--------------------------------------------------------------------------
%scaling factors
X = [10 12];

CLOSENESS = 20;

%Little Wall
% WIDTH_OF_WALL = 28;
% HEIGHT_OF_WALL = 46 + 15/16;

%Big Wall
WIDTH_OF_WALL = 48 + 1/16;
HEIGHT_OF_WALL = 95 + 15/16;

%number of disks for check
DISKS = 154;
%desired accuracy of measurements +/- (inches)
ACCURACY = 1;

%--------------------------------------------------------------------------
% Computation
%--------------------------------------------------------------------------

%setup kinect and get first image
try
    colorVid = videoinput('kinect',1,'BGR_1920x1080');
    colorimg = getsnapshot(colorVid);
    img = imrotate(colorimg,-90);
    firstImg = flipdim(img,2);
catch
    firstImg = imread('./img/newTEST.jpg');
end
imshow(firstImg);

%% Pre Crop
%first select top left corner, then top right, then bottom left double
%click, this makes the image more manageable
% [firstcropx,firstcropy] = getpts;
% 
% firstImg = imcrop(firstImg,[firstcropx(1) firstcropy(1) firstcropx(2)-...
%     firstcropx(1) firstcropy(3)-firstcropy(1)]);
% cla;
% imshow(firstImg);
% 
% dimensions = size(firstImg);
% width1 = dimensions(2);
% height1 = dimensions(1);

%% First Crop

dimensions = size(firstImg);
width1 = dimensions(2);
height1 = dimensions(1);

%determines image projection, click on upper left, upper right, lower left,
%double click lower right
[cornersx,cornersy] = getpts;
U = [cornersx(1),cornersy(1);cornersx(2),cornersy(2);...
    cornersx(3),cornersy(3);cornersx(4),cornersy(4)];
X_tmp = [0,0;width1,0;0,height1;width1,height1];
T = maketform('projective',U,X_tmp);
secondImg = imtransform(firstImg,T); 
cla;
imshow(secondImg)

%% Second Crop

%double click top left corner and bottom right corner
[xmin,ymin] = getpts;
[xmax,ymax] = getpts;

realImg = imcrop(secondImg,[xmin ymin xmax-xmin ymax-ymin]);
cla;
imshow(realImg);

dimensions = size(realImg);
width2 = dimensions(2);
height2 = dimensions(1);
xscaling_factor = WIDTH_OF_WALL/width2;
yscaling_factor = HEIGHT_OF_WALL/height2;

%% Handhold Search

%search for handholds
% [centers1, radii1, metric1] = imfindcircles(realImg,X,'Sensitivity',0.9,...
%     'Method','twostage','EdgeThreshold',0.9);
% [centers2, radii2, metric2] = imfindcircles(realImg,X,'Sensitivity',0.965,...
%     'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.09);
% 
% %eliminate overlapping or double counted circles
% for i = 1:size(centers2,1)
%     j = 1;
%     while j <= size(centers1,1)
%         if norm(centers2(i,:) - centers1(j,:)) < closeness
%             centers1(j,:) = [];
%             radii1(j,:) = [];
%         else
%             j = j + 1;
%         end
%     end
% end
% 
% %combine the two methods
% handholds_centers = vertcat(centers1,centers2);
% handholds_radii = vertcat(radii1,radii2);

%identify handholds
% [handholds_centers, handholds_radii, metric2] = imfindcircles(realImg,X,'Sensitivity',0.95,...
%     'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.09);

[centers1, radii1, metric1] = imfindcircles(realImg,X,'Sensitivity',0.98,...
    'Method','twostage','EdgeThreshold',0.9);
[centers2, radii2, metric2] = imfindcircles(realImg,X,'Sensitivity',0.976,...
    'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.099);

%eliminate overlapping or double counted circles
for i = 1:size(centers2,1)
    j = 1;
    while j <= size(centers1,1)
        if norm(centers2(i,:) - centers1(j,:)) < CLOSENESS
            centers1(j,:) = [];
            radii1(j,:) = [];
        else
            j = j + 1;
        end
    end
end
% 
% %combine the two methods
%combine the two methods
handholds_centers = vertcat(centers1,centers2);
handholds_radii = vertcat(radii1,radii2);

i = 1;
while i <= length(handholds_centers)
    if handholds_centers(i,1) > 999 && handholds_centers(i,2) < 359 || handholds_centers(i,1) < 30
        handholds_centers(i,:) = [];
        handholds_radii(i,:) = [];
    elseif handholds_centers(i,1) > 1000
        handholds_centers(i,:) = [];
        handholds_radii(i,:) = [];
    elseif handholds_centers(i,2) < 25
        handholds_centers(i,:) = [];
        handholds_radii(i,:) = [];
    else
        i = i + 1;
    end
end

viscircles(handholds_centers, handholds_radii,'EdgeColor','b');
points = handholds_centers;

%convert handholds from pixels to inches
for i = 1:length(handholds_centers)
    handholds_centers(i,1) = handholds_centers(i,1)*xscaling_factor;
    handholds_centers(i,2) = (height2-handholds_centers(i,2))*yscaling_factor;
    if handholds_centers(i,2) > 60
        handholds_centers(i,2) = handholds_centers(i,2)-0.28;
        if handholds_centers(i,1) < 12
            handholds_centers(i,1) = handholds_centers(i,1)+0.2;
        elseif handholds_centers(i,1) > 39
            handholds_centers(i,1) = handholds_centers(i,1)-0.27;
        end
    elseif handholds_centers(i,2) < 30
        handholds_centers(i,2) = handholds_centers(i,2) + 0.21;
        if handholds_centers(i,1) < 12
            handholds_centers(i,1) = handholds_centers(i,1)+0.2;
        elseif handholds_centers(i,1) > 39
            handholds_centers(i,1) = handholds_centers(i,1)-0.27;
        end
    else
        handholds_centers(i,2) = handholds_centers(i,2) - 0.1;
    end

end

impixelinfo;

%% Check
%accuracy checking procedures, repeats the function if two specified points
%are not located where they should be
%accuracy_check = [4 4;24 44];
% accuracy_check = [4+1/16 3+15/16;44 28;23+3/16 55+25/32];
% [xaccuracy_compare1,yaccuracy_compare1] = getpts;
% [xaccuracy_compare2,yaccuracy_compare2] = getpts;
% [xaccuracy_compare3,yaccuracy_compare3] = getpts;
% for i = 1:length(points)
%     if norm(points(i,:) - [xaccuracy_compare1,yaccuracy_compare1]) <...
%             closeness
%         xaccuracy_compare1 = points(i,1);
%         yaccuracy_compare1 = points(i,2);
%         viscircles(points(i,:), handholds_radii(i,:),'EdgeColor','g');
%         yaccuracy_compare1 = height2-yaccuracy_compare1;
%         xaccuracy_compare1 = xscaling_factor*xaccuracy_compare1;
%         yaccuracy_compare1 = yscaling_factor*yaccuracy_compare1;
%     elseif norm(points(i,:) - [xaccuracy_compare2,yaccuracy_compare2]) <...
%             closeness
%         xaccuracy_compare2 = points(i,1);
%         yaccuracy_compare2 = points(i,2);
%         viscircles(points(i,:), handholds_radii(i,:),'EdgeColor','g');
%         yaccuracy_compare2 = height2-yaccuracy_compare2;
%         xaccuracy_compare2 = xscaling_factor*xaccuracy_compare2;
%         yaccuracy_compare2 = yscaling_factor*yaccuracy_compare2;
%     elseif norm(points(i,:) - [xaccuracy_compare3,yaccuracy_compare3]) <...
%             closeness
%         xaccuracy_compare3 = points(i,1);
%         yaccuracy_compare3 = points(i,2);
%         viscircles(points(i,:), handholds_radii(i,:),'EdgeColor','g');
%         yaccuracy_compare3 = height2-yaccuracy_compare3;
%         xaccuracy_compare3 = xscaling_factor*xaccuracy_compare3;
%         yaccuracy_compare3 = yscaling_factor*yaccuracy_compare3;
%     end
% end


% if norm(accuracy_check(1)-[xaccuracy_compare1,yaccuracy_compare1])...
%         > accuracy && norm(accuracy_check(2)-[xaccuracy_compare2...
%         ,yaccuracy_compare2]) > accuracy
%     InitializingWallSetup()
% elseif length(points) ~= disks
%     InitializingWallSetup()
% end

% 
% first_check = norm(accuracy_check(1,:)-[xaccuracy_compare1...
%     ,yaccuracy_compare1]);
% second_check = norm(accuracy_check(2,:)-[xaccuracy_compare2...
%     ,yaccuracy_compare2]);
% third_check = norm(accuracy_check(3,:)-[xaccuracy_compare3...
%     ,yaccuracy_compare3]);
% 
% off_by_roughly = (first_check+second_check+third_check)/3;

% if off_by_roughly > accuracy
%     InitializingWallSetup()
% % elseif length(points) ~= disks
% %     InitializingWallSetup()
% end

    
    
% for i = 1:length(handholds_centers)
%     if norm(handholds_centers(i,:) - accuracy_check(1,:)) < 0.2
%         for i = 1:length(handholds_centers)
%             if norm(handholds_centers(i,:) - accuracy_check(2,:)) < 0.2
%                 break
%             else
%                 InitializingWallSetup()
%             end
%         end
%     end
% end
% OR PICK THE POINTS ON SCREEN
            

% str = input('Does this look appropriate? (y/n) ','s');
% s2 = 'n';
% tf = strcmp(str,s2);
% if tf == 1
%     InitializingWallSetup()
% end
off_by_roughly = 0;

end