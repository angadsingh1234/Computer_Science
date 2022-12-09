function [signature_matrix] = create_signature_matrix(binary_vector_matrix, k)
    num_products = size(binary_vector_matrix,2);
    num_model_words = size(binary_vector_matrix,1);
    
    signature_matrix = zeros(k, num_products);
    
    for r = 1:k
        perm = randperm(length(1:num_model_words));
        for c = 1:num_products
        
            signature_matrix(r,c) = min(perm(binary_vector_matrix(:,c) == 1));
        end
    end
    
end

