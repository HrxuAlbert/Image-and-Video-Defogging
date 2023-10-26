% Single Retinex Algorithm 
function enhanced_image = single_scale_retinex(image, sigma)
    % logistic transformation
    log_image = log(double(image) + 1);
    
    % Gaussian Filter
    filtered_image = imgaussfilt(log_image, sigma);
    
    % back to original range
    enhanced_image = exp(filtered_image) - 1;
end