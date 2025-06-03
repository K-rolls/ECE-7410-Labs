% filepath: /home/krolls/_MUN/ECE-7410/labs/L1/question3.m

% Load the image
imc = imread("~/_MUN/ECE-7410/labs/L1/im3.png");

% Convert to grayscale
img = rgb2gray(imc);

% Display the original image
figure;
imshow(img);
title('Original Image');

% Rotate the image by 90 degrees using custom code from question1.m
tic; % Start timing
theta = -90 * (pi / 180);

% Transformation matrix for rotation
R = [cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
    0           0          1];

[y_max, x_max] = size(img); % Obtaining the size of the image

corners = [0, 0, 1;
    x_max, 0, 1;
    0, y_max, 1;
    x_max, y_max, 1]; % Corner points of the image

new_corners = corners * R; % New location of corners
new_width = round(max(new_corners(:, 1)) - min(new_corners(:, 1)));
new_height = round(max(new_corners(:, 2)) - min(new_corners(:, 2)));
min_width = abs(min(new_corners(:, 1)));
min_height = abs(min(new_corners(:, 2)));
min_width = round(min_width) + 1;
min_height = round(min_height) + 1;

rot_img_custom = zeros(new_height, new_width);
for i = 1:y_max
    for j = 1:x_max
        temp = ([j - 1, i - 1, 1]) * R;
        x_new = round(temp(1, 1)) + min_width;
        y_new = round(temp(1, 2)) + min_height;
        rot_img_custom(y_new, x_new) = img(i, j);
    end
end
custom_time = toc; % End timing

% Display the rotated image using custom code
figure;
imshow(rot_img_custom, []);
title('Rotated Image (Custom Code)');

% Rotate the image by 90 degrees using inbuilt functions
tic; % Start timing
tform = affine2d([cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1]);
% Create appropriate output view for 90-degree rotation (swap width and height)
outputView = imref2d([y_max, x_max]);  % Swap dimensions for 90-degree rotation
[rot_img_inbuilt, RB] = imwarp(img, tform, 'OutputView', outputView, 'FillValues', 0);
inbuilt_time = toc; % End timing

% Display the rotated image using inbuilt functions
figure;
imshow(rot_img_inbuilt, []);
title('Rotated Image (Inbuilt Function)');

% Save the image to the current directory
imwrite(rot_img_inbuilt, 'text.png');

% Compare the speed
fprintf('Time taken using custom code: %.4f seconds\n', custom_time);
fprintf('Time taken using inbuilt functions: %.4f seconds\n', inbuilt_time);