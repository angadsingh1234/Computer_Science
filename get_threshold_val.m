function [thresholds, bands, rows] = get_threshold_val(k)
   
    thresholds = zeros(50, 1); 
    bands = zeros(50,1);
    rows = zeros(50,1); 
    
    index = 0; 
    
    for i = 1:k
        if mod(k,i) == 0
            index = index  + 1;
            band = i;
            row = k / band;
            thresholds(index) = (1/band)^(1/row);
            bands(index) = band;
            rows(index) = row; 
        end
    end
    
    thresholds = thresholds(thresholds~=0);
    bands = bands(bands~=0);
    rows = rows(rows~=0);
end

