function [clean] = clean_neighbour_matrix(q, l, list_of_tvs, signature_matrix, j_threshold) 
    
    clean = 0; 
    
    if strcmp(list_of_tvs(q).modelID_title, "") == 1 ||  strcmp(list_of_tvs(l).modelID_title, "") == 1 
        if strcmp(list_of_tvs(l).shop, list_of_tvs(q).shop) == 1 || strcmp(list_of_tvs(l).brand, list_of_tvs(q).brand) == 0
            clean = 1; 
        elseif jaccard_similarity(signature_matrix, q, l) < j_threshold
            clean = 1; 
        end
    else

        if strcmp(list_of_tvs(q).modelID_title, list_of_tvs(l).modelID_title) == 0
            clean = 1;
        end

    end

end

