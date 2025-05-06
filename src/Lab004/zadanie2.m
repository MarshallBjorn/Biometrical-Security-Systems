% Program pomocniczy demonstrujący w jaki sposób może zostać wykonane zliczanie monet z
% wykorzystaniem wersji kołowej transformaty Hougha
% ==========================================================================
clear all, close all, clc
% Załaduj obraz zawierający przykładowe okręgi -> plik dostępny w zasobach pakietu Matlab
A = imread('circlesBrightDark.png');
imshow(A)
Rmin = 15; % dobór tych parametrów ma kluczowe znaczenie dla
Rmax = 95; % dalszej pracy algorytmu
[srodki_j, promienie_j] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','bright');
[srodki_c, promienie_c] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','dark');
viscircles(srodki_j, promienie_j,'Color','b'); %Wizualizacja okręgów
viscircles(srodki_c, promienie_c,'LineStyle','--'); %Wizualizacja okręgów
hold on
title('Wykrywanie okręgów w obrazie');
hold off
% ==========================================================================
% Na podstawie kodu powyżej zliczyć monety w zbiorach monety1-4.jpg :)
% ==========================================================================
A = imread('monety4.jpg');
A= A(380:1262,711:1657);
A= imresize(A,0.5);
imshow(A>55)
A = edge(A, 'canny');
% dla jpg-ów może być potrzebna konwersja do gray
% A= (A(:,:,1)+A(:,:,2)+A(:,:,3))./3;
% lub A= mat2gray(A);
Rmin = 30; % Zakres promieni poszukiwanych okręgów
Rmax = 55;
[srodki, promienie] = imfindcircles(A,[Rmin Rmax], 'ObjectPolarity','bright');
if length(srodki)>0
viscircles(srodki, promienie,'Color','b'); %Wizualizacja okręgów
najw_moneta= find(promienie==max(promienie)); % indeks największej monety
najmn_moneta= find(promienie==min(promienie)); % indeks najmniejszej monety
viscircles(srodki(najw_moneta,:), promienie(najw_moneta) ,'Color','r'); %Wizualizacja okręgów
viscircles(srodki(najmn_moneta,:), promienie(najmn_moneta) ,'Color','y'); %Wizualizacjaokręgów
hold on
title(['Zliczanie monet w obrazie. Liczba monet to: ' num2str(length(srodki))]);
hold off

end
% Mile widziany fragment zliczający sumę nominałów monet :)
% return
% ==========================================================================
% Przetwarzanie zbioru monety1.jpg
% Szacowanie złożoności obliczeniowej
% ==========================================================================
start= tic;
im = imread('monety4.jpg');
A=im;
A= (A(:,:,1)+A(:,:,2)+A(:,:,3))./3;
e = edge(A, 'canny', 0.6);
radii = 60:1:90; %15:1:40;
h = circle_hough(e, radii, 'same', 'normalise');
peaks = circle_houghpeaks(h, radii, 'nhoodxy', 11, 'nhoodr', 7, 'npeaks', 90);
imshow(im);
hold on;
for peak = peaks
[x, y] = circlepoints(peak(3));
plot(x+peak(1), y+peak(2), 'g-');
end
hold off
stop= toc(start);

exportgraphics(gcf, 'zad2result2.png', 'Resolution', 300);