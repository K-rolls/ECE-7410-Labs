imc = imread("~/_MUN/ECE-7410/labs/L1/im1.png");

img = rgb2gray(imc);

imshow(img);
title('Image in grayscale');

% Rotate 45 degrees
theta = -25*(pi/180);

% Transformation matrix for rotation
R = [cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
    0           0          1];

[y_max, x_max] = size(img); % Obtaining the size of the image

corners = [0,0,1;
    x_max,0,1;
    0,y_max,1;
    x_max,y_max,1]; % Corner points of the image

new_corners = corners*R % New location of corners
new_width = round(max(new_corners(:,1)) - min(new_corners(:,1)));
new_height = round(max(new_corners(:,2)) - min(new_corners(:,2)));
new_img = zeros(new_height,new_width);

min_width = abs(min(new_corners(:,1)));
min_height = abs(min(new_corners(:,2)));
min_width = round(min_width)+1;
min_height = round(min_height)+1;
rot_img = zeros(new_height,new_width);
for i = 1:y_max
    for j = 1:x_max
        temp = ([j-1 i-1 1])*R;
        x_new = round(temp(1,1))+ min_width;
        y_new = round(temp(1,2))+ min_height;
        rot_img(y_new,x_new) = img(i,j);
    end
end

figure;
imshow(rot_img, []);
title('Rotated image');