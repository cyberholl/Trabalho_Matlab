function [ValoresGradiente,Valoresy]=getGradient(zdistance)
ImagemDoGradiente=double(zdistance); %Converts zdistance to double
[ValoresGradiente,Valoresy]=gradient(ImagemDoGradiente); %Calculates the gradient of the image
    
Teste=(ValoresGradiente<(10) & ValoresGradiente>(-10)); % Gets the borders to discart them
ValoresGradiente=ValoresGradiente.*Teste; % discarts the borders
ValoresGradiente=medfilt2(ValoresGradiente); % discarts the borders

Teste=(Valoresy<(10) & Valoresy>(-10)); % Gets the borders to discart them
Valoresy=Valoresy.*Teste; % discarts the borders
Valoresy=medfilt2(Valoresy); % discarts the borders

end