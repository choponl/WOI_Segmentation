function [LM]=makeLM(image_grey, params)

disp('Identify Landmarks')
figure('Name','Choose Landmarks');

[Px,Py,~]=size(image_grey);

% Display WL
imshow(imrotate(image_grey,params.im_rotate))
axis image
hold on

% AMS
[x,y]=getLM('Anterior Midline Suture Landmark',Px,Py);
LM.ams=[x,y];
plot(LM.ams(1),Py+1-LM.ams(2),'mo')

% Bregma
[x,y]=getLM('Bregma',Px,Py);
LM.bregma=[x,y];
plot(LM.bregma(1),Py+1-LM.bregma(2),'mo')

% Lambda
[x,y]=getLM('Lambda',Px,Py);
LM.lambda=[x,y];
plot(LM.lambda(1),Py+1-LM.lambda(2),'mo')

title('Chosen Landmarks');
end

function [x,y]=getLM(loc,Px,Py)
gca;

disp(['- Click ',loc]);
title(['Click ',loc])

[x,y]=ginput(1);

if x>=0 && x<=Px && y>=0 && y<=Py
    % Correct for the way Matlab displays images
    y=Py+1-y;
else
    x=NaN;
    y=NaN;
end

end
