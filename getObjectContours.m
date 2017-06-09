% object -> objecto para que lhe sejam detectados os contornos
% D -> Imagem com os pontos interiores da malha
% GAP2 -> intervalo de pontos para os contornos
% x -> linha dos contornos
% y -> coluna dos contornos
function [y,x]=getObjectContours(object,D,GAP2) 
%% Contours using canny
BW = edge(object,'Canny');
[B,~] = bwboundaries(BW,'noholes'); % coordinates of all contours
for n=1:size(B,1)
    contador=0; % counter at 0
    for m=1:GAP2:size(B{n,1},1) 
        contador=contador+1; % contador para incrementar no numero de pontos
        Vetor{n,1}(contador,:)=B{n,1}(m,:); % Vetor que guarda as coordenadas do canny 
    end
end
%% Junta à imagem D as coordenadas dos pontos anteriores 
 B=Vetor{1}(:,:); 
  for n=1:size(B,1)
      D(B(n,1),B(n,2))=1; % para cada coordenada de B colocar D com pixel branco
  end
[y,x]=find(D==1); % encontra as coordenadas de todos os pixels brancos
end