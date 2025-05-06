%Program demonstrujący wykorzystanie wersji kołowej transformaty Hougha
%w zadaniu wyodrębniania pola tęczówki
%==========================================================================
clear all, close all, clc
oko = imread('oko1.jpg'); %lub oko1
oko= mat2gray(oko);
imshow(oko)

% Wszystkie wystąpienia ???? należy uzupełnić samodzielnie dobranymi
% parametrami transformaty
Rmin = 80; %twardówka - tęczówka
Rmax = 150;
[srodki_j, promienie_j] = imfindcircles(oko,[Rmin Rmax],'ObjectPolarity','dark', 'Sensitivity', 0.95);

Rmin = 20; %źrenica - tęczówka
Rmax = 30;
[srodki_c, promienie_c] = imfindcircles(im2bw(oko, 0.12),[Rmin Rmax],'ObjectPolarity', 'dark', 'Method', 'TwoStage', 'Sensitivity', 0.85);

viscircles(srodki_j, promienie_j,'Color','b'); %Wizualizacja okręgów
viscircles(srodki_c, promienie_c,'LineStyle','--'); %Wizualizacja okręgów
hold on
title('Wykrywanie okręgów w obrazie');
hold off

exportgraphics(gcf, 'results.png', 'Resolution', 300);

% parametry normalizacji
promien_rozdz = 90;
kat_zakres = 360;

% Rozwijanie tęczówki do współrzędnych biegunowych
[polar_tab, szum_tab] = polar_transform(oko, ...
    srodki_c(1), srodki_c(2), promienie_c, ...
    srodki_j(1), srodki_j(2), promienie_j, ...
    promien_rozdz, kat_zakres);

figure
imagesc(polar_tab)
colormap(gray)
