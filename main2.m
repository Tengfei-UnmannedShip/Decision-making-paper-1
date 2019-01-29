%% DecisionMaking����1��������-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.���׺��ѣ�main1����Ҫ˼·��������jinfen��ʦ�ബ���������㷨��Ԥ����wang��ʦ֤�����������㷨
%2.11��18�������жϳ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WTF:���������а棬wtf������ϸ�ĳ���ע��
clear all;
clc;
tic;%tic1
t1=clock;
%% WTF:������ʼ��
ShipNum=4;
t=1500;
ship(1).speed = 18*1852/3600;%WTF������Ϊ18����/Сʱ��1����=1.852������1����/Сʱ=1.852���Сʱ=1852/3600��/��
ship(1).ratio=1;             %��֪��ʲô��˼
ship(1).initialCourse = 0;
ship(1).courseAlter = 0;
ship(1).courseTime = 0; %the time that the ship keeps on the new course
ship(1).range=(4+0.1*rand())*1852;  %detect range
ship(1).no=1;  %receive information from other ships
% ship(1).pos = [0-ship(1).speed*sind(ship(1).initialCourse)*t 0-ship(1).speed*cosd(ship(1).initialCourse)*t];%WTF��������ǰ��λ�ã������Ʒ�����
ship(1).pos =[0,-7871];
ship(1).decisioncycle=3;
ship(1).evd=15; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����

ship(2).speed = 16*1852/3600;
ship(2).ratio=1;
ship(2).initialCourse = 230;
ship(2).courseAlter = 0;
ship(2).courseTime = 0;
ship(2).range=(4+0.1*rand())*1852;  %detect range
ship(2).no=2;  %receive information from other ships
% ship(2).pos = [0-ship(2).speed*sind(ship(2).initialCourse)*t -1200-ship(2).speed*cosd(ship(2).initialCourse)*t];
ship(2).pos =[5359.58738825731,3297.22780074911];
ship(2).decisioncycle=4;
ship(2).evd=15; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����

ship(3).speed = 16*1852/3600;
ship(3).ratio=1;
ship(3).initialCourse = 300;
ship(3).courseAlter = 0;
ship(3).courseTime = 0;
ship(3).range=(4+0.1*rand())*1852;  %detect range
ship(3).no=3;  %receive information from other ships
% ship(3).pos = [-ship(3).speed*sind(ship(3).initialCourse)*t 1000-ship(3).speed*cosd(ship(3).initialCourse)*t];
ship(3).pos =[6059.09862505539,-2498.22222222222];
ship(3).decisioncycle=5;
ship(3).evd=15; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����

ship(4).speed = 12*1852/3600;
ship(4).ratio=1;
ship(4).initialCourse = 150;
ship(4).courseAlter = 0;
ship(4).courseTime = 0;
ship(4).range=(4+0.1*rand())*1852;  %detect range
ship(4).no=4;  %receive information from other ships
% ship(4).pos = [0-ship(4).speed*sind(ship(4).initialCourse)*t 2000-ship(4).speed*cosd(ship(4).initialCourse)*t];
ship(4).pos =[-2623.66666666667,6544.32396879154];
ship(4).decisioncycle=5;
ship(4).evd=15; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����


pos1=zeros(t,2);
pos1(1,:)=ship(1).pos;%WTF������λ�þ����һ�У�����t��ֵ��δȷ����%%�²⴬��ԭ�����λ��
pos2=zeros(t,2);
pos2(1,:)=ship(2).pos;
pos3=zeros(t,2);
pos3(1,:)=ship(3).pos;
pos4=zeros(t,2);
pos4(1,:)=ship(4).pos;

c1=zeros(t,2);
c1(1,:)=ship(1).initialCourse;%WTF��������ʼ����
c2=zeros(t,2);
c2(1,:)=ship(2).initialCourse;
c3=zeros(t,2);
c3(1,:)=ship(3).initialCourse;
c4=zeros(t,2);
c4(1,:)=ship(4).initialCourse;

for i=1:1:ShipNum
    ship(i).data=[];%WTF��ship.data��Ϊ��
    ship(i).CAL=zeros(ShipNum,ShipNum);
    for ii=1:1:ShipNum
        ship(i).ship(ii).pos=ship(ii).pos;%��ʼ�����д����յ������д�λ��
        ship(i).ship(ii).data=[];
        ship(i).ship(ii).speed=ship(ii).speed;
        ship(i).ship(ii).ratio=ship(ii).ratio;
        ship(i).ship(ii).initialCourse=ship(ii).initialCourse ;
        ship(i).ship(ii).courseAlter=ship(ii).courseAlter;
        ship(i).ship(ii).courseTime=ship(ii).courseTime;
        ship(i).ship(ii).range=ship(ii).range;  %detect range
    end
end
OSdecision=[0 0 0 0];
OSdecConut=zeros(t,4);
s=0;
%% WTF:��ʼִ�зֲ�ʽ����
for i=2:t
    %% ׼������
    tic ;%tic2
    t2=clock;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Update%WTF��������Ϣ����,��ʹ
    for j=1:ShipNum
        ship(j).pos = [ship(j).pos(1)+ship(j).ratio*ship(j).speed*sind(ship(j).initialCourse+ship(j).courseAlter) ...
            ship(j).pos(2)+ship(j).ratio*ship(j).speed*cosd(ship(j).initialCourse+ship(j).courseAlter)];
        %WTF����ǰ�Ĵ���λ��Ϊ��ԭλ��x+1*��ǰ�ٶ�v*sin��ԭ�����alpha+��ǰ��ƫת��beta����ԭλ��y+1*��ǰ�ٶ�v*cos��ԭ�����alpha+��ǰ��ƫת��beta����
        %WTF��ship(j).ratio�²���һ������ʱ�䲽���Ĳ���
        if ship(j).courseTime>0    %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ�ڵ�ǰ�����ϣ���1��������ѭ������1�롣
            ship(j).courseTime = ship(j).courseTime-1;%ÿ��ѭ��ֻҪ�ڴ���⺽���ϣ�ʱ��ͼ�1��ֱ��Ϊ0��
        end
        if ship(j).courseTime == 0  %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ���ڵ�ǰ�����ϣ����򲻸ı䣬���ı�ĺ����courseAlterΪ0��
            ship(j).courseAlter = 0;
        end
        ship(j).Course=ship(j).initialCourse+ship(j).courseAlter;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pos1(i,:)=ship(1).pos;%WTF�����䴬��λ�þ���ÿһһ��ѭ��Ϊһ�룬ÿһ�����λ�þ����¼�һ�У�������1500�С�
    pos2(i,:)=ship(2).pos;
    pos3(i,:)=ship(3).pos;
    pos4(i,:)=ship(4).pos;
    
    c1(i,:)=ship(1).Course;%WTF�����䴬���������ÿ��ѭ�����´�����ǰ����ԭ�����alpha+��ǰ��ƫת��beta����������1500�С�
    c2(i,:)=ship(2).Course;
    c3(i,:)=ship(3).Course;
    c4(i,:)=ship(4).Course;
    %% ������ʼ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for OS=1:1:ShipNum  %�ӵ�һ�Ҵ��������Ҵ��ı���
        if decisioncycle(OS,i,ship) %�жϵ�ǰiʱ������j���ľ���������
            risk_neighbor_temp1=SearchNeighbor(ship(OS),ship,ship(OS).range);
            if ship(OS).courseAlter==0 && ~isempty(risk_neighbor_temp1)%WTF:����û��ת������Ҳ�����һ���Ѿ��жϳ�����û����Ҫ��·�Ĵ���ֱ����
                if CollisionRisk(ship(OS),risk_neighbor_temp1) %WTF:�������ٴ�����ײ����ʱ
                    OSdecConut(i,OS)=1;
                    OSdecision(OS)=OSdecision(OS)+1;
                    disp(['��',num2str(OS),'�Ҵ��ĵ�',num2str(OSdecision(OS)),'�ξ���']);
                    %% ֤�������Ƶ�����ǰ��CAL����
                    % neighbor_temp=SearchNeighbor(ship(j),ship,ship(j).range);%��j�Ҵ����ڴ����������ⷶΧ�����д�
                    % ���������д���Ҫ���ǵ������Բ����жϷ�Χ��
                    % ����ǵ�һ����������
                    if OSdecision(OS)==1  %�ڵ�һ���������ڣ���������Ϣ���룬CAL�����ձ���������
                        CAL_temp = Rule_judge(ship,ShipNum);
                        ship(OS).CAL = CAL_temp;
                    else  %�ǵ�һ����������
                        inferMatrix = ones(ShipNum,ShipNum);
                        for ship_i = 1:1:ShipNum
                            for ship_j = ShipNum:-1:ship_i+1 %ֻ�ж������ǣ��������Խ��߼�����
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                %t(i)ʱ϶(��һʱ��)ʵ��״̬
                                pos_own=ship(OS).ship(ship_i).pripos;
                                course_own=ship(OS).ship(ship_i).priCourse;
                                v_own=ship(OS).ship(ship_i).prispeed;
                                
                                pos_target=ship(OS).ship(ship_j).pripos;
                                course_target=ship(OS).ship(ship_j).priCourse;
                                v_target=ship(OS).ship(ship_j).prispeed;
                                pristate=[pos_own,course_own,v_own;
                                    pos_target,course_target, v_target];
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                %t(i)ʱ϶(��һʱ��)Ԥ��״̬����ĳһ�Ҵ�Ϊ����ʱ����״̬Ϊ����״̬��Ҳ����һʱ�̵�ʵ��״̬
                                pos_own_predic=ship(OS).ship(ship_i).prepos;
                                course_own_predic=ship(OS).ship(ship_i).preCourse;
                                v_own_predic=ship(OS).ship(ship_i).prespeed;
                                
                                pos_target_predic=ship(OS).ship(ship_j).prepos;
                                course_target_predic=ship(OS).ship(ship_j).preCourse;
                                v_target_predic=ship(OS).ship(ship_j).prespeed;
                                prestate=[pos_own_predic, course_own_predic,v_own_predic;
                                    pos_target_predic,course_target_predic,v_target_predic];
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                %t(i+1)ʱ϶(��ǰʱ��)ʵ��״̬
                                pos_own_post=ship(ship_i).pos;
                                course_own_post=ship(ship_i).Course;
                                v_own_post=ship(ship_i).ratio*ship(ship_i).speed;
                                
                                pos_target_post=ship(ship_j).pos;
                                course_target_post=ship(ship_j).Course;
                                v_target_post=ship(ship_j).ratio*ship(ship_j).speed;
                                poststate=[pos_own_post,course_own_post,v_own_post;
                                    pos_target_post,course_target_post,v_target_post];
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                
                                %����������Ϣ����ļ���
                                inferMatrix_temp = Pre_infer(pristate,prestate,poststate);
                                inferMatrix(ship_i,ship_j) = inferMatrix_temp(1,1);
                                
                                %�ڶ����������µ�CAL����
                                if inferMatrix(ship_i,ship_j)>ship(OS).evd %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����
                                    ship(OS).CAL(ship_i,ship_j)=1-ship(OS).CAL(ship_i,ship_j);
                                    ship(OS).CAL(ship_j,ship_i)=1-ship(OS).CAL(ship_j,ship_i);%���֤�ݾ�����󣬳ɶ��޸Ķ�Ӧ��CAL����ֵ
                                end
                            end
                        end
                    end
                    %% ��j���ݵ�ǰ��CAL������Ԥ�⵱ǰ�ı�������-�������ߺ�Ŀ�괬Ԥ��
                    % ��Ȼ�����д���û�б�����Ŀ�괬������
                    for ii=1:1500
                        if ii==1  %��ǰ��״̬
                            for kk = 1:ShipNum  %�ӵ�һ�Ҵ��������Ҵ��ı�����û�б�����Ŀ�괬������
                                %�ѵ�ǰ��״̬���ϣ���һ���������ڻ��õ���ͬʱҲ�ǵ�ǰ�ľ��ߵ����
                                ship(OS).ship(kk).pripos=ship(kk).pos;
                                ship(OS).ship(kk).prispeed=ship(kk).ratio*ship(kk).speed;
                                ship(OS).ship(kk).priCourse=ship(kk).Course;
                                %ͬ���ģ���ǰ��״̬Ҳ�ǵ�ǰ�ľ��ߵ����
                                ship(OS).ship(kk).pos=ship(kk).pos;
                                ship(OS).ship(kk).speed=ship(kk).ratio*ship(kk).speed;
                                ship(OS).ship(kk).Course=ship(kk).Course;
                            end
                        else %��ʼ��OS�Ժ���Ԥ��
                            for j=1:ShipNum
                                ship(OS).ship(j).pos = [ship(OS).ship(j).pos(1)+ship(OS).ship(j).ratio*ship(OS).ship(j).speed*sind(ship(OS).ship(j).initialCourse+ship(OS).ship(j).courseAlter) ...
                                    ship(OS).ship(j).pos(2)+ship(OS).ship(j).ratio*ship(OS).ship(j).speed*cosd(ship(OS).ship(j).initialCourse+ship(OS).ship(j).courseAlter)];
                                %WTF����ǰ�Ĵ���λ��Ϊ��ԭλ��x+1*��ǰ�ٶ�v*sin��ԭ�����alpha+��ǰ��ƫת��beta����ԭλ��y+1*��ǰ�ٶ�v*cos��ԭ�����alpha+��ǰ��ƫת��beta����
                                if ship(OS).ship(j).courseTime>0    %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ�ڵ�ǰ�����ϣ���1��������ѭ������1�롣
                                    ship(OS).ship(j).courseTime = ship(OS).ship(j).courseTime-1;%ÿ��ѭ��ֻҪ�ڴ���⺽���ϣ�ʱ��ͼ�1��ֱ��Ϊ0��
                                end
                                if ship(OS).ship(j).courseTime == 0  %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ���ڵ�ǰ�����ϣ����򲻸ı䣬���ı�ĺ����courseAlterΪ0��
                                    ship(OS).ship(j).courseAlter = 0;
                                end
                                ship(OS).ship(j).Course=ship(OS).ship(j).initialCourse+ship(OS).ship(j).courseAlter;
                            end
                            if ii==ship(OS).decisioncycle+1  %��һ������ʱ����������״̬
                                for kk = 1:ShipNum  %�ӵ�һ�Ҵ��������Ҵ��ı�����û�б�����Ŀ�괬������
                                    %����һ��ʱ�̵�Ԥ��״̬����
                                    ship(OS).ship(kk).prepos=ship(OS).ship(kk).pos;
                                    ship(OS).ship(kk).prespeed=ship(OS).ship(kk).ratio*ship(OS).ship(kk).speed;
                                    ship(OS).ship(kk).preCourse=ship(OS).ship(kk).Course;
                                end
                            end
                            %the give-way ships take actions
                            for jj=1:ShipNum  %�ӵ�һ�Ҵ��������Ҵ��ı�����û�б�����Ŀ�괬������
                                neighbor_temp1=SearchNeighbor(ship(OS).ship(jj),ship(OS).ship,ship(OS).ship(jj).range);%��j�Ҵ����ڴ����������ⷶΧ�����д�
                                neighbor_temp2=SearchNeighbor(ship(OS).ship(jj),ship(OS).ship,5.5*1852);%WTF:��j�Ҵ������з����ڴ���������5.5��������д�
                                if ship(OS).ship(jj).courseAlter==0 && ~isempty(neighbor_temp1)%WTF:����û��ת������Ҳ�����һ���Ѿ��жϳ�����û����Ҫ��·�Ĵ���ֱ����
                                    if CollisionRisk(ship(OS).ship(jj),neighbor_temp1) %WTF:�������ٴ�����ײ����ʱ
                                        [ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime] = Decision_making(ship(OS).ship(jj),neighbor_temp2);
                                        if ship(OS).ship(jj).courseAlter>0 || ship(OS).ship(jj).ratio<1
                                            %WTF:��չship(j).data����ÿ�θ���һ��
                                            ship(OS).ship(jj).data=[ship(OS).ship(jj).data;ii ship(OS).ship(jj).ratio ship(OS).ship(jj).courseAlter ship(OS).ship(jj).courseTime];
                                        end
                                    end
                                end
                            end
                        end
                    end %�����Ժ���Ԥ�ݽ���
                end
            end
            ship(OS).ratio= ship(OS).ship(OS).ratio;
            ship(OS).courseAlter = ship(OS).ship(OS).courseAlter; %��ʱ�ĺ����ǰ��վ�������ĺ�������Ϊ��ʼ����ģ�����绷���еĳ�ʼ����ͬ
            ship(OS).courseTime  = ship(OS).ship(OS).courseTime;
            ship(OS).data=[ship(OS).data;i ship(OS).ratio ship(OS).courseAlter ship(OS).courseTime];%WTF:��չship(j).data����ÿ�θ���һ��
        else %���򣬲����ߣ�ֱ�ӱ���ԭ��״̬��[ship(j).ratio ship(j).courseAlter ship(j).courseTime] ��
            ship(OS).ratio= ship(OS).ratio;
            ship(OS).courseAlter = ship(OS).courseAlter; %��ʱ�ĺ����ǰ��վ�������ĺ�������Ϊ��ʼ����ģ�����绷���еĳ�ʼ����ͬ
            ship(OS).courseTime  = ship(OS).courseTime;
            ship(OS).data=[ship(OS).data;i ship(OS).ratio ship(OS).courseAlter ship(OS).courseTime];%WTF:��չship(j).data����ÿ�θ���һ��
        end
    end
    disp(['��',num2str(i),'��ѭ������,����ʱ�䣺',num2str(etime(clock,t2))]);
    disp(['etime�������ӿ�ʼ���������е�ʱ��:',num2str(etime(clock,t1))]);
    disp('======================================')
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����ʱ��tic2��ʱ�䣬�������һ������tic����forѭ����i=3ʱ�����Լ���������һ��ѭ����ʱ��
disp(['toc�������һ��ѭ������ʱ��',num2str(toc)])
disp(['etime����������ʱ�䣺',num2str(etime(clock,t1))]);
pos1=pos1/1852;
pos2=pos2/1852;
pos3=pos3/1852;
pos4=pos4/1852;
%show ships' positions at every moment
%%WTF:��ͼ����
figure;
subplot(2,2,1);
hold on;
%WTF:���������ĳ�ʼλ��
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:���������Ľ���λ��
drawShip(pos1(400,:),c1(400),1);
drawShip(pos2(400,:),c2(400),2);
drawShip(pos3(400,:),c3(400),3);
drawShip(pos4(400,:),c4(400),4);

%WTF:���������ĺ���ͼ
p11=plot(pos1(1:400,1),pos1(1:400,2),'r-');
p22=plot(pos2(1:400,1),pos2(1:400,2),'g-');
p33=plot(pos3(1:400,1),pos3(1:400,2),'b-');
p44=plot(pos4(1:400,1),pos4(1:400,2),'k-');

%WTF:������ͷ��Բ���ڱ�ʾ��ȫ��Χ
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
%WTF:���������ĳ�ʼλ��
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:���������Ľ���λ��
drawShip(pos1(800,:),c1(800),1);
drawShip(pos2(800,:),c2(800),2);
drawShip(pos3(800,:),c3(800),3);
drawShip(pos4(800,:),c4(800),4);

%WTF:���������ĺ���ͼ
p11=plot(pos1(1:800,1),pos1(1:800,2),'r-');
p22=plot(pos2(1:800,1),pos2(1:800,2),'g-');
p33=plot(pos3(1:800,1),pos3(1:800,2),'b-');
p44=plot(pos4(1:800,1),pos4(1:800,2),'k-');

%WTF:������ͷ��Բ���ڱ�ʾ��ȫ��Χ
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
%WTF:���������ĳ�ʼλ��
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:���������Ľ���λ��
drawShip(pos1(1000,:),c1(1000),1);
drawShip(pos2(1000,:),c2(1000),2);
drawShip(pos3(1000,:),c3(1000),3);
drawShip(pos4(1000,:),c4(1000),4);

%WTF:���������ĺ���ͼ
p11=plot(pos1(1:1000,1),pos1(1:1000,2),'r-');
p22=plot(pos2(1:1000,1),pos2(1:1000,2),'g-');
p33=plot(pos3(1:1000,1),pos3(1:1000,2),'b-');
p44=plot(pos4(1:1000,1),pos4(1:1000,2),'k-');

%WTF:������ͷ��Բ���ڱ�ʾ��ȫ��Χ
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
%WTF:���������ĳ�ʼλ��
drawShip(pos1(1,:),c1(1),1);
drawShip(pos2(1,:),c2(1),2);
drawShip(pos3(1,:),c3(1),3);
drawShip(pos4(1,:),c4(1),4);

%WTF:���������Ľ���λ��
drawShip(pos1(1500,:),c1(1500),1);
drawShip(pos2(1500,:),c2(1500),2);
drawShip(pos3(1500,:),c3(1500),3);
drawShip(pos4(1500,:),c4(1500),4);

%WTF:���������ĺ���ͼ
p11=plot(pos1(:,1),pos1(:,2),'r-');
p22=plot(pos2(:,1),pos2(:,2),'g-');
p33=plot(pos3(:,1),pos3(:,2),'b-');
p44=plot(pos4(:,1),pos4(:,2),'k-');

%WTF:������ͷ��Բ���ڱ�ʾ��ȫ��Χ
circle(pos1(1500,:),900/1852,1);
circle(pos2(1500,:),900/1852,2);
circle(pos3(1500,:),900/1852,3);
circle(pos4(1500,:),900/1852,4);

axis([-4,4,-4.5,3.5]);
xlabel('n miles');
ylabel('n miles');
title('T=1500s');
box on;
