%colorImage -> imagem colorida da camera rgb
%threshold  -> threshold a realizar em imagem de niveis de cinzento
%object     -> objecto detectado
function [object]=getObject(colorImage,threshold)
%% Primeira passagem, encontra a maior área preta
teste=colorImage; % adaptação de código 
teste=rgb2gray(teste); % imagem em niveis de cinzento
teste=~imbinarize(teste,threshold); % binarização da imagem a partir de um threshold defenido pelo utilizador
save=teste; %Guarda a imagem obtida em save;
[L,~]=bwlabel(teste); % label do objecto
s = regionprops(teste,'Area'); % áreas
Areas=[s.Area]'; % areas em forma de array
pretended_part=find(Areas==max(Areas)); % encontra a maior área
teste=ismember(L,pretended_part); % e discarta as restantes
teste=~teste; % inverte para que o fundo volte a ficar preto
teste=imclearborder(teste); % apaga os objectos na fronteira
%% Segunda passagem
% a partir da imagem invertida anteriormente ( que seria o fundo preto a
% branco), é encontrada a maior área branca e são adicionados os furos
[L,~]=bwlabel(teste); % Objects label
s = regionprops(teste,'Area'); % Areas properties
Areas=[s.Area]'; % areas in array shape
pretended_part=find(Areas==max(Areas)); % find biggest area
teste=ismember(L,pretended_part); % and discart the other objects with small areas
teste=teste.*~save; % adicionada os furos da imagem
%% Terceira passagem
% apenas fica com o objecto a detectar
[L,~]=bwlabel(teste); % Objects label
s = regionprops(teste,'Area'); % Areas properties
Areas=[s.Area]'; % areas in array shape
pretended_part=find(Areas==max(Areas)); % find biggest area
teste=ismember(L,pretended_part); % and discart the other objects with small areas
object=teste; %final da adaptação
end