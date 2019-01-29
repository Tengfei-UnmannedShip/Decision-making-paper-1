function f0 = F0( x,a,b )
% Tengfei Decision-Making1论文中使用的基准函数
%   Detailed explanation goes here
if a<=x
    f0=1-exp(-((x-a)/b)^2);
else
    f0=0;
end

end

