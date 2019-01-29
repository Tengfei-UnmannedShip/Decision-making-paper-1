%%JIfen原程序，对比测试
clear all;
clc;
%% WTF:参数初始化
t=850;

ship(1).speed = 18*1852/3600;%WTF：航速为18海里/小时。1海里=1.852公里，因此1海里/小时=1.852公里／小时=1852/3600米/秒
ship(1).ratio=1;             %不知道什么意思
ship(1).initialCourse = 0;
ship(1).courseAlter = 0;
ship(1).courseTime = 0; %the time that the ship keeps on the new course
ship(1).range=(4+0.1*rand())*1852;  %detect range
ship(1).no=1;  %receive information from other ships
% ship(1).pos = [0-ship(1).speed*sind(ship(1).initialCourse)*t 0-ship(1).speed*cosd(ship(1).initialCourse)*t];%WTF：船舶当前的位置？？倒推法？？
ship(1).pos =[0,-7871];

ship(2).speed = 16*1852/3600;
ship(2).ratio=1;
ship(2).initialCourse = 230;
ship(2).courseAlter = 0;
ship(2).courseTime = 0;
ship(2).range=(4+0.1*rand())*1852;  %detect range
ship(2).no=2;  %receive information from other ships
% ship(2).pos = [0-ship(2).speed*sind(ship(2).initialCourse)*t -1200-ship(2).speed*cosd(ship(2).initialCourse)*t];
ship(2).pos =[5359.58738825731,3297.22780074911];

ship(3).speed = 16*1852/3600;
ship(3).ratio=1;
ship(3).initialCourse = 300;
ship(3).courseAlter = 0;
ship(3).courseTime = 0;
ship(3).range=(4+0.1*rand())*1852;  %detect range
ship(3).no=3;  %receive information from other ships
% ship(3).pos = [-ship(3).speed*sind(ship(3).initialCourse)*t 1000-ship(3).speed*cosd(ship(3).initialCourse)*t];
ship(3).pos =[6059.09862505539,-2498.22222222222];

ship(4).speed = 12*1852/3600;
ship(4).ratio=1;
ship(4).initialCourse = 150;
ship(4).courseAlter = 0;
ship(4).courseTime = 0;
ship(4).range=(4+0.1*rand())*1852;  %detect range
ship(4).no=4;  %receive information from other ships
% ship(4).pos = [0-ship(4).speed*sind(ship(4).initialCourse)*t 2000-ship(4).speed*cosd(ship(4).initialCourse)*t];
ship(4).pos =[-2623.66666666667,6544.32396879154];

pos1=ship(1).pos%WTF：船舶位置矩阵第一行，但是t的值尚未确定，%%猜测船舶原定最初位置
pos2=ship(2).pos
pos3=ship(3).pos
pos4=ship(4).pos

c1=ship(1).initialCourse%WTF：船舶初始航向
c2=ship(2).initialCourse
c3=ship(3).initialCourse
c4=ship(4).initialCourse
 
for i=1:4
    ship(i).data=[];%WTF：ship.data置为空
end
s=0;
%% WTF:开始执行分布式决策
for i=2:1500
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Update%WTF：船舶信息更新
    for j=1:4
        ship(j).pos = [ship(j).pos(1)+ship(j).ratio*ship(j).speed*sind(ship(j).initialCourse+ship(j).courseAlter) ...
                       ship(j).pos(2)+ship(j).ratio*ship(j).speed*cosd(ship(j).initialCourse+ship(j).courseAlter)];
        %WTF：当前的船舶位置为（原位置x+1*当前速度v*sin（原航向角alpha+当前的偏转角beta），原位置y+1*当前速度v*cos（原航向角alpha+当前的偏转角beta））
        %WTF：ship(j).ratio猜测是一个类似时间步长的参数
        if ship(j).courseTime>0    %此处为船舶在航线上航行的时间，若大于0表示在当前航线上，减1，即本步循环用了1秒。
            ship(j).courseTime = ship(j).courseTime-1;%每个循环只要在待检测航线上，时间就减1，直到为0。
        end
        if ship(j).courseTime == 0  %此处为船舶在航线上航行的时间，若等于0表示不在当前航线上，则航向不改变，即改变的航向角courseAlter为0。
            ship(j).courseAlter = 0;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pos1=[pos1;ship(1).pos];%WTF：扩充船舶位置矩阵，每一一个循环为一秒，每一秒就在位置矩阵下加一行，最后就是1500行。
    pos2=[pos2;ship(2).pos];
    pos3=[pos3;ship(3).pos];
    pos4=[pos4;ship(4).pos];
    
    c1=[c1;ship(1).initialCourse+ship(1).courseAlter];%WTF：扩充船舶航向矩阵，每个循环更新船舶当前航向（原航向角alpha+当前的偏转角beta），最后就是1500行。
    c2=[c2;ship(2).initialCourse+ship(2).courseAlter];
    c3=[c3;ship(3).initialCourse+ship(3).courseAlter];
    c4=[c4;ship(4).initialCourse+ship(4).courseAlter];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %the give-way ships take actions
    for j=1:4  %从第一艘船到第四艘船的遍历
      %  if j~=1 %第一艘船不参与避碰，保持原速
            neighbor_temp1=SearchNeighbor(ship(j),ship,ship(j).range);%第j艘船的邻船，即进入检测范围的所有船
            if ~isempty(neighbor_temp1)%如果临船结构体数组不为空
                t=length(neighbor_temp1);%t=临船的数量
                for k=t:-1:1%for的条件句，eg:7:-1:1是每次-1从7到1，
                  
                   %WTF：将目标船与本船的位置向量旋转到航向角为0的情况，即坐标系转移到本船为中心本船航向为y正向(0度)
                   pos_temp= neighbor_temp1(k).pos;
                   pos_temp= pos_temp-ship(j).pos;
                   [pos_temp(1) pos_temp(2)] = coord_conv(pos_temp(1),pos_temp(2),ship(j).initialCourse);
                   %WTF：判断如果所有目标船的x坐标小于0，且本船不是不参与避碰的一船，则需要让路的临船集合为空，本船直航
                   if pos_temp(1)<0 %&& neighbor_temp1(k).no ~= 1 %WTF：x<0即目标船在左侧，则为直航船
                       neighbor_temp1(k)=[];%WTF：本船没有位于左侧的目标船本船为直航船，需要让路的目标船集合为空
                   end
                end
            end
            neighbor_temp2=SearchNeighbor(ship(j),ship,5.5*1852);%WTF:第j艘船的所有风险邻船，即进入5.5海里的所有船
            if ship(j).courseAlter==0 && ~isempty(neighbor_temp1)%WTF:本船没有转向决策且不是上一步已经判断出来的没有需要让路的船的直航船
                if CollisionRisk(ship(j),neighbor_temp1) %WTF:本船与临船有碰撞风险时
                    [ship(j).ratio ship(j).courseAlter ship(j).courseTime] = Evolution_right2(ship(j),neighbor_temp2);
                    if ship(j).courseAlter>0 || ship(j).ratio<1
                        ship(j).data=[ship(j).data;i ship(j).ratio ship(j).courseAlter ship(j).courseTime];%WTF:扩展ship(j).data矩阵，每次更新一行
                    end
                end
            end
      %  end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos1=pos1/1852;
pos2=pos2/1852;
pos3=pos3/1852;
pos4=pos4/1852;
%show ships' positions at every moment
%% 点云图程序采集数据，采集9组数据，数据格式为ti时刻的[x1 y1 x2 y2 x3 y3 x4 y4](i=1~9)
position_data=[pos1(1,:) pos2(1,:)  pos3(1,:) pos4(1,:)
               pos1(188,:) pos2(188,:)  pos3(188,:) pos4(188,:)
               pos1(376,:) pos2(376,:)  pos3(376,:) pos4(376,:)
               pos1(564,:) pos2(564,:)  pos3(564,:) pos4(564,:)
               pos1(752,:) pos2(752,:)  pos3(752,:) pos4(752,:)
               pos1(940,:) pos2(940,:)  pos3(940,:) pos4(940,:)
               pos1(1128,:) pos2(1128,:)  pos3(1128,:) pos4(1128,:)
               pos1(1316,:)   pos2(1316,:)    pos3(1316,:)   pos4(1316,:)
               pos1(1500,:)   pos2(1500,:)    pos3(1500,:)   pos4(1500,:)]

course_data=[c1(1,1) c2(1,1)  c3(1,1)  c4(1,1)]
%% WTF:绘图程序，非常好，可以直接用
figure;
subplot(2,2,1);
hold on;
%WTF:画出船舶的初始位置
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:画出船舶的结束位置
drawShip(pos1(400,:),c1(400),1);
drawShip(pos2(400,:),c2(400),2);
drawShip(pos3(400,:),c3(400),3);
drawShip(pos4(400,:),c4(400),4);

%WTF:画出过往的航迹图
p11=plot(pos1(1:400,1),pos1(1:400,2),'r-');
p22=plot(pos2(1:400,1),pos2(1:400,2),'g-');
p33=plot(pos3(1:400,1),pos3(1:400,2),'b-');
p44=plot(pos4(1:400,1),pos4(1:400,2),'k-');

%WTF:画出船头的圆用于表示安全范围
circle(pos1(400,:),900/1852,1);
circle(pos2(400,:),900/1852,2);
circle(pos3(400,:),900/1852,3);
circle(pos4(400,:),900/1852,4);

axis([-4,4,-4.5,3.5]);
xlabel('n miles');
ylabel('n miles');
title('T=400s');
box on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
subplot(2,2,2);
hold on;
%WTF:画出船舶的初始位置
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:画出船舶的结束位置
drawShip(pos1(800,:),c1(800),1);
drawShip(pos2(800,:),c2(800),2);
drawShip(pos3(800,:),c3(800),3);
drawShip(pos4(800,:),c4(800),4);

%WTF:画出过往的航迹图
p11=plot(pos1(1:800,1),pos1(1:800,2),'r-');
p22=plot(pos2(1:800,1),pos2(1:800,2),'g-');
p33=plot(pos3(1:800,1),pos3(1:800,2),'b-');
p44=plot(pos4(1:800,1),pos4(1:800,2),'k-');

%WTF:画出船头的圆用于表示安全范围
circle(pos1(800,:),900/1852,1);
circle(pos2(800,:),900/1852,2);
circle(pos3(800,:),900/1852,3);
circle(pos4(800,:),900/1852,4);

axis([-4,4,-4.5,3.5]);
xlabel('n miles');
ylabel('n miles');
title('T=800s');
box on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
subplot(2,2,3);
hold on;
%WTF:画出船舶的初始位置
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:画出船舶的结束位置
drawShip(pos1(1000,:),c1(1000),1);
drawShip(pos2(1000,:),c2(1000),2);
drawShip(pos3(1000,:),c3(1000),3);
drawShip(pos4(1000,:),c4(1000),4);

%WTF:画出过往的航迹图
p11=plot(pos1(1:1000,1),pos1(1:1000,2),'r-');
p22=plot(pos2(1:1000,1),pos2(1:1000,2),'g-');
p33=plot(pos3(1:1000,1),pos3(1:1000,2),'b-');
p44=plot(pos4(1:1000,1),pos4(1:1000,2),'k-');

%WTF:画出船头的圆用于表示安全范围
circle(pos1(1000,:),900/1852,1);
circle(pos2(1000,:),900/1852,2);
circle(pos3(1000,:),900/1852,3);
circle(pos4(1000,:),900/1852,4);

axis([-4,4,-4.5,3.5]);
xlabel('n miles');
ylabel('n miles');
title('T=1000s');
box on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
subplot(2,2,4);
hold on;
%WTF:画出船舶的初始位置
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:画出船舶的结束位置
drawShip(pos1(1500,:),c1(1500),1);
drawShip(pos2(1500,:),c2(1500),2);
drawShip(pos3(1500,:),c3(1500),3);
drawShip(pos4(1500,:),c4(1500),4);

%WTF:画出过往的航迹图
p11=plot(pos1(:,1),pos1(:,2),'r-');
p22=plot(pos2(:,1),pos2(:,2),'g-');
p33=plot(pos3(:,1),pos3(:,2),'b-');
p44=plot(pos4(:,1),pos4(:,2),'k-');

%WTF:画出船头的圆用于表示安全范围
circle(pos1(1500,:),900/1852,1);
circle(pos2(1500,:),900/1852,2);
circle(pos3(1500,:),900/1852,3);
circle(pos4(1500,:),900/1852,4);

axis([-4,4,-4.5,3.5]);
xlabel('n miles');
ylabel('n miles');
title('T=1500s');
box on;
% % 
% for i=1:length(pos1)
%     set(p11,'xdata',pos1(1:i,1),'ydata',pos1(1:i,2));
%     set(p22,'xdata',pos2(1:i,1),'ydata',pos2(1:i,2));
%     set(p33,'xdata',pos3(1:i,1),'ydata',pos3(1:i,2));
%     set(p44,'xdata',pos4(1:i,1),'ydata',pos4(1:i,2));
% 
%     set(p1,'xdata',pos1(i,1),'ydata',pos1(i,2));
%     set(p2,'xdata',pos2(i,1),'ydata',pos2(i,2));
%     set(p3,'xdata',pos3(i,1),'ydata',pos3(i,2));
%     set(p4,'xdata',pos4(i,1),'ydata',pos4(i,2));
%     pause(.01);
%     drawnow;
% end