function f0 = F0( x,a,b )
% Tengfei Decision-Making1������ʹ�õĻ�׼����
%   Detailed explanation goes here
if a<=x
    f0=1-exp(-((x-a)/b)^2);
else
    f0=0;
end

end

