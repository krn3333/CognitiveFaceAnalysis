%##########################################################################
%
% EyeDetecct : detect both eye position in face image
%
% im : face image
% lx, ly : x, y positions of left eye
% rx, ry : x, y positions of right eye
%##########################################################################
function [lx,ly,rx,ry]=EyeDetecct(im)

im1=imresize(im,[54 38],'bilinear');
templateR=double(rgb2gray(imread('reye.bmp')));
templateL=double(rgb2gray(imread('leye.bmp')));
templateR = imresize(templateR,[14 14], 'bilinear');
templateL = imresize(templateL,[14 14], 'bilinear');
threshold=0.4;

% eye detection using template matching
[lx1,ly1,rx1,ry1]=eyematch2(im1,threshold,templateR,templateL);
m=(ly1+ry1)/2;
ly1=m;
ry1=m;
lx=round(lx1/38*size(im,2));
ly=round(ly1/54*size(im,1));
rx=round(rx1/38*size(im,2));
ry=round(ry1/54*size(im,1));

end