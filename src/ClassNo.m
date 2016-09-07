%
% ClassNo return class no corresponding to string.
%
%##########################################################################
function [n] = ClassNo(s)
    if s == 'AN'
        n = 1;
    elseif s=='DI'
        n = 2;
    elseif s=='FE'
        n = 3;
    elseif s=='HA'
        n = 4;
    elseif s=='SA'
        n = 5;
    elseif s=='SU'
        n = 6;
    end
end