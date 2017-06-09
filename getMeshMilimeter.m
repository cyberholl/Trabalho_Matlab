function imagemMalha=getMeshMilimeter(ptCloud,object,distancianova,distanciaAjustavel)
 [distxh,distxv]=gradient(ptCloud(:,:,1));
 [distyh,distyv]=gradient(ptCloud(:,:,2));
 [distzh,distzv]=gradient(ptCloud(:,:,3));
 % distancias horizontais e verticais entre os pontos
 distanciahorizontal=sqrt(distxh.^2+distzh.^2+distyh.^2);
 distanciavertical=sqrt(distyv.^2+distzv.^2+distxv.^2);
 ValoresGradiente=distxh+distxv+distyh+distyv+distzh+distzv;

%Separação dos pontos pela distancia pretendida horizontalmente
distanciaAjustavel=distanciaAjustavel/1000;

matrizHorizontal=zeros(size(distanciavertical));
for n=1:size(distxh,1)
   distancia=0;
   for m=1:size(distxh,2) 
    distancia=distancia+distanciahorizontal(n,m);
    if isnan(distancia)
       distancia=0; 
    end
    if distancia>distanciaAjustavel
    matrizHorizontal(n,m)=1;
    distancia=0;
    end
   end
end

% Separar os pontos pela distancia vertical
matrizvertical=zeros(size(distanciavertical));
for n=1:size(distxh,2)
   distancia=0;
   for m=1:size(distxh,1) 
    distancia=distancia+distanciavertical(m,n);
    if isnan(distancia)
       distancia=0; 
    end
    if distancia>distanciaAjustavel
    matrizvertical(m,n)=1;
    distancia=0;
    end
   end
end

% total vertical e horizontal
total=matrizvertical+matrizHorizontal;


total=(total>1); % escolhe a intersecção do vertical com o horizontal

erosao=bwmorph(object,'erode');
total=erosao.*total;
%imshow(total)

% Encontra os pontos da intersecção 
[y,x]=find(total==1);

% Nova distancia entre pontos na vertical
intervalo=(distancianova/1000)/distanciaAjustavel;
intervalo=round(intervalo);
if intervalo<1
    intervalo=1;
end
imagemMalha=zeros(size(total));
for n=1:intervalo:size(x,1)
imagemMalha(y(n),x(n))=1;
end

% Nova distancia entre pontos na horizontal
total=imagemMalha';
[y,x]=find(total==1);
imagemMalha=zeros(size(total));
for n=1:intervalo:size(x,1)
imagemMalha(y(n),x(n))=1;
end
imagemMalha=imagemMalha';

end