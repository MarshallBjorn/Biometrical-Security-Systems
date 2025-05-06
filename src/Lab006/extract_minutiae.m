function [minutiaeMap, endings, bifurcations] = extract_minutiae(skel)

% Inicjalizacja
[r, c] = size(skel);
minutiaeMap = zeros(r, c);
endings = [];
bifurcations = [];

% Analiza sąsiedztwa 3x3
for i = 2:r-1
    for j = 2:c-1
        if skel(i,j)
            block = skel(i-1:i+1, j-1:j+1);
            CN = sum(block(:)) - 1;
            if CN == 1
                minutiaeMap(i,j) = 1;        % zakończenie
                endings = [endings; i, j];
            elseif CN >= 3
                minutiaeMap(i,j) = 2;        % rozwidlenie
                bifurcations = [bifurcations; i, j];
            end
        end
    end
end

end
