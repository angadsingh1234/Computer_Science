function [data] = import_data(jsonFile)
    fileName = jsonFile; % filename in JSON extension 
    str = fileread(fileName); % dedicated for reading files as text 
    data = jsondecode(str); % Using the jsondecode function to parse JSON from string 
end

