function [rdata]=diffdata(data,mdata,isbrain, params)

Px = size(data,1);
Py = size(data,2);

data=reshape(data,[],size(data,4));
mdata2=repmat(reshape(mdata,[],1),1,size(data,4));
rdata=zeros(size(data),'like',data);
rdata(isbrain,:)=(data(isbrain,:)-mdata2(isbrain,:))./mdata2(isbrain,:);
rdata=reshape(rdata,Px,Py,sum(~params.fluorescence),[]);

end