function CAL = Rule_judge( ship,Boat_Num )
%% Ŀ�괬��·��ֱ���жϣ�ע�⣬��ʱ�����ship״̬�Ǵӱ������ӽǿ�����
% ���巽������Ŀ�괬λ�ڱ�����fore sectionʱ��CAL=1��
% ��Ҫ˼·�ο���jinfen���򣬵����в�ͬ����ע��
%���룺����������ϢBoat����������Boat_Num���������OwnNum
%�����Situation����
for i=1:1:Boat_Num
    %������Ϣ��ȡ
    Boat_x(i)=ship(i).pos(1);                  %��i����x����
    Boat_y(i)=ship(i).pos(2);                  %��i����y����
    ship(i).course = ship(i).initialCourse+ship(i).courseAlter;
    Boat_theta(i)=-ship(i).course/180*pi;      %��i��������Ƕ�
    range = [Boat_x(i)+10, Boat_y(i)+10];
    Boat_head(i,:)=Goal_point(Boat_x(i),Boat_y(i),ship(i).course,range);
    Boat_Speed(i)=ship(i).speed;              %��i�����ٶȴ�С
    %ͨ������DCPA��TCPA��ÿһ��Ŀ�괬���ϰ�ȫ�Ա�ǩlabel
end

for k=1:1:Boat_Num
    % ��������
    OwnNum=k;
    OS_vector=[Boat_head(OwnNum,1)-Boat_x(OwnNum),Boat_head(OwnNum,2)-Boat_y(OwnNum)];
    OS_test= [OS_vector,0];
    for i=1:1:Boat_Num
        if i~=OwnNum
            %Ŀ�괬�뱾������,����Ϊ�ӱ���ָ��Ŀ�괬
            TS_vector = [Boat_x(i)-Boat_x(OwnNum),Boat_y(i)-Boat_y(OwnNum)];
            TS_test= [TS_vector,0];
            %����������Ŀ�괬�����нǣ���ʱ��
            theta0=acosd(dot(OS_vector,TS_vector)/(norm(OS_vector)*norm(TS_vector)));  %�����0��180��һ����ֵ��û������
            z_theta=cross(OS_test,TS_test); %��˵Ľ����һ����ά��������3��Ԫ�ص�������������ʱ�뻹��˳ʱ��
            if z_theta(3)>0      %��˵Ľ����������˵��oa��bc����ʱ�룬�Ժ�����˵�Ǹ��Ƕ�
                theta(OwnNum,i)=-theta0;
            elseif z_theta(3)==0  %�������0����˵��oa,bc���ߡ�theta=180
                theta(OwnNum,i)=180;
            else                             %��˵Ľ���Ǹ�����˵��oa��bc��˳ʱ�룬�Ժ�����˵�����Ƕ�
                theta(OwnNum,i)=theta0;
            end
            
            if theta(OwnNum,i)>-5 && theta(OwnNum,i)<112.5    %Ŀ�괬��(-5,112.5)��ʱ��������·(Give-way:1)��Ŀ�괬ֱ��(Stand-on:0)
                CAL(OwnNum,i)=1;       %������·��CALΪ1
            elseif theta(OwnNum,i)>355 && theta(OwnNum,i)<360 %Ŀ�괬��(355,360)��ʱ��(-5,0)��������·(Give-way:1)��Ŀ�괬ֱ��(Stand-on:0)
                CAL(OwnNum,i)=1;
            else
                CAL(OwnNum,i)=0;
            end
        else
            theta(OwnNum,i)=0;
            CAL(OwnNum,i)=2; %�����Ա�����Ϊ2
        end
    end
end
end

