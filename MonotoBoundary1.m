function [MonotoBoundary_Pos,x,y,x0,y0] = MonotoBoundary1( pos,theta,n_step,l_step,delt_theta_range)
%%%%%%%%%%%%%%%
% pos:�������ĵ�λ��(delta_x,delta_y)
% theta:�����
% n_step:�ӵ�ǰλ��ǰ���Ĳ�������ʼ����n_step=15;
% l_step:ÿһ���Ĳ��������ٶ��йأ���ʼ����l_step=0.05;
% delt_theta_range:����Ǹı�ķ�Χ����ʼ����delt_theta_range=12;
% ע�⣺delt_theta_range��ÿһ��ת��ĽǶȵ����ã�Ӧ��֤length(delt_theta)Ϊ����
%%%%%%%%%%%%%%

% MONOTO_model_2_general(delta_x, delta_y, theta, color)
%%%%%%%%%%%%%%%
%���ĵ�λ��(delta_x,delta_y),�����theta��color�Ǵ��ţ����Ų�ͬ����ɫ��ͬ
%%%%%%%%%%%%%%
delta_x = pos(1);
delta_y = pos(2);

%% ����MONOTO_model_2д�ɵĺ�������״������
% �������������MONOTO_model_1�����Ż��ı��ĳ���
% �ú�ѧϰ���������˼·���Լ����������˼·
%% ��״������-1
% ����������ĳ���ı�
% �������������MONOTO_model_1�����Ż��ı��ĳ���
% �ú�ѧϰ���������˼·���Լ����������˼·

delt_theta = -delt_theta_range : 0.1 : delt_theta_range; %�Ƕȵĸı���
angleArr = ones(n_step-1, length(delt_theta));
% l_step1=ones(n_step-1, length(delt_theta));
for i=1:n_step-1
    angleArr(i, :) = delt_theta*i; 
end

x = zeros(n_step, length(delt_theta));
y = zeros(n_step, length(delt_theta));
x(2:n_step,:) = l_step*sin(deg2rad(angleArr));
y(2:n_step,:) = l_step*cos(deg2rad(angleArr));

%% λ������
%���У�x��y����n*m�ľ���n��Ϊ�ܹ�ǰ���Ĳ�����mΪ���õ�ѡ�񣨱�������Ϊ-12?��12?��ת��

for i=2:n_step-1
    x(i+1,:) = x(i,:) + x(i+1,:); %�����ӷ�
    y(i+1,:) = y(i,:) + y(i+1,:);
end
y=y+l_step*ones(n_step, length(delt_theta));

x0=[0  0];
y0=[0  l_step];

%���ս��%%%%%%%%%%%
% x,yΪ������ɵ�����
x_temp = x*cosd(theta) + y*sind(theta);
y_temp = y*cosd(theta) - x*sind(theta);
x = x_temp + delta_x;
y = y_temp + delta_y;

% x0,y0Ϊ�Ӵ������ĵ㵽������㣬�������ӱ���
x_temp = x0*cosd(theta) + y0*sind(theta);
y_temp = y0*cosd(theta) - x0*sind(theta);
x0 = x_temp + delta_x;
y0 = y_temp + delta_y;
%%%%%%%%%%%%

%MonotoBoundary_Poֻ¼��߽��posֵ
MonotoBoundary_Pos.left=[(x(:,1))';(y(:,1))'];
MonotoBoundary_Pos.right=[(x(:,length(delt_theta)))';(y(:,length(delt_theta)))'];
MonotoBoundary_Pos.fore=[x(n_step,:);y(n_step,:)];
end
