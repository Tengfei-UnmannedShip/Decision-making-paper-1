function m=evidence(m1,m2,p)

sum=0;
k=0;

k=k+m1(1)*m2(2);
k=k+m1(2)*m2(1);

if p==1
    sum=sum+m1(1)*+m2(1);
    sum=sum+m1(1)*+m2(3);
    sum=sum+m1(3)*+m2(1);

elseif p==2
    sum=sum+m1(2)*+m2(2);
    sum=sum+m1(2)*+m2(3);
    sum=sum+m1(3)*+m2(2);
    
elseif p==3
    sum=sum+m1(3)*m2(3);
end

m=sum/(1-k);
end
