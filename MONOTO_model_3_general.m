function MONOTO_model_3_general(delta_x, delta_y, theta, color)
%%%%%%%%%%%%%%%
%中心点位置(delta_x,delta_y),航向角theta，color是船号，船号不同，颜色不同
%%%%%%%%%%%%%%

%% 树枝形离散谱-1

%来自王树武根据MONOTO_model_1程序优化改编后的程序
% 好好学习矩阵运算的思路，以及向量运算的思路
delt_theta =[-8 -4 0 4 8]; %角度的改变量
n_step=8;
speed=0.3;
l_step=speed/n_step;
angleArr = ones(n_step-1, length(delt_theta));

for i=1:n_step-1
    angleArr(i, :) = delt_theta*i;
end

x = zeros(n_step, length(delt_theta));
y = zeros(n_step, length(delt_theta));
x(2:n_step,:) = l_step*sin(deg2rad(angleArr));
y(2:n_step,:) = l_step*cos(deg2rad(angleArr));

%%%%%%%%%%%%%
angleArr0 = angleArr + theta;
%%%%%%%%%%%%

for i=2:n_step-1
    x(i+1,:) = x(i,:) + x(i+1,:); %向量加法
    y(i+1,:) = y(i,:) + y(i+1,:);
end
y=y+l_step*ones(n_step, length(delt_theta));
x0=[0  0];
y0=[0  l_step];

%%%%%%%%%%%%
x_temp = x*cosd(theta) + y*sind(theta);
y_temp = y*cosd(theta) - x*sind(theta);
x = x_temp + delta_x;
y = y_temp + delta_y;

x_temp = x0*cosd(theta) + y0*sind(theta);
y_temp = y0*cosd(theta) - x0*sind(theta);
x0 = x_temp + delta_x;
y0 = y_temp + delta_y;
%%%%%%%%%%%%

plot(x0,y0,'b-');
hold on
plot(x, y, 'b-');
hold on
scatter(x(n_step,1:2),y(n_step,1:2),'ro');
hold on
scatter(x(n_step,3),y(n_step,3),'ko');
hold on
scatter(x(n_step,4:5),y(n_step,4:5),'go');
hold on
x1=[];
y1=[];
angleArr1=[];
for k=1:length(delt_theta)
angleArr01=angleArr0(n_step-1, k)*ones(n_step-1, length(delt_theta))+angleArr;
x01 = x(n_step, k)*ones(n_step, length(delt_theta));
y01 = y(n_step, k)*ones(n_step, length(delt_theta));
x01(2:n_step,:) = l_step*sin(deg2rad(angleArr01));
y01(2:n_step,:) = l_step*cos(deg2rad(angleArr01));
for i=2:n_step-1
    x01(i+1,:) = x01(i,:) + x01(i+1,:); %向量加法
    y01(i+1,:) = y01(i,:) + y01(i+1,:);
end
x01(2:n_step,:)=x01(2:n_step,:)+x(n_step, k)*ones(n_step-1, length(delt_theta));
y01(2:n_step,:)=y01(2:n_step,:)+y(n_step, k)*ones(n_step-1, length(delt_theta));
% x01=x01+l_step*sin(deg2rad(angleArr01(n_step-1, k)))*ones(n_step, length(delt_theta));
% y01=y01+l_step*cos(deg2rad(angleArr01(n_step-1, k)))*ones(n_step, length(delt_theta));
% x010=[x(n_step, k)  l_step*sin(deg2rad(angleArr(n_step-1, k)))];
% y010=[y(n_step, k)  l_step*cos(deg2rad(angleArr(n_step-1, k)))];
% plot(x010,y010,'b-');
% hold on

plot(x01, y01, 'b-');
hold on
scatter(x01(n_step,1:2),y01(n_step,1:2),'ro');
hold on
scatter(x01(n_step,3),y01(n_step,3),'ko');
hold on
scatter(x01(n_step,4:5),y01(n_step,4:5),'go');
hold on
x1=[x1;x01(n_step,:)];
y1=[y1;y01(n_step,:)];
angleArr1=[angleArr1;angleArr01(n_step-1,:)];
end
x2=[];
y2=[];
for j=1:length(delt_theta)
for k=1:length(delt_theta)
angleArr2=angleArr1(j, k)*ones(n_step-1, length(delt_theta))+angleArr;
x02 = x1(j, k)*ones(n_step, length(delt_theta));
y02 = y1(j, k)*ones(n_step, length(delt_theta));
x02(2:n_step,:) = l_step*sin(deg2rad(angleArr2));
y02(2:n_step,:) = l_step*cos(deg2rad(angleArr2));
for i=2:n_step-1
    x02(i+1,:) = x02(i,:) + x02(i+1,:); %向量加法
    y02(i+1,:) = y02(i,:) + y02(i+1,:);
end
x02(2:n_step,:)=x02(2:n_step,:)+x1(j, k)*ones(n_step-1, length(delt_theta));
y02(2:n_step,:)=y02(2:n_step,:)+y1(j, k)*ones(n_step-1, length(delt_theta));
plot(x02, y02, 'b-');
hold on
scatter(x02(n_step,1:2),y02(n_step,1:2),'ro'); %绘制散点图
hold on
scatter(x02(n_step,3),y02(n_step,3),'ko');
hold on
scatter(x02(n_step,4:5),y02(n_step,4:5),'go');
hold on
x2=[x2;x02(n_step,:)];
y2=[y2:y02(n_step,:)];
end
end
ship_icon( delta_x,delta_y,0.05,0.02,theta,color )
axis equal

% print('-djpeg', '-r300', 'right');

end


