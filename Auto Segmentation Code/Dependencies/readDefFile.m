function [fvalues]=readDefFile(filename)

fid=fopen(filename);
input = '';
fvalues = struct;

try
    while ~contains(input,'END')
        input = fgetl(fid);
        if (~isempty(input) && input(1)~='#')
            split = find(isstrprop(input,'wspace'),1);
            key = lower(input(1:(split-1)));
            value = input((split+1):end);
                if ~ismember(key,{'indir', 'outdir','data_type'})
                    value = str2num(value);
                end
            fvalues.(key)=value;
        end
    end
catch
end

fclose(fid);

end
