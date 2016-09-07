
classnum=6;
kerneloption= 2;
kernel='gaussian';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[file_name file_path] = uigetfile ('*.*');
if file_path == 0
    return;
end
im1=double(imread([file_path,file_name]));

% face detection
im2 = FaceRegionExt(im1);
aa=FaceExpFea(im2);
img = aa(:);

%loading adaboost machine
load RLearners1;
load RLearners2;
load RLearners3;

%SVM
load xsup, load w, load b, load nbsv;

a=[];
for i=1:3
    if (i==1)
        for k = 1 : length(RLearners1)
           out=get_dim(RLearners1{k});
            a=[a out];
        end
    elseif i==2
        for k = 1 : length(RLearners2)
           out=get_dim(RLearners2{k});
            a=[a out];
        end
    elseif i==3
        for k = 1 : length(RLearners3)
           out=get_dim(RLearners3{k});
            a=[a out];
        end
    end
end
idxarray=zeros(1,size(img,1));

fea = [];
for k = 1 : length(a)
   if (idxarray(a(k))==1)
       continue;
   end
  fea=[fea img(a(k),:)'];
  idxarray(a(k))=1;
end

fea=double(fea);
fea=(fea)/256;
[ypred,maxi] = svmmultival(fea,xsup,w,b,nbsv,kernel,kerneloption);

facialexp = ClassName(ypred);

subplot(1,2,1); imshow(im1,[]);   title(file_name);
subplot(1,2,2); imshow(im2,[]); title(facialexp);
