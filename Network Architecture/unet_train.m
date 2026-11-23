%%__________________________ Create Network _____________________________%%

% Load in images
imageFolder = "<training image folder>";
images = fullfile(imageFolder,'*png');

% Load in masks
maskFolder = '<training masks folder>';
masks = fullfile(maskFolder,'*png');

% Define mask labels
classNames = ["brain","notBrain"];
labelIDs   = [255 0];

% Create datastores
image_datastore = imageDatastore(images);
mask_datastore = pixelLabelDatastore(masks,classNames,labelIDs);

% Combine image and mask datasets
combinedData = combine(image_datastore,mask_datastore);

% Separate dataset into training, validation, and test sets
num = length(images);
indices = randperm(num);
trainingData = subset(combinedData,indices(1:num*0.9));
validationData = subset(combinedData,indices(num*0.9:num));

clear imageFolder images maskFolder masks combinedData indices

% Create layers
lgraph = unet_architecture;

% Define training options
options = trainingOptions("sgdm", ...
    'GradientThreshold',2, ...
    'InitialLearnRate',1e-3, ...
    'Shuffle','never', ...
    'MaxEpochs',20, ...
    'MiniBatchSize',10, ...
    'Verbose',0, ...
    'ValidationData',validationData, ...
    Plots="training-progress");
 
% Train network
net = trainNetwork(trainingData,lgraph,options);