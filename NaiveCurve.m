function y = NaiveCurve(x,a1,b1,a2,b2)
%% �������������ý�Ծ����    
assert(a1<a2);  %���a1<a2����ʾ����
    if (x<=a1)
        y=b1;
    elseif (x>=a2)
        y=b2;
    else
        y=b1+(x-a1)*(b2-b1)/(a2-a1);
    end
end
    