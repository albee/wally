% WallyLocater 
% This function locates Wally's end effectors. Preliminary implementation.
function [endeffector_centers,shoulder_centers,endeffector_points,shoulder_points] = WallyLocator(T,xmin,ymin,xmax,ymax,width2,height2)

%% Setup
%his shoulders as well (eventually). Output is a 4x2 matrix of his end
%effectors A,B,C,D in that order clockwise from the top left


%Can use the next line to demonstrate, but then comment out everything
%before the search for end effectors
%%wallypic = imread('wallykinecty2.jpg');

%See InitializingWallSetup for detailed comments on each section (this
%function is simply reexecuting it with values defined in that functions
%setup)

%--------------------------------------------------------------------------
% Setup
%--------------------------------------------------------------------------
%scaling factors
X = [4 7];

CLOSENESS = 20;

%Little Wall
% WIDTH_OF_WALL = 28;
% HEIGHT_OF_WALL = 46 + 15/16;

%Big Wall
WIDTH_OF_WALL = 48 + 1/16;
HEIGHT_OF_WALL = 95 + 15/16;

xscaling_factor = WIDTH_OF_WALL/width2;
yscaling_factor = HEIGHT_OF_WALL/height2;

%image acquisition
try
    colorVid = videoinput('kinect',1,'BGR_1920x1080');
    colorimg = getsnapshot(colorVid);
    img = imrotate(colorimg,-90);
    firstImg = flipdim(img,2);
catch
    firstImg = imread('./testing_pics/newwallyTEST6.jpg');
end

%--------------------------------------------------------------------------
% Computation
%--------------------------------------------------------------------------

%% Crop
secondImg = imtransform(firstImg,T); 
wallypic1 = imcrop(secondImg,[xmin ymin xmax-xmin ymax-ymin]);
wallypic = rgb2gray(wallypic1);
wallypic = imsharpen(wallypic,'Radius',3,'Amount',2,'Threshold',.3);
imshow(wallypic);

%% Find Hands and Shoulders
%find end effectors
[shoulder_centers, sradii, metric1] = imfindcircles(wallypic,X,'Sensitivity',0.9,...
    'Method','twostage','EdgeThreshold',0.35);
% [shoulder_centers, sradii, metric1] = imfindcircles(wallypic,X,'Sensitivity',0.85,...
%     'Method','twostage','EdgeThreshold',0.2);
[endeffector_centers, eradii, metric2] = imfindcircles(wallypic,X,'Sensitivity',0.87,...
    'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.152);
% [endeffector_centers, eradii, metric2] = imfindcircles(wallypic,X,'Sensitivity',0.8,...
%     'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.14);
endeffector_centers = endeffector_centers(1:4,:); % take strongest 4
eradii = eradii(1:4,:);
metric2 = metric2(1:4,:);
shoulder_centers = shoulder_centers(1:3,:);
sradii = sradii(1:3,:);
metric1 = metric1(1:3,:);

%eliminate extraneous circles
%IMPORTANT, CHANGES NEED TO BE MADE FOR SMALLER WALL
i = 1;
while i <= size(endeffector_centers,1)
    j = 1;
    while j <= size(shoulder_centers,1)
        if norm(endeffector_centers(i,:) - shoulder_centers(j,:)) < CLOSENESS
            shoulder_centers(j,:) = [];
            sradii(j,:) = [];
        else
            j = j + 1;
        end
    end
    if endeffector_centers(i,1) < 50 || endeffector_centers(i,1) > 920
        endeffector_centers(i,:) = [];
        eradii(i,:) = [];
    else
        i = i + 1;
    end
end

%uncomment below if you want to see the circles on an image
%%imshow(wallypic);
%%viscircles(shoulder_centers, sradii,'EdgeColor','r');

%% Assigning Hands and Shoulders
%assigning and reordering the endeffectors to go from A clockwise
text_str = cell(4,1);
letter = ['A' 'B' 'C' 'D'];
for ii=1:4
    text_str{ii} = [letter(ii)];
end

left = zeros(2,2);
[~,index] = min(endeffector_centers(:,1));
left(1,:) = endeffector_centers(index,:);
endeffector_centers(index,:) = [];
[~,index] = min(endeffector_centers(:,1));
left(2,:) = endeffector_centers(index,:);
endeffector_centers(index,:) = [];

right = zeros(2,2);
[~,index] = max(endeffector_centers(:,1));
right(1,:) = endeffector_centers(index,:);
endeffector_centers(index,:) = [];
[~,index] = max(endeffector_centers(:,1));
right(2,:) = endeffector_centers(index,:);
endeffector_centers(index,:) = [];

bottom_left = zeros(1,2);
[~,index] = max(left(:,2));
bottom_left(1,:) = left(index,:);
left(index,:) = [];
top_left = left;

bottom_right = zeros(1,2);
[~,index] = max(right(:,2));
bottom_right(1,:) = right(index,:);
right(index,:) = [];
top_right = right;

endeffector_centers = [top_left;top_right;bottom_right;bottom_left];
endeffector_points = endeffector_centers;

position = endeffector_centers;
box_color = {'green','green','green','green'};
RGB = insertText(wallypic1,position,text_str,'FontSize',30,'BoxColor',...
    box_color,'BoxOpacity',0.4,'TextColor','white');
imshow(RGB)

%Assigning and reordering the shoulders to go from A clockwise
left = zeros(2,2);
[~,index] = min(shoulder_centers(:,1));
left(1,:) = shoulder_centers(index,:);
shoulder_centers(index,:) = [];
[~,index] = min(shoulder_centers(:,1));
left(2,:) = shoulder_centers(index,:);
shoulder_centers(index,:) = [];

right = zeros(2,2);
[~,index] = max(shoulder_centers(:,1));
right(1,:) = shoulder_centers(index,:);
shoulder_centers(index,:) = [];

bottom_left = zeros(1,2);
[~,index] = max(left(:,2));
bottom_left(1,:) = left(index,:);
left(index,:) = [];
top_left = left;

bottom_right = zeros(1,2);
[~,index] = max(right(:,2));
bottom_right(1,:) = right(index,:);

body_angle = atan((bottom_right(2)-bottom_left(2))/...
    (bottom_right(1)-bottom_left(1)));

shoulder_distance = norm(bottom_right-bottom_left);

shoulder_centers = [top_left;top_left(1)+shoulder_distance*cos(...
    body_angle),top_left(2)+shoulder_distance*sin(body_angle)...
    ;bottom_right;bottom_left];

%93.648 is pixel distance from one shoulder to another

sradii = [5;5;5;5];
shoulder_points = shoulder_centers;

%viscircles(shoulder_centers, sradii,'EdgeColor','r');

% text_str = cell(4,1);
% letter = ['A' 'B' 'C' 'D'];
% for ii=1:4
%     text_str{ii} = [letter(ii)];
% end
% position = shoulder_centers;
% box_color = {'blue','blue','blue','blue'};
% RGB = insertText(RGB,position,text_str,'FontSize',30,'BoxColor',...
%     box_color,'BoxOpacity',0.4,'TextColor','white');
% figure
% imshow(RGB)
% title('End Effector and Shoulder Locations');
% 
eradii = [5;5;5;5];
viscircles(endeffector_centers, eradii,'EdgeColor','b');

%% Get Real Dimensions

%convert to real world dimensions
for i = 1:length(endeffector_centers)
    endeffector_centers(i,1) = endeffector_centers(i,1)*xscaling_factor;
    endeffector_centers(i,2) = (height2-endeffector_centers(i,2))*yscaling_factor;
end
for i = 1:length(shoulder_centers)
    shoulder_centers(i,1) = shoulder_centers(i,1)*xscaling_factor;
    shoulder_centers(i,2) = (height2-shoulder_centers(i,2))*yscaling_factor;
end

impixelinfo;

%uncomment below if you want to check for extraneous circles
%%length(endeffector_centers)

%% 4 EE Selector
% [endeffectors_x,endeffectors_y] = getpts;
% for j = 1:length(endeffectors_x)
%     for i = 1:length(points)
%         if norm(points(i,:) - [endeffectors_x(j),endeffectors_y(j)]) <...
%                 closeness*3
%             endeffectors_x(j) = points(i,1);
%             endeffectors_y(j) = points(i,2);
%             viscircles(points(i,:), points_radii(i,:),'EdgeColor','b');
%             endeffectors_y(j)= height2-endeffectors_y(j);
%             endeffectors_x(j) = xscaling_factor*endeffectors_x(j);
%             endeffectors_y(j) = yscaling_factor*endeffectors_y(j);
%             break
%         end
%     end
% end
% endeffector_centers = [endeffectors_x,endeffectors_y];

end