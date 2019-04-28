%% ��״������-1
%����������ĳ���ı�

%�������������MONOTO_model_1�����Ż��ı��ĳ���
% �ú�ѧϰ���������˼·���Լ����������˼·
clc;
clear;

delt_theta = -12 : 0.4 : 12; %�Ƕȵĸı���
delt = 8./(abs(delt_theta)+1); %�Ƕȵĸı���
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
%% λ������
%���У�x��y����n*m�ľ���n��Ϊ�ܹ�ǰ���Ĳ�����mΪ���õ�ѡ�񣨱�������Ϊ-12?��12?��ת��

for i=2:n_step-1
    x(i+1,:) = x(i,:) + x(i+1,:); %�����ӷ�
    y(i+1,:) = y(i,:) + y(i+1,:);
%     x1(i+1,:) = x1(i,:) + x1(i+1,:); %�����ӷ�
%     y1(i+1,:) = y1(i,:) + y1(i+1,:);
end
y=y+l_step*ones(n_step, length(delt_theta));
% y1=y1+l_step*ones(n_step, length(delt_theta));
x0=[0  0];
y0=[0  l_step];
plot(x0,y0,'b-');
hold on
plot(x, y, '-b');
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

ship_icon( 0,0,0.05,0.02,0,1 )

print('-djpeg', '-r300', 'left');