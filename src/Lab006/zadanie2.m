%% Inicjalizacja
clear all;
close all;
clc;

if ~exist('output', 'dir')
    mkdir('output');
end

%% 1. Wczytanie obrazów tęczówki
irisFiles = dir('Irises/*.jpg');
numImages = length(irisFiles);
images = cell(1, numImages);

for i = 1:numImages
    images{i} = imread(fullfile(irisFiles(i).folder, irisFiles(i).name));
    if size(images{i}, 3) == 3
        images{i} = rgb2gray(images{i});
    end
end

%% 2. Segmentacja tęczówki i tworzenie masek
irisMasks = cell(1, numImages);
irisCenters = zeros(numImages, 2);
irisRadii = zeros(numImages, 1);

figure;
for i = 1:numImages
    img = imadjust(images{i});
    
    % Wykrywanie okręgu tęczówki
    [centers, radii] = imfindcircles(img, [30 120], 'ObjectPolarity', 'dark', 'Sensitivity', 0.98, 'EdgeThreshold', 0.05);
    
    if ~isempty(centers)
        irisCenters(i,:) = centers(1,:);
        irisRadii(i) = radii(1);
        
        % Tworzenie maski tęczówki
        [x, y] = meshgrid(1:size(img,2), 1:size(img,1));
        irisMasks{i} = ((x - centers(1,1)).^2 + (y - centers(1,2)).^2 <= radii(1)^2);
        
        % Wizualizacja
        subplot(ceil(numImages/3), 3, i);
        imshow(img);
        viscircles(centers(1,:), radii(1), 'Color', 'r');
        title(sprintf('Obraz %d', i));

        frame = getframe(gca);
        outputPath = fullfile('output', sprintf('iris_detected_%02d.png', i));
        imwrite(frame.cdata, outputPath);
    else
        error('Nie znaleziono tęczówki w obrazie %d', i);
    end
end

%% 3. Normalizacja tęczówki (Rubber Sheet Model)
normalizedIrises = cell(1, numImages);
normalizedSize = [64, 512]; % Rozmiar znormalizowanej tęczówki [wysokość, szerokość]

for i = 1:numImages
    normalizedIrises{i} = normalizeIris(images{i}, irisCenters(i,:), irisRadii(i), normalizedSize);
    
    % Wizualizacja
    figure;
    subplot(1,2,1); imshow(images{i}); title('Oryginał');
    subplot(1,2,2); imshow(normalizedIrises{i}); title('Znormalizowana tęczówka');
    frame = getframe(gcf);
    outputPath = fullfile('output', sprintf('iris_normalized_%02d.png', i));
    imwrite(frame.cdata, outputPath);

end

%% 4. Ekstrakcja cech
gaborFeatures = cell(1, numImages);
lambda = 8; % Długość fali
theta = 0:30:150; % Orientacje

% Utworzenie banku filtrów Gabora
gaborArray = gabor(lambda, theta);

for i = 1:numImages
    img = normalizedIrises{i};
    gaborMagnitude = imgaborfilt(img, gaborArray);
    
    % Konwersja do kodu binarnego
    gaborFeatures{i} = gaborMagnitude > mean(gaborMagnitude(:));
end

%% 5. Obliczenie dystansu Hamminga dla wszystkich par
hdMatrix = zeros(numImages, numImages);

for i = 1:numImages
    for j = i+1:numImages
        hdMatrix(i,j) = hammingDistance(gaborFeatures{i}, gaborFeatures{j});
    end
end

% Symetryczne wypełnienie macierzy
hdMatrix = hdMatrix + hdMatrix';

%% 6. Wizualizacja wyników
figure;
imagesc(hdMatrix);
colorbar;
title('Macierz dystansu Hamminga');
xlabel('Indeks obrazu');
ylabel('Indeks obrazu');
frame = getframe(gcf);
outputPath = fullfile('output', 'hamming_matrix.png');
imwrite(frame.cdata, outputPath);

%% 7. Ocena wyników
fprintf('Średni dystans Hamminga: %.3f\n', mean(hdMatrix(hdMatrix > 0)));
fprintf('Minimalny dystans: %.3f\n', min(hdMatrix(hdMatrix > 0)));
fprintf('Maksymalny dystans: %.3f\n', max(hdMatrix(:)));

%% Funkcje pomocnicze
function normalized = normalizeIris(img, center, radius, normalizedSize)
    [height, width] = size(img);
    [x, y] = meshgrid(1:width, 1:height);
    
    % Konwersja do współrzędnych biegunowych
    theta = linspace(0, 2*pi, normalizedSize(2));
    r = linspace(0, 1, normalizedSize(1));
    
    [thetaGrid, rGrid] = meshgrid(theta, r);
    
    % Transformacja do współrzędnych kartezjańskich
    xq = center(1) + rGrid * radius .* cos(thetaGrid);
    yq = center(2) + rGrid * radius .* sin(thetaGrid);
    
    % Interpolacja
    normalized = interp2(x, y, double(img), xq, yq, 'linear', 0);
    normalized = uint8(normalized);
end

function hd = hammingDistance(code1, code2)
    % Uproszczone obliczenie HD (dla kodów binarnych)
    xorResult = xor(code1, code2);
    hd = mean(xorResult(:));
end