function recovered_image = dehaze(input_image, transmission, atmospheric_light)
    % remove the haze
    recovered_image = zeros(size(input_image));
    for c = 1:3
        recovered_image(:, :, c) = (input_image(:, :, c) - atmospheric_light) ./ max(transmission, 0.1) + atmospheric_light;
    end
end