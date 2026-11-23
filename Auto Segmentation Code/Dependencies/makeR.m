function R=makeR(data)

switch numel(size(data))
    case 4
        [Px,Py,numc,T]=size(data);
        
        nump=Px*Py;
        
        data=reshape(data,nump,numc,T);
        
    case 3
        [nump,numc,T]=size(data);
end

R=zeros(nump,nump,numc,'like',data);
for c=1:numc
    cdata=squeeze(data(:,c,:));
        
    cdata=normRow3(cdata);

    R(:,:,c)=cdata*cdata'/T;
end

end

