%%JIfenԭ���򣬶ԱȲ���
clear all;
clc;
%% WTF:������ʼ��
t=850;

ship(1).speed = 18*1852/3600;%WTF������Ϊ18����/Сʱ��1����=1.852������1����/Сʱ=1.852���Сʱ=1852/3600��/��
ship(1).ratio=1;             %��֪��ʲô��˼
ship(1).initialCourse = 0;
ship(1).courseAlter = 0;
ship(1).courseTime = 0; %the time that the ship keeps on the new course
ship(1).range=(4+0.1*rand())*1852;  %detect range
ship(1).no=1;  %receive information from other ships
% ship(1).pos = [0-ship(1).speed*sind(ship(1).initialCourse)*t 0-ship(1).speed*cosd(ship(1).initialCourse)*t];%WTF��������ǰ��λ�ã������Ʒ�����
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

pos1=ship(1).pos%WTF������λ�þ����һ�У�����t��ֵ��δȷ����%%�²⴬��ԭ�����λ��
pos2=ship(2).pos
pos3=ship(3).pos
pos4=ship(4).pos

c1=ship(1).initialCourse%WTF��������ʼ����
c2=ship(2).initialCourse
c3=ship(3).initialCourse
c4=ship(4).initialCourse
 
for i=1:4
    ship(i).data=[];%WTF��ship.data��Ϊ��
end
s=0;
%% WTF:��ʼִ�зֲ�ʽ����
for i=2:1500
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Update%WTF��������Ϣ����
    for j=1:4
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
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pos1=[pos1;ship(1).pos];%WTF�����䴬��λ�þ���ÿһһ��ѭ��Ϊһ�룬ÿһ�����λ�þ����¼�һ�У�������1500�С�
    pos2=[pos2;ship(2).pos];
    pos3=[pos3;ship(3).pos];
    pos4=[pos4;ship(4).pos];
    
    c1=[c1;ship(1).initialCourse+ship(1).courseAlter];%WTF�����䴬���������ÿ��ѭ�����´�����ǰ����ԭ�����alpha+��ǰ��ƫת��beta����������1500�С�
    c2=[c2;ship(2).initialCourse+ship(2).courseAlter];
    c3=[c3;ship(3).initialCourse+ship(3).courseAlter];
    c4=[c4;ship(4).initialCourse+ship(4).courseAlter];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %the give-way ships take actions
    for j=1:4  %�ӵ�һ�Ҵ��������Ҵ��ı���
      %  if j~=1 %��һ�Ҵ����������������ԭ��
            neighbor_temp1=SearchNeighbor(ship(j),ship,ship(j).range);%��j�Ҵ����ڴ����������ⷶΧ�����д�
            if ~isempty(neighbor_temp1)%����ٴ��ṹ�����鲻Ϊ��
                t=length(neighbor_temp1);%t=�ٴ�������
                for k=t:-1:1%for�������䣬eg:7:-1:1��ÿ��-1��7��1��
                  
                   %WTF����Ŀ�괬�뱾����λ��������ת�������Ϊ0�������������ϵת�Ƶ�����Ϊ���ı�������Ϊy����(0��)
                   pos_temp= neighbor_temp1(k).pos;
                   pos_temp= pos_temp-ship(j).pos;
                   [pos_temp(1) pos_temp(2)] = coord_conv(pos_temp(1),pos_temp(2),ship(j).initialCourse);
                   %WTF���ж��������Ŀ�괬��x����С��0���ұ������ǲ����������һ��������Ҫ��·���ٴ�����Ϊ�գ�����ֱ��
                   if pos_temp(1)<0 %&& neighbor_temp1(k).no ~= 1 %WTF��x<0��Ŀ�괬����࣬��Ϊֱ����
                       neighbor_temp1(k)=[];%WTF������û��λ������Ŀ�괬����Ϊֱ��������Ҫ��·��Ŀ�괬����Ϊ��
                   end
                end
            end
            neighbor_temp2=SearchNeighbor(ship(j),ship,5.5*1852);%WTF:��j�Ҵ������з����ڴ���������5.5��������д�
            if ship(j).courseAlter==0 && ~isempty(neighbor_temp1)%WTF:����û��ת������Ҳ�����һ���Ѿ��жϳ�����û����Ҫ��·�Ĵ���ֱ����
                if CollisionRisk(ship(j),neighbor_temp1) %WTF:�������ٴ�����ײ����ʱ
                    [ship(j).ratio ship(j).courseAlter ship(j).courseTime] = Evolution_right2(ship(j),neighbor_temp2);
                    if ship(j).courseAlter>0 || ship(j).ratio<1
                        ship(j).data=[ship(j).data;i ship(j).ratio ship(j).courseAlter ship(j).courseTime];%WTF:��չship(j).data����ÿ�θ���һ��
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
%% ����ͼ����ɼ����ݣ��ɼ�9�����ݣ����ݸ�ʽΪtiʱ�̵�[x1 y1 x2 y2 x3 y3 x4 y4](i=1~9)
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
%% WTF:��ͼ���򣬷ǳ��ã�����ֱ����
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