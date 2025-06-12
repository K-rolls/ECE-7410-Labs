imc = imread('im2.png'); % Read the image
img = rgb2gray(imc); % Convert to grayscale
imshow(img); % View image

% Ensure directory exists
if ~exist('./L1/report', 'dir')
    mkdir('./L1/report');
end

imwrite(img, 'L1/report/img2_gray.png'); % Save the grayscale image

H = size(img, 1); % Read the height of the image
W = size(img, 2); % Read the width of the image

Hist_arr = zeros(1, 256); % Array for holding the (original) histogram
Hist_eq_arr = zeros(1, 256); % Array for holding the (equalized) histogram

CDF_array = zeros(1, length(Hist_arr)); % array to hold cumulative distribution function (CDF)

hist_eq_img = uint8(zeros(H, W)); % A 2D array for keeping histogram equalized image (intensity in 8 bit integers)

for i = 1:H
    for j = 1:W
        Hist_arr(1, img(i, j) + 1) = Hist_arr (1, img(i, j) + 1) + 1;
    end
end

figure;
bar(Hist_arr);
title('Histogram of Original Image');
saveas(gcf, 'L1/report/img2_hist_orig.png', 'png');

Hist_arr_pdf = Hist_arr / (H * W); % PDF

figure;
plot(0:255, Hist_arr_pdf, 'r-');
xlabel('Gray Level');
ylabel('Probability Density Function (PDF)');
grid on;
axis([0 255 0 max(Hist_arr_pdf) * 1.1]);
title('PDF of Original Image');
saveas(gcf, 'L1/report/img2_pdf_orig.png', 'png');

dummy1 = 0; % A dummy variable to hold the summation results

for k = 1:length(Hist_arr) % Generating the CDF from PDF
    dummy1 = dummy1 + Hist_arr_pdf(k);
    CDF_array(k) = dummy1;
end

figure;
plot(0:255, CDF_array, 'b-');
title('CDF of Original Image');
xlabel('Gray Level');
ylabel('Cumulative Probability');
grid on;
saveas(gcf, 'L1/report/img2_cdf_orig.png', 'png');

for l = 1:H % Histogram equalization

    for m = 1:W
        hist_eq_img(l, m) = round(CDF_array(img(l, m) + 1) * (length(Hist_arr_pdf) - 1)); % scale to 255 and round to nearest integer
        Hist_eq_arr(1, hist_eq_img(l, m) + 1) = Hist_eq_arr (1, hist_eq_img(l, m) + 1) + 1; % Its histogram
    end

end

% Display the histogram of equalized image
figure;
subplot(2, 1, 1);
bar(Hist_eq_arr);
title('Histogram of Equalized Image');

% Create a mapping table showing original gray levels and their new values
mapping = zeros(1, 256);

for i = 1:256
    mapping(i) = round(CDF_array(i) * 255);
end

% Display the mapping
subplot(2, 1, 2);
plot(0:255, mapping, 'r-', 0:255, 0:255, 'b--');
title('Mapping from Original to Equalized Gray Levels');
xlabel('Original Gray Level');
ylabel('New Gray Level');
legend('Equalization Mapping', 'Identity Line');
grid on;
saveas(gcf, 'L1/report/img2_mapping.png', 'png');

% Display the equalized image
figure;
subplot(1, 2, 1);
imshow(img);
title('Original Image');
subplot(1, 2, 2);
imshow(hist_eq_img);
title('Histogram Equalized Image');
saveas(gcf, 'L1/report/img2_equalized.png', 'png');
