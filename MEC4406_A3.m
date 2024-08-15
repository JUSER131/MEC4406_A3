% MEC4406 Assignment 3 - Machine Vision
% Author: Jack Halpin
% Date: 12/08/2024

clc

% Define the dataset directory;
workDir = 'Mowing_Dataset/Mowing Dataset(1)/';

% Setup variables to loop through the directory of images;

filePattern = fullfile(workDir, '*.jpg');
theFiles = dir(filePattern);

% Loop through each image and read it in, display the output.
for k = 1 : 6000
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading file %s\n', fullFileName)
    imageArray = imread(fullFileName);

    [L,N] = superpixels(imageArray,150);
    outputImage = zeros(size(imageArray),'like',imageArray);

    idx = label2idx(L);
    numRows = size(imageArray,1);
    numCols = size(imageArray,2);
    for labelVal = 1:N
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal}+numRows*numCols;
        blueIdx = idx{labelVal}+2*numRows*numCols;
        outputImage(redIdx) = mean(imageArray(redIdx));
        outputImage(greenIdx) = mean(imageArray(greenIdx));
        outputImage(blueIdx) = mean(imageArray(blueIdx));
    end

    ix = find(L == 1);
    L1 = L*0;
    L1(ix) = 1;
    
    BW = boundarymask(L);
    subplot(2, 2, 1)
    imshow(imageArray)
    subplot(2, 2, 3)
    imshow(outputImage)
    subplot(2, 2, 2)
    imshow(imoverlay(imageArray,BW,'cyan'))
    subplot(2, 2, 4)
    imshow(L1)
    drawnow % Force display to update immediately.
end

