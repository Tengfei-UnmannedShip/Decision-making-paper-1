% close all
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

figure
k=2500;
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
