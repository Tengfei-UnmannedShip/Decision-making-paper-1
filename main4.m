%% DecisionMaking����1��������-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.11��29�ո�
%2.˼·��ÿһ�Ҵ����δ����״̬��ÿ������ж�CAL���䣬ֱ�Ӷ�ȡ�ϴεľ��ߣ�λ�á����򣨳�ʼ����+�ı����������٣���ʼ����*ϵ������
%3.���д���������������гɹ������ݴ洢Ϊ��case1-11-30��ʵ��ͼƬ�洢Ϊ��case1-11-30-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WTF:���������а棬wtf������ϸ�ĳ���ע��
clear all
clc;
tic;%tic1
t1=clock;
%% WTF:������ʼ��
ShipNum=4;
t=1500;
tt=1500;
ship(1).speed = 18*1852/3600;%WTF������Ϊ18����/Сʱ��1����=1.852������1����/Сʱ=1.852���Сʱ=1852/3600��/��
ship(1).ratio=1;             %��֪��ʲô��˼
ship(1).initialCourse = 0;
ship(1).courseAlter = 0;
ship(1).courseTime = 0; %the time that the ship keeps on the new course
% ship(1).range=(4+0.1*rand())*1852;  %detect range
ship(1).range=5*1852;  %detect range
ship(1).no=1;  %receive information from other ships
% ship(1).pos = [0-ship(1).speed*sind(ship(1).initialCourse)*t 0-ship(1).speed*cosd(ship(1).initialCourse)*t];%WTF��������ǰ��λ�ã������Ʒ�����
ship(1).pos =[0,-7871];
ship(1).decisioncycle=3;
ship(1).evd=5; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����

ship(2).speed = 16*1852/3600;
ship(2).ratio=1;
ship(2).initialCourse = 230;
ship(2).courseAlter = 0;
ship(2).courseTime = 0;
ship(2).range=5*1852;  %detect range
ship(2).no=2;  %receive information from other ships
% ship(2).pos = [0-ship(2).speed*sind(ship(2).initialCourse)*t -1200-ship(2).speed*cosd(ship(2).initialCourse)*t];
ship(2).pos =[5359.58738825731,3297.22780074911];
ship(2).decisioncycle=4;
ship(2).evd=5; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����

ship(3).speed = 16*1852/3600;
ship(3).ratio=1;
ship(3).initialCourse = 300;
ship(3).courseAlter = 0;
ship(3).courseTime = 0;
ship(3).range=5*1852;  %detect range
ship(3).no=3;  %receive information from other ships
% ship(3).pos = [-ship(3).speed*sind(ship(3).initialCourse)*t 1000-ship(3).speed*cosd(ship(3).initialCourse)*t];
ship(3).pos =[6059.09862505539,-2498.22222222222];
ship(3).decisioncycle=5;
ship(3).evd=5; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����

ship(4).speed = 12*1852/3600;
ship(4).ratio=1;
ship(4).initialCourse = 150;
ship(4).courseAlter = 0;
ship(4).courseTime = 0;
ship(4).range=5*1852;  %detect range
ship(4).no=4;  %receive information from other ships
% ship(4).pos = [0-ship(4).speed*sind(ship(4).initialCourse)*t 2000-ship(4).speed*cosd(ship(4).initialCourse)*t];
ship(4).pos =[-2623.66666666667,6544.32396879154];
ship(4).decisioncycle=5;
ship(4).evd=5; %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����


pos1=zeros(t,2);
pos1(1,:)=ship(1).pos;%WTF������λ�þ����һ�У�����t��ֵ��δȷ����%%�²⴬��ԭ�����λ��
pos2=zeros(t,2);
pos2(1,:)=ship(2).pos;
pos3=zeros(t,2);
pos3(1,:)=ship(3).pos;
pos4=zeros(t,2);
pos4(1,:)=ship(4).pos;

c1=zeros(t,1);
c1(1,:)=ship(1).initialCourse;%WTF��������ʼ����
c2=zeros(t,1);
c2(1,:)=ship(2).initialCourse;
c3=zeros(t,1);
c3(1,:)=ship(3).initialCourse;
c4=zeros(t,1);
c4(1,:)=ship(4).initialCourse;

for i=1:1:ShipNum
    ship(i).data=[];%WTF��ship.data��Ϊ��
    ship(i).CAL=zeros(ShipNum,ShipNum);
    ship(i).CALchange=0; %CAL�ı�ı�־λ�����û�ı䣬����Բ��þ��ߣ�ֱ��ִ��Ԥ�Ƽƻ�
    ship(i).decision_lable=0;
end
OSdecision=[0 0 0 0];
OSdecConut=zeros(t,4);
s=0;
%% WTF:��ʼִ�зֲ�ʽ����
for i=2:t
    %% ȫ�ֻ���
    tic ;%tic2
    t2=clock;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Update%WTF��������Ϣ����
    for j=1:ShipNum
        if ship(j).decision_lable~=0
            ship(j).pos=ship(j).DM_pos(i-ship(j).decision_lable,2*j-1:2*j);
            ship(j).Course=ship(j).DM_c(i-ship(j).decision_lable,j);
            ship(j).courseAlter=ship(j).Course-ship(j).initialCourse;
            ship(j).ratio=ship(j).DM_r(i-ship(j).decision_lable,j);
        else
            ship(j).pos = [ship(j).pos(1)+ship(j).ratio*ship(j).speed*sind(ship(j).initialCourse+ship(j).courseAlter) ...
                ship(j).pos(2)+ship(j).ratio*ship(j).speed*cosd(ship(j).initialCourse+ship(j).courseAlter)];
            %WTF����ǰ�Ĵ���λ��Ϊ��ԭλ��x+1*��ǰ�ٶ�v*sin��ԭ�����alpha+��ǰ��ƫת��beta����ԭλ��y+1*��ǰ�ٶ�v*cos��ԭ�����alpha+��ǰ��ƫת��beta����
            if ship(j).courseTime>0    %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ�ڵ�ǰ�����ϣ���1��������ѭ������1�롣
                ship(j).courseTime = ship(j).courseTime-1;%ÿ��ѭ��ֻҪ�ڴ���⺽���ϣ�ʱ��ͼ�1��ֱ��Ϊ0��
            end
            if ship(j).courseTime == 0  %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ���ڵ�ǰ�����ϣ����򲻸ı䣬���ı�ĺ����courseAlterΪ0��
                ship(j).courseAlter = 0;
            end
            ship(j).Course=ship(j).initialCourse+ship(j).courseAlter;
        end
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
                    disp(['*��',num2str(OS),'�Ҵ��ĵ�',num2str(OSdecision(OS)),'�ξ���']);
                    %% ֤�������Ƶ�����ǰ��CAL����
                    % neighbor_temp=SearchNeighbor(ship(j),ship,ship(j).range);%��j�Ҵ����ڴ����������ⷶΧ�����д�
                    % ���������д���Ҫ���ǵ������Բ����жϷ�Χ��
                    % ����ǵ�һ����������
                    if OSdecision(OS)==1  %�ڵ�һ���������ڣ���������Ϣ���룬CAL�����ձ���������
                        CAL_temp = Rule_judge(ship,ShipNum);
                        ship(OS).CAL = CAL_temp;
                        ship(OS).oldCAL = ship(OS).CAL;
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
                        if ship(OS).CAL~=ship(OS).oldCAL
                            ship(OS).CALchange=1;%CAL�ڱ������иı�
                            disp('  �Ʋ��CAL�иı䣬���¾���');
                        else
                            ship(OS).CALchange=0;%CAL�ڱ������иı�
                            disp('  �Ʋ��CAL���䣬������һ������������');
                        end
                    end
                    %% ��j���ݵ�ǰ��CAL������Ԥ�⵱ǰ�ı�������-�������ߺ�Ŀ�괬Ԥ��
                    % ���д���û�б�����Ŀ�괬������
                    if  ship(OS).CALchange==0 && OSdecision(OS)~=1 %CAL���䣬�Ҳ��ǵ�һ�ξ��ߣ���ֱ�Ӹ����Ʋ���Ϣ��������
                        for kk = 1:ShipNum  %�ӵ�һ�Ҵ��������Ҵ��ı�����û�б�����Ŀ�괬������
                            %�ѵ�ǰ��״̬���ϣ���һ���������ڻ��õ�
                            ship(OS).ship(kk).pripos=ship(kk).pos;
                            ship(OS).ship(kk).prispeed=ship(kk).ratio*ship(kk).speed;
                            ship(OS).ship(kk).priCourse=ship(kk).Course;
                            
                            ship(OS).ship(kk).prepos= ship(OS).DM_pos(i-ship(OS).decision_lable,2*kk-1:2*kk);%�洢���е�decision-making(DM)��pos���
                            ship(OS).ship(kk).prespeed=ship(OS).DM_r(i-ship(OS).decision_lable,kk)*ship(OS).ship(kk).speed;
                            ship(OS).ship(kk).preCourse=ship(OS).DM_c(i-ship(OS).decision_lable,kk);
                        end
                    else
                        ship(OS).decision_lable=i; %��һ�ξ��߱�־λ
                        for ii=1:tt
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
                                    %�����Ժ��о��ߣ�Ԥ����¼��
                                    ship(OS).DM_pos(ii,2*kk-1:2*kk)=ship(kk).pos;%�洢���е�decision-making(DM)��pos���
                                    ship(OS).DM_c(ii,kk)=ship(kk).initialCourse+ship(kk).courseAlter;%WTF�����䴬���������ÿ��ѭ�����´�����ǰ����ԭ�����alpha+��ǰ��ƫת��beta����������1500�С�
                                    ship(OS).DM_r(ii,kk)=ship(kk).ratio;
                                    %�����Ļ���״̬��Ϣ¼��
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
                                for kk=1:1:ShipNum %��������OS�Ժ��о��ߵĽ��
                                    ship(OS).DM_pos(ii,2*kk-1:2*kk)=ship(OS).ship(kk).pos;
                                    ship(OS).DM_c(ii,kk)=ship(OS).ship(kk).initialCourse+ship(OS).ship(kk).courseAlter;
                                    ship(OS).DM_r(ii,kk)=ship(OS).ship(kk).ratio;
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
                                            [ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime] = Decision_making(ship(OS).ship(jj),neighbor_temp2,ship(OS).CAL);
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
            end
            %             ship(OS).ratio= ship(OS).ship(OS).ratio;
            %             ship(OS).courseAlter = ship(OS).ship(OS).courseAlter; %��ʱ�ĺ����ǰ��վ�������ĺ�������Ϊ��ʼ����ģ�����绷���еĳ�ʼ����ͬ
            %             ship(OS).courseTime  = ship(OS).ship(OS).courseTime;
            %             ship(OS).data=[ship(OS).data;i ship(OS).ratio ship(OS).courseAlter ship(OS).courseTime];%WTF:��չship(j).data����ÿ�θ���һ��
            %         else %���򣬲����ߣ�ֱ�ӱ���ԭ��״̬��[ship(j).ratio ship(j).courseAlter ship(j).courseTime] ��
            %             ship(OS).ratio= ship(OS).ratio;
            %             ship(OS).courseAlter = ship(OS).courseAlter; %��ʱ�ĺ����ǰ��վ�������ĺ�������Ϊ��ʼ����ģ�����绷���еĳ�ʼ����ͬ
            %             ship(OS).courseTime  = ship(OS).courseTime;
            %             ship(OS).data=[ship(OS).data;i ship(OS).ratio ship(OS).courseAlter ship(OS).courseTime];%WTF:��չship(j).data����ÿ�θ���һ��
        end
    end
    disp(['��',num2str(i),'��ѭ������,����ʱ�䣺',num2str(etime(clock,t2))]);
    disp(['����ӿ�ʼ���������е�ʱ��:',num2str(etime(clock,t1))]);
    disp('======================================')
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����ʱ��tic2��ʱ�䣬�������һ������tic����forѭ����i=3ʱ�����Լ���������һ��ѭ����ʱ��
disp(['���һ��ѭ������ʱ��',num2str(toc)])
disp(['����������ʱ�䣺',num2str(etime(clock,t1))]);
pos1=pos1/1852;
pos2=pos2/1852;
pos3=pos3/1852;
pos4=pos4/1852;
%% ��ͼ����show ships' positions at every moment

%% ��ͼ����show ships' positions at every moment

figure;
subplot(2,2,1);
hold on;
%WTF:���������ĳ�ʼλ��
drawShip0(pos1(1,:),c1(1),1);
drawShip0(pos2(1,:),c2(1),2);
drawShip0(pos3(1,:),c3(1),3);
drawShip0(pos4(1,:),c4(1),4);

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
drawShip0(pos1(1,:),c1(1),1);
drawShip0(pos2(1,:),c2(1),2);
drawShip0(pos3(1,:),c3(1),3);
drawShip0(pos4(1,:),c4(1),4);

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
drawShip0(pos1(1,:),c1(1),1);
drawShip0(pos2(1,:),c2(1),2);
drawShip0(pos3(1,:),c3(1),3);
drawShip0(pos4(1,:),c4(1),4);

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
drawShip0(pos1(1,:),c1(1),1);
drawShip0(pos2(1,:),c2(1),2);
drawShip0(pos3(1,:),c3(1),3);
drawShip0(pos4(1,:),c4(1),4);

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
