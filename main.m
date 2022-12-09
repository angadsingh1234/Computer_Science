data = import_data('TVs-all-merged.json');
[model_words, num_tvs, list_of_tvs] = get_model_words(data);
[binary_vector_matrix] = create_binary_vector_matrix(data, model_words, num_tvs);

num_bootstrap_rounds = 5; 
num_permutations = 700;
threshold_val = 0.5;

[thresholds, bands, rows] = get_threshold_val(700);
[~, minIndex] = min(abs(thresholds - threshold_val));

band = bands(minIndex);
row = rows(minIndex);

rng('default');

jaccard_thresholds = 0.1:0.1:1;

f1_scores = zeros(2, num_bootstrap_rounds);
%%
for b = 1:num_bootstrap_rounds
    b
    f1_scores_bootstrap = zeros(1, length(jaccard_thresholds));

    [train_tvs, test_tvs, train, test] = get_bootstrap_sample(num_tvs, list_of_tvs); 
    [signature_matrix] = create_signature_matrix(binary_vector_matrix(:,train), num_permutations);

    for i = 1:length(jaccard_thresholds)
        i
        %Train
        [neighbour_matrix, nc_matrix] = LSH(signature_matrix, band, train_tvs, jaccard_thresholds(i));
        [~, f1, ~, ~] = get_f1_star_score(neighbour_matrix, train_tvs, nc_matrix);
        f1_scores_bootstrap(i) = f1;

    end

    %Test
    [~,max_f1_index] = max(f1_scores_bootstrap);
    
    [signature_matrix] = create_signature_matrix(binary_vector_matrix(:,test), num_permutations);
    [neighbour_matrix, nc_matrix] = LSH(signature_matrix, band, test_tvs, jaccard_thresholds(max_f1_index));
    [~, f1, ~, ~] = get_f1_star_score(neighbour_matrix, test_tvs, nc_matrix);

    f1_scores(1,b) = f1;
    f1_scores(2,b) = jaccard_thresholds(max_f1_index);
    
end
%% 
mean_f1_score = mean(f1_scores,2);
variance_f1_scores = var(f1_scores, 0, 2);

num_iterations = length(bands);

final_f1_scores = zeros(1, num_iterations);
final_f1_star_scores = zeros(1, num_iterations);
pair_qualities = zeros(1, num_iterations);
pair_completeness_scores = zeros(1, num_iterations);
num_comparisons = zeros(1, num_iterations);

for i = 1:num_iterations
    i
    [signature_matrix] = create_signature_matrix(binary_vector_matrix, num_permutations);
    [neighbour_matrix, nc_matrix] = LSH(signature_matrix, bands(i), list_of_tvs, mean_f1_score(2));

    [f1_star, f1, pq, pc] = get_f1_star_score(neighbour_matrix, list_of_tvs, nc_matrix);

    final_f1_scores(i) = f1;
    final_f1_star_scores(i) = f1_star;
    pair_qualities(i) = pq;
    pair_completeness_scores(i) = pc;
    num_comparisons(i) = sum(nc_matrix, 'all');

end
%%
fraction_comparisons = num_comparisons ./ nchoosek(num_tvs,2);

data_plot = [transpose(fraction_comparisons), transpose(final_f1_star_scores), transpose(pair_qualities), transpose(pair_completeness_scores), transpose(final_f1_scores)];
data_plot = sortrows(data_plot);

plot(data_plot(:,1), data_plot(:,3), '-o','color', 'blue', 'LineWidth', 0.9, 'MarkerFaceColor','red')
xlabel('Fraction of Comparisons') 
ylabel('Pair Quality') 
