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

function [rot_img] = rotate_image(img, R)
    % Function to rotate an image using a transformation matrix
    [y_max, x_max] = size(img);
    fprintf('Image size: %d x %d\n', y_max, x_max);
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
end

tic; % Start timing
rot_img_custom = rotate_image(img, R); % Rotate using custom code
custom_time = toc; % End timing

% Rotate the image by 90 degrees using inbuilt functions
tic; % Start timing
% Create the transformation matrix using maketform
tform = maketform('affine', R);
% Apply the transformation using imtransform      
rot_img_inbuilt = imtransform(img, tform);
inbuilt_time = toc; % End timing

% Display the rotated image using inbuilt functions
figure('Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Units', 'normalized');

% Create very tight subplot layout
p = get(gcf, 'Position');

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

% save the figure
saveas(gcf, './L1/report/img3_q1.png', 'png');

H = size(img,1); % Read the height of the image
W = size(img,2); % Read the width of the image

Hist_arr = zeros(1,256); % Array for holding the (original) histogram
Hist_eq_arr = zeros(1,256); % Array for holding the (equalized) histogram

CDF_array = zeros(1,length(Hist_arr)); % array to hold cumulative distribution function (CDF)

hist_eq_img = uint8(zeros(H,W)); % A 2D array for keeping histogram equalized image (intensity in 8 bit integers)

for i=1:H,
    for j=1:W,
        Hist_arr(1,img(i,j)+1)=Hist_arr (1,img(i,j)+1)+1 ;
    end
end

Hist_arr_pdf = Hist_arr/(H*W); % PDF

dummy1=0; % A dummy variable to hold the summation results
for k=1:length(Hist_arr); % Generating the CDF from PDF
    dummy1=dummy1+Hist_arr_pdf(k);
    CDF_array(k)= dummy1;
end

for l=1:H, % Histogram equalization
    for m=1:W,
        hist_eq_img(l,m)= round(CDF_array(img(l,m)+1)*(length(Hist_arr_pdf)-1)); % scale to 255 and round to nearest integer
        Hist_eq_arr(1, hist_eq_img(l,m)+1)=Hist_eq_arr (1,hist_eq_img(l,m)+1)+1; % Its histogram
    end
end

figure;
subplot(2,2,1);
imshow(img);
title('Original Image');
subplot(2,2,2);
bar(Hist_arr);
title('Histogram of Original Image');
subplot(2,2,3);
imshow(hist_eq_img);
title('Histogram Equalized Image');
subplot(2,2,4);
bar(Hist_eq_arr);
title('Histogram of Equalized Image');

% Save the histogram equalized image
saveas(gcf, './L1/report/img3_hist_eq.png', 'png');