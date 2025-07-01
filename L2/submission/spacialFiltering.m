% ECE 7410 - Laboratory 2: Spatial Filtering

%% Q1.2: Read img1 and convert to grayscale
% Create output directory
if ~exist('./L2/outputs/01_smoothing', 'dir')
    mkdir('./L2/outputs/01_smoothing');
end

% Read image
img1 = imread('./L2/img1.png');
img1_gray = rgb2gray(img1);

% Save the grayscale image
imwrite(img1_gray, './L2/outputs/01_smoothing/img1_grey.png');

%% Q1.3 Function: Custom Spatial Filtering
function output = my_filter2D(img, kernel)
    % Convert inputs to double for calculations
    img = double(img);
    kernel = double(kernel);

    % Get image and kernel dimensions
    [M, N] = size(img);
    [m, n] = size(kernel);

    % Calculate padding needed (zero padding)
    pad_m = floor(m / 2);
    pad_n = floor(n / 2);

    % Zero pad the image
    padded_image = zeros(M + 2 * pad_m, N + 2 * pad_n);
    padded_image(pad_m + 1:M + pad_m, pad_n + 1:N + pad_n) = img;

    % Initialize output image
    output = zeros(M, N);

    % Perform spatial filtering
    for i = 1:M
        for j = 1:N
            % Extract region from padded image
            region = padded_image(i:i + m - 1, j:j + n - 1);
            % Apply spatial filtering: (element-wise multiplication and sum)
            output(i, j) = sum(sum(region .* kernel));
        end
    end

    % Convert back to uint8 and clamp values to [0, 255]
    output = uint8(max(0, min(255, output)));
end

%% Q1.4: Apply spatial filters
% Define Kernels
kernel1 = (1/9) * ones(3);
kernel2 = (1/49) * ones(7);
kernel3 = fspecial('average', [7, 7]);
kernel4 = fspecial('gaussian', [3, 3], 0.5);
kernel5 = fspecial('gaussian', [7, 7], 1.2);

% Apply spatial filters
filtered1 = my_filter2D(img1_gray, kernel1);
filtered2 = my_filter2D(img1_gray, kernel2);
filtered3 = my_filter2D(img1_gray, kernel3);
filtered4 = my_filter2D(img1_gray, kernel4);
filtered5 = my_filter2D(img1_gray, kernel5);

% Save filtered images
% Create kernel output directory
if ~exist('./L2/outputs/01_smoothing/04', 'dir')
    mkdir('./L2/outputs/01_smoothing/04');
end

imwrite(filtered1, './L2/outputs/01_smoothing/04/kernel1.png');
imwrite(filtered2, './L2/outputs/01_smoothing/04/kernel2.png');
imwrite(filtered3, './L2/outputs/01_smoothing/04/kernel3.png');
imwrite(filtered4, './L2/outputs/01_smoothing/04/kernel4.png');
imwrite(filtered5, './L2/outputs/01_smoothing/04/kernel5.png');

%% Q1.5 Function: Custom Median Filtering
function output = my_median_filter(img, kernel_size)
    % Convert to double for calculations
    img = double(img);

    % Get image dimensions
    [M, N] = size(img);

    % Calculate padding needed (zero padding)
    pad = floor(kernel_size / 2);

    % Zero pad the image manually
    padded_image = zeros(M + 2 * pad, N + 2 * pad);
    padded_image(pad + 1:M + pad, pad + 1:N + pad) = img;

    % Initialize output image
    output = zeros(M, N);

    % Perform median filtering
    for i = 1:M
        for j = 1:N
            % Extract region from padded image
            region = padded_image(i:i + kernel_size - 1, j:j + kernel_size - 1);
            % Calculate median of the region
            output(i, j) = median(region(:));
        end
    end

    % Convert back to uint8
    output = uint8(output);
end

%% Q1.6 Apply custom median filters
filtered_median_3 = my_median_filter(img1_gray, 3);
filtered_median_5 = my_median_filter(img1_gray, 5);

% Save median filtered images
if ~exist('./L2/outputs/01_smoothing/06', 'dir')
    mkdir('./L2/outputs/01_smoothing/06');
end
imwrite(filtered_median_3, './L2/outputs/01_smoothing/06/median3.png');
imwrite(filtered_median_5, './L2/outputs/01_smoothing/06/median5.png');

% Step 6: Show all results in one subplot figure
figure;
subplot(2, 4, 1); imshow(img1_gray); title('Original Grayscale');
subplot(2, 4, 2); imshow(filtered1); title('(1/9) ones(3)');
subplot(2, 4, 3); imshow(filtered2); title('(1/49) ones(7)');
subplot(2, 4, 4); imshow(filtered3); title('average (7x7)');
subplot(2, 4, 5); imshow(filtered4); title('gaussian (3x3, 0.5)');
subplot(2, 4, 6); imshow(filtered5); title('gaussian (7x7, 1.2)');
subplot(2, 4, 7); imshow(filtered_median_3); title('Median (3x3)');
subplot(2, 4, 8); imshow(filtered_median_5); title('Median (5x5)');

%% Q2: Sharpening and Edge Detection
% Read img2 and convert to grayscale
img2 = imread('./L2/img2.png');
img2_gray = rgb2gray(img2);

% Create output directory for sharpening
if ~exist('./L2/outputs/02_sharpening', 'dir')
    mkdir('./L2/outputs/02_sharpening');
end

% Save the grayscale image
imwrite(img2_gray, './L2/outputs/02_sharpening/img2_grey.png');

% Define sharpening kernels
kernel6 = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
kernel7 = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
kernel8 = fspecial('log', 3);

% Apply sharpening filters using the custom function
filtered6 = my_filter2D(img2_gray, kernel6);
filtered7 = my_filter2D(img2_gray, kernel7);
filtered8 = my_filter2D(img2_gray, kernel8);

% Apply filters to sharpen the original image
% Convert to double for arithmetic operations and clamp results
sharpened_img6 = uint8(max(0, min(255, double(img2_gray) + double(filtered6))));
sharpened_img7 = uint8(max(0, min(255, double(img2_gray) + double(filtered7))));
sharpened_img8 = uint8(max(0, min(255, double(img2_gray) - double(filtered8))));

% Save sharpening filtered images and sharpened results
imwrite(filtered6, './L2/outputs/02_sharpening/kernel6.png');
imwrite(filtered7, './L2/outputs/02_sharpening/kernel7.png');
imwrite(filtered8, './L2/outputs/02_sharpening/kernel8.png');
imwrite(sharpened_img6, './L2/outputs/02_sharpening/sharpened6.png');
imwrite(sharpened_img7, './L2/outputs/02_sharpening/sharpened7.png');
imwrite(sharpened_img8, './L2/outputs/02_sharpening/sharpened8.png');

% Display sharpening results
figure;
subplot(3, 3, 1); imshow(img2_gray); title('Original img2 Grayscale');
subplot(3, 3, 2); imshow(filtered6); title('Kernel 6 (Vertical Edge)');
subplot(3, 3, 3); imshow(filtered7); title('Kernel 7 (Horizontal Edge)');
subplot(3, 3, 4); imshow(filtered8); title('Kernel 8 (Laplacian of Gaussian)');
subplot(3, 3, 5); imshow(sharpened_img6); title('Sharpened with Kernel 6');
subplot(3, 3, 6); imshow(sharpened_img7); title('Sharpened with Kernel 7');
subplot(3, 3, 7); imshow(sharpened_img8); title('Sharpened with Kernel 8');
