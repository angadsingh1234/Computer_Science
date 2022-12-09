function [similarity] = jaccard_similarity(signature_matrix, q, l)
    
    permutations = size(signature_matrix, 1);
    similarity = length(intersect(signature_matrix(:,q), signature_matrix(:,l))) / permutations;
   
end

