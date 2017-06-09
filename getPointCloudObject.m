function zdistance=getPointCloudObject(object,depthImage)
mask2 = im2uint16(object)/65535; 
zdistance=depthImage.*mask2;
zdistance=medfilt2(zdistance); 
end