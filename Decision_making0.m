function [v_ratio,theta,time] = Decision_making0(OS,ship_temp,CAL)
%% ����Ԥ��TS����Ϊ
%coordinate transformation
for j=1:length(ship_temp)
    %WTF:��Ŀ�괬������ת�����Ա���Ϊ����ԭ�������ϵ��
    ship_temp(j).pos = ship_temp(j).pos-OS.pos; %ƽ��
    %WTF:��ת�����Ŀ�괬������ͨ����ת����һ��ת��Ϊ��������ָ��y�����������ϵ��
    ship_temp(j).pos = coord_conv(ship_temp(j).pos(1),ship_temp(j).pos(2),OS.initialCourse);%��ת
    %WTF:��Ŀ�괬�ĺ���ת��Ϊ�Ա�������Ϊy�����������ϵ��
    ship_temp(j).initialCourse = ship_temp(j).initialCourse-OS.initialCourse;
    if ship_temp(j).initialCourse<0
        ship_temp(j).initialCourse=ship_temp(j).initialCourse+360;
    end
end

%WTF:Ŀ�괬��λ�úͺ���ת����ɺ󣬽�������λ������ԭ�㣬�������ĺ����Ϊy������
OS.pos=[0 0];
OS.initialCourse=0;

%% find all the ships that the own ship should give way
% ship_giveway1 = [];%WTF:����Ϊ��·��(CAL(OS,TS)=1)����ͼ6-4�е�{TS1}: λ��355�㡫67.5��(F&A)��ֱ�����ļ��ϣ�����ת��Ϊ��
% ship_giveway2 = [];%WTF:����Ϊ��·��(CAL(OS,TS)=1)����ͼ6-4�е�{TS2}: λ��67.5�㡫112.5��(B)��ֱ�����ļ��ϣ��ȼ�����ת��
% ship_standon1 = [];%WTF:����Ϊֱ����(CAL(OS,TS)=0)����ͼ6-5�е�{TS1}: �뱾���Ľ���Ƕȴ���90��Ĵ���ת��Ϊ��
% ship_standon2 = [];%WTF:����Ϊֱ����(CAL(OS,TS)=0)����ͼ6-5�е�{TS2}: �뱾���Ľ���Ƕȴ���90��Ĵ����ȼ�����ת��
ship_giveway1 = [];%WTF:������Ҫ��Ҫת����õĴ�������(CAL(OS,TS)=1)����ͼ6-4�е�{TS1}: λ��355�㡫67.5��(F&A)��ֱ������(CAL(OS,TS)=0)����ͼ6-5�е�{TS1}: �뱾���Ľ���Ƕȴ���90�����·��
ship_giveway2 = [];%WTF:������Ҫ�ȱ�������ת����õĴ�
for i=1:length(ship_temp)
    if CollisionRisk(OS,ship_temp(i))
        if 360-ship_temp(i).initialCourse>90  %crossing angle is larger than 90
            ship_giveway1 = [ship_giveway1;ship_temp(i)];
        else                                  %crossing angle is smaller than 90
            ship_giveway2 = [ship_giveway2;ship_temp(i)];
        end
    end
end
ship_giveway = [ship_giveway1;ship_giveway2];
%% �������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% anti-collision by changing speed
if isempty(ship_giveway2)  %WTF:��������ͼ6-5��{TS2} Ϊ�ռ�����ִ�б��پ���
    ratio_temp=OS.ratio;
else
    ratio_temp=OS.ratio;
    speed_temp=OS.speed*0.05;
    if CAL(OS.no,ship_temp(i).no)==1
        %% CAL==1ʱ�ı��پ���
        while ratio_temp>0.5 && CollisionRisk(OS,ship_giveway2)
            ratio_temp=ratio_temp-0.05;
            OS.speed=OS.speed-speed_temp;
        end
    else
        %% CAL==0ʱ�ı��پ���
        while OS.speed<25*1852/3600 && CollisionRisk(OS,ship_giveway2)
            ratio_temp=ratio_temp+0.05;
            OS.speed=OS.speed+speed_temp;
        end
    end
end
v_ratio = ratio_temp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% anti-collision by steering
if isempty(ship_giveway1) && ~CollisionRisk(OS,ship_giveway2)
    theta = 0;
    time = 0;
else
    if CAL(OS.no,ship_temp(i).no)==1
        %% CAL==1ʱ��ת�����
        if CollisionRisk(OS,ship_giveway)
            for theta_temp = 10:30
                for time_temp = 3*60:10*60
                    OS.courseAlter=theta_temp;
                    OS.courseTime=time_temp;
                    p_temp = CollisionRisk(OS,ship_giveway);
                    if p_temp==0
                        break;
                    end
                end
                if p_temp==0
                    break;
                end
            end
            theta = theta_temp;
            time = time_temp;
        else
            theta = 0;
            time = 0;
        end
    else
        %% CAL==0ʱ��ת�����
        if CollisionRisk(OS,ship_giveway)
            for theta_temp = -10:-1:-30
                for time_temp = 3*60:10*60
                    OS.courseAlter=theta_temp;
                    OS.courseTime=time_temp;
                    p_temp = CollisionRisk(OS,ship_giveway);
                    if p_temp==0
                        break;
                    end
                end
                if p_temp==0
                    break;
                end
            end
            theta = theta_temp;
            time = time_temp;
        else
            theta = 0;
            time = 0;
        end
    end
end
end