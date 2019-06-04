%testcode

A = imread('walltestv2.jpg');
B = imresize(A,0.25);
B = imrotate(B,-90);
%Matlabcv v6
clear
close all
clc

A = imread('walltestv2.jpg');
B = imresize(A,0.25);
B = imrotate(B,-90);
imshow(B)
hold on
%imgscale=.25;
closeness = 20;
X = [10 13];
[centers1, radii1, metric1] = imfindcircles(B,X,'Sensitivity',0.85,...
    'Method','twostage','EdgeThreshold',0.05);
[centers2, radii2, metric2] = imfindcircles(B,X,'Sensitivity',0.91,...
    'ObjectPolarity','dark','Method','twostage','EdgeThreshold',0.036);

for i = 1:size(centers1,1)
    j = 1;
    while j <= size(centers2,1)
        if norm(centers1(i,:) - centers2(j,:)) < closeness
            centers2(j,:) = [];
            radii2(j,:) = [];
        end
        j = j + 1;
    end
end

centers = vertcat(centers1,centers2);
radii = vertcat(radii1,radii2);


corners = zeros(4,2);

[~,index] = min(centers(:,1));
corners(1,:) = centers(index,:); 
centers(index,:) = [];
radii(index,:) = [];
[~,index] = max(centers(:,1));
corners(2,:) = centers(index,:);
centers(index,:) = [];
radii(index,:) = [];
[~,index] = min(centers(:,1));
corners(3,:) = centers(index,:);
centers(index,:) = [];
radii(index,:) = [];
[~,index] = max(centers(:,1));
corners(4,:) = centers(index,:);
centers(index,:) = [];
radii(index,:) = [];

% while corners(1,1) == 0 | corners(2,1) == 0 | corners(3,1) == 0 | corners(4,1) == 0 | corners(1,2) == 0 | corners(2,2) == 0 | corners(3,2) == 0 | corners(4,2) == 0
%     
%     [~,index1x] = min(centers(:,1));
%     [~,index2x] = max(centers(:,1));
%     [~,index1y] = min(centers(:,2));
%     [~,index2y] = max(centers(:,2));
%     if index1x == index1y
%         corners(1,:) = centers(index1x,:);
%         centers(index1x,:) = [];
%         radii(index1x,:) = [];
%     elseif index1x == index2y
%         corners(3,:) = centers(index1x,:);
%         centers(index1x,:) = [];
%         radii(index1x,:) = [];
%     elseif index2x == index1y
%         corners(2,:) = centers(index2x,:);
%         centers(index2x,:) = [];
%         radii(index2x,:) = [];
%     elseif index2x == index2y
%         corners(4,:) = centers(index2x,:);
%         centers(index2x,:) = [];
%         radii(index2x,:) = [];
%     elseif index1x ~= index1y & index1x ~= index2y & index2x ~= index1y & index2x ~= index2y
%         if centers(index1y,1) > centers(index1x,1) & centers(index1y,1) < centers(index2x,1) & centers(index1y,1) < centers(index2y,1)
%             corners(1,:) = centers(index1y,:);
%             centers(index1y,:) = [];
%             radii(index1y,:) = [];
%         end
%     end
% end


impixelinfo;

centers;

left = zeros(2,2);
[~,index] = min(corners(:,1));
left(1,:) = corners(index,:);
corners(index,:) = [];
[~,index] = min(corners(:,1));
left(2,:) = corners(index,:);
corners(index,:) = [];

right = zeros(2,2);
[~,index] = max(corners(:,1));
right(1,:) = corners(index,:);
corners(index,:) = [];
[~,index] = max(corners(:,1));
right(2,:) = corners(index,:);
corners(index,:) = [];

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


%%%Remember to implement the above on the other centers as well


length(centers);

%%%B = imcrop(B,[bottom_left(1) bottom_left(2) bottom_right(1)-bottom_left(1) top_right(2)-bottom_right(2)])
%%%figure, imshow(B)

hold off

U = zeros(4,2);
U = [top_left;top_right;bottom_left;bottom_right];
X = [0,0;465,0;0,690;465,690];

T = maketform('projective',U,X);

B2 = imtransform(B,T); 
figure, imshow(B2)
B2 = imcrop(B2,[56 53 486 705]);
%[xmin ymin width height]
figure, imshow(B2)
hold on
impixelinfo;

[handholdsx,handholdsy] = getpts

radii = 8;

for i = 1:length(handholdsx)
    viscircles([handholdsx(i) handholdsy(i)], radii,'EdgeColor','b');
end

