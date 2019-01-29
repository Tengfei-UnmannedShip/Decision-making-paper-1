%% DecisionMaking论文1的主程序-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.12月15日改
%2.1.思路，每一艘船算出未来的状态，每次如果判断CAL不变，直接读取上次的决策（位置、航向（初始航向+改变量）、航速（初始航速*系数））
%2.2.设置某一艘船不遵守避碰规则，并反着来
%2.3.对原程序有修改
%3.所有船正常的情况，运行成功，数据存储为：case1-11-30，实验图片存储为：case1-11-30-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WTF:完整可运行版，wtf做了详细的程序注释
clear all;
clc;
close all;
tic;%tic1
t1=clock;
%% WTF:参数初始化
ShipNum=4;
t=2000;
tt=2000;
ship(1).speed = 18*1852/3600;%WTF：航速为18海里/小时。1海里=1.852公里，因此1海里/小时=1.852公里／小时=1852/3600米/秒
ship(1).ratio=1;             %不知道什么意思
ship(1).initialCourse = 0;
ship(1).courseAlter = 0;
ship(1).courseTime = 0; %the time that the ship keeps on the new course
ship(1).range=5*1852;  %detect range
ship(1).no=1;  %receive information from other ships
% ship(1).pos = [0-ship(1).speed*sind(ship(1).initialCourse)*t 0-ship(1).speed*cosd(ship(1).initialCourse)*t];%WTF：船舶当前的位置？？倒推法？？
ship(1).pos =[0,-4]*1852;
ship(1).decisioncycle=3;
ship(1).evd=0.8; %本船的evidance门槛，数值越小表示对于证据距离越严谨，数值越大越宽松
ship(1).compliance=1; %compliance是对避碰规则的符合性，0：直线前进不避让，1：遵守，2：不遵守，反着来

ship(2).speed = 18*1852/3600;
ship(2).ratio=1;
ship(2).initialCourse = 230;
ship(2).courseAlter = 0;
ship(2).courseTime = 0;
ship(2).range=5*1852;  %detect range
ship(2).no=2;  %receive information from other ships
% ship(2).pos = [0-ship(2).speed*sind(ship(2).initialCourse)*t -1200-ship(2).speed*cosd(ship(2).initialCourse)*t];
ship(2).pos =[3,3]*1852;
ship(2).decisioncycle=4;
ship(2).evd=0.8; %本船的evidance门槛，数值越小表示对于证据距离越严谨，数值越大越宽松
ship(2).compliance=1; %compliance是对避碰规则的符合性，0：直线前进不避让，1：遵守，2：不遵守，反着来

ship(3).speed = 16*1852/3600;
ship(3).ratio=1;
ship(3).initialCourse = 300;
ship(3).courseAlter = 0;
ship(3).courseTime = 0;
ship(3).range=5*1852;  %detect range
ship(3).no=3;  %receive information from other ships
% ship(3).pos = [-ship(3).speed*sind(ship(3).initialCourse)*t 1000-ship(3).speed*cosd(ship(3).initialCourse)*t];
ship(3).pos =[3,-3]*1852;
ship(3).decisioncycle=5;
ship(3).evd=0.8; %本船的evidance门槛，数值越小表示对于证据距离越严谨，数值越大越宽松
ship(3).compliance=1; %compliance是对避碰规则的符合性，0：直线前进不避让，1：遵守，2：不遵守，反着来


ship(4).speed = 13*1852/3600;
ship(4).ratio=1;
ship(4).initialCourse = 150;
ship(4).courseAlter = 0;
ship(4).courseTime = 0;
ship(4).range=5*1852;  %detect range
ship(4).no=4;  %receive information from other ships
% ship(4).pos = [0-ship(4).speed*sind(ship(4).initialCourse)*t 2000-ship(4).speed*cosd(ship(4).initialCourse)*t];
ship(4).pos =[-1.5,3]*1852;
ship(4).decisioncycle=5;
ship(4).evd=0.8; %本船的evidance门槛，数值越小表示对于证据距离越严谨，数值越大越宽松
ship(4).compliance=1; %compliance是对避碰规则的符合性，0：直线前进不避让，1：遵守，2：不遵守，反着来

pos1=zeros(t,2);
pos1(1,:)=ship(1).pos;%WTF：船舶位置矩阵第一行，但是t的值尚未确定，%%猜测船舶原定最初位置
pos2=zeros(t,2);
pos2(1,:)=ship(2).pos;
pos3=zeros(t,2);
pos3(1,:)=ship(3).pos;
pos4=zeros(t,2);
pos4(1,:)=ship(4).pos;

c1=zeros(t,1);
c1(1,:)=ship(1).initialCourse;%WTF：船舶初始航向
c2=zeros(t,1);
c2(1,:)=ship(2).initialCourse;
c3=zeros(t,1);
c3(1,:)=ship(3).initialCourse;
c4=zeros(t,1);
c4(1,:)=ship(4).initialCourse;

for i=1:1:ShipNum
    ship(i).data=[];%WTF：ship.data置为空
    ship(i).CAL=zeros(ShipNum,ShipNum);
    ship(i).CALchange=0; %CAL改变的标志位，如果没改变，则可以不用决策，直接执行预计计划
    ship(i).decision_lable=0;
    ship(i).infer=[];
    ship(i).OSRealdecision0=0;
end
OSdecision=[0 0 0 0];
OSdecision_time=[ ];
OSdecConut=zeros(t,4);
s=0;
%% WTF:开始执行分布式决策
for i=2:t
    %% 全局环境
    tic ;%tic2
    t2=clock;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Update%WTF：船舶信息更新
    for j=1:ShipNum
        if ship(j).decision_lable~=0
            ship(j).pos=ship(j).DM_pos(i-ship(j).decision_lable,2*j-1:2*j);
            ship(j).Course=ship(j).DM_c(i-ship(j).decision_lable,j);
            ship(j).courseAlter=ship(j).Course-ship(j).initialCourse;
            ship(j).ratio=ship(j).DM_r(i-ship(j).decision_lable,j);
        else
            ship(j).Course=ship(j).initialCourse+ship(j).courseAlter;
            speed_now=ship(j).ratio*ship(j).speed;
            %WTF：当前的船舶位置为（原位置x+1*当前速度v*sin（原航向角alpha+当前的偏转角beta），原位置y+1*当前速度v*cos（原航向角alpha+当前的偏转角beta））
            ship(j).pos =[ship(j).pos(1)+speed_now*sind(ship(j).Course),ship(j).pos(2)+speed_now*cosd(ship(j).Course)];
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pos1(i,:)=ship(1).pos;%WTF：扩充船舶位置矩阵，每一一个循环为一秒，每一秒就在位置矩阵下加一行，最后就是1500行。
    pos2(i,:)=ship(2).pos;
    pos3(i,:)=ship(3).pos;
    pos4(i,:)=ship(4).pos;
    
    c1(i,:)=ship(1).Course;%WTF：扩充船舶航向矩阵，每个循环更新船舶当前航向（原航向角alpha+当前的偏转角beta），最后就是1500行。
    c2(i,:)=ship(2).Course;
    c3(i,:)=ship(3).Course;
    c4(i,:)=ship(4).Course;
    
    %% 本船开始决策%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for OS=1:1:ShipNum  %从第一艘船到第四艘船的遍历
        if decisioncycle(OS,i,ship)&& ship(OS).compliance~=0%判断当前i时刻是在j船的决策周期中且compliance==1即本船正常
            %compliance=0 说明完全不变，此时不决策就好%%compliance=2 只决策，不推测，反着来
            risk_neighbor_temp1=SearchNeighbor(ship(OS),ship,ship(OS).range);
            if CollisionRisk(ship(OS),risk_neighbor_temp1) %WTF:本船与临船有碰撞风险时
                OSdecConut(i,OS)=1;
                OSdecision(OS)=OSdecision(OS)+1;
                OSdecision_time(OS,OSdecision(OS))=i;
                disp(['t=',num2str(i),',  ','第',num2str(OS),'艘船的第',num2str(OSdecision(OS)),'次决策']);
                %% 证据理论推导出当前的CAL矩阵
                % neighbor_temp=SearchNeighbor(ship(j),ship,ship(j).range);%第j艘船的邻船，即进入检测范围的所有船
                % 领域内所有船都要考虑到，所以不再判断范围船
                % 如果是第一个决策周期
                if OSdecision(OS)==1  %在第一个决策周期，不计算信息距离，CAL矩阵按照避碰规则来
                    ship(OS).OSRealdecision=[i 1];
                    CAL_temp = Rule_judge(ship,ShipNum);
                    ship(OS).CAL = CAL_temp;
                    ship(OS).oldCAL = ship(OS).CAL;
                else  %非第一个决策周期
                    inferMatrix = ones(ShipNum,ShipNum);
                    for ship_i = 1:1:ShipNum
                        for ship_j = ShipNum:-1:ship_i+1 %只判断上三角，不包括对角线及以下
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %t(i)时隙(上一时刻)实际状态
                            pos_own=ship(OS).ship(ship_i).pripos;
                            course_own=ship(OS).ship(ship_i).priCourse;
                            v_own=ship(OS).ship(ship_i).prispeed;
                            
                            pos_target=ship(OS).ship(ship_j).pripos;
                            course_target=ship(OS).ship(ship_j).priCourse;
                            v_target=ship(OS).ship(ship_j).prispeed;
                            pristate=[pos_own,course_own,v_own;
                                pos_target,course_target, v_target];
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %t(i)时隙(上一时刻)预测状态，当某一艘船为本船时，其状态为决策状态，也即下一时刻的实际状态
                            pos_own_predic=ship(OS).ship(ship_i).prepos;
                            course_own_predic=ship(OS).ship(ship_i).preCourse;
                            v_own_predic=ship(OS).ship(ship_i).prespeed;
                            
                            pos_target_predic=ship(OS).ship(ship_j).prepos;
                            course_target_predic=ship(OS).ship(ship_j).preCourse;
                            v_target_predic=ship(OS).ship(ship_j).prespeed;
                            prestate=[pos_own_predic, course_own_predic,v_own_predic;
                                pos_target_predic,course_target_predic,v_target_predic];
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %t(i+1)时隙(当前时刻)实际状态
                            pos_own_post=ship(ship_i).pos;
                            course_own_post=ship(ship_i).Course;
                            v_own_post=ship(ship_i).ratio*ship(ship_i).speed;
                            
                            pos_target_post=ship(ship_j).pos;
                            course_target_post=ship(ship_j).Course;
                            v_target_post=ship(ship_j).ratio*ship(ship_j).speed;
                            poststate=[pos_own_post,course_own_post,v_own_post;
                                pos_target_post,course_target_post,v_target_post];
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            %首先生成信息距离的计算
                            inferMatrix_temp = Pre_infer(pristate,prestate,poststate);
                            inferMatrix(ship_i,ship_j) = inferMatrix_temp(1,1);
                            ship(OS).infer=[ship(OS).infer;ship_i ship_j inferMatrix_temp];
                            
                            %第二步，生成新的CAL矩阵
                            if inferMatrix_temp(1,1)>ship(OS).evd %本船的evidance门槛，数值越小表示对于证据距离越严谨，数值越大越宽松
                                ship(OS).CAL(ship_i,ship_j)=1-ship(OS).CAL(ship_i,ship_j);
                                ship(OS).CAL(ship_j,ship_i)=1-ship(OS).CAL(ship_j,ship_i);%如果证据距离过大，成对修改对应的CAL决策值
                                disp(['  推测的',num2str(ship_j),'船对',num2str(ship_i),'船不准确，偏差为',num2str(inferMatrix_temp(1,1))]);
                            end
                        end
                    end
                    if isequal(ship(OS).CAL,ship(OS).oldCAL)
                        ship(OS).CALchange=0;%CAL在本决策中改变
                        disp('  推测的CAL不变，保持上一决策周期运行');
                        
                    else
                        ship(OS).CALchange=1;%CAL在本决策中改变
                        ship(OS).OSRealdecision0=ship(OS).OSRealdecision0+1;
                        ship(OS).OSRealdecision=[ship(OS).OSRealdecision;i ship(OS).OSRealdecision0];
                        disp(['  推测的CAL有改变，第',num2str(ship(OS).OSRealdecision0),'次重新决策']);
                    end
                end
                %% 船j根据当前的CAL矩阵来预测当前的避碰场景-本船决策和目标船预测
                % 所有船，没有本船与目标船的区别
                if  ship(OS).CALchange==0 && OSdecision(OS)~=1 %CAL不变，且不是第一次决策，则直接更新推测信息，不决策
                    for kk = 1:ShipNum  %从第一艘船到第四艘船的遍历，没有本船与目标船的区别
                        %把当前的状态存上，下一个决策周期会用到
                        ship(OS).ship(kk).pripos=ship(kk).pos;
                        ship(OS).ship(kk).prispeed=ship(kk).ratio*ship(kk).speed;
                        ship(OS).ship(kk).priCourse=ship(kk).Course;
                        
                        ship(OS).ship(kk).prepos= ship(OS).DM_pos(i-ship(OS).decision_lable,2*kk-1:2*kk);%存储所有的decision-making(DM)的pos结果
                        ship(OS).ship(kk).prespeed=ship(OS).DM_r(i-ship(OS).decision_lable,kk)*ship(OS).ship(kk).speed;
                        ship(OS).ship(kk).preCourse=ship(OS).DM_c(i-ship(OS).decision_lable,kk);
                    end
                else
                    ship(OS).decision_lable=i; %这一次决策标志位
                    for ii=1:tt
                        if ii==1  %当前的状态
                            for kk = 1:ShipNum  %从第一艘船到第四艘船的遍历，没有本船与目标船的区别
                                %把当前的状态存上，下一个决策周期会用到，同时也是当前的决策的起点
                                ship(OS).ship(kk).pripos=ship(kk).pos;
                                ship(OS).ship(kk).prispeed=ship(kk).ratio*ship(kk).speed;
                                ship(OS).ship(kk).priCourse=ship(kk).Course;
                                %同样的，当前的状态也是当前的决策的起点
                                ship(OS).ship(kk).pos=ship(kk).pos;
                                ship(OS).ship(kk).speed=ship(kk).ratio*ship(kk).speed;
                                ship(OS).ship(kk).Course=ship(kk).Course;
                                %本船脑海中决策／预测结果录入
                                ship(OS).DM_pos(ii,2*kk-1:2*kk)=ship(kk).pos;%存储所有的decision-making(DM)的pos结果
                                ship(OS).DM_c(ii,kk)=ship(kk).initialCourse+ship(kk).courseAlter;%WTF：扩充船舶航向矩阵，每个循环更新船舶当前航向（原航向角alpha+当前的偏转角beta），最后就是1500行。
                                ship(OS).DM_r(ii,kk)=ship(kk).ratio;
                                %各船的基本状态信息录入
                                ship(OS).ship(kk).pos=ship(kk).pos;
                                ship(OS).ship(kk).data=[];
                                ship(OS).ship(kk).speed=ship(kk).speed;
                                ship(OS).ship(kk).ratio=ship(kk).ratio;
                                ship(OS).ship(kk).initialCourse=ship(kk).initialCourse ;
                                ship(OS).ship(kk).courseAlter=ship(kk).courseAlter;
                                ship(OS).ship(kk).courseTime=ship(kk).courseTime;
                                ship(OS).ship(kk).range=ship(kk).range;  %detect range
                                ship(OS).ship(kk).no=ship(kk).no;
                            end
                        else %开始在OS脑海中预演
                            for j=1:ShipNum
                                ship(OS).ship(j).Course=GetNextHeading( ship(OS).ship(j).Course, ship(OS).ship(j).initialCourse+ship(OS).ship(j).courseAlter );
                                ship(OS).ship(j).pos = [ship(OS).ship(j).pos(1)+ship(OS).ship(j).ratio*ship(OS).ship(j).speed*sind(ship(OS).ship(j).Course) ...
                                    ship(OS).ship(j).pos(2)+ship(OS).ship(j).ratio*ship(OS).ship(j).speed*cosd(ship(OS).ship(j).Course)];
                                %WTF：当前的船舶位置为（原位置x+1*当前速度v*sin（原航向角alpha+当前的偏转角beta），原位置y+1*当前速度v*cos（原航向角alpha+当前的偏转角beta））
                                if ship(OS).ship(j).courseTime>0    %此处为船舶在航线上航行的时间，若大于0表示在当前航线上，减1，即本步循环用了1秒。
                                    ship(OS).ship(j).courseTime = ship(OS).ship(j).courseTime-1;%每个循环只要在待检测航线上，时间就减1，直到为0。
                                end
                                if ship(OS).ship(j).courseTime == 0  %此处为船舶在航线上航行的时间，若等于0表示不在当前航线上，则航向不改变，即改变的航向角courseAlter为0。
                                    ship(OS).ship(j).courseAlter = 0;
                                end
                            end
                            for kk=1:1:ShipNum %存入所有OS脑海中决策的结果
                                ship(OS).DM_pos(ii,2*kk-1:2*kk)=ship(OS).ship(kk).pos;
                                ship(OS).DM_c(ii,kk)=ship(OS).ship(kk).Course;
                                ship(OS).DM_r(ii,kk)=ship(OS).ship(kk).ratio;
                            end
                            if ii==ship(OS).decisioncycle+1  %下一个决策时刻其他船的状态
                                for kk = 1:ShipNum  %从第一艘船到第四艘船的遍历，没有本船与目标船的区别
                                    %把下一个时刻的预测状态存上
                                    ship(OS).ship(kk).prepos=ship(OS).ship(kk).pos;
                                    ship(OS).ship(kk).prespeed=ship(OS).ship(kk).ratio*ship(OS).ship(kk).speed;
                                    ship(OS).ship(kk).preCourse=ship(OS).ship(kk).Course;
                                end
                            end
                            %the give-way ships take actions
                            for jj=1:ShipNum  %从第一艘船到第四艘船的遍历，没有本船与目标船的区别
                                neighbor_temp1=SearchNeighbor(ship(OS).ship(jj),ship(OS).ship,ship(OS).ship(jj).range);%第j艘船的邻船，即进入检测范围的所有船
                                neighbor_temp2=SearchNeighbor(ship(OS).ship(jj),ship(OS).ship,5.5*1852);%WTF:第j艘船的所有风险邻船，即进入5.5海里的所有船
                                if ship(OS).ship(jj).courseAlter==0 && ~isempty(neighbor_temp1)%WTF:本船没有转向决策且不是上一步已经判断出来的没有需要让路的船的直航船
                                    if CollisionRisk(ship(OS).ship(jj),neighbor_temp1) %WTF:本船与临船有碰撞风险时
                                        if jj==OS %本船自己的决策时，本船知道自己是否遵守规则
                                            [ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime] = Decision_making2(ship(OS).ship(jj),neighbor_temp2,ship(OS).CAL,ship(OS).compliance);
                                            if ship(OS).ship(jj).courseAlter>0 || ship(OS).ship(jj).ratio<1 %记录本船的决策
                                                ship(OS).data=[ship(OS).data;i,ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime];%WTF:扩展ship(j).data矩阵，每次如果有决策（转向或变速）更新一行
                                            end
                                        else   %对其他船，按照CAL来
                                            [ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime] = Decision_making(ship(OS).ship(jj),neighbor_temp2,ship(OS).CAL);
                                        end
                                    end
                                end
                            end
                        end
                    end %本船脑海中预演结束
                end
            end
        end
    end
    %     disp(['第',num2str(i),'次循环结束,运行时间：',num2str(etime(clock,t2))]);
    %     disp(['程序从开始到现在运行的时间:',num2str(etime(clock,t1))]);
    %     disp('======================================')
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算此时到tic2的时间，由于最后一次遇到tic是在for循环的i=3时，所以计算的是最后一次循环的时间
% disp(['最后一次循环运行时间',num2str(toc)])
disp(['程序总运行时间：',num2str(etime(clock,t1))]);
pos1=pos1/1852;
pos2=pos2/1852;
pos3=pos3/1852;
pos4=pos4/1852;
%% 绘图程序：show ships' positions at every moment
figure
for fig=1:6
    
    switch fig
        case 1
            k=200;
        case 2
            k=400;
        case 3
            k=800;
        case 4
            k=1000;
        case 5
            k=1500;
        case 6
            k=2000;
    end
    
    subplot(3,2,fig);
    hold on;
    
    %WTF:画出船舶的初始位置
    drawShip0(pos1(1,:),c1(1),1);
    drawShip0(pos2(1,:),c2(1),2);
    drawShip0(pos3(1,:),c3(1),3);
    drawShip0(pos4(1,:),c4(1),4);
    
    %WTF:画出船舶的结束位置
    drawShip(pos1(k,:),c1(k),1);
    drawShip(pos2(k,:),c2(k),2);
    drawShip(pos3(k,:),c3(k),3);
    drawShip(pos4(k,:),c4(k),4);
    
    %WTF:画出过往的航迹图
    plot(pos1(1:k,1),pos1(1:k,2),'r-');
    plot(pos2(1:k,1),pos2(1:k,2),'g-');
    plot(pos3(1:k,1),pos3(1:k,2),'b-');
    plot(pos4(1:k,1),pos4(1:k,2),'k-');
    
    %WTF:画出船头的圆用于表示安全范围
    circle(pos1(k,:),900/1852,1);
    circle(pos2(k,:),900/1852,2);
    circle(pos3(k,:),900/1852,3);
    circle(pos4(k,:),900/1852,4);
    
    axis([-4.5,4.5,-4.5,4.5]);
    xlabel('\it n miles', 'Fontname', 'Times New Roman');
    ylabel('\it n miles', 'Fontname', 'Times New Roman');
    title(['t=',num2str(k),'s'], 'Fontname', 'Times New Roman');
    box on;
    
end