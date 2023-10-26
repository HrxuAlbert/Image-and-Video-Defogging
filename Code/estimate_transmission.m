function transmission = estimate_transmission(input_image, atmospheric_light, beta)
    % estimate transmission rate
    transmission = 1 - beta * min(input_image, [], 3) / atmospheric_light;
end