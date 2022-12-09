function [f1_star, f1, pair_quality, pair_completeness] = get_f1_star_score(neighbour_matrix, list_of_tvs, num_comparisons_matrix)
   
    num_products = size(neighbour_matrix, 1);
    real_neighbour_matrix = zeros(num_products, num_products);
   
    num_comparisons = sum(num_comparisons_matrix, 'all');
    duplicates_found = 0;
    num_duplicates = 0;

    TN = 0;
    FP = 0;
    FN = 0;
    TP = 0; 

    for i = 1:num_products
        for j = 1 + i:num_products

            if strcmp(list_of_tvs(i).modelID, list_of_tvs(j).modelID) == 1
                real_neighbour_matrix(i,j) = 1;
                num_duplicates = num_duplicates + 1; 
            end

            if num_comparisons_matrix(i,j) == 1 && real_neighbour_matrix(i,j) == 1
                duplicates_found = duplicates_found + 1; 
            end

            if real_neighbour_matrix(i,j) == 0 && neighbour_matrix(i,j) == 0
                TN = TN + 1;
            end
            if real_neighbour_matrix(i,j) == 0 && neighbour_matrix(i,j) == 1
                FP = FP + 1;
            end
            if real_neighbour_matrix(i,j) == 1 && neighbour_matrix(i,j) == 0
                FN = FN + 1;
            end
            if real_neighbour_matrix(i,j) == 1 && neighbour_matrix(i,j) == 1
                TP = TP + 1;
            end
            
        end
    end

    precision = TP / (TP + FP);
    recall = TP / (TP + FN);
    
    f1 = 2 * precision * recall / (precision + recall);
    
    pair_quality = duplicates_found / num_comparisons;
    pair_completeness = duplicates_found / num_duplicates;
    
    f1_star = (2 * pair_quality * pair_completeness) / (pair_quality + pair_completeness);
    
end

