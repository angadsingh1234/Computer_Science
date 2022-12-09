function [train_list_of_tvs, test_list_of_tvs, train_set, test_set] = get_bootstrap_sample(num_tvs, list_of_tvs)
    
    full_set = [1:num_tvs];
    train_set = zeros(1, 1);
    tsi = 0; 
    for i = 1:num_tvs
        
        index = randi([1, num_tvs]); 
        
        if ~any(train_set == index)
            tsi = tsi + 1;
            train_set(tsi) = index;
        end   
    end
    
    train_set = unique(train_set);
    
    test_set = setdiff(full_set, train_set);
    
    train_list_of_tvs = list_of_tvs(train_set);
    test_list_of_tvs = list_of_tvs(test_set);
    
end

