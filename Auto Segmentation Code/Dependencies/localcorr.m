function RL=localcorr(rawdata, params)

Px = size(rawdata,1);
Py = size(rawdata,2);

% Get Correlation Matrix
R=makeR(rawdata);
R=reshape(R,Px,Py,Px,Py,params.numled);

% Initialize result
RL=zeros(Px,Py,params.numled,4,'like',R);

% Loop over all pixels
for x=1:Px
    for y=1:Py

            try
                RL(x,y,:,1)=squeeze(R(x,y,x-1,y,:));
            catch
                RL(x,y,:,1)=NaN;
            end
            
             try
                RL(x,y,:,2)=squeeze(R(x,y,x+1,y,:));
            catch
                RL(x,y,:,2)=NaN;
             end
            
            try
                RL(x,y,:,3)=squeeze(R(x,y,x,y-1,:));
            catch
                RL(x,y,:,3)=NaN;
            end
            
            try
                RL(x,y,:,4)=squeeze(R(x,y,x,y+1,:));
            catch
                RL(x,y,:,4)=NaN;
            end

    end
end

end