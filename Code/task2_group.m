% Setting input and output folder paths
input_folder = 'IEI2019'; 
output_folder = 'OutputImage'; 
% Get all image files in the input folder
input_files = dir(fullfile(input_folder, '*.jpg')); % Matching .jpg and .JPG files

for i = 1:numel(input_files)
    %Get filename
    file_name = input_files(i).name;

    % Import Images
    input_image = im2double(imread(fullfile(input_folder, file_name)));
    
    %% Dark Channel Preprocessing
    dark_channel = min(input_image, [], 3);
    % window size
    window_size = 15;
    % Calculate local minima (minima within the window)
    min_dark_channel = imerode(dark_channel, strel('square', window_size));
    % Find the maximum value (brightest area) from the minimum image
    atmospheric_light = max(min_dark_channel(:));
    %atmospheric_light = 255;
    % Estimated transmittance
    beta = 0.6; % Transmittance adjustment parameters
    transmission = estimate_transmission(input_image, atmospheric_light, beta);
    % Defogging reconstruction
    recovered_image = dehaze(input_image, transmission, atmospheric_light);
    %% Histogram Algorithm Processing
    dehazed_image = recovered_image; 
    % Color correction: using histogram equalization
    color_corrected_image = histeq(dehazed_image);
    %% CLAHE Algorithm Processing
    % Contrast enhancement: using CLAHE
    % Since it is a color image, it needs to be converted to grayscale before processing it
    % Decompose color images into three channels
    red_channel = color_corrected_image(:,:,1);
    green_channel = color_corrected_image(:,:,2);
    blue_channel = color_corrected_image(:,:,3);
    % Use CLAHE for each channel
    red_enhanced = adapthisteq(red_channel, 'ClipLimit', 0.01);
    green_enhanced = adapthisteq(green_channel, 'ClipLimit', 0.01);
    blue_enhanced = adapthisteq(blue_channel, 'ClipLimit', 0.01);
    % Recombine channels for color images
    contrast_enhanced_image = cat(3, red_enhanced,green_enhanced, blue_enhanced);
    %% Generate output file name
    output_file = fullfile(output_folder, file_name);  
    % Saving processed images
    imwrite(contrast_enhanced_image, output_file);
    % Show all the results to compare (may affect the total efficiency)
%     figure(i);
%     subplot(1,4,1);
%     imshow(input_image);
%     title('Original Image')
% 
%     subplot(1,4,2);
%     imshow(dehazed_image);
%     title('Defogged image');
%     
%     subplot(1,4,3);
%     imshow(color_corrected_image);
%     title('Color corrected image');
%     
%     subplot(1,4,4);
%     imshow(contrast_enhanced_image);
%     title('Contrast-enhanced image');
end


