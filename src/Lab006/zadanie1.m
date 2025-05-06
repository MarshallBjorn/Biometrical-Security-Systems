clear; clc; close all;

% Wczytaj obraz
img = imread('test 2.jpg');
if size(img,3) == 3
    img = rgb2gray(img);
end

% Wstępna obróbka
img_eq = adapthisteq(img);             % Poprawa kontrastu
img_filt = medfilt2(img_eq);           % Usunięcie szumów

% Filtracja Gaborowa
gaborArray = gabor(8, [0 45 90 135]);  % 4 orientacje
gaborMag = zeros(size(img_filt));
for i = 1:length(gaborArray)
    gaborMag = gaborMag + imgaborfilt(img_filt, gaborArray(i));
end
gaborMag = mat2gray(gaborMag);

% Binaryzacja i morfologia
bw = imbinarize(gaborMag);
bw = bwareaopen(bw, 50);               % Usuń małe obiekty
skeleton = bwmorph(bw, 'skel', Inf);   % Skeletonizacja

% Ekstrakcja minucji
[minutiaeMap, endings, bifurcations] = extract_minutiae(skeleton);

% Wizualizacja
figure;
subplot(2,2,1), imshow(img), title('Oryginalny');
subplot(2,2,2), imshow(gaborMag), title('Po filtrze Gabor');
subplot(2,2,3), imshow(skeleton), title('Skeleton');
subplot(2,2,4), imshow(img), title('Minucje'); hold on;
plot(endings(:,2), endings(:,1), 'ro', 'MarkerSize', 6);
plot(bifurcations(:,2), bifurcations(:,1), 'go', 'MarkerSize', 6);
legend('Zakończenia', 'Rozwidlenia');

exportgraphics(gcf, 'zad2results.png', 'Resolution', 300)