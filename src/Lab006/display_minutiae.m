
function display_minutiae(fingerprint_skeleton, minutiae)
    % Displays the fingerprint skeleton image with minutiae marked.
    % Minutiae format: [x, y, angle]
    % Uses colored rectangles:
    % - Green for ridge endings
    % - Red for bifurcations

    figure;
    imshow(fingerprint_skeleton); hold on;

    for i = 1:size(minutiae, 1)
        x = minutiae(i, 1);
        y = minutiae(i, 2);
        angle = minutiae(i, 3);

        % Estimate type based on neighborhood count (simplified logic)
        % This assumes that bifurcations were added last (optional hint)
        neighbourhood = fingerprint_skeleton(y-1:y+1, x-1:x+1);
        type = sum(sum(neighbourhood));
        if type == 2 %starts/ends of lines
            color = 'g';  % Ridge ending
        elseif type == 4  % bifurcations
            color = 'r';  % Bifurcation
        end

        % Draw a small rectangle at the minutia location
        rectangle('Position', [x-1.5, y-1.5, 3, 3], 'EdgeColor', color, 'LineWidth', 1.5);
    end

    title('Minutiae Display on Skeleton');
    hold off;
end
