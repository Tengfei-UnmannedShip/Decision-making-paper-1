function pos_vir = spline3(x1,y1,alpha1,t1,x2,y2,alpha2,t2,t,v)

%v=15*1852/3600*0.8;
%v=1;

M=[x1^3 x1^2 x1 1;
    x2^3 x2^2 x2 1;
    3*x1^2 2*x1 1 0;
    3*x2^2 2*x2 1 0];
N=[y1;y2;tand(90-alpha1);tand(90-alpha2)];

%cond(M)
p=inv(M)*N;  %系数矩阵

s=v*(t-t1);

x_left = x1;
x_right = x2;
delta_x = 0.1; %控制精度

%sum = 0;
f = inline('sqrt(1+(3*a*x^2+2*b*x+c)^2)','x','a','b','c');
while abs(x_right-x_left)>delta_x
    %sum=sum+1
    xx=(x_right+x_left)/2;
    k = abs(simpr1(f,x1,xx,100,p));
    if k>s
        x_right = xx;
    else
        x_left = xx;
    end
end

x_vir = (x_right+x_left)/2;
y_vir = p(1)*x_vir^3+p(2)*x_vir^2+p(3)*x_vir+p(4);

pos_vir = [x_vir y_vir];