% Define mask labels
classNames = ["brain","notBrain"];
labelIDs   = [1 0];

% Load in images
imageFolder = 'T:\Hayden\Multi_Atlas Segmentation\Temporal Inclusion\Training Images\GreenCombined\';
images = fullfile(imageFolder,'*png');

% Load in masks
maskFolder = 'T:\Hayden\Multi_Atlas Segmentation\Temporal Inclusion\Training Masks\';
masks = fullfile(maskFolder,'*png');

% Create datastores
image_datastore = imageDatastore(images);
mask_datastore = pixelLabelDatastore(masks,classNames,labelIDs);

for i = 1:256
    if i==1 
        test(i,:) = [0;0;0];
    elseif i>1 && i<120
        test(i,:) = [237;32;36]; 
    elseif i>119 && i<250
        test(i,:) = [105;189;69];
    else
        test(i,:) = [246;235;20];
    end
end

test = test./256;

for i=2:25

    % image = readimage(image_datastore,i);
    mask = readimage(mask_datastore,i);
    image = readimage(image_datastore,i);
    mask = 

    % Run image through pretrained Unet
    segmentedImage = semanticseg(image,net);

    %RemoveNoise
    segmentedImage = segmentedImage == "brain";
    mask = mask ~= "notBrain";
    windowSize = 1;
    kernel = ones(windowSize,windowSize) / windowSize ^ 2;
    blurryImage = conv2(single(segmentedImage), kernel, 'same');
    segmentedImage = blurryImage > 0.7; % Rethreshold

%     finalImage = labeloverlay(image,segmentedImage,'Colormap','spring','Transparency',0.2);
%     maskedImage = labeloverlay(image,mask);

    accuracy(i,1) = dice(segmentedImage,mask);
    accuracy(i,2) = jaccard(segmentedImage,mask);
    accuracy(i,3) = bfscore(segmentedImage,mask);
% 
%     finalImage = labeloverlay(finalImage,mask,'Colormap','cool','Transparency',0.5);

    finalMask = mask + (2*segmentedImage);
    
    % Plot Images
    figure(2)
    imshow(finalMask,[],Colormap=test);

%     subplot(2,5,i+5)
%     imshow(maskedImage)

end