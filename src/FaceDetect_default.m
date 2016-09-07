%##########################################################################
%
% manual face region in JAFFE database
%
%##########################################################################
function [aa]=FaceDetect_default(I)
rect = [72,95,115,115];
aa=imcrop(I, rect);
end
