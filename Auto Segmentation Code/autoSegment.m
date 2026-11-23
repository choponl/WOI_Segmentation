% _______________________________________________________ %
% 
% Automated Segmentation Code
% 
% Chidren's Hospital of Philadelphia | White Lab
% Author: Hayden Fisher
% Created: February 16, 2025
% Updated: November 22, 2026
%
% _______________________________________________________ %

% function segmentedImage = autoSegment(filename)

% Load system parameters file
params = readDefFile("Segmentation_Parameters.txt");

filepath = strcat(params.indir,"/",filename,".mat");

%% Load Raw Image Data
try
    rawdata = load(filepath);
    rawdata = double(rawdata);
catch
    error('A valid filepath is required for segmentation');
end

%% Create False Color Image
[~, index] = min(abs(params.wavelengths - 530));
disp_image = rawdata(:,:,index,50)/max(max(rawdata(:,:,index,50)));

%% Calculate Quality Control Metrics
[mask,qcdata] = qualityControl(rawdata,params);

%% Identify Landmarks
if params.create_landmarks == 0
    try
        filepath = strcat(params.indir,"/",filename,"_landmarks.mat");
        load(filepath)
    catch
        warning('Landmark file not found. Continuing with landmark identification')
        LM = makeLM(disp_image,params);
    end
else
    LM = makeLM(disp_image,params);
end

%% Load Networks
network_files = findNetworks(params);
for i = 1:params.numled
    if params.fluorescence(i)
        network(i) = load(strcat("Networks/Fluorescence/",network_files(i)));
    else
        network(i) = load(strcat("Networks/Hemodynamic/",network_files(i)));
    end
end

load("Dependencies/sp128.mat")

%% Define Arrays for Segmentation
segImage = imCreate(rawdata, LM, qcdata, params);

%% Segment Wavelengths
disp("Segmenting Images")

combinedMask = zeros([128,128]);
for i = 1:params.numled
    if params.include(i)
        mask = semanticseg(imresize(segImage(:,:,:,i).*256,0.25),network(i).net)=="brain";
    else
        mask = zeros([128,128]);
    end
    combinedMask = combinedMask + mask;
end

combinedMask = combinedMask./sum(params.include);

%% Combine Segmentations
segmentation = zeros(128,128);
alpha = params.sigmoid_alpha;
beta = params.sigmoid_beta;

for j = 1:128
    for k = 1:128
        pixel = combinedMask(j,k);
        weight = 1/(1+exp(alpha*pixel-beta));
        if Sp(j,k) >= weight
            segmentation(j,k) = 1;
        end
    end
end

windowSize = params.window;
kernel = ones(windowSize,windowSize) / windowSize ^ 2;
blurryImage = conv2(single(segmentation), kernel, 'same');
segmentedImage = blurryImage > params.threshold; % Rethreshold
finalImage = labeloverlay(imresize(segImage(:,:,1,2),[128,128]),segmentedImage);

imshow(finalImage)