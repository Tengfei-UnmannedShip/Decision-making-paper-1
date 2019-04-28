%% 本程序用于画出扇形的船舶航行位置图

clc;
clear all;

syms x y
% x0=0;
% y0=0;%起始点在(0,0)
% pos0=[x0  y0];
% x1=0;
% y1=0.02;
% pos1=[x1  y1];
% d=0.02;
% % theta=pi/36;
% line_x=[x0 
%         x1];
% line_y=[y0
%         y1];
n_step=21;


for j=1:n_step   
    theta=(j-(n_step+1)/2)*pi/180;
    x0=0;
    y0=0;%起始点在(0,0)
    x1=0;
    y1=0.05;
    d=0.05;
    line_x=[x0 
            x1];
    line_y=[y0
            y1];
for i=1:15
    [solx,soly]=solve([(x-x1)^2+(y-y1)^2==d^2,(x1-x0)*(x-x1)+(y1-y0)*(y-y1)==cos(theta)*d^2],[x, y] );
    pos2=double([solx,soly]);
    [m,n]=size(pos2);
    if m<2
        pos21=pos2(1,:);
        pos22=pos2(1,:);        
    else
        pos21=pos2(1,:);
        pos22=pos2(2,:);
    end
    x2=pos21(1);
    y2=pos21(2);
    a0=[x1-x0 y1-y0 0];
    a1=[x2-x1 y2-y1 0];
    a2=cross(a0,a1);
    if theta>=0
       if a2(3)<0
          x2=pos21(1);
          y2=pos21(2);
       else
          x2=pos22(1);
          y2=pos22(2);
       end
    else
       if a2(3)>0
          x2=pos21(1);
          y2=pos21(2);
       else
          x2=pos22(1);
          y2=pos22(2);
       end
    end
line_x=[line_x;x2];
line_y=[line_y;y2];

      x0=x1;
      y0=y1;
      x1=x2;
      y1=y2;
end
line_X(j,:)=line_x';
line_Y(j,:)=line_y';
end
line=[line_x line_y];
[p,q]=size(line_X);

for j=1:n_step  
plot(line_X(j,:),line_Y(j,:),'b-')
hold on
end
plot(line_X(:,q),line_Y(:,q),'r--')

