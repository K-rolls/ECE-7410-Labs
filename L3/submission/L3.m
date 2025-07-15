%% Laboratory 3: Frequency Domain Filtering

%% Create output directory
if ~exist('./L3/out', 'dir')
    mkdir('./L3/out');
end

%% Set default figure properties
set(0, 'DefaultFigureUnits', 'pixels');
set(0, 'DefaultFigurePosition', [100, 100, 800, 600]);
set(0, 'DefaultAxesLooseInset', [0.02, 0.02, 0.02, 0.02]);
set(0, 'DefaultAxesPosition', [0.05, 0.05, 0.9, 0.9]);

%% Define subplot positions
pos = [0.05, 0.55, 0.4, 0.4;
       0.55, 0.55, 0.4, 0.4;
       0.05, 0.05, 0.4, 0.4;
       0.55, 0.05, 0.4, 0.4];

%% Step 1 & 2: Read and display the image
F_rgb = imread('puppy.jpg');
F = rgb2gray(F_rgb);

imwrite(F, './L3/out/01_original_grayscale.png');

%% Step 3: Obtain and display padding parameters
im_size = size(F);
P = 2 * im_size(1);
Q = 2 * im_size(2);
fprintf('Image size: %d x %d\n', im_size(1), im_size(2));
fprintf('Padding parameters: P = %d, Q = %d\n', P, Q);

%% Step 4: Obtain and display FT of the image
FTIm = fft2(double(F), P, Q);

ft_display = log(1 + abs(fftshift(FTIm)));
ft_display = uint8(255 * mat2gray(ft_display));
imwrite(ft_display, './L3/out/04_fourier_transform.png');

%% Step 6a: Ideal low pass filters
cutoffs_a = [0.3, 0.7];
for i = 1:length(cutoffs_a)
    D0 = cutoffs_a(i) * im_size(1);
    Filter = lp_hp_filters('ideal', 'lp', P, Q, D0, 0);

    Filtered_image = real(ifft2(Filter .* FTIm));
    Filtered_image = Filtered_image(1:im_size(1), 1:im_size(2));
    Fim = fftshift(FTIm);
    FTI = log(1 + abs(Fim));
    Ff = fftshift(Filter);
    FTF = log(1 + abs(Ff));

    fig = figure('Visible', 'off');
    subplot('Position', pos(1, :)); imshow(F, []); title('Original Image');
    subplot('Position', pos(2, :)); imshow(FTI, []); title('FT of Original');
    subplot('Position', pos(3, :)); imshow(FTF, []); title('Filter in frequency domain');
    subplot('Position', pos(4, :)); imshow(Filtered_image, []); title('Filtered Image');

    fig_filename = sprintf('./L3/out/6a_ideal_lp_D0_%.1f.png', cutoffs_a(i));
    saveas(fig, fig_filename);
    close(fig);
end

%% Step 6b: Butterworth low pass filters
cutoffs_b = [0.1, 0.5];
orders = [1, 5, 20];
for i = 1:length(cutoffs_b)
    for j = 1:length(orders)
        D0 = cutoffs_b(i) * im_size(1);
        Filter = lp_hp_filters('btw', 'lp', P, Q, D0, orders(j));

        Filtered_image = real(ifft2(Filter .* FTIm));
        Filtered_image = Filtered_image(1:im_size(1), 1:im_size(2));
        Fim = fftshift(FTIm);
        FTI = log(1 + abs(Fim));
        Ff = fftshift(Filter);
        FTF = log(1 + abs(Ff));

        fig = figure('Visible', 'off');
        subplot('Position', pos(1, :)); imshow(F, []); title('Original Image');
        subplot('Position', pos(2, :)); imshow(FTI, []); title('FT of Original');
        subplot('Position', pos(3, :)); imshow(FTF, []); title('Filter in frequency domain');
        subplot('Position', pos(4, :)); imshow(Filtered_image, []); title('Filtered Image');

        fig_filename = sprintf('./L3/out/6b_butterworth_lp_D0_%.1f_n_%d.png', cutoffs_b(i), orders(j));
        saveas(fig, fig_filename);
        close(fig);
    end
end

%% Step 6c: Gaussian low pass filters
cutoffs_c = [0.1, 0.3, 0.7];
for i = 1:length(cutoffs_c)
    D0 = cutoffs_c(i) * im_size(1);
    Filter = lp_hp_filters('gaussian', 'lp', P, Q, D0, 0);

    Filtered_image = real(ifft2(Filter .* FTIm));
    Filtered_image = Filtered_image(1:im_size(1), 1:im_size(2));
    Fim = fftshift(FTIm);
    FTI = log(1 + abs(Fim));
    Ff = fftshift(Filter);
    FTF = log(1 + abs(Ff));

    fig = figure('Visible', 'off');
    subplot('Position', pos(1, :)); imshow(F, []); title('Original Image');
    subplot('Position', pos(2, :)); imshow(FTI, []); title('FT of Original');
    subplot('Position', pos(3, :)); imshow(FTF, []); title('Filter in frequency domain');
    subplot('Position', pos(4, :)); imshow(Filtered_image, []); title('Filtered Image');

    fig_filename = sprintf('./L3/out/6c_gaussian_lp_D0_%.1f.png', cutoffs_c(i));
    saveas(fig, fig_filename);
    close(fig);
end

%% Step 6d: Ideal high pass filters
cutoffs_d = [0.1, 0.3, 0.7];
for i = 1:length(cutoffs_d)
    D0 = cutoffs_d(i) * im_size(1);
    Filter = lp_hp_filters('ideal', 'hp', P, Q, D0, 0);

    Filtered_image = real(ifft2(Filter .* FTIm));
    Filtered_image = Filtered_image(1:im_size(1), 1:im_size(2));
    Fim = fftshift(FTIm);
    FTI = log(1 + abs(Fim));
    Ff = fftshift(Filter);
    FTF = log(1 + abs(Ff));

    fig = figure('Visible', 'off');
    subplot('Position', pos(1, :)); imshow(F, []); title('Original Image');
    subplot('Position', pos(2, :)); imshow(FTI, []); title('FT of Original');
    subplot('Position', pos(3, :)); imshow(FTF, []); title('Filter in frequency domain');
    subplot('Position', pos(4, :)); imshow(Filtered_image, []); title('Filtered Image');

    fig_filename = sprintf('./L3/out/6d_ideal_hp_D0_%.1f.png', cutoffs_d(i));
    saveas(fig, fig_filename);
    close(fig);
end

%% Step 6e: Butterworth high pass filters
cutoffs_e = [0.1, 0.5];
orders = [1, 5, 20];
for i = 1:length(cutoffs_e)
    for j = 1:length(orders)
        D0 = cutoffs_e(i) * im_size(1);
        Filter = lp_hp_filters('btw', 'hp', P, Q, D0, orders(j));

        Filtered_image = real(ifft2(Filter .* FTIm));
        Filtered_image = Filtered_image(1:im_size(1), 1:im_size(2));
        Fim = fftshift(FTIm);
        FTI = log(1 + abs(Fim));
        Ff = fftshift(Filter);
        FTF = log(1 + abs(Ff));

        fig = figure('Visible', 'off');
        subplot('Position', pos(1, :)); imshow(F, []); title('Original Image');
        subplot('Position', pos(2, :)); imshow(FTI, []); title('FT of Original');
        subplot('Position', pos(3, :)); imshow(FTF, []); title('Filter in frequency domain');
        subplot('Position', pos(4, :)); imshow(Filtered_image, []); title('Filtered Image');

        fig_filename = sprintf('./L3/out/6e_butterworth_hp_D0_%.1f_n_%d.png', cutoffs_e(i), orders(j));
        saveas(fig, fig_filename);
        close(fig);
    end
end

%% Step 6f: Gaussian high pass filters
cutoffs_f = [0.1, 0.3, 0.7];
for i = 1:length(cutoffs_f)
    D0 = cutoffs_f(i) * im_size(1);
    Filter = lp_hp_filters('gaussian', 'hp', P, Q, D0, 0);

    Filtered_image = real(ifft2(Filter .* FTIm));
    Filtered_image = Filtered_image(1:im_size(1), 1:im_size(2));
    Fim = fftshift(FTIm);
    FTI = log(1 + abs(Fim));
    Ff = fftshift(Filter);
    FTF = log(1 + abs(Ff));

    fig = figure('Visible', 'off');
    subplot('Position', pos(1, :)); imshow(F, []); title('Original Image');
    subplot('Position', pos(2, :)); imshow(FTI, []); title('FT of Original');
    subplot('Position', pos(3, :)); imshow(FTF, []); title('Filter in frequency domain');
    subplot('Position', pos(4, :)); imshow(Filtered_image, []); title('Filtered Image');

    fig_filename = sprintf('./L3/out/6f_gaussian_hp_D0_%.1f.png', cutoffs_f(i));
    saveas(fig, fig_filename);
    close(fig);
end
