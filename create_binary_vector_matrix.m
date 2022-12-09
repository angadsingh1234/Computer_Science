function [binary_vector_matrix] = create_binary_vector_matrix(data, model_words, num_tvs) 
    num_model_words = length(model_words);
    binary_vector_matrix = zeros(num_model_words, num_tvs);
    fn = fieldnames(data);
    j = 0;
    for k=1:numel(fn)
        tvs_in_item = length(data.(fn{k}));
        for z = 1:tvs_in_item
            j = j + 1;
            for i = 1:length(model_words)
                if contains(lower(data.(fn{k})(z).('title')), lower(model_words(i)))
                    binary_vector_matrix(i,j) = 1;
                end
            end
        end
    end
end

