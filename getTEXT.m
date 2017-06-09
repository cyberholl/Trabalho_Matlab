% ptCloud-> nuvem de pontos das coordenadas dos centroides
% text-> texto para enviar para o arduino
function text=getTEXT(ptCloud,tx,ty,tz)
color=ptCloud.Color; % Cor da nuvem de pontos
points=ptCloud.Location; % Localização dos pontos
%% Coordenadas dos pontos obtidos
cor=single(color);
cor=cor>0;
local=cor.*points;
local=flipud(local); % a points cloud inverte sempre os resultados

x=local(:,:,1); y=local(:,:,2); z=local(:,:,3);
z(z==0)=NaN; % colocação dos valores 0 de distancia como nan
points3D=[x(:)';y(:)';z(:)']'; % vetor concatenado
points3D=points3D(~any(isnan(points3D),2),:); % caso existam valores nan na matriz, estes são removidos
x=points3D(:,1)-tx/100;
y=points3D(:,2)-ty/100;
z=points3D(:,3)-tz/100;

azimuth=(90-abs((atand(z./x)))).*(z./x)./(abs(z./x)); %angulox
elevation=(90-abs((atand(z./y)))).*(z./y)./(abs(z./y)); % anguloy

text = strcat(':1;',num2str(size(x,1)),';');
for n=1:size(azimuth,1)
    variavel1=-azimuth(n);
    variavel2=-elevation(n);
    
    text=strcat(text,num2str(variavel1),';',num2str(variavel2),';');
end

end