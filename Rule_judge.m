function CAL = Rule_judge( ship,Boat_Num )
%% 目标船让路与直航判断，注意，此时输入的ship状态是从本船的视角看到的
% 具体方法，当目标船位于本船的fore section时，CAL=1，
% 主要思路参考了jinfen程序，但是有不同，需注意
%输入：船舶基本信息Boat，船舶数量Boat_Num，本船编号OwnNum
%输出：Situation向量
for i=1:1:Boat_Num
    %基本信息提取
    Boat_x(i)=ship(i).pos(1);                  %第i个船x坐标
    Boat_y(i)=ship(i).pos(2);                  %第i个船y坐标
    ship(i).course = ship(i).initialCourse+ship(i).courseAlter;
    Boat_theta(i)=-ship(i).course/180*pi;      %第i个船艏向角度
    range = [Boat_x(i)+10, Boat_y(i)+10];
    Boat_head(i,:)=Goal_point(Boat_x(i),Boat_y(i),ship(i).course,range);
    Boat_Speed(i)=ship(i).speed;              %第i个船速度大小
    %通过计算DCPA和TCPA给每一艘目标船加上安全性标签label
end

for k=1:1:Boat_Num
    % 本船向量
    OwnNum=k;
    OS_vector=[Boat_head(OwnNum,1)-Boat_x(OwnNum),Boat_head(OwnNum,2)-Boat_y(OwnNum)];
    OS_test= [OS_vector,0];
    for i=1:1:Boat_Num
        if i~=OwnNum
            %目标船与本船向量,方向为从本船指向目标船
            TS_vector = [Boat_x(i)-Boat_x(OwnNum),Boat_y(i)-Boat_y(OwnNum)];
            TS_test= [TS_vector,0];
            %本船向量与目标船向量夹角，逆时针
            theta0=acosd(dot(OS_vector,TS_vector)/(norm(OS_vector)*norm(TS_vector)));  %结果是0～180的一个数值，没有正负
            z_theta=cross(OS_test,TS_test); %叉乘的结果是一个三维向量，第3个元素的正负代表了逆时针还是顺时针
            if z_theta(3)>0      %叉乘的结果是正数，说明oa到bc是逆时针，对航海来说是负角度
                theta(OwnNum,i)=-theta0;
            elseif z_theta(3)==0  %结果若是0，则说明oa,bc共线。theta=180
                theta(OwnNum,i)=180;
            else                             %叉乘的结果是负数，说明oa到bc是顺时针，对航海来说是正角度
                theta(OwnNum,i)=theta0;
            end
            
            if theta(OwnNum,i)>-5 && theta(OwnNum,i)<112.5    %目标船在(-5,112.5)度时，本船让路(Give-way:1)，目标船直航(Stand-on:0)
                CAL(OwnNum,i)=1;       %本船让路，CAL为1
            elseif theta(OwnNum,i)>355 && theta(OwnNum,i)<360 %目标船在(355,360)度时即(-5,0)，本船让路(Give-way:1)，目标船直航(Stand-on:0)
                CAL(OwnNum,i)=1;
            else
                CAL(OwnNum,i)=0;
            end
        else
            theta(OwnNum,i)=0;
            CAL(OwnNum,i)=2; %本船对本船记为2
        end
    end
end
end

