function [set1, set2, min_dist] = find_closest_minutiae_sets(minutiae_sets)
    % Finds the pair of minutiae sets (fingerprints) with the minimum total distance
    % Input:
    %   minutiae_sets - 1xM cell array, each cell is [N x 3] matrix of minutiae [x, y, angle]
    % Output:
    %   set1, set2 - indices of the closest fingerprint sets
    %   min_dist - minimum total distance

    M = numel(minutiae_sets);
    min_dist = inf;

    for i = 1:M-1
        for j = i+1:M
            A = minutiae_sets{i};
            B = minutiae_sets{j};

            total = 0;
            count = 0;

            % Compare each minutia in A to the closest in B
            for m = 1:size(A,1)
                dists = vecnorm(B(:,1:2) - A(m,1:2), 2, 2);
                [d_min, ~] = min(dists);
                total = total + d_min;
                count = count + 1;
            end

            % Average distance as similarity measure
            avg_dist = total / count;

            if avg_dist < min_dist
                min_dist = avg_dist;
                set1 = i;
                set2 = j;
            end
        end
    end
end
