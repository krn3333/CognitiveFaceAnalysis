%########################################################################
%
% FaceExpFea : extract features of face region in image
%
% I : face image
% feature : feature for facial expression recognition
%
%########################################################################

function [feature] = FaceExpFea(I)
c = [1   0.2  1   -2  0  0  0 10];
casenum = c(1);  % type of the parameter settings
gamma = c(2);    % gamma parameter
sigma0 = c(3);   % inner Gaussian size
sigma1 = c(4);   % outer Gaussian size
sx = c(5);       % x offset of centres of inner and outer filter
sy = c(6);       % y offset of centres of inner and outer filter
mask = c(7);     % mask
do_norm = c(8);  % Normalize the spread of output values
mask=[];
%gabor filter parameters

f = [2 4 8 16 32];
%theta = [0 pi/12 2*pi/12 3*pi/12 4*pi/12 5*pi/12 6*pi/12 7*pi/12 8*pi/12 9*pi/12 10*pi/12 11*pi/12];
theta = [0 pi/8 2*pi/8 3*pi/8 4*pi/8 5*pi/8 6*pi/8 7*pi/8];
%theta = [0 pi/3 pi/6 pi/2 pi/4 2*pi/3 3*pi/4 5*pi/6];
downsample = 1;
imsize = [64,64];
im1n = preproc2(I,gamma,sigma0,sigma1,[sx,sy],mask,do_norm);
B = imresize (im1n, imsize);
feature = [];
for j = 1:length(f)
    for k=1:length(theta)
        [G,gabout] = gaborfilter1 (B, 6, 6, f(j), theta(k),downsample);
        gabout = uint8(gabout);
        feature = [feature, gabout(:)];
    end
end

end