function [lrdata]=logmean(data,isbrain)

numcontrast=size(data,3);
Px = size(data,1);
Py = size(data,2);

data=reshape(data,[],size(data,4));

mdata=mean(data,2);
lrdata=zeros(size(data),'like',data);
lrdata(isbrain,:)=-log(data(isbrain,:)./mdata(isbrain,:));
lrdata=squeeze(reshape(lrdata,Px,Py,numcontrast,[]));

end