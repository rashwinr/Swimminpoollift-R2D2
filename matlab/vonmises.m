function [vm] = vonmises(s1,s2)
%VONMISES Summary of this function goes here
%   Detailed explanation goes here
vm = sqrt(s1*s1-s1*s2+s2*s2);
end

