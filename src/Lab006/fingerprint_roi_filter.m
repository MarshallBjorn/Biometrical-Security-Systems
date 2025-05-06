function roi_mask = fingerprint_roi_filter(image)
    % Extracts fingerprint ROI 
    % Inputs:
    %   image - grayscale fingerprint image
    % Outputs:
    %   roi_mask - binary mask of fingerprint area
    
    % Step 1: Adaptive thresholding
    bw = imbinarize(image, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.4);
    bw = ~bw;

    % Step 2: Remove small noise
    bw = bwareaopen(bw, 25);

    % Step 3: Morphological cleanup
    bw = imclose(bw, strel('disk', 5));
    bw = imfill(bw, 'holes');
    bw = imopen(bw, strel('disk', 5));

    % Step 4: Keep largest connected component
    bw = bwareafilt(bw, 1);

    % Step 5: Optional erosion to shrink ROI margin
    roi_mask = imerode(bw, strel('disk', 5));
end
