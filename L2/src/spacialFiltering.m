% Spatial and Median Filtering of Image

% Step 1: Read img1 and convert to grayscale
img1 = imread('img1.png');
img1_gray = rgb2gray(img1);

% Display original grayscale image
figure;
imshow(img1_gray);
title('Original Grayscale Image');

% Step 2: Define Kernels
kernel1 = (1/9) * ones(3);
kernel2 = (1/49) * ones(7);
kernel3 = fspecial('average', [7, 7]);
kernel4 = fspecial('gaussian', [3, 3], 0.5);
kernel5 = fspecial('gaussian', [7, 7], 1.2);

% Step 3: Apply spatial filters
filtered1 = my_filter2D(img1_gray, kernel1);
filtered2 = my_filter2D(img1_gray, kernel2);
filtered3 = my_filter2D(img1_gray, kernel3);
filtered4 = my_filter2D(img1_gray, kernel4);
filtered5 = my_filter2D(img1_gray, kernel5);

% Step 4: Apply custom median filters
filtered_median_3 = my_median_filter(img1_gray, 3);
filtered_median_5 = my_median_filter(img1_gray, 5);

% Step 5: Display each filtered image in separate figures
figure; imshow(filtered1); title('Filtered with Kernel 1: (1/9) * ones(3)');
figure; imshow(filtered2); title('Filtered with Kernel 2: (1/49) * ones(7)');
figure; imshow(filtered3); title('Filtered with Kernel 3: fspecial average (7x7)');
figure; imshow(filtered4); title('Filtered with Kernel 4: fspecial gaussian (3x3, 0.5)');
figure; imshow(filtered5); title('Filtered with Kernel 5: fspecial gaussian (7x7, 1.2)');
figure; imshow(filtered_median_3); title('Median Filtered (3x3)');
figure; imshow(filtered_median_5); title('Median Filtered (5x5)');

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


% --- Function: Custom 2D Filtering ---
function output = my_filter2D(image, kernel)
    image = double(image);
    kernel = double(kernel);
    [M, N] = size(image);
    [m, n] = size(kernel);
    pad_m = floor(m / 2);
    pad_n = floor(n / 2);
    padded_image = padarray(image, [pad_m, pad_n], 0, 'both');
    kernel = rot90(kernel, 2);  % Flip kernel for convolution
    output = zeros(M, N);
    for i = 1:M
        for j = 1:N
            region = padded_image(i:i+m-1, j:j+n-1);
            output(i, j) = sum(sum(region .* kernel));
        end
    end
    output = uint8(output);
end

% --- Function: Custom Median Filtering ---
function output = my_median_filter(image, kernel_size)
    image = double(image);
    [M, N] = size(image);
    pad = floor(kernel_size / 2);
    padded_image = padarray(image, [pad, pad], 0, 'both');
    output = zeros(M, N);
    for i = 1:M
        for j = 1:N
            region = padded_image(i:i+2*pad, j:j+2*pad);
            output(i, j) = median(region(:));
        end
    end
    output = uint8(output);
end
