function y = NaiveCurve(x,a1,b1,a2,b2)
%% 本函数用于设置阶跃函数    
assert(a1<a2);  %如果a1<a2则显示错误
    if (x<=a1)
        y=b1;
    elseif (x>=a2)
        y=b2;
    else
        y=b1+(x-a1)*(b2-b1)/(a2-a1);
    end
end
    