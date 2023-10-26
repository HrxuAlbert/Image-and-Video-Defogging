%task1
% input the image
image1 = imread('db\IEI2019\H22.png'); 
image2 = imread('db\IEI2019\H26.jpg');
image3 = imread('db\IEI2019\R1.jpg');

% calculate the diagram
histogram1 = imhist(image1);
histogram2 = imhist(image2);
histogram3 = imhist(image3);

% plot the histogram
figure(1);
subplot(1,3,1);
bar(histogram1);
title('Image Histogram H22');
xlabel('Pixel Intensity');
ylabel('Frequency');
subplot(1,3,2);
bar(histogram2);
title('Image Histogram H26');
xlabel('Pixel Intensity');
ylabel('Frequency');
subplot(1,3,3)
bar(histogram3);
title('Image Histogram R1');
xlabel('Pixel Intensity');
ylabel('Frequency');


