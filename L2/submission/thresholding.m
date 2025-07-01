% ECE 7410 - Laboratory 2: Thresholding

%% Q2: Function to calculate optimal threshold using Otsu's method
function optimal_threshold = calculate_optimal_threshold(img)
    % Convert to grayscale if needed
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Convert to double for calculations
    img = double(img);

    % Calculate histogram
    [counts, ~] = hist(img(:), 0:255);

    % Calculate probabilities
    p = counts / sum(counts);

    % Initialize variables
    L = 256; % Number of gray levels (0-255)
    max_variance = 0;
    optimal_threshold = 0;

    % Try all possible thresholds
    for t = 1:(L - 1)
        % Calculate class probabilities
        omega_0 = sum(p(1:t));
        omega_1 = sum(p(t + 1:L));

        % Skip if one class is empty
        if omega_0 == 0 || omega_1 == 0
            continue;
        end

        % Calculate class means
        mu_0 = sum((0:(t - 1)) .* p(1:t)) / omega_0;
        mu_1 = sum((t:(L - 1)) .* p(t + 1:L)) / omega_1;

        % Calculate inter-class variance
        sigma_b_squared = omega_0 * omega_1 * (mu_0 - mu_1) ^ 2;

        % Update optimal threshold if this variance is larger
        if sigma_b_squared > max_variance
            max_variance = sigma_b_squared;
            optimal_threshold = t - 1; % Convert to 0-255 range
        end
    end
end

%% Q3: Calculate optimal thresholds for test images
% Read images
img3 = imread('./L2/img3.png');
img4 = imread('./L2/img4.png');

% Calculate optimal thresholds
threshold_img3 = calculate_optimal_threshold(img3);
threshold_img4 = calculate_optimal_threshold(img4);

% Display results
fprintf('Optimal threshold for img3.png: %d\n', threshold_img3);
fprintf('Optimal threshold for img4.png: %d\n', threshold_img4);

%% Q4: Function to convert grayscale to binary using threshold
function binary_img = grayscale_to_binary(img, threshold)
    % Convert to grayscale if needed
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Convert to double for calculations
    img = double(img);

    % Get image dimensions
    [rows, cols] = size(img);

    % Initialize binary image
    binary_img = zeros(rows, cols);

    % Apply threshold manually using loops
    for i = 1:rows
        for j = 1:cols
            if img(i, j) > threshold
                binary_img(i, j) = 255; % White pixel
            else
                binary_img(i, j) = 0; % Black pixel
            end
        end
    end

    % Convert to uint8
    binary_img = uint8(binary_img);
end

%% Q5: Generate and save binary images using optimal thresholds
% Create output directory
if ~exist('./L2/outputs/03_thresholding', 'dir')
    mkdir('./L2/outputs/03_thresholding');
end

% Convert to binary using optimal thresholds
binary_img3 = grayscale_to_binary(img3, threshold_img3);
binary_img4 = grayscale_to_binary(img4, threshold_img4);

% Display and save results
figure('Position', [100, 100, 1200, 400]);

% Display img3 results
subplot(2, 3, 1);
imshow(img3);
title('Original img3.png');

subplot(2, 3, 2);
if size(img3, 3) == 3
    imshow(rgb2gray(img3));
else
    imshow(img3);
end
title('Grayscale img3.png');

subplot(2, 3, 3);
imshow(binary_img3);
title(sprintf('Binary img3 (threshold = %d)', threshold_img3));

% Display img4 results
subplot(2, 3, 4);
imshow(img4);
title('Original img4.png');

subplot(2, 3, 5);
if size(img4, 3) == 3
    imshow(rgb2gray(img4));
else
    imshow(img4);
end
title('Grayscale img4.png');

subplot(2, 3, 6);
imshow(binary_img4);
title(sprintf('Binary img4 (threshold = %d)', threshold_img4));

% Save binary images
imwrite(binary_img3, './L2/outputs/03_thresholding/bin3.png');
imwrite(binary_img4, './L2/outputs/03_thresholding/bin4.png');

% Save the figure
saveas(gcf, './L2/outputs/03_thresholding/thresholding_results.png');

fprintf('Binary images saved to ./outputs/03_thresholding/\n');
