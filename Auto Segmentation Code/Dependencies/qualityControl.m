% _______________________________________________________ %
% 
% Quality Control for Automated Segmentation
% 
% Chidren's Hospital of Philadelphia | White Lab
% Author: Hayden Fisher
% Created: February 16, 2025
% Updated: November 22, 2026
%
% _______________________________________________________ %

function [mask,qcdata] = qualityControl(rawdata,params)

%% Exclude saturated pixels
disp('Quality Control: Saturation')
qcdata.max=max(rawdata,[],4);
mask.sat=logical(qcdata.max<(2^16-1));

%% Remove Linear Trend
disp('Quality Control: Detrending')
qcdata.mean=mean(rawdata,4);
rawdata2=permute(detrend(permute(rawdata,[4 1 2 3])),[2 3 4 1]);
rawdata2=rawdata2+qcdata.mean;

%% Mask Noise Floor
disp('Quality Control: Noise Floor')
for c=1:params.numled
    qcdata.floor(:,:,c)=sum(rawdata2(:,:,c,:)<10,4); % Count pixels below floor
    mask.floor(:,:,c)=all(rawdata2(:,:,c,:)>10,4); % Mask pixels that ever drop below floor
end
rawdata2(rawdata2<0)=0;
mask.zeronan=~any(rawdata2==0,4);

%% Beer-Lambert
disp('Quality Control: Ratiometric Data')

lrdata=logmean(rawdata2(:,:,~params.fluorescence,:),logical(mask.zeronan(:,:,~params.fluorescence).*mask.sat(:,:,~params.fluorescence)));
rdata=diffdata(rawdata2(:,:,~params.fluorescence,:),qcdata.mean(:,:,~params.fluorescence),logical(mask.zeronan(:,:,~params.fluorescence).*mask.sat(:,:,~params.fluorescence)),params);
fndata=[];
if any(params.fluorescence)
    fndata=diffdata(rawdata2(:,:,params.fluorescence==1,:),qcdata.mean(:,:,params.fluorescence==1),logical(mask.zeronan(:,:,params.fluorescence==1).*mask.sat(:,:,params.fluorescence==1)),params);
end

%% Signal Variance
disp('Quality Control: Signal Variance')

qcdata.std=std(rawdata2,0,4); % After detrending
Px = size(rawdata2,1);
Py = size(rawdata2,2);

if any(params.fluorescence)
    qcdata.stdr=zeros(Px,Py,params.numled,'like',rawdata);
    qcdata.stdr(:,:,~params.fluorescence)=std(rdata,0,4);
    qcdata.stdr(:,:,params.fluorescence==1)=std(fndata,0,3);
else
    qcdata.stdr=std(rdata,0,4);
end

for c=1:params.numled
    mask.std(:,:,c)=qcdata.stdr(:,:,c)<0.02;
end

%% Local Correlations
disp('Quality Control: Local Correlation')

qcdata.sqroot=sqrt(qcdata.mean);
qcdata.rlocal=localcorr(rawdata2,params);

for c=1:params.numled
    mask.corr(:,:,c)=all(qcdata.rlocal(:,:,c)>=0,4);
end

%% Combine Masks
mask.tot=logical(mask.sat.*mask.std.*mask.corr.*mask.floor);