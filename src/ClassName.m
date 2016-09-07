%
% ClassName return string represented expression corresponding to class no.
%
%##########################################################################
function [s]=ClassName(n)
    if n == 1
        s = 'Angry';
    elseif n==2
        s = 'Disgust'
    elseif n==3
        s= 'Fear';
    elseif n==4
       s = 'Happy';
    elseif n==5
        s = 'Sad';
    elseif n==6
        s = 'Surprise';
    end
end