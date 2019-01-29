function s=simpr1(f,a,b,M,c)

h=(b-a)/(2*M);
s1=0;
s2=0;

for k=1:M
    x=a+h*(2*k-1);
    s1=s1+feval(f,x,c(1),c(2),c(3));
end

for k=1:(M-1)
    x=a+h*2*k;
    s2=s2+feval(f,x,c(1),c(2),c(3));
end

s=h*(feval(f,a,c(1),c(2),c(3))+feval(f,b,c(1),c(2),c(3))+4*s1+2*s2)/3;