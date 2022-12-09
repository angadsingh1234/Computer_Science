function [neighbour_matrix, num_comparisons_matrix] = LSH(signature_matrix, bands, list_of_tvs, j_treshold)
    
    num_products = size(signature_matrix, 2);
    neighbour_matrix = zeros(num_products, num_products);
    
    bucket_arr = zeros(1,bands*num_products); 
    buckets = struct();
    
    bucket_index = 0; 
    
    permutations = size(signature_matrix, 1);
    rows = permutations / bands; 
    
    for b = 1:bands
        for p = 1:num_products 
            bucket = str2double(sprintf('%d', signature_matrix(((b-1)*rows +1) : ((b-1)*rows) + rows, p)));

            if ~any(bucket_arr(1,:) == bucket) 
                bucket_index = bucket_index + 1;
                
                bucket_arr(bucket_index) = bucket;
                
                buckets(bucket_index).bucket = bucket;
                buckets(bucket_index).duplicates = p;
            else
                index = find(bucket_arr == bucket);
                buckets(index).duplicates = [buckets(index).duplicates, p];
                
            end
        end
    end

    num_comparisons_matrix = zeros(num_products, num_products);
    
    for z = 1:length(buckets)
        duplicates = sort(unique(buckets(z).duplicates));
        if length(duplicates) > 1
            for i = 1:(length(duplicates)- 1)
                for j = 1 + i:length(duplicates)
                    
                    q = duplicates(i);
                    l = duplicates(j);

                    if num_comparisons_matrix(q,l) == 1
                        continue;
                    end
                    
                    num_comparisons_matrix(q,l) = 1;

                    if clean_neighbour_matrix(q,l, list_of_tvs, signature_matrix, j_treshold) == 1
                        neighbour_matrix(q,l) = 0;
                    else
                        neighbour_matrix(q,l) = 1;
                    end             
                       
                end
            end
        end
    end
    
end

