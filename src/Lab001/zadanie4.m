% Wczytanie obrazu i konwersja do skali szarości
rgbImage = imread('monety1.jpg'); % przykład dobrze kontrastowego obrazu
grayImage = rgb2gray(rgbImage);

% Segmentacja metodą Otsu
binaryImage = imbinarize(grayImage, graythresh(grayImage));

% Wypełnienie dziur (opcjonalne)
binaryImage = imfill(binaryImage, 'holes');

% Etykietowanie obiektów
labeledImage = bwlabel(binaryImage);

% Właściwości obiektów
props = regionprops(labeledImage, 'BoundingBox', 'Area', 'Perimeter');

% Wyświetlenie obrazu z nałożonymi obramowaniami
figure;
imshow(rgbImage);
title('Wykryte obiekty z obramowaniem');
hold on;

% Iteracja przez obiekty i rysowanie obramowań
for k = 1:length(props)
    bbox = props(k).BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
    
    % Wyświetlanie powierzchni i obwodu w konsoli (opcjonalnie)
    fprintf('Obiekt %d: Powierzchnia = %.2f, Obwód = %.2f\n', k, props(k).Area, props(k).Perimeter);
end

hold off;
exportgraphics(gca, 'zadanie4images/obiekty_z_obramowaniem.png');