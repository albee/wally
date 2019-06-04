function [T,xmin,ymin,xmax,ymax,...
    width2,height2,points] = InitializingWallSetupnew()
%InitializingWallSetup Call this at the beginning of a wall usage to setup
%the correct guidelines for viewing the wall given the tripod/wall setup.
%The outputs are necessary as inputs for following functions for
%streamlining


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

%number of disks for check
disks = 154;
%desired accuracy of measurements +/- (inches)
accuracy = 1;


%width of test wall is 28 and 3/16 inch
%height of test wall is 46 and 15/16 inch
%distance from back of kinect to wall ~57 inches

%setup kinect and get first image
colorVid = videoinput('kinect',1,'BGR_1920x1080');
colorimg = getsnapshot(colorVid);
img = imrotate(colorimg,-90);
firstImg = flipdim(img,2);
imshow(firstImg);

%%%firstImg = imread('taperectest.jpg');
%%%firstImg = imread('magnetoffsetprep.jpg');

%%%FOR TESTING PURPOSES
%%%firstImg = imread('function_testing.jpg');
%%%imshow(firstImg);

%first select top left corner, then top right, then bottom left double
%click, this makes the image more manageable
%[firstcropx,firstcropy] = getpts;

%%%firstcropx = [2.390000000000001e+02;833;2.420000000000000e+02];
%%%firstcropy = [9.319999999999999e+02;9.289999999999999e+02;1913];

% firstImg = imcrop(firstImg,[firstcropx(1) firstcropy(1) firstcropx(2)-...
%     firstcropx(1) firstcropy(3)-firstcropy(1)]);
figure, imshow(firstImg);
%%impixelinfo;
dimensions = size(firstImg);
width1 = dimensions(2);
height1 = dimensions(1);

%The following is to determine the projection for the image
[cornersx,cornersy] = getpts;
U = [cornersx(1),cornersy(1);cornersx(2),cornersy(2);...
    cornersx(3),cornersy(3);cornersx(4),cornersy(4)];
X = [0,0;width1,0;0,height1;width1,height1];
T = maketform('projective',U,X);
secondImg = imtransform(firstImg,T); 
figure, imshow(secondImg)
%%impixelinfo;

%double click top left corner and bottom right corner
[xmin,ymin] = getpts;
[xmax,ymax] = getpts;

realImg = imcrop(secondImg,[xmin ymin xmax-xmin ymax-ymin]);
realImg = imresize(realImg,[1880 999]);
%[xmin ymin width height]
imshow(realImg);
%%impixelinfo;

%%%realImg = imread('accurate_kinda.jpg');
%%%figure, imshow(realImg)

dimensions = size(realImg);
width2 = dimensions(2);
height2 = dimensions(1);

%search for handholds
closeness = 20;
X = [10 12];
% [centers1, radii1, metric1] = imfindcircles(realImg,X,'Sensitivity',0.98,...
%     'Method','twostage','EdgeThreshold',0.9);
% [centers2, radii2, metric2] = imfindcircles(realImg,X,'Sensitivity',0.976,...
%     'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.099);
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
% handholds_centers = handholds_centers(1:231,:);
% handholds_radii = vertcat(radii1,radii2);
% handholds_radii = handholds_radii(1:231);

%EDIT
[handholds_centers, handholds_radii, metric2] = imfindcircles(realImg,X,'Sensitivity',0.98,...
    'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.09);
% handholds_centers = handholds_centers(1:231,:);
% handholds_radii = handholds_radii(1:231);


viscircles(handholds_centers, handholds_radii,'EdgeColor','b');

%scaling factors
%%width_of_wall = 28;
%little wall 28
width_of_wall = 48 + 1/16;
xscaling_factor = width_of_wall/width2;
%%height_of_wall = 46 + 15/16;
height_of_wall = 95 + 15/16;
yscaling_factor = height_of_wall/height2;

points = handholds_centers;

%convert handholds from pixels to inches
for i = 1:length(handholds_centers)
    handholds_centers(i,1) = handholds_centers(i,1)*xscaling_factor;
    handholds_centers(i,2) = (height2-handholds_centers(i,2))*yscaling_factor;
end

%accuracy checking procedures, repeats the function if two specified points
%are not located where they should be
%%accuracy_check = [20+1/16 35+7/8; 4 44; 15+15/16 24+1/8];
accuracy_check = [4+1/16 3+15/16;44 28;24+3/16 31+1/16];
[xaccuracy_compare1,yaccuracy_compare1] = getpts;
[xaccuracy_compare2,yaccuracy_compare2] = getpts;
[xaccuracy_compare3,yaccuracy_compare3] = getpts;
for i = 1:length(points)
    if norm(points(i,:) - [xaccuracy_compare1,yaccuracy_compare1]) <...
            closeness
        xaccuracy_compare1 = points(i,1);
        yaccuracy_compare1 = points(i,2);
        viscircles(points(i,:), handholds_radii(i,:),'EdgeColor','g');
        yaccuracy_compare1 = height2-yaccuracy_compare1;
        xaccuracy_compare1 = xscaling_factor*xaccuracy_compare1;
        yaccuracy_compare1 = yscaling_factor*yaccuracy_compare1;
    elseif norm(points(i,:) - [xaccuracy_compare2,yaccuracy_compare2]) <...
            closeness
        xaccuracy_compare2 = points(i,1);
        yaccuracy_compare2 = points(i,2);
        viscircles(points(i,:), handholds_radii(i,:),'EdgeColor','g');
        yaccuracy_compare2 = height2-yaccuracy_compare2;
        xaccuracy_compare2 = xscaling_factor*xaccuracy_compare2;
        yaccuracy_compare2 = yscaling_factor*yaccuracy_compare2;
    elseif norm(points(i,:) - [xaccuracy_compare3,yaccuracy_compare3]) <...
            closeness
        xaccuracy_compare3 = points(i,1);
        yaccuracy_compare3 = points(i,2);
        viscircles(points(i,:), handholds_radii(i,:),'EdgeColor','g');
        yaccuracy_compare3 = height2-yaccuracy_compare3;
        xaccuracy_compare3 = xscaling_factor*xaccuracy_compare3;
        yaccuracy_compare3 = yscaling_factor*yaccuracy_compare3;
    end
end


% if norm(accuracy_check(1)-[xaccuracy_compare1,yaccuracy_compare1])...
%         > accuracy && norm(accuracy_check(2)-[xaccuracy_compare2...
%         ,yaccuracy_compare2]) > accuracy
%     InitializingWallSetup()
% elseif length(points) ~= disks
%     InitializingWallSetup()
% end


first_check = norm(accuracy_check(1,:)-[xaccuracy_compare1...
    ,yaccuracy_compare1]);
second_check = norm(accuracy_check(2,:)-[xaccuracy_compare2...
    ,yaccuracy_compare2]);
third_check = norm(accuracy_check(3,:)-[xaccuracy_compare3...
    ,yaccuracy_compare3]);

off_by_roughly = (first_check+second_check+third_check)/3;

% if off_by_roughly > accuracy
%     InitializingWallSetup()
% elseif length(points) ~= disks
%     InitializingWallSetup()
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
            

str = input('Does this look appropriate? (y/n) ','s');
s2 = 'n';
tf = strcmp(str,s2);
if tf == 1
    InitializingWallSetup()
end
    

end