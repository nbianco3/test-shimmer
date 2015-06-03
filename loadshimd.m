function [sensorNamesCellArray, signalNamesCellArray, formatNamesCellArray, signalUnitsCellArray, sensorDataArray] = loadshimd(filePath)

%LOADSHIMD - Reads Shimmer data from a file which uses SHIMDv1 or
%              SHIMDv2 formats.
%
%  LOADSHIMD(FILEPATH) loads the header and numeric data from the file 
%  defined in FILEPATH. 
%
%  SYNOPSIS: [sensorNamesCellArray, signalNamesCellArray, signalUnitsCellArray, sensorDataArray] = loadshimd(filePath)
%
%  INPUT : filePath - String value defining the name/path of the file that 
%                     data is loaded from.
% 
%  OUTPUT: sensorNamesCellArray - [n x 1] cell array containing the sensor
%                                 names where n = number of data signals.
%  OUTPUT: signalNamesCellArray - [n x 1] cell array containing the signal 
%                                 names where n = number of data signals.
%  OUTPUT: formatNamesCellArray - [n x 1] cell array containing the signal 
%                                 formats where n = number of data signals.
%  OUTPUT: signalUnitsCellArray - [n x 1] cell array containing the signal 
%                                 units where n = number of data signals.
%  OUTPUT: sensorDataArray - [m x n] numeric array containing the sensor 
%                            data where m = number of samples and n = number
%                            of data signals.
%
%  EXAMPLE: [sensorNamesCellArray, signalNamesCellArray, signalUnitsCellArray, sensorDataArray] = loadshimd('shimmerdata.dat')
%
%  Created: 3rd January 2013, Karol O'Donovan <support@shimmer-research.com>
%


nHeaderRows = 3;                                                           % Initialise nHeaderRows to 3 (SHIMDv1 file format)

%% Determiine if file format is SHIMDv1 or SHIMDv2
try
    dlmread (filePath,'\t',[3 0 3 0]);	                                   % Load value from 4th row 1st column of data, generates an error if it is not a numeric value
catch                                                                      % If an Error is generated
    nHeaderRows = 4;                                                       % Initialise nHeaderRows to 4 (SHIMDv2 file format)   
end
 

%% Load numeric data
sensorDataArray = dlmread (filePath,'\t',nHeaderRows,0);	               % Load tab seperated numeric data from a text file starting 
                                                                           % from 4th/5th row 1st column of data(i=0,1,2...) (i.e. ignore header information)                                                                                                   

%% Load header data

[nSamples, nSignals] = size(sensorDataArray);                              % Determine number of signals captured in the file (i.e. columns of data)     

fid = fopen(filePath);

sensorNamesCellTemp = textscan(fid, '%s', nSignals, 'delimiter' , '\t');   % Load tab seperated sensor name strings for each signal  
sensorNamesCellArray = sensorNamesCellTemp{1}';
signalNamesCellTemp = textscan(fid, '%s', nSignals, 'delimiter' , '\t');   % Load tab seperated signal name strings for each signal  
signalNamesCellArray = signalNamesCellTemp{1}';

if nHeaderRows == 4                                                        % SHIMDv2 file format
    formatNamesCellTemp = textscan(fid, '%s', nSignals, 'delimiter' , '\t');   % Load tab seperated data format name strings for each signal  
    formatNamesCellArray = formatNamesCellTemp{1}';  
end

signalUnitsCellTemp = textscan(fid, '%s', nSignals, 'delimiter' , '\t');   % Load tab seperated signal unit strings for each signal  
signalUnitsCellArray = signalUnitsCellTemp{1}';

% If file is in SHIMDv1 format, determine data format from timsetamp units
if nHeaderRows == 3                                                        % SHIMDv1 file format
    if (strmatch(signalUnitsCellArray(1),'no units'))                      % if units are 'no units' them it must be raw data
        formatName = 'RAW';                                                % use 'RAW' data format string   
    else
        formatName = 'CAL';                                                % use 'CAL' data format string   
    end
    
    nRows = length(signalUnitsCellArray);
      
    for i = 1:nRows
        formatNamesCellArray(i) = cellstr(formatName);                     % Build cell array of data format names
    end
    
end

fclose(fid);

end