function [MonotoBoundary_Pos,x,y,x0,y0] = MonotoBoundary1( pos,theta,n_step,l_step,delt_theta_range)
%%%%%%%%%%%%%%%
% pos:船舶中心点位置(delta_x,delta_y)
% theta:航向角
% n_step:从当前位置前进的步数，初始设置n_step=15;
% l_step:每一步的步长，与速度有关，初始设置l_step=0.05;
% delt_theta_range:航向角改变的范围，初始设置delt_theta_range=12;
% 注意：delt_theta_range和每一步转变的角度的设置，应保证length(delt_theta)为整数
%%%%%%%%%%%%%%

% MONOTO_model_2_general(delta_x, delta_y, theta, color)
%%%%%%%%%%%%%%%
%中心点位置(delta_x,delta_y),航向角theta，color是船号，船号不同，颜色不同
%%%%%%%%%%%%%%
delta_x = pos(1);
delta_y = pos(2);

%% 根据MONOTO_model_2写成的函数，扇状连续谱
% 来自王树武根据MONOTO_model_1程序优化改编后的程序
% 好好学习矩阵运算的思路，以及向量运算的思路
%% 扇状连续谱-1
% 根据王树武的程序改编
% 来自王树武根据MONOTO_model_1程序优化改编后的程序
% 好好学习矩阵运算的思路，以及向量运算的思路

delt_theta = -delt_theta_range : 0.1 : delt_theta_range; %角度的改变量
angleArr = ones(n_step-1, length(delt_theta));
% l_step1=ones(n_step-1, length(delt_theta));
for i=1:n_step-1
    angleArr(i, :) = delt_theta*i; 
end

x = zeros(n_step, length(delt_theta));
y = zeros(n_step, length(delt_theta));
x(2:n_step,:) = l_step*sin(deg2rad(angleArr));
y(2:n_step,:) = l_step*cos(deg2rad(angleArr));

%% 位置生成
%其中，x，y都是n*m的矩阵，n行为总共前进的步数，m为可用的选择（本程序中为-12?到12?的转向）

for i=2:n_step-1
    x(i+1,:) = x(i,:) + x(i+1,:); %向量加法
    y(i+1,:) = y(i,:) + y(i+1,:);
end
y=y+l_step*ones(n_step, length(delt_theta));

x0=[0  0];
y0=[0  l_step];

%最终结果%%%%%%%%%%%
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

%MonotoBoundary_Po只录入边界的pos值
MonotoBoundary_Pos.left=[(x(:,1))';(y(:,1))'];
MonotoBoundary_Pos.right=[(x(:,length(delt_theta)))';(y(:,length(delt_theta)))'];
MonotoBoundary_Pos.fore=[x(n_step,:);y(n_step,:)];
end
