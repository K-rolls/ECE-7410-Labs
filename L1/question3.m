% Load the image
imc = imread("~/_MUN/ECE-7410/labs/L1/im3.png");

% Convert to grayscale
img = rgb2gray(imc);

% Rotate the image by 90 degrees using custom code from question1.m
theta = pi/2;

% Transformation matrix for rotation
R = [cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
    0           0          1];

tic; % Start timing
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

% Rotate the image by 90 degrees using inbuilt functions
rot_angle = pi/2;
tic; % Start timing
% Create the transformation matrix using maketform
tform = maketform('affine', R);
% Apply the transformation using imtransform      
rot_img_inbuilt = imtransform(img, tform);
inbuilt_time = toc; % End timing

% Display the rotated image using inbuilt functions
figure;
subplot(2, 2, 1);
imshow(imc,[]);
title('Original Image');

subplot(2, 2, 2);
imshow(rot_img_inbuilt, []);
title('Rotated Image (Inbuilt Function)');
text(size(rot_img_inbuilt,2)-100, size(rot_img_inbuilt,1)-20, sprintf('Time: %.4f sec', inbuilt_time), 'Color', 'white', 'FontSize', 8, 'BackgroundColor', [0 0 0 0.5]);

subplot(2, 2, 3);
imshow(rot_img_custom, []);
title('Rotated Image (Custom Code)');
text(size(rot_img_custom,2)-100, size(rot_img_custom,1)-20, sprintf('Time: %.4f sec', custom_time), 'Color', 'white', 'FontSize', 8, 'BackgroundColor', [0 0 0 0.5]);

subplot(2, 2, 4);
bar([custom_time, inbuilt_time]);
set(gca, 'xticklabel', {'Custom Code', 'Inbuilt Function'});
title('Performance Comparison');
ylabel('Time (seconds)');
grid on;

% Compare the speed
fprintf('Time taken using custom code: %.4f seconds\n', custom_time);
fprintf('Time taken using inbuilt functions: %.4f seconds\n', inbuilt_time);
