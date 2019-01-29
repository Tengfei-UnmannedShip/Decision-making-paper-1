function [v_ratio theta time] = Evolution_right2(ship,ship_temp)
%% 专门针对compliance==2的情况
v_ratio=ship.ratio;
%% WTF:船舶坐标转换处理
%coordinate transformation
for j=1:length(ship_temp)
    
    %WTF:将目标船的坐标转换成以本船为坐标原点的坐标系中
    ship_temp(j).pos = ship_temp(j).pos-ship.pos; %平移 
    
    %WTF:将转化后的目标船的坐标通过旋转，进一步转化为本船航向指向y轴正向的坐标系中
    ship_temp(j).pos = coord_conv(ship_temp(j).pos(1),ship_temp(j).pos(2),ship.initialCourse);%旋转
    
    %WTF:将目标船的航向转化为以本船航向为y轴正向的坐标系中
    ship_temp(j).initialCourse = ship_temp(j).initialCourse-ship.initialCourse;
    if ship_temp(j).initialCourse<0
        ship_temp(j).initialCourse=ship_temp(j).initialCourse+360;
    end
end

%WTF:目标船的位置和航向都转化完成后，将本船的位置置于原点，将本船的航向归为y轴正向
ship.pos=[0 0];
ship.initialCourse=0;
%%
%% find all the ships that the own ship should give way
d_thre = 1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ship_giveway1 = [];
ship_giveway2 = [];
ship_standon = [];
for i=1:length(ship_temp)
    if CollisionRisk(ship,ship_temp(i))
        if ship_temp(i).pos(1)>0    %WTF:x>0即在第一或第四象限，即在本船的左侧
            if 360-ship_temp(i).initialCourse>90  %crossing angle is larger than 90
                ship_giveway1 = [ship_giveway1;ship_temp(i)];
            else%crossing angle is smaller than 90
                ship_giveway2 = [ship_giveway2;ship_temp(i)];
            end
        else
            ship_standon = [ship_standon;ship_temp(i)];            
        end
    end
end
ship_giveway = [ship_giveway1;ship_giveway2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% anti-collision by changing speed
if isempty(ship_giveway2)  %WTF:根据论文图6-5，{TS2} 为空集不用执行变速决策
    ratio_temp=ship.ratio;
else
    ratio_temp=ship.ratio;
    speed_temp=ship.speed*0.05;
    while ratio_temp>0.5 && CollisionRisk(ship,ship_giveway2)
        ratio_temp=ratio_temp-0.05;
        ship.speed=ship.speed-speed_temp;
    end
end
v_ratio = ratio_temp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% anti-collision by steering
if isempty(ship_giveway1) && ~CollisionRisk(ship,ship_giveway2)
    theta = 0;
    time = 0;
else
    if CollisionRisk(ship,ship_giveway)
      for theta_temp = 20:30
          for time_temp = 3*60:10*60
              ship.courseAlter=-theta_temp;
              ship.courseTime=time_temp;
              p_temp = CollisionRisk(ship,ship_giveway);
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