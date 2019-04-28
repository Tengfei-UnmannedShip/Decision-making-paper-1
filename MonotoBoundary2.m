function [MonotoBoundary_Pos,x_temp,y] = MonotoBoundary2( pos,n_step,l_step,theta)
%%%%%%%%%%%%%%%
% pos:�������ĵ�λ��(delta_x,delta_y)
% theta:�����
% n_step:�ӵ�ǰλ��ǰ���Ĳ�������ʼ����n_step=8;
% l_step:ÿһ���Ĳ��������ٶ��йأ���ʼ����speed=0.3;l_step=speed/n_step;
% delt_theta_range:����Ǹı�ķ�Χ����ʼ����delt_theta_range=12;
% ע�⣺delt_theta_range��ÿһ��ת��ĽǶȵ����ã�Ӧ��֤length(delt_theta)Ϊ����
%%%%%%%%%%%%%%



%% ����MONOTO_model_3д�ɵĺ�������״��ɢ��
% �������������MONOTO_model_1�����Ż��ı��ĳ���
% �ú�ѧϰ���������˼·���Լ����������˼·
%%%%%%%%%%%%%%%
%���ĵ�λ��(delta_x,delta_y),�����theta��color�Ǵ��ţ����Ų�ͬ����ɫ��ͬ
%%%%%%%%%%%%%%
delta_x = pos(1);
delta_y = pos(2);

%% ��֦����ɢ��-1

%�������������MONOTO_model_1�����Ż��ı��ĳ���
% �ú�ѧϰ���������˼·���Լ����������˼·
delt_theta =[-8 -4 0 4 8]; %�Ƕȵĸı���
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
    x(i+1,:) = x(i,:) + x(i+1,:); %�����ӷ�
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
    x01(i+1,:) = x01(i,:) + x01(i+1,:); %�����ӷ�
    y01(i+1,:) = y01(i,:) + y01(i+1,:);
end
x01(2:n_step,:)=x01(2:n_step,:)+x(n_step, k)*ones(n_step-1, length(delt_theta));
y01(2:n_step,:)=y01(2:n_step,:)+y(n_step, k)*ones(n_step-1, length(delt_theta));

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
    x02(i+1,:) = x02(i,:) + x02(i+1,:); %�����ӷ�
    y02(i+1,:) = y02(i,:) + y02(i+1,:);
end
x02(2:n_step,:)=x02(2:n_step,:)+x1(j, k)*ones(n_step-1, length(delt_theta));
y02(2:n_step,:)=y02(2:n_step,:)+y1(j, k)*ones(n_step-1, length(delt_theta));

x2=[x2;x02(n_step,:)];
y2=[y2:y02(n_step,:)];
end
end


% print('-djpeg', '-r300', 'right');

%MonotoBoundary_Poֻ¼��߽��posֵ
MonotoBoundary_Pos.left=[x(:,1),y(:,1)];
MonotoBoundary_Pos.right=[x(:,length(delt_theta)),y(:,length(delt_theta))];
MonotoBoundary_Pos.fore=[x(n_step,:), y(n_step,:)];
end
