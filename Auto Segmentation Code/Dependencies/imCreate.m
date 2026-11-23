function segImage = imCreate(rawdata, LM, qcdata, params)

imcoord = imref2d([512 512]);
tformi = transformLM(LM);

for i = 1:params.numled

    base_image = double(imresize(rawdata(:,:,i,1),[512 512]))/max(max(double(imresize(rawdata(:,:,i,1),[512 512]))));
    aligned_image = rot90(imwarp(base_image,tformi,'cubic','OutputView',imcoord));
    
    lcorr_ua = min(qcdata.rlocal(:,:,i,:),[],4);
    lcorr_ua = imresize(lcorr_ua,[512 512]);
    try
        std_ua = qcdata.stdr(:,:,i);
    catch
        std_ua = qcdata.stdlr(:,:,i);
    end
    std_ua = interp1([0,max(max(std_ua))],[0,1],std_ua);
    std_ua = adapthisteq(std_ua,"Distribution","exponential");
    std_ua = imresize(std_ua,[512 512]);

    lcorr = rot90(imwarp(lcorr_ua,tformi,'cubic','OutputView',imcoord));
    std = rot90(imwarp(std_ua,tformi,'cubic','OutputView',imcoord));
    
    segImage(:,:,1,i) = aligned_image;
    segImage(:,:,2,i) = lcorr;
    segImage(:,:,3,i) = std;
end
end

function tformi = transformLM(LM)
LM.ams = LM.ams.*4;
LM.lambda = LM.lambda.*4;

ref.ams = [258 440];
ref.lambda = [258 60];

ref.mid=(ref.ams+ref.lambda)/2;
LM.mid=(LM.ams+LM.lambda)/2;

A=[ref.ams;ref.lambda]; % Ref points
M=[LM.ams;LM.lambda]; % Mouse points

Ti_lm=[1 0 0 ; 0 1 0 ; -LM.mid(2) -LM.mid(1) 1]; % LM midpoint -> Origin
Ti_ref=[1 0 0 ; 0 1 0 ; ref.mid(2) ref.mid(1) 1]; % Origin -> Ref midpoint

phi=atan2(LM.ams(1)-LM.lambda(1),LM.ams(2)-LM.lambda(2));
theta=-phi;
Ri=[cos(theta) sin(theta) 0 ; -sin(theta) cos(theta) 0 ; 0 0 1];

slm=norm(A(1,:)-A(2,:))/norm(M(1,:)-M(2,:));
S_lm=diag([slm,slm,1]);

M2Ai=Ti_lm*Ri*S_lm*Ti_ref;

tformi=affine2d(M2Ai);

end