videoFile = 'db\IEV2022\airplane.mp4'; %load the video
videoObj = VideoReader(videoFile);

outputFile = 'airplane_output.avi';
outputObj = VideoWriter(outputFile, 'MPEG-4');
open(outputObj);

scales = [0.5, 1, 0.2]; % Different Scales 

while hasFrame(videoObj)
    
    frame = readFrame(videoObj);
    multi_scale_result = zeros(size(frame));

    for scale = scales
        % Single Retinex Algorithm
        enhanced_frame = single_scale_retinex(frame, scale);
        
        % Normalize each Retinex result
        enhanced_frame = (enhanced_frame - min(enhanced_frame(:))) / (max(enhanced_frame(:)) - min(enhanced_frame(:)));

        % Combine all reslut together to generate the final result
        multi_scale_result = max(multi_scale_result, enhanced_frame);
    end
    
    % CLAHE
        % Separate Colored Image to separate channels
    [R, G, B] = imsplit(multi_scale_result);

    % CLAHE on each channel
    R_with_CLAHE = adapthisteq(R, 'Cliplimit', 0.01,  'NumTiles', [8,8]);
    G_with_CLAHE = adapthisteq(G, 'Cliplimit', 0.01,  'NumTiles', [8,8]);
    B_with_CLAHE = adapthisteq(B, 'Cliplimit', 0.01,  'NumTiles', [8,8]);

    % recombine the result to get the result
    enhanced_frame_with_CLAHE = cat(3, R_with_CLAHE, G_with_CLAHE, B_with_CLAHE);

    % Write the processed frame to file
    writeVideo(outputObj, enhanced_frame_with_CLAHE);
end

close(outputObj);

function enhanced_image = single_scale_retinex(image, sigma)
    % logistic transformation
    log_image = log(double(image) + 1);
    
    % Gaussian Filter
    filtered_image = imgaussfilt(log_image, sigma);
    
    % Back to original range
    enhanced_image = exp(filtered_image) - 1;
end

