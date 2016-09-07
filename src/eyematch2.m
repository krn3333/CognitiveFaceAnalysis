% ----------- Template Matching --------------- %
% face  :           Face image
% thresh :           Threshold for eye region seperation
% template:          Right eye template
% template2:         Left eye template
%
% lefteyex, lefteyey : x, y positions of left eye
% righteyex, righteyey : x, y positions of right eye
% eyematch2(I,.8,temp_Rgh,temp_Lft);
%
%##########################################################################

function [lefteyex,lefteyey,righteyex,righteyey]=eyematch2(face,thresh,template,template2);

%
%first selection
img=face-mean(mean(face));
template=template-mean(mean(template));
template2=template2-mean(mean(template2));

C=normxcorr2(template,img);
C2=normxcorr2(template2,img);

Csub = C((size(template,1)-1)/2+1:size(img,1)-1,(size(template,2)-1)/2+1:size(img,2)-1);
%figure;
Csub2 = C2((size(template,1)-1)/2+1:size(img,1)-1,(size(template,2)-1)/2+1:size(img,2)-1);
%figure;
%imshow(Csub, []), pixval;

BW1 = Csub;
BW1(find(BW1<thresh))=0;
BW1(find(BW1>thresh))=1;
%figure, imshow(BW);
BW2 = Csub2;
BW2(find(BW2<thresh))=0;
BW2(find(BW2>thresh))=1;

BW=BW1+BW2;
%figure, imshow(BW);
[L,n] = bwlabel(BW);
stats = regionprops(L, 'centroid');
% Draw an asterisk 


% second selection
face=histeq(face);
BW = edge(face,'sobel',0.1,'horizontal');
histvector=sum(BW');
val=max(histvector);


%figure(1);imshow(face);
centroids = cat(1, stats.Centroid);

halfline=fix(size(face,2)/2);
LeftCoor=[];
RightCoor=[];
for i=1:size(centroids,1)
    if centroids(i,1) < halfline
        LeftCoor=[LeftCoor centroids(i,:)'];
    else
        RightCoor=[RightCoor centroids(i,:)'];
    end
end
disarray=[];
for i=1:size(LeftCoor,2)
    for j=1:size(RightCoor,2)
        dis=abs(LeftCoor(2,i)-RightCoor(2,j));
        if ( abs(LeftCoor(1,i)-RightCoor(1,j)) > size(face,2) * 0.3 )
            disarray=[disarray [i j  dis]'];
        end
    end
end
[B,IX]=sort (disarray(3,:),'ascend');
lefteyex=LeftCoor(1,disarray(1,IX(1)));
lefteyey=LeftCoor(2,disarray(1,IX(1)));
righteyex=RightCoor(1,disarray(2,IX(1)));
righteyey=RightCoor(2,disarray(2,IX(1)));
%hold on
%plot(centroids(:,1), centroids(:,2), 'r*');
%for i=1:size(face,2)
%    plot(i, val, 'g-');
%end
%plot(lefteyex, lefteyey, 'b*');
%plot(righteyex, righteyey, 'b*');
%hold off
