function [v_ratio,theta,time] = Decision_making0(OS,ship_temp,CAL)
%% 用于预测TS的行为
%coordinate transformation
for j=1:length(ship_temp)
    %WTF:将目标船的坐标转换成以本船为坐标原点的坐标系中
    ship_temp(j).pos = ship_temp(j).pos-OS.pos; %平移
    %WTF:将转化后的目标船的坐标通过旋转，进一步转化为本船航向指向y轴正向的坐标系中
    ship_temp(j).pos = coord_conv(ship_temp(j).pos(1),ship_temp(j).pos(2),OS.initialCourse);%旋转
    %WTF:将目标船的航向转化为以本船航向为y轴正向的坐标系中
    ship_temp(j).initialCourse = ship_temp(j).initialCourse-OS.initialCourse;
    if ship_temp(j).initialCourse<0
        ship_temp(j).initialCourse=ship_temp(j).initialCourse+360;
    end
end

%WTF:目标船的位置和航向都转化完成后，将本船的位置置于原点，将本船的航向归为y轴正向
OS.pos=[0 0];
OS.initialCourse=0;

%% find all the ships that the own ship should give way
% ship_giveway1 = [];%WTF:本船为让路船(CAL(OS,TS)=1)，即图6-4中的{TS1}: 位于355°～67.5°(F&A)的直航船的集合，本船转向为主
% ship_giveway2 = [];%WTF:本船为让路船(CAL(OS,TS)=1)，即图6-4中的{TS2}: 位于67.5°～112.5°(B)的直航船的集合，先减速再转向
% ship_standon1 = [];%WTF:本船为直航船(CAL(OS,TS)=0)，即图6-5中的{TS1}: 与本船的交叉角度大于90°的船，转向为主
% ship_standon2 = [];%WTF:本船为直航船(CAL(OS,TS)=0)，即图6-5中的{TS2}: 与本船的交叉角度大于90°的船，先加速再转向
ship_giveway1 = [];%WTF:本船需要主要转向避让的船，包括(CAL(OS,TS)=1)，即图6-4中的{TS1}: 位于355°～67.5°(F&A)的直航船和(CAL(OS,TS)=0)，即图6-5中的{TS1}: 与本船的交叉角度大于90°的让路船
ship_giveway2 = [];%WTF:本船需要先变速速再转向避让的船
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
%% 避碰决策 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% anti-collision by changing speed
if isempty(ship_giveway2)  %WTF:根据论文图6-5，{TS2} 为空集不用执行变速决策
    ratio_temp=OS.ratio;
else
    ratio_temp=OS.ratio;
    speed_temp=OS.speed*0.05;
    if CAL(OS.no,ship_temp(i).no)==1
        %% CAL==1时的变速决策
        while ratio_temp>0.5 && CollisionRisk(OS,ship_giveway2)
            ratio_temp=ratio_temp-0.05;
            OS.speed=OS.speed-speed_temp;
        end
    else
        %% CAL==0时的变速决策
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
        %% CAL==1时的转向决策
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
        %% CAL==0时的转向决策
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