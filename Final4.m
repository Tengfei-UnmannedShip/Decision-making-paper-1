%% ��Final2������������⵽CAL�ı䣬ֱ�ӱ�complanice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.12��21�ո�
% 2.��main5�Ļ����ϸģ�ʵ�ʲ��԰汾
% 3.���compliance0=2ʱ���������������������ֻ�����Լ���״̬��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DecisionMaking����1��������-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.12��21�ո�
% 2.��main5�Ļ����ϸģ�ʵ�ʲ��԰汾
% 3.���compliance0=2ʱ���������������������ֻ�����Լ���״̬��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
% close all;
tic;%tic1
t1=clock;
%% WTF:������ʼ��
%�����������ã������޸�,�ֱ��ǣ�
%1~2λ��(�м��λ�ã�������ʼλ��)��3���١�4��ʼ����5������������ԣ�6��������ʱ����7��ⷶΧ��range����8֤�ݾ�����ֵ��9�Ƿ��Ʋ�

shipLabel=[
    1 1
    1 1
    1 1
    1 1];

% shipLabel=zeros(4,2);%����Ƿ����м佻��
boat=[
    0.0, 2.5,  18,   0,  1,  3,  6,  0.77, 1
    0.2,-0.2,  18, 230,  1,  4,  6,  0.77, 1
    0.4, 0.3,  16, 300,  1,  5,  6,  0.77, 1
    0.5, 0.5,  13, 135,  1,  5,  6,  0.77, 1
    ];
boat(:,5)=shipLabel(:,1);
boat(:,9)=shipLabel(:,2);

% if shipLabel(1,1)==0
%     boat(:,8)=0.7895;
% end

%�����������
ShipNum=4;
t=2500;
tt=2000;
for j=1:1:ShipNum
    %     ship(i).pos = boat(i,1:2)*1852;
    ship(j).speed = boat(j,3)*1852/3600;%WTF������Ϊ18����/Сʱ��1����=1.852������1����/Сʱ=1.852���Сʱ=1852/3600��/��
    ship(j).initialCourse = boat(j,4);
    ship(j).compliance= boat(j,5); %compliance�ǶԱ�������ķ����ԣ�0��ֱ��ǰ�������ã�1�����أ�2�������أ�������
    ship(j).decisioncycle=boat(j,6);
    ship(j).range=boat(j,7)*1852;  %detect range
    ship(j).no=j;  %receive information from other ships
    ship(j).evd=boat(j,8); %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����
    ship(j).inferLabbel=boat(j,9); %����9�Ƿ��Ʋ��־��1Ϊ�Ʋ⣬0���Ʋ�
    ship(j).data=[];%WTF��ship.data��Ϊ��
    ship(j).CAL=zeros(ShipNum,ShipNum);
    ship(j).CALchange=0; %CAL�ı�ı�־λ�����û�ı䣬����Բ��þ��ߣ�ֱ��ִ��Ԥ�Ƽƻ�
    ship(j).CALchange_data=[];
    ship(j).compliance_data=[];
    ship(j).decision_lable=0;
    ship(j).infer=[];
    ship(j).OSRealdecision0=0;
    ship(j).courseAlter = 0;
    ship(j).courseTime = 0;
    ship(j).ratio=1;
    ship(j).pos=[boat(j,1)-ship(j).speed*sind(ship(j).initialCourse)*0.5*t, boat(j,2)-ship(j).speed*cosd(ship(j).initialCourse)*0.5*t];
    ship(j).Course = ship(j).initialCourse+ship(j).courseAlter;
    ship(j).DCPA_Record = [];
    ship(j).TCPA_Record = [];
end
%����DCPA��TCPA��Dis����Сֵͳ��
for j=1:ShipNum
    kk=1;
    for jj=1:ShipNum
        if j==jj
            continue
        else
            v_own = ship(j).ratio*ship(j).speed;
            course_own = ship(j).Course;
            pos_own = ship(j).pos;
            
            v_target = ship(jj).ratio*ship(jj).speed;
            course_target = ship(jj).Course;
            pos_target = ship(jj).pos;
            DCPA_temp(kk)=computeDCPA(v_own,course_own,pos_own,v_target,course_target,pos_target);
            TCPA_temp(kk)=computeTCPA(v_own,course_own,pos_own,v_target,course_target,pos_target);
            Dis_temp(kk)=pdist( [pos_own;pos_target] );
        end
        ship(j).DCPA_Record(1,2*kk-1:2*kk)=[jj,DCPA_temp(kk)];
        ship(j).TCPA_Record(1,2*kk-1:2*kk)=[jj,TCPA_temp(kk)];
        ship(j).Dis_Record(1,2*kk-1:2*kk)=[jj,Dis_temp(kk)];
        kk=kk+1;
    end
    
    [DCPA_value,DCPA_ship_num]=min(DCPA_temp);
    DCPA_ship_num=2*DCPA_ship_num-1;
    DCPA_ship=ship(j).DCPA_Record(1,DCPA_ship_num);
    
    [TCPA_value,TCPA_ship_num]=min(TCPA_temp);
    TCPA_ship_num=2*TCPA_ship_num-1;
    TCPA_ship=ship(j).TCPA_Record(1,TCPA_ship_num);
    
    [Dis_value,Dis_ship_num]=min(Dis_temp);
    Dis_ship_num=2*Dis_ship_num-1;
    Dis_ship=ship(j).Dis_Record(1,Dis_ship_num);
    
    ship(j).DCPAmin_Record=[DCPA_ship,DCPA_value];
    ship(j).TCPAmin_Record=[TCPA_ship,TCPA_value];
    ship(j).Dismin_Record=[Dis_ship,Dis_value];
end

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
OSdecision=[0 0 0 0];
OSdecision_time=[ ];
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
        if ship(j).inferLabbel==0 %�����������������Ʋ�
            ship(j).Course=GetNextHeading( ship(j).Course, ship(j).initialCourse+ship(j).courseAlter );
            ship(j).pos = [ship(j).pos(1)+ship(j).ratio*ship(j).speed*sind(ship(j).Course) ...
                ship(j).pos(2)+ship(j).ratio*ship(j).speed*cosd(ship(j).Course)];
            %WTF����ǰ�Ĵ���λ��Ϊ��ԭλ��x+1*��ǰ�ٶ�v*sin��ԭ�����alpha+��ǰ��ƫת��beta����ԭλ��y+1*��ǰ�ٶ�v*cos��ԭ�����alpha+��ǰ��ƫת��beta����
            %WTF��ship(j).ratio�²���һ������ʱ�䲽���Ĳ���
            if ship(j).courseTime>0    %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ�ڵ�ǰ�����ϣ���1��������ѭ������1�롣
                ship(j).courseTime = ship(j).courseTime-1;%ÿ��ѭ��ֻҪ�ڴ���⺽���ϣ�ʱ��ͼ�1��ֱ��Ϊ0��
            end
            if ship(j).courseTime == 0  %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ���ڵ�ǰ�����ϣ����򲻸ı䣬���ı�ĺ����courseAlterΪ0��
                ship(j).courseAlter = 0;
            end
        else
            if ship(j).decision_lable~=0
                ship(j).pos=ship(j).DM_pos(i-ship(j).decision_lable,2*j-1:2*j);
                ship(j).Course=ship(j).DM_c(i-ship(j).decision_lable,j);
                ship(j).courseAlter=ship(j).Course-ship(j).initialCourse;
                ship(j).ratio=ship(j).DM_r(i-ship(j).decision_lable,j);
            else
                ship(j).Course=ship(j).initialCourse+ship(j).courseAlter;
                speed_now=ship(j).ratio*ship(j).speed;
                %WTF����ǰ�Ĵ���λ��Ϊ��ԭλ��x+1*��ǰ�ٶ�v*sin��ԭ�����alpha+��ǰ��ƫת��beta����ԭλ��y+1*��ǰ�ٶ�v*cos��ԭ�����alpha+��ǰ��ƫת��beta����
                ship(j).pos =[ship(j).pos(1)+speed_now*sind(ship(j).Course),ship(j).pos(2)+speed_now*cosd(ship(j).Course)];
            end
        end
    end
    
    %ͳ�Ƶ�ǰ��DCPA��TCPA��Dis
    for j=1:ShipNum
        kk=1;
        for jj=1:ShipNum
            if j==jj
                continue
            else
                v_own = ship(j).ratio*ship(j).speed;
                course_own = ship(j).Course;
                pos_own = ship(j).pos;
                
                v_target = ship(jj).ratio*ship(jj).speed;
                course_target = ship(jj).Course;
                pos_target = ship(jj).pos;
                DCPA_temp(kk)=computeDCPA(v_own,course_own,pos_own,v_target,course_target,pos_target);
                TCPA_temp(kk)=computeTCPA(v_own,course_own,pos_own,v_target,course_target,pos_target);
                Dis_temp(kk)=pdist( [pos_own;pos_target] );
            end
            ship(j).DCPA_Record(i,2*kk-1:2*kk)=[jj,DCPA_temp(kk)];
            ship(j).TCPA_Record(i,2*kk-1:2*kk)=[jj,TCPA_temp(kk)];
            ship(j).Dis_Record(i,2*kk-1:2*kk)=[jj,Dis_temp(kk)];
            kk=kk+1;
        end
        
        [DCPA_value,DCPA_ship_num]=min(DCPA_temp);
        DCPA_ship_num=2*DCPA_ship_num-1;
        DCPA_ship=ship(j).DCPA_Record(i,DCPA_ship_num);
        
        [TCPA_value,TCPA_ship_num]=min(TCPA_temp);
        TCPA_ship_num=2*TCPA_ship_num-1;
        TCPA_ship=ship(j).TCPA_Record(i,TCPA_ship_num);
        
        [Dis_value,Dis_ship_num]=min(Dis_temp);
        Dis_ship_num=2*Dis_ship_num-1;
        Dis_ship=ship(j).Dis_Record(i,Dis_ship_num);
        
        ship(j).DCPAmin_Record=[ship(j).DCPAmin_Record;DCPA_ship,DCPA_value];
        ship(j).TCPAmin_Record=[ship(j).TCPAmin_Record;TCPA_ship,TCPA_value];
        ship(j).Dismin_Record=[ship(j).Dismin_Record;Dis_ship,Dis_value];
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
        if decisioncycle(OS,i,ship)&& ship(OS).compliance~=0%�жϵ�ǰiʱ������j���ľ�����������compliance==1����������
            %compliance=0 ˵����ȫ���䣬��ʱ�����߾ͺã�compliance=2 ������
            risk_neighbor_temp1=SearchNeighbor(ship(OS),ship,ship(OS).range);
            if ~isempty(risk_neighbor_temp1) && CollisionRisk0(ship(OS),risk_neighbor_temp1) %WTF:�������ٴ�����ײ����ʱ
                OSdecConut(i,OS)=1;
                OSdecision(OS)=OSdecision(OS)+1;
                OSdecision_time(OS,OSdecision(OS))=i;
                disp(['t=',num2str(i),',  ','��',num2str(OS),'�Ҵ��ĵ�',num2str(OSdecision(OS)),'�ξ���']);
                %% compliance=2ʱ�����෴�Ҳ����ر�������
                if ship(OS).inferLabbel==0 %�����������������Ʋ⣻
                    neighbor_temp2=SearchNeighbor(ship(OS),ship,5.5*1852);%WTF:��j�Ҵ������з����ڴ���������5.5��������д�
                    if ship(OS).courseAlter==0 %WTF:����û��ת������Ҳ�����һ���Ѿ��жϳ�����û����Ҫ��·�Ĵ���ֱ����
                        if CollisionRisk(ship(OS),risk_neighbor_temp1) %WTF:�������ٴ�����ײ����ʱ
                            ship(OS).CAL= Rule_judge(ship,ShipNum);
                            [ship(OS).ratio,ship(OS).courseAlter,ship(OS).courseTime] = Decision_making2(ship(OS),neighbor_temp2,ship(OS).CAL,ship(OS).compliance);
                            if ship(OS).courseAlter~=0 || ship(OS).ratio~=1
                                ship(OS).data=[ship(OS).data;i ship(OS).ratio ship(OS).courseAlter ship(OS).courseTime];%WTF:��չship(j).data����ÿ�θ���һ��
                            end
                        end
                    end
                else
                    %% inferLabbel==1 �����������ߣ���֤�������Ƶ�����ǰ��CAL����
                    % neighbor_temp=SearchNeighbor(ship(j),ship,ship(j).range);%��j�Ҵ����ڴ����������ⷶΧ�����д�
                    % ���������д���Ҫ���ǵ������Բ����жϷ�Χ��
                    % ����ǵ�һ����������
                    if OSdecision(OS)==1  %�ڵ�һ���������ڣ���������Ϣ���룬CAL�����ձ���������
                        ship(OS).OSRealdecision=[i 1];
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
                                ship(OS).infer=[ship(OS).infer;ship_i ship_j inferMatrix_temp];
                                
                                %�ڶ����������µ�CAL����
                                if inferMatrix_temp(1,1)>ship(OS).evd %������evidance�ż�����ֵԽС��ʾ����֤�ݾ���Խ�Ͻ�����ֵԽ��Խ����
                                    ship(OS).CAL(ship_i,ship_j)=1-ship(OS).CAL(ship_i,ship_j);
                                    ship(OS).CAL(ship_j,ship_i)=1-ship(OS).CAL(ship_j,ship_i);%���֤�ݾ�����󣬳ɶ��޸Ķ�Ӧ��CAL����ֵ
                                    disp(['  �Ʋ��',num2str(ship_j),'����',num2str(ship_i),'����׼ȷ��ƫ��Ϊ',num2str(inferMatrix_temp(1,1))]);
                                    ship(OS).CALchange_data=[ship(OS).CALchange_data;i ship_j ship_i inferMatrix_temp(1,1)];
                                end
                            end
                        end
                        
                        if isequal(ship(OS).CAL,ship(OS).oldCAL)
                            ship(OS).CALchange=0;%CAL�ڱ�������û�иı䣬������
                            disp('  �Ʋ��CAL���䣬������һ������������');
                        else
                            ship(OS).CALchange=1;%CAL�ڱ������иı䣬��Ҫ���¾���
                            ship(OS).OSRealdecision0=ship(OS).OSRealdecision0+1;
                            ship(OS).OSRealdecision=[ship(OS).OSRealdecision;i ship(OS).OSRealdecision0];
                            disp(['  �Ʋ��CAL�иı䣬��',num2str(ship(OS).OSRealdecision0),'�����¾���']);
                            
                            if ~isequal(ship(OS).CAL(OS,:),ship(OS).oldCAL(OS,:))
                                ship(OS).compliance=ship(OS).compliance+1;
                                if ship(OS).compliance>2
                                    ship(OS).compliance=1;
                                end
                                ship(OS).compliance_data=[ship(OS).compliance_data;i ship(OS).compliance];
                            end
                            ship(OS).oldCAL=ship(OS).CAL;
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
                                    ship(OS).ship(j).Course=GetNextHeading( ship(OS).ship(j).Course, ship(OS).ship(j).initialCourse+ship(OS).ship(j).courseAlter );
                                    ship(OS).ship(j).pos = [ship(OS).ship(j).pos(1)+ship(OS).ship(j).ratio*ship(OS).ship(j).speed*sind(ship(OS).ship(j).Course) ...
                                        ship(OS).ship(j).pos(2)+ship(OS).ship(j).ratio*ship(OS).ship(j).speed*cosd(ship(OS).ship(j).Course)];
                                    %WTF����ǰ�Ĵ���λ��Ϊ��ԭλ��x+1*��ǰ�ٶ�v*sin��ԭ�����alpha+��ǰ��ƫת��beta����ԭλ��y+1*��ǰ�ٶ�v*cos��ԭ�����alpha+��ǰ��ƫת��beta����
                                    if ship(OS).ship(j).courseTime>0    %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ�ڵ�ǰ�����ϣ���1��������ѭ������1�롣
                                        ship(OS).ship(j).courseTime = ship(OS).ship(j).courseTime-1;%ÿ��ѭ��ֻҪ�ڴ���⺽���ϣ�ʱ��ͼ�1��ֱ��Ϊ0��
                                    end
                                    if ship(OS).ship(j).courseTime == 0  %�˴�Ϊ�����ں����Ϻ��е�ʱ�䣬������0��ʾ���ڵ�ǰ�����ϣ����򲻸ı䣬���ı�ĺ����courseAlterΪ0��
                                        ship(OS).ship(j).courseAlter = 0;
                                    end
                                end
                                for kk=1:1:ShipNum %��������OS�Ժ��о��ߵĽ��
                                    ship(OS).DM_pos(ii,2*kk-1:2*kk)=ship(OS).ship(kk).pos;
                                    ship(OS).DM_c(ii,kk)=ship(OS).ship(kk).Course;
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
                                    risk_neighbor_temp1=SearchNeighbor(ship(OS).ship(jj),ship(OS).ship,ship(OS).ship(jj).range);%��j�Ҵ����ڴ����������ⷶΧ�����д�
                                    neighbor_temp2=SearchNeighbor(ship(OS).ship(jj),ship(OS).ship,5.5*1852);%WTF:��j�Ҵ������з����ڴ���������5.5��������д�
                                    if ship(OS).ship(jj).courseAlter==0 && ~isempty(risk_neighbor_temp1)%WTF:����û��ת������Ҳ�����һ���Ѿ��жϳ�����û����Ҫ��·�Ĵ���ֱ����
                                        if CollisionRisk(ship(OS).ship(jj),risk_neighbor_temp1) %WTF:�������ٴ�����ײ����ʱ
                                            if jj==OS %�����Լ��ľ���ʱ������֪���Լ��Ƿ����ع���
                                                [ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime] = Decision_making2(ship(OS).ship(jj),neighbor_temp2,ship(OS).CAL,ship(OS).compliance);
                                                if ship(OS).ship(jj).courseAlter~=0 || ship(OS).ship(jj).ratio~=1 %��¼�����ľ���
                                                    ship(OS).data=[ship(OS).data;i,ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime];%WTF:��չship(j).data����ÿ������о��ߣ�ת�����٣�����һ��
                                                end
                                            else   %��������������CAL��
                                                [ship(OS).ship(jj).ratio,ship(OS).ship(jj).courseAlter,ship(OS).ship(jj).courseTime] = Decision_making0(ship(OS).ship(jj),neighbor_temp2,ship(OS).CAL);
                                            end
                                        end
                                    end
                                end
                            end
                        end %�����Ժ���Ԥ�ݽ���
                    end
                end
            end
        end
    end
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����ʱ��tic2��ʱ�䣬�������һ������tic����forѭ����i=3ʱ�����Լ���������һ��ѭ����ʱ��
% disp(['���һ��ѭ������ʱ��',num2str(toc)])
disp(['����������ʱ�䣺',num2str(etime(clock,t1))]);
ship1Dismin=min(ship(1).Dismin_Record(:,2));
ship1Dismin_time=find((ship(1).Dismin_Record(:,2))<ship1Dismin+0.5);
disp(['��̾��룺t=',num2str(ship1Dismin_time(1)),'Dis=',num2str(ship1Dismin)]);
pos1=pos1/1852;
pos2=pos2/1852;
pos3=pos3/1852;
pos4=pos4/1852;
%% ��ͼ����show ships' positions at every moment
figure
for fig=1:6
    
    switch fig
        case 1
            k=200;
        case 2
            k=500;
        case 3
            k=1000;
        case 4
            k=1500;
        case 5
            k=2000;
        case 6
            k=2500;
    end
    
    subplot(3,2,fig);
    hold on;
    
    %WTF:���������ĳ�ʼλ��
    drawShip0(pos1(1,:),c1(1),1,400);
    drawShip0(pos2(1,:),c2(1),2,400);
    drawShip0(pos3(1,:),c3(1),3,400);
    drawShip0(pos4(1,:),c4(1),4,400);
    
    %WTF:���������Ľ���λ��
    drawShip(pos1(k,:),c1(k),1,400);
    drawShip(pos2(k,:),c2(k),2,400);
    drawShip(pos3(k,:),c3(k),3,400);
    drawShip(pos4(k,:),c4(k),4,400);
    
    %WTF:���������ĺ���ͼ
    plot(pos1(1:k,1),pos1(1:k,2),'r-');
    plot(pos2(1:k,1),pos2(1:k,2),'g-');
    plot(pos3(1:k,1),pos3(1:k,2),'b-');
    plot(pos4(1:k,1),pos4(1:k,2),'k-');
    
    %WTF:������ͷ��Բ���ڱ�ʾ��ȫ��Χ
    circle(pos1(k,:),900/1852,1);
    circle(pos2(k,:),900/1852,2);
    circle(pos3(k,:),900/1852,3);
    circle(pos4(k,:),900/1852,4);
    
    grid on;
    xlabel('\it n miles', 'Fontname', 'Times New Roman');
    ylabel('\it n miles', 'Fontname', 'Times New Roman');
    title(['t=',num2str(k),'s'], 'Fontname', 'Times New Roman');
    box on;
end
figure
k=ship1Dismin_time(1);
%WTF:���������ĳ�ʼλ��
drawShip(pos1(1,:),c1(1),1,400);
drawShip(pos2(1,:),c2(1),2,400);
drawShip(pos3(1,:),c3(1),3,400);
drawShip(pos4(1,:),c4(1),4,400);
%WTF:���������Ľ���λ��
drawShip(pos1(k,:),c1(k),1,400);
drawShip(pos2(k,:),c2(k),2,400);
drawShip(pos3(k,:),c3(k),3,400);
drawShip(pos4(k,:),c4(k),4,400);

%WTF:���������ĺ���ͼ
plot(pos1(1:k,1),pos1(1:k,2),'r-');
plot(pos2(1:k,1),pos2(1:k,2),'g-');
plot(pos3(1:k,1),pos3(1:k,2),'b-');
plot(pos4(1:k,1),pos4(1:k,2),'k-');

%WTF:������ͷ��Բ���ڱ�ʾ��ȫ��Χ
circle(pos1(k,:),900/1852,1);
circle(pos2(k,:),900/1852,2);
circle(pos3(k,:),900/1852,3);
circle(pos4(k,:),900/1852,4);
grid on;
xlabel('\it n miles', 'Fontname', 'Times New Roman');
ylabel('\it n miles', 'Fontname', 'Times New Roman');
title(['t=',num2str(k),'s'], 'Fontname', 'Times New Roman');
