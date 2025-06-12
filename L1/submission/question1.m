imc = imread("~/_MUN/ECE-7410/labs/L1/im1.png");

img = rgb2gray(imc);

% Ensure directory exists
if ~exist('./L1/report', 'dir')
    mkdir('./L1/report');
end

imwrite(img, './L1/report/img1_grey.png');

function [rot_img] = rotate_image(img, R)
    % Rotate image `img` using the transformation matrix `R`
    [y_max, x_max] = size(img);
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

    rot_img = zeros(new_height, new_width);

    for i = 1:y_max
        for j = 1:x_max
            temp = ([j - 1, i - 1, 1]) * R;
            x_new = round(temp(1, 1)) + min_width;
            y_new = round(temp(1, 2)) + min_height;
            rot_img(y_new, x_new) = img(i, j);
        end
    end

    % convert to uint8 for display
    rot_img = uint8(rot_img);
end

function [R] = rotation_matrix(theta)
    % Create a rotation matrix for a given angle in radians
    R = [cos(theta) -sin(theta) 0;
         sin(theta) cos(theta) 0;
         0 0 1];
end

rot_img_45 = rotate_image(img, rotation_matrix(pi / 4));
rot_img_90 = rotate_image(img, rotation_matrix(pi / 2));
rot_img_25 = rotate_image(img, rotation_matrix((-25) * (pi / 180)));

figure;
subplot(1, 3, 1);
imshow(rot_img_45, []);
title('Rotated image by 45 degrees');
imwrite(rot_img_45, './L1/report/img1_rotated_45.png', 'png');

subplot(1, 3, 2);
imshow(rot_img_90, []);
title('Rotated image by 90 degrees');
imwrite(rot_img_90, './L1/report/img1_rotated_90.png', 'png');

subplot(1, 3, 3);
imshow(rot_img_25, []);
title('Rotated image by -25 degrees');
imwrite(rot_img_25, './L1/report/img1_rotated_25.png', 'png');

function [new_image] = transform_image_inverse(img, T)
    % Transform image using inverse transformation mapping
    [y_max, x_max] = size(img);

    % Calculate corners of original image
    corners = [0, 0, 1;
               x_max, 0, 1;
               0, y_max, 1;
               x_max, y_max, 1];

    % Transform corners to find output image size
    new_corners = corners * T;
    new_width = round(max(new_corners(:, 1)) - min(new_corners(:, 1)));
    new_height = round(max(new_corners(:, 2)) - min(new_corners(:, 2)));
    min_width = abs(min(new_corners(:, 1)));
    min_height = abs(min(new_corners(:, 2)));
    min_width = round(min_width) + 1;
    min_height = round(min_height) + 1;

    % Initialize output image
    new_image = zeros(new_height, new_width);

    % Invert transformation matrix
    T_inv = inv(T);

    % For each pixel in output image, find corresponding input pixel
    for i = 1:new_height
        for j = 1:new_width
            % Map output coordinates back to input coordinates
            output_coords = [j - min_width, i - min_height, 1];
            input_coords = output_coords * T_inv;

            x_orig = round(input_coords(1)) + 1;
            y_orig = round(input_coords(2)) + 1;

            % Check if coordinates are within input image bounds
            if (x_orig >= 1 && x_orig <= x_max) && (y_orig >= 1 && y_orig <= y_max)
                new_image(i, j) = img(y_orig, x_orig);
            else
                new_image(i, j) = 0; % Assign zero if out of bounds
            end
        end
    end

    % Convert to uint8 for display
    new_image = uint8(new_image);
end

% Translation 50 pixels right and 45 pixels down
T_i = [1 0 0;
       0 1 0;
       50 45 1];

rot_img_i = transform_image_inverse(img, T_i);

% Scale by 0.5 in x-direction and 1.5 in y-direction
T_ii = [0.5 0 0;
        0 1.5 0;
        0 0 1];

rot_img_ii = transform_image_inverse(img, T_ii);

% Shear by 0.2 in vertical direction
T_iii = [1 0.2 0;
         0 1 0;
         0 0 1];

rot_img_iii = transform_image_inverse(img, T_iii);

% Shear by 0.3 in horizontal direction
T_iv = [1 0 0;
        0.3 1 0;
        0 0 1];

rot_img_iv = transform_image_inverse(img, T_iv);

% Rotation by 50 degrees followed by translation 25 pixels right and 30 pixels down
theta_v = 50 * (pi / 180); % Convert degrees to radians

T_v = rotation_matrix(theta_v) * [1 0 0;
                                  0 1 0;
                                  25 30 1];

rot_img_v = transform_image_inverse(img, T_v);

figure;
subplot(2, 3, 1);
imshow(rot_img_i, []);
title('Translation $\left( t_x = 50, t_y = 45 \right)$', 'Interpreter', 'latex');
imwrite(rot_img_i, './L1/report/img1_6_i.png', 'png');

subplot(2, 3, 2);
imshow(rot_img_ii, []);
title('Scale $\left(c_x = 0.5, c_y = 1.5\right)$', 'Interpreter', 'latex');
imwrite(rot_img_ii, './L1/report/img1_6_ii.png', 'png');

subplot(2, 3, 3);
imshow(rot_img_iii, []);
title('Shear (vertical) $\left(s_v = 0.2\right)$', 'Interpreter', 'latex');
imwrite(rot_img_iii, './L1/report/img1_6_iii.png', 'png');

subplot(2, 3, 4);
imshow(rot_img_iv, []);
title('Shear (horizontal) $\left(s_v = 0.3\right)$', 'Interpreter', 'latex');
imwrite(rot_img_iv, './L1/report/img1_6_iv.png', 'png');

subplot(2, 3, 5);
imshow(rot_img_v, []);
title('Rotation $\left(\theta = 50^\circ\right)$ followed by translation $\left( t_x = 25, t_y = 30 \right)$', 'Interpreter', 'latex');
imwrite(rot_img_v, './L1/report/img1_6_v.png', 'png');

subplot(2, 3, 6);
imshow(img, []);
title('Original Image');
