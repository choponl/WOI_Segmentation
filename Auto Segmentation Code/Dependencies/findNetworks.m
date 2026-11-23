function networks = findNetworks(params)

include_hb = logical(params.include .* ~params.fluorescence);
include_fl = logical(params.include .* params.fluorescence);

% Hemodynamic Wavelengths
hemodynamic = dir('Networks/Hemodynamic/network_*nm.mat');
available_hb = cellfun(@(s) ...
    str2double(regexp(s, '\d+(?=nm\.mat$)', 'match', 'once')), ...
    {hemodynamic.name});
targetWavelengths_hb = params.wavelengths(logical(include_hb));

% Excitation Wavelengths
fluorescent = dir('Networks/Hemodynamic/network_*nm.mat');
available_fl = cellfun(@(s) ...
    str2double(regexp(s, '\d+(?=nm\.mat$)', 'match', 'once')), ...
    {fluorescent.name});
targetWavelengths_fl = params.wavelengths(logical(include_fl));

for k = 1:params.numled
    if include_hb
        [~, closestIndex] = min(abs(available_hb - targetWavelengths_hb(k)));
        networks(k) = string(hemodynamic(closestIndex).name);
    elseif include_fl
        [~, closestIndex] = min(abs(available_fl - targetWavelengths_fl(k)));
        networks(k) = string(fluorescent(closestIndex).name);
    end
end