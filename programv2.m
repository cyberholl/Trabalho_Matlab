function varargout = programv2(varargin)
% PROGRAMV2 MATLAB code for programv2.fig
%      PROGRAMV2, by itself, creates a new PROGRAMV2 or raises the existing
%      singleton*.
%
%      H = PROGRAMV2 returns the handle to a new PROGRAMV2 or the handle to
%      the existing singleton*.
%
%      PROGRAMV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROGRAMV2.M with the given input arguments.
%
%      PROGRAMV2('Property','Value',...) creates a new PROGRAMV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before programv2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to programv2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help programv2

% Last Modified by GUIDE v2.5 22-May-2017 14:30:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @programv2_OpeningFcn, ...
                   'gui_OutputFcn',  @programv2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                         Funções iniciais                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before programv2 is made visible.
function programv2_OpeningFcn(hObject, eventdata, handles, varargin)
imaqreset; % termina possivel ligação anterior à kinect 
clear global; % apaga todas as variaveis globais
%% 
global tx;
global tz;
global ty;
tx=0;ty=0;tz=0;
global checked;
checked=0;
global connected;
connected=0;
global a;
a=serial('COM3','BaudRate',9600,'OutputBufferSize',1500);%,'InputBufferSize',1500);
set(handles.uibuttongroup1,'visible','off') % operações da imagem
set(handles.uibuttongroup3,'visible','off') % operações da malha
set(handles.uipanel11,'visible','off') % imagem da malha
set(handles.uipanel12,'visible','off') % imagem do objecto
set(handles.uipanel13,'visible','off') % imagem do gradiente
set(handles.uipanel15,'visible','off') % calibrations

set(handles.pushbutton8,'visible','off') % connect_arduino
set(handles.pushbutton6,'visible','off') % refresh da imagem
set(handles.pushbutton5,'visible','off') % refresh da malha
set(handles.pushbutton10,'visible','off') % calibrate mesh
set(handles.pushbutton9,'visible','off') % start mesh
set(handles.pushbutton7,'visible','off') % botão turn on laser
set(handles.pushbutton4,'visible','off') % refresh da mesh
%% Reset das variaveis
global laser; % variavel global do estado do laser;
laser=0; % coloca o laser como desligado
%pushbutton8_Callback(hObject, eventdata, handles);
set(handles.text43,'String','Click Refresh only when the depth video is stable');
%% Variaveis Globais do video da kinect
global depthDevice; % depth
global colorDevice; % rgb
global NoCamera; % Global No Camera
global src; % variavel com o source do depthDevice
try
%% RGB
handles.output = hObject; % faz output da handle
axes(handles.axes1); %seleciona o axes 1
colorDevice = videoinput('kinect',1); % video rgb proveniente da kinect
hImage=image(zeros(480,640,3),'Parent',handles.axes1); % cria uma imagem de zeros com a 
%dimensão de colordevice
preview(colorDevice,hImage); % envia o video para o himage ( axes1)
%% Depth
%Depth
axes(handles.axes2); % seleciona o axes 2
depthDevice = videoinput('kinect',2); % video proveniente de depth
hImage=image(zeros(480,640,3),'Parent',handles.axes2); % cria imagem preta com as 
%mesmas dimensões de depthDevice
preview(depthDevice,hImage); % envia o video para o himage ( axes2)
colormap default; % Para o que o gradiente tenha cor (afeta também a depth cam)
%% Regular altura da camera
src=depthDevice.Source; % propriedades da camera
valor=get(handles.slider1,'Value'); %lê o valor do slider 1 ( regula a altura da camera)
src.CameraElevationAngle=valor;
NoCamera=0;
catch
NoCamera=1;  
%http://www.lydogbillede.dk/wp-content/uploads/2013/08/Xbox-360-Kinect-Standalone.jpg
imageinitial=('Xbox-360-Kinect-Standalone.jpg');
axes(handles.axes1);
imshow(imageinitial,'Parent',handles.axes1);
%http://www.evangelicalsforsocialaction.org/wp-content/uploads/2014/07/plug-in-mission1.jpg
imageinitial=('plug-in-mission1.jpg');
axes(handles.axes2);
imshow(imageinitial,'Parent',handles.axes2);

end
%% Others coloca as imagens a preto
% Object detected
axes(handles.axes4);
imageinitial=zeros(480,640);
imshow(imageinitial,'Parent',handles.axes4);
% Mesh Created
axes(handles.axes3);
imshow(imageinitial,'Parent',handles.axes3);
% Gradient 
%axes(handles.axes5);
%imshow(imageinitial,'Parent',handles.axes5);
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = programv2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Para fechar o programa
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Desliga a app;
global a;
try % caso exista ligação corre
    %a=serial('COM3','BaudRate',9600,'OutputBufferSize',1500,'InputBufferSize',1500);
fprintf(a,':2;1;0;0;');
fclose(instrfind);
catch
fclose(instrfind);
end

hf=findobj('Name','programv2'); %encontra um programa de nome programv2 (programa currente)
close(hf) % e fecha-o

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Funções tratar a imagem                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Slider da erosão
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=get(handles.slider2,'Value');
set(handles.text5,'String',round(valor));
pushbutton5_Callback(hObject, eventdata, handles)
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Slider de Dilatação
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=get(handles.slider3,'Value');
set(handles.text4,'String',round(valor));
pushbutton5_Callback(hObject, eventdata, handles)
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Slider threshold
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=get(handles.slider4,'Value');
set(handles.text7,'String',(valor));
pushbutton5_Callback(hObject, eventdata, handles)
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Botão de confirmar imagem
function pushbutton2_Callback(hObject, eventdata, handles)
axes(handles.axes3);
set(handles.uipanel11,'visible','on') % imagem do objecto
set(handles.uibuttongroup3,'visible','on') % imagem do objecto
set(handles.text43,'String','Object Selected');

%% Retira a profundidade para a propriedade pretendida
% Global In
global imagem_cor; % imagem com a peça com cor branca e resto a preto;
global depthImage; % imagem 3D
global depthDevice; % dispositivo 3D
% Global out
global zdistance; % variavel com as distancias segundo z;
global ptCloud; % nuvem de pontos
global points; % pontos da nuvem de pontos
%% Cria a nuvem de pontos 
depthImage = medfilt2(depthImage);
imagemfinal=im2uint8(imagem_cor);
ptCloud = pcfromkinect(depthDevice,depthImage,imagemfinal); % cria a nuvem de pontos
color=ptCloud.Color; % Cor da nuvem de pontos
points=ptCloud.Location; % Localização dos pontos
zdistance=points(:,:,3); % Distancias Z dos pontos
%% Retira da point cloud apenas os pontos correspondentes ao objecto
pointcloudselect=single(color); % converte a cor em single
pointcloudselect=pointcloudselect>0; % procura os valores de cor maiores que 0; o que tem cor fica 1;
pointcloudselect=pointcloudselect.*points; % multiplica os pontos pelo 
ptCloud=fliplr(pointcloudselect); % faz flip da direita para a esquerda da imagem para alinhar a nuvem de pontos com a imagem com cor.
 pushbutton6_Callback(hObject, eventdata, handles); % chama o botão que cria a malha;

%% Botão de refresh à foto (escondido)
function pushbutton5_Callback(hObject, eventdata, handles)
global colorImage; % Global variable from the RGB video
global object;
global imagem_cor;
global ValoresGradiente;
axes(handles.axes4);
erode=round(get(handles.slider2,'Value'));
dilate=round(get(handles.slider3,'Value'));

threshold=get(handles.slider4,'Value');
object=getObject(colorImage,threshold); 
object=medfilt2(object);

if erode>0
object = bwmorph(object,'erode',erode);
end
if dilate>0
object = bwmorph(object,'dilate',dilate);
end
imagem_cor=repmat(object,[1 1 3]);
Imagem=double(imagem_cor).*im2double(colorImage);
imshow(Imagem,'Parent',handles.axes4);

%% Cria a nuvem de pontos e calcula o gradiente
global depthImage;
global depthDevice;
depthImage = medfilt2(depthImage);
imagemfinal=im2uint8(imagem_cor);
ptCloud = pcfromkinect(depthDevice,depthImage,imagemfinal); % cria a nuvem de pontos
points=ptCloud.Location; % Localização dos pontos
zdistance=points(:,:,3); % Distancias Z dos pontos
zdistance1=fliplr(zdistance); % como a camera inverte a imagem é preciso colocá-la corretamente
%% calcula o gradiente (multiplica por 1000 porque estava em metros)
[valoresx,valoresy]=(getGradient(zdistance1.*1000));
%% cria uma imagem que tudo o que não for objecto é nan
gradienteview=double(object);
gradienteview(~gradienteview) = NaN;
%% faz uma operação com os valores nan para eliminar o fundo
ValoresGradiente=(valoresx+valoresy)+gradienteview-gradienteview;
%% reset ao axes5 
cla(handles.axes5,'reset');  
%% projeta o gradiente no axes5
axes(handles.axes5); 
showGradient(flipud(ValoresGradiente));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Funções para a criação da malha                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Escolha entre malha 2D ou 3D
function slider16_Callback(hObject, eventdata, handles)
pushbutton6_Callback(hObject, eventdata, handles);
function slider16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Numero de pontos exteriores da malha
function slider17_Callback(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=round(get(handles.slider17,'Value'));
set(handles.text29,'String',(valor)); 
pushbutton4_Callback(hObject, eventdata, handles);
function slider17_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Densidade dos quadrados
function slider19_Callback(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=round(get(handles.slider19,'Value'));
set(handles.text31,'String',(valor)); 
pushbutton6_Callback(hObject, eventdata, handles);
function slider19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Ajuste do gradiente dos quadrados
function slider20_Callback(hObject, eventdata, handles)
% hObject    handle to slider20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=round(get(handles.slider20,'Value'));
set(handles.text33,'String',(valor)); 
pushbutton6_Callback(hObject, eventdata, handles);
function slider20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Ajuste 1 da distancia 
function slider21_Callback(hObject, eventdata, handles)
% hObject    handle to slider21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=round(get(handles.slider21,'Value'));
set(handles.text35,'String',(valor)); 
pushbutton6_Callback(hObject, eventdata, handles);
function slider21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Ajuste 2 da distancia 
function slider22_Callback(hObject, eventdata, handles)
% hObject    handle to slider22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor=round(get(handles.slider22,'Value'));
set(handles.text37,'String',(valor)); 
pushbutton6_Callback(hObject, eventdata, handles);
function slider22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% Escolha entre distancia ou quadrados
function slider23_Callback(hObject, eventdata, handles)
% hObject    handle to slider23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton6_Callback(hObject, eventdata, handles);
function slider23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Densidade dos pontos interiores 2D
function slider26_Callback(hObject, eventdata, handles)
valor=round(get(handles.slider26,'Value'));
set(handles.text41,'String',(valor)); 
pushbutton6_Callback(hObject, eventdata, handles);
function slider26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Botão escondido que a partir de pontos interiores anteriormente obtidos, 
% junta os exteriores e realiza a malha total
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GAP2=round(get(handles.slider17,'Value'))*10+1; % intervalo entre pontos para os contornos
%% Variáveis globais
global object; % objecto detectado
global D; % Imagem com os pontos interiores
global colorImage; % Imagem de cor da kinect (snapshot)
%% Mostrar a imagem colorida em grayscale
axes(handles.axes3); % eixo para mostrar a malha
imshow(rgb2gray(colorImage),'Parent',handles.axes3); hold on;  % coloca a imagem nesse eixo
%% Retira os contornos 
[y,x]=getObjectContours(object,D,GAP2); % adiciona os contornos exteriores aos interiores
dt = delaunayTriangulation(x,y); % usa as coordenadas dos pontos anteriores para traçar a malha
%% A partir da malha anterior, verifica que pontos estão dentro do objecto e fora
temp = zeros(size(object)+2);
temp(2:end-1,2:end-1) = object;
I = temp;
fc = dt.incenter;
in = interp2(I, fc(:,1), fc(:,2))>=1;
%% Coloca os pontos no eixo 3
plot(fc(in,1),fc(in,2),'b.') 
%% Repetir procedimento de retirar nuvem de pontos (mas com os centroides dos triangulos da malha)
zer=zeros(size(object));
x=fc(in,2);
y=fc(in,1);
for n=1:size(fc(in,1))
   zer(round(x(n)),round(y(n)))=1; 
end

pontos=repmat(zer,1,1,3);
global imagemCalibrar;
imagemCalibrar=im2uint8(pontos);
set(handles.uipanel15,'visible','on') % calibrations
set(handles.pushbutton8,'visible','on') % connect_arduino

%% Botão de refresh à malha total (escondido)
function pushbutton6_Callback(hObject, eventdata, handles)
% Entrada
global ValoresGradiente;
global object;
global ptCloud;
% Saida
global D;
% Verificação dos sliders 
d2ou3D=round(get(handles.slider16,'Value')); % Se é para realizar a malha a 2D ou a 3D
squaresORmm=round(get(handles.slider23,'Value')); % Se é para ser com base em quadrados ou em distancia
ajuste1=round(get(handles.slider21,'Value')); % ajuste 1
ajuste2=round(get(handles.slider22,'Value')); % ajuste 2
numberSquares=round(get(handles.slider19,'Value')); % numero de quadrados
ajuste=round(get(handles.slider20,'Value')); % ajuste de quadrados
gap=round(get(handles.slider26,'Value')); % ajusta a densidade da malha interior 2D

if d2ou3D==1
    if squaresORmm ==1
D=getMeshSquares(fliplr(ValoresGradiente),object,ajuste,numberSquares);
    else
D=getMeshMilimeter(ptCloud,object,ajuste1,ajuste2);   
    end
else
D=getMesh2D(object,gap); % obter malha 2D   
end

pushbutton4_Callback(hObject, eventdata, handles); % Botão que cria a malha com os pontos exteriores

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Funções para o arduino                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ligar e desligar o laser
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a; % variavel global do arduino
global laser; % variavel laser tem que ser global para ser declarada no arranque do programa como 0

try % caso exista ligação corre
   if laser==0 % se a variavel laser for 0;
   fprintf(a, ':1;1;0;0;');
   laser=1; % e coloca a variavel a 1
   set(handles.pushbutton7,'String','Turn off laser') % modifica o texto do botão Turn on laser
   set(handles.text43,'String','Laser on'); % mensagem de que o laser está on 
   else % caso contrário
   fprintf(a, ':2;1;0;0;');
   laser=0; % coloca a variavel laser a 0;
   set(handles.pushbutton7,'String','Turn on laser') % modifica o texto do botão Turn on laser
   set(handles.text43,'String','Laser off'); % mensagem de que o laser está off
   end
catch % cano não exista ligação
    pushbutton8_Callback(hObject, eventdata, handles) % clica no botão de disconnect
end
%% Conecção ao arduino
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a;
pushbutton10_Callback(hObject, eventdata, handles);
global connected;
global mesh;
global laser;
 if connected==1
     set(handles.pushbutton9,'visible','off') % start mesh
     set(handles.text43,'String','Arduino Disconnected');% texto da caixa de mensagens para Arduino disconnected
     set(handles.pushbutton7,'visible','off') % botão turn on laser invisivel
     set(handles.pushbutton8,'String','Connect to Arduino') % texto to botão para Connect to Arduino
     try 
     fprintf(a, ':2;1;0;0;');
     fclose(instrfind);
     catch 
       fclose(instrfind); 
     end
     connected=0;
     laser=1;
 else
try % tenta ligar-se ao arduino
     fopen(a);
     set(handles.pushbutton9,'visible','on') % start mesh
     set(handles.text43,'String','Arduino Connected');% texto da caixa de mensagens para Arduino Connected
     %set(handles.pushbutton7,'visible','on') % botão turn on laser visivel
     set(handles.pushbutton8,'String','Disconnect Arduino')% texto to botão para Disconnect Arduino  
     connected=1;
     mesh=1;
     laser=0;
      
catch % disconnect
    fclose(instrfind);
    %disp('error');
     set(handles.pushbutton9,'visible','off') % start mesh
     set(handles.text43,'String','Arduino Disconnected');% texto da caixa de mensagens para Arduino disconnected
     set(handles.pushbutton7,'visible','off') % botão turn on laser invisivel
     set(handles.pushbutton8,'String','Connect to Arduino') % texto to botão para Connect to Arduino
     
     connected=0;
     laser=1;
end
 end
    

%% Enviar as coordenadas da malha para o arduino
function pushbutton9_Callback(hObject, eventdata, handles)
    global checked; 
    if checked==1      
    else
    pushbutton10_Callback(hObject, eventdata, handles);  
    end
    
    global mesh;
    global a;
    global text;
    global laser;
    
    
    if mesh==1 
    if checked==1  
    fprintf(a,text);   
    else
    laser=0;
    pushbutton7_Callback(hObject, eventdata, handles);
    fprintf(a,text);
    mesh=0;
    set(handles.pushbutton9,'String','STOP');
    end
    else
        set(handles.pushbutton9,'String','Start Mesh');
        fprintf(a,':2,1;0;0;');
        laser=1;
    pushbutton7_Callback(hObject, eventdata, handles);
    mesh=1;
    end
    
%% Calibrar a malha
function pushbutton10_Callback(hObject, eventdata, handles)
global depthImage;
global depthDevice;
global imagemCalibrar;
ptCloud = pcfromkinect(depthDevice,depthImage,imagemCalibrar); % cria a nuvem de pontos

%% Matriz de transformação
global tx;
global tz;
global ty;
global text;
text=getTEXT(ptCloud,tx,ty,tz);
global checked;
if checked==1
    pushbutton9_Callback(hObject, eventdata, handles);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                              Kinect                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Elevação da camara
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global src; % variavel que contem as propriedades da camera
valor=get(handles.slider1,'Value'); % lê o valor do slider
set(handles.text9,'String',round(valor)); % coloca o texto
src.CameraElevationAngle=round(valor);
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%% Botão Refresh que tira print à Depthimage e à colorImage
function pushbutton1_Callback(hObject, eventdata, handles)
% Variáveis globais
global colorImage;
global depthImage;
global depthDevice;
global colorDevice;
global NoCamera;

if NoCamera==1
close all;
clear global;
close(gcbf)
programv2
else 
set(handles.uipanel15,'visible','off') % calibrations
set(handles.pushbutton8,'visible','off') % connect_arduino
depthImage=getsnapshot(depthDevice); % snapshot do depth device
colorImage = getsnapshot(colorDevice); % snapshot do color device
depthImage = getDepthFrames(depthImage,depthDevice,20); % Retira mais 20 snapshots do depth device
% o propósito das 20 é, visto a camera às vezes apanhar ruído, esse ruido,
% poder apanhar toda a informação.
set(handles.uipanel11,'visible','off') % imagem do objecto
set(handles.uipanel13,'visible','on') % imagem do objecto
set(handles.uibuttongroup3,'visible','off') % imagem do objecto
set(handles.uipanel12,'visible','on') % imagem do objecto
set(handles.uibuttongroup1,'visible','on') % imagem do objecto
pushbutton5_Callback(hObject, eventdata, handles) % botão invisivel que faz refresh ao objecto
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Funções que o programa pedia para evitar erros               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estas funções apenas são necessárias pois o matlab diz que as mesmas
% estão em falta, mesmo não havendo nenhum botão ou slider com esses nomes.
 function slider18_CreateFcn(hObject, eventdata, handles)
% 
 if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor',[.9 .9 .9]);
 end
 function slider24_CreateFcn(hObject, eventdata, handles)
 if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor',[.9 .9 .9]);
 end
 function slider25_CreateFcn(hObject, eventdata, handles)
 if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor',[.9 .9 .9]);
 end


% --- Executes on slider movement.
function slider28_Callback(hObject, eventdata, handles)
% hObject    handle to slider28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tx;
tx=round(get(handles.slider28,'Value')); % ajuste x;
set(handles.text47,'String',tx); % coloca o texto
pushbutton10_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider29_Callback(hObject, eventdata, handles)
% hObject    handle to slider29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ty;
ty=round(get(handles.slider29,'Value')); % ajuste x;
set(handles.text48,'String',ty); % coloca o texto

pushbutton10_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider30_Callback(hObject, eventdata, handles)
% hObject    handle to slider30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tz;
tz=round(get(handles.slider30,'Value')); % ajuste x;
set(handles.text49,'String',tz); % coloca o texto

pushbutton10_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global checked;
checked=round(get(handles.checkbox1,'Value')); % ajuste x;
% Hint: get(hObject,'Value') returns toggle state of checkbox1
