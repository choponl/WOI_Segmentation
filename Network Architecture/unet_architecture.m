function lgraph = unet_architecture()

lgraph = layerGraph();

%% _____________________________ Branches ______________________________ %%

layers = [
    imageInputLayer([128 128],"Name","imageInput")
    convolution2dLayer([3 3],64,"Name","conv1_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu1_a")
    convolution2dLayer([3 3],64,"Name","conv1_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu1_b")
    maxPooling2dLayer([2 2],"Name","max_pooling1","Padding",[0 0 0 0],"Stride",[2 2])

    convolution2dLayer([3 3],128,"Name","conv2_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu2_a")
    convolution2dLayer([3 3],128,"Name","conv2_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu2_b")
    maxPooling2dLayer([2 2],"Name","max_pooling2","Padding",[0 0 0 0],"Stride",[2 2])

    convolution2dLayer([3 3],256,"Name","conv3_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu3_a")
    convolution2dLayer([3 3],256,"Name","conv3_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu3_b")
    dropoutLayer(0.3,"Name","dropout3")
    maxPooling2dLayer([2 2],"Name","max_pooling3","Padding",[0 0 0 0],"Stride",[2 2])
    
    convolution2dLayer([3 3],512,"Name","conv4_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu4_a")
    convolution2dLayer([3 3],512,"Name","conv4_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu4_b")
    dropoutLayer(0.5,"Name","dropout4")
    maxPooling2dLayer([2 2],"Name","max_pooling4","Padding",[0 0 0 0],"Stride",[2 2])

    convolution2dLayer([3 3],1024,"Name","convB","Padding",'same',"Stride",[1 1])
    reluLayer("Name","reluB")
    convolution2dLayer([3 3],1024,"Name","convB2","Padding",'same',"Stride",[1 1])
    reluLayer("Name","reluB2")
    dropoutLayer(0.5,"Name","dropoutB")

    transposedConv2dLayer([2 2],512,"Name","conv2d5","Stride",[2 2],"BiasLearnRateFactor",2)
    reluLayer("Name","relu5_a")
    depthConcatenationLayer(2,"Name","depth5")
    convolution2dLayer([3 3],512,"Name","conv5_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu5_b")
    convolution2dLayer([3 3],512,"Name","conv5_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu5_c")

    transposedConv2dLayer([2 2],256,"Name","conv2d6","Stride",[2 2],"BiasLearnRateFactor",2)
    reluLayer("Name","relu6_a")
    depthConcatenationLayer(2,"Name","depth6")
    convolution2dLayer([3 3],256,"Name","conv6_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu6_b")
    convolution2dLayer([3 3],256,"Name","conv6_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu6_c")

    transposedConv2dLayer([2 2],128,"Name","conv2d8","Stride",[2 2],"BiasLearnRateFactor",2)
    reluLayer("Name","relu8_a")
    depthConcatenationLayer(2,"Name","depth8")
    convolution2dLayer([3 3],128,"Name","conv8_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu8_b")
    convolution2dLayer([3 3],128,"Name","conv8_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu8_c")

    transposedConv2dLayer([2 2],64,"Name","conv2d9","Stride",[2 2],"BiasLearnRateFactor",2)
    reluLayer("Name","relu9_a")
    depthConcatenationLayer(2,"Name","depth9")
    convolution2dLayer([3 3],64,"Name","conv9_a","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu9_b")
    convolution2dLayer([3 3],64,"Name","conv9_b","Padding",'same',"Stride",[1 1])
    reluLayer("Name","relu9_c")

    convolution2dLayer([1 1],2,"Name","conv9_c","Padding",'same',"Stride",[1 1])
    softmaxLayer("Name","softmax9")
    pixelClassificationLayer("Name","output","Classes",["brain","notBrain"],'ClassWeights',[0.65 0.35])];
    lgraph = addLayers(lgraph,layers);

%% ___________________________ Connections _____________________________ %%

lgraph = connectLayers(lgraph,"relu1_b","depth9/in2");
lgraph = connectLayers(lgraph,"relu2_b","depth8/in2");
lgraph = connectLayers(lgraph,"relu3_b","depth6/in2");
lgraph = connectLayers(lgraph,"relu4_b","depth5/in2");

