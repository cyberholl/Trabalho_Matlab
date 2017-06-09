% Gap               -> intervalo entre pontos da malha mais refinada
% Gap3              -> tamanho dos quadrados da imagem
% object            -> objecto onde tra�ar a malha
% ValoresGradiente  -> Imagem com os gradientes obtida previamente a partir
%                      da fun��o gradient.
% D                 -> Imagem preta com pontos brancos (malha)
function D=getMeshSquares(ValoresGradiente,object,Gap,Gap3)
parametro1=1;
% Divis�o em v�rios quadrados
contadorlinhas=0;
contadorcolunas=0;
for n=1:Gap3:(size(ValoresGradiente,1)-Gap3)
    contadorlinhas=contadorlinhas+1;
    contadorcolunas=0;
    for m=1:Gap3:(size(ValoresGradiente,2)-Gap3)
        contadorcolunas=contadorcolunas+1;
        Quadrados(:,:,contadorlinhas,contadorcolunas)=ValoresGradiente(n:n+Gap3,m:m+Gap3);
    end
end

%% C�lculo do gradiente m�dio de cada quadrado
% Colocar matrizes a zero
maximo=zeros(size(Quadrados,3),size(Quadrados,4));
minimo=maximo;
media=maximo;
mediaabs=maximo;
subtracao=maximo;
% percorrer a dimens�o de Quadrados (matriz 4D com as v�rias divis�es)
for n=1:size(Quadrados,3)
    for m=1:size(Quadrados,4)
        Quadrado=Quadrados(:,:,n,m);
        sumatorio=0;
        contador=0;
        maximo(n,m)=max(Quadrado(:));
        minimo(n,m)=min(Quadrado(:));       
        for o=1:size(Quadrado,1)
           for p=1:size(Quadrado,2)
               if isnan(Quadrado(o,p)) % se for not a number
                   % nada n�o faz nada
               else % caso contr�rio
                 contador=contador+1; % acrescenta 1 ao contador
                  sumatorio=sumatorio+Quadrado(o,p);   % soma o valor da c�lula ao sumatorio 
               end   
           end
        end 
         media(n,m)=sumatorio/contador; % no fim divide o valor somado pelo contador
         subtracao(n,m)=maximo(n,m)-media(n,m);
         mediaabs(n,m)=abs(media(n,m));
         subtracao(n,m)=abs(subtracao(n,m));
    end
end
  
%% Divis�o das v�rias zonas em grupos
matriz=zeros(size(mediaabs,1),size(mediaabs,2));
% Separa��o consuante o m�dulo da m�dia
for n=1:size(media,1)
    for m=1:size(media,2)
       valor=mediaabs(n,m);  % leitura do valor da m�dia
        if isnan(valor) % se for nan
            matriz(n,m)=0; % atribuir valor 0
        elseif(valor<=parametro1)
            matriz(n,m)=1;
        elseif(valor<=parametro1*2 && valor>parametro1)    
            matriz(n,m)=2;
        elseif(valor<=parametro1*4 && valor>parametro1*2)      
            matriz(n,m)=3;
        elseif(valor<=parametro1*6 && valor>parametro1*4)   
            matriz(n,m)=4;
        elseif(valor>parametro1*6)  
            matriz(n,m)=5;
        end   
    end
end    
    
%% A partir do valor dos quadrados expandir para a imagem original.
% Expandir a matriz com o valor das m�dias para 
medias2=zeros(size(object));
for n=1:Gap3:size(medias2,1)-Gap3
    for m=1:Gap3:size(medias2,2)-Gap3

        if (n==1 && m ~=1)
          medias2(n:n+Gap3-1,m:m+Gap3-1)=matriz((n),((m-1)/Gap3));  
        elseif (m==1 && n~=1)
          medias2(n:n+Gap3-1,m:m+Gap3-1)=matriz(((n-1)/Gap3),m);   
        elseif (m==1 && n==1)
        medias2(n:n+Gap3-1,m:m+Gap3-1)=matriz(n,m);     
        else
       medias2(n-1:n+Gap3-1,m-1:m+Gap3-1)=matriz(((n-1)/Gap3),((m-1)/Gap3));
        end
    end
end
aresta=bwmorph(object,'erode',4);
aresta=~aresta;

medias2=fliplr(medias2)-aresta;    

%%
mesh1=meshImage(object,round(Gap*3));
mesh2=meshImage(object,round(Gap*3));
mesh3=meshImage(object,round(Gap*2));
mesh4=meshImage(object,round(Gap*2));
mesh5=meshImage(object,round(Gap*1));

%Nivel 5
nivel5=medias2==5;
nivel5=nivel5.*mesh5;
%Nivel 4
nivel4=medias2==4;
nivel4=nivel4.*mesh4;
%Nivel 3
nivel3=medias2==3;
nivel3=nivel3.*mesh3;
%Nivel 2
nivel2=medias2==2;
nivel2=nivel2.*mesh2;
%Nivel 1
nivel1=medias2==1;
nivel1=nivel1.*mesh1;

D=nivel1+nivel2+nivel3+nivel4+nivel5;
D=D.*object;
imshow(D)
end