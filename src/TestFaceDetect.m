[file_name file_path] = uigetfile ('\TrainTotal\*.*');
if file_path ~= 0
    im=imread([file_path,file_name]);
    J=FaceRegionExt(im);
    J=uint8(J);
    figure, imshow(J);
end