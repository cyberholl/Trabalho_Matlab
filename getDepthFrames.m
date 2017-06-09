function depthImage=getDepthFrames(depthImage,depthDevice,N)
% Define size of frame cell
frame{N}=zeros(size(getsnapshot(depthDevice)));
% capture 10 frames
for n=1:N
    frame{n}=getsnapshot(depthDevice);
    if n>1
        depthImage=depthImage+frame{n}.*mask;
    else
        depthImage=frame{n};
    end
    pause(0.01);
    mask =im2uint16(depthImage==0)/65535;
end
end