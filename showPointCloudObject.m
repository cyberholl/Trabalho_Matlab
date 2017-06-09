function ptCloud=showPointCloudObject(zdistance,depthDevice)
 ptCloud = depthToPointCloud(zdistance,depthDevice);
%  showPointCloud(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
%  xlabel('X (m)');
%  ylabel('Y (m)');
%  zlabel('Z (m)');
end