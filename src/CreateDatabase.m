clear; clc; close all;

%*****************************************************
% select training folder
[file_name file_path] = uigetfile ('*.*','Select for training');
if file_path == 0
    return;
end
szTrainPath = file_path;
szLableFilename = strcat(szTrainPath,'list');

fid=fopen(szLableFilename);
imageLabel=textscan(fid,'%s %s %s %s %s');
fclose(fid);

mask = [];

numImage = length(imageLabel{1});  % Total Observations: Number of Images in training set
TrainImages='';
for i = 1:numImage
	TrainImages{i,1} = strcat(szTrainPath, imageLabel{5}(i));
end

traindb = [];
for i = 1:numImage
    s=imageLabel{5}(i);
    tt=cell2mat(s);
    ss = tt(4:5);
    yapp(i) = ClassNo(ss);
end
for i = 1:numImage
    t=TrainImages{i,1};
    s= cell2mat(t);
    im1=double(imread(s));
    im2 = FaceRegionExt(im1);
    if (length(im2) < 2)
        kkk=0;
    end
    aa=FaceExpFea (im2);
    traindb(:,i) = aa(:);
    disp(sprintf('Loading Train Image # %d',i));
end
for i = 1:numImage
    s=imageLabel{5}(i);
    tt=cell2mat(s);
    ss = tt(4:5);
    traindblabel(i) = ClassNo(ss);
end

save traindb traindb;
save traindblabel traindblabel;
%##########################################################################
% select testing folder
[file_name file_path] = uigetfile ('*.*','Select for testing');
if file_path == 0
    return;
end
szTestPath = file_path;
szLableFilename = strcat(szTestPath,'list');

fid=fopen(szLableFilename);
imageLabel=textscan(fid,'%s %s %s %s %s');
fclose(fid);

mask = [];

numImage = length(imageLabel{1});  % Total Observations: Number of Images in training set
TestImages='';
for i = 1:numImage
	TestImages{i,1} = strcat(szTestPath, imageLabel{5}(i));
end

testdb=[];
for i = 1:numImage
    s=imageLabel{5}(i);
    tt=cell2mat(s);
    ss = tt(4:5);
    yapp(i) = ClassNo(ss);
end
for i = 1:numImage
    t=TestImages{i,1};
    s= cell2mat(t);
    im1=double(imread(s));
    im2 = FaceRegionExt(im1);
    if (length(im2) < 2)
        kkk=0;
    end
    aa=FaceExpFea (im2);
    testdb(:,i) = aa(:);
    disp(sprintf('Loading Test Image # %d',i));
end
for i = 1:numImage
    s=imageLabel{5}(i);
    tt=cell2mat(s);
    ss = tt(4:5);
    testdblabel(i) = ClassNo(ss);
end

save testdb testdb;
save testdblabel testdblabel;