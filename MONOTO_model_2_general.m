function MONOTO_model_2_general(delta_x, delta_y, theta, color)
%%%%%%%%%%%%%%%
%中心点位置(delta_x,delta_y),航向角theta，color是船号，船号不同，颜色不同
%%%%%%%%%%%%%%

%% 扇状连续谱-1
%根据王树武的程序改编

%来自王树武根据MONOTO_model_1程序优化改编后的程序
% 好好学习矩阵运算的思路，以及向量运算的思路

delt_theta = -12 : 0.4 : 12; %角度的改变量
n_step=15;
l_step=0.05;
angleArr = ones(n_step-1, length(delt_theta));
% l_step1=ones(n_step-1, length(delt_theta));
for i=1:n_step-1
    angleArr(i, :) = delt_theta*i; 
end
% for i=1:length(delt_theta)
%     l_step1(:,i) = (l_step/8)*delt(i);
%     
% end

x = zeros(n_step, length(delt_theta));
y = zeros(n_step, length(delt_theta));
x(2:n_step,:) = l_step*sin(deg2rad(angleArr));
y(2:n_step,:) = l_step*cos(deg2rad(angleArr));
% x1(2:n_step,:) = l_step1.*(sin(deg2rad(angleArr)));
% y1(2:n_step,:) = l_step1.*(cos(deg2rad(angleArr)));
%% 位置生成
%其中，x，y都是n*m的矩阵，n行为总共前进的步数，m为可用的选择（本程序中为-12?到12?的转向）

for i=2:n_step-1
    x(i+1,:) = x(i,:) + x(i+1,:); %向量加法
    y(i+1,:) = y(i,:) + y(i+1,:);
%     x1(i+1,:) = x1(i,:) + x1(i+1,:); %向量加法
%     y1(i+1,:) = y1(i,:) + y1(i+1,:);
end
y=y+l_step*ones(n_step, length(delt_theta));
% y1=y1+l_step*ones(n_step, length(delt_theta));
x0=[0  0];
y0=[0  l_step];

%%%%%%%%%%%%
% x,y为最后生成的扇形
x_temp = x*cosd(theta) + y*sind(theta);
y_temp = y*cosd(theta) - x*sind(theta);
x = x_temp + delta_x;
y = y_temp + delta_y;

% x0,y0为从船舶中心点到扇形起点，即“扇子柄”
x_temp = x0*cosd(theta) + y0*sind(theta);
y_temp = y0*cosd(theta) - x0*sind(theta);
x0 = x_temp + delta_x;
y0 = y_temp + delta_y;
%%%%%%%%%%%%

plot(x0,y0,'b-');
hold on
plot(x, y, 'g-');
plot(x(n_step,:), y(n_step,:),  'r--');

% plot(x(:,1), y(:,1),'r--','linewidth',2);
% plot(x(:,61), y(:,61), 'r--','linewidth',2);
% plot(x(:,20), y(:,20), 'r--','linewidth',2);
% plot(x(:,40), y(:,40), 'r--','linewidth',2);
% plot(x(:,30), y(:,30), 'r--');
% % plot(x1, y1, 'g-');
% % hold on
% plot(x(n_step,:), y(n_step,:),  'r--','linewidth',2);
% hold on
% plot(x(10,:), y(10,:), 'r--','linewidth',2);

% plot(x1(n_step,:), y1(n_step,:), 'r--');
% hold on

ship_icon( delta_x,delta_y,0.05,0.02,theta,color )
axis equal

% print('-djpeg', '-r300', 'left');
end