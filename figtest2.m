% close all
%% 绘图程序：show ships' positions at every moment
figure
for fig=1:9
% 
%     switch fig
%         case 1
%             k=200;
%         case 2
%             k=400;
%         case 3
%             k=800;
%         case 4
%             k=1000;
%         case 5
%             k=1500;
%         case 6
%             k=2000;
%     end
    k=1150+60*fig;
    subplot(3,3,fig);
    hold on;

%     WTF:画出船舶的初始位置
    drawShip0(pos1(1,:),c1(1),1,300);
    drawShip0(pos2(1,:),c2(1),2,300);
    drawShip0(pos3(1,:),c3(1),3,300);
    drawShip0(pos4(1,:),c4(1),4,300);

%     WTF:画出船舶的结束位置
    drawShip(pos1(k,:),c1(k),1,300);
    drawShip(pos2(k,:),c2(k),2,300);
    drawShip(pos3(k,:),c3(k),3,300);
    drawShip(pos4(k,:),c4(k),4,300);

%     WTF:画出过往的航迹图
    plot(pos1(1:k,1),pos1(1:k,2),'r-');
    plot(pos2(1:k,1),pos2(1:k,2),'g-');
    plot(pos3(1:k,1),pos3(1:k,2),'b-');
    plot(pos4(1:k,1),pos4(1:k,2),'k-');

%     WTF:画出船头的圆用于表示安全范围
    circle(pos1(k,:),900/1852,1);
    circle(pos2(k,:),900/1852,2);
    circle(pos3(k,:),900/1852,3);
    circle(pos4(k,:),900/1852,4);

    if fig==6
        axis([-6.5,4.5,-4.5,7]);
    else
        axis([-4.5,4.5,-4.5,4.5]);
    end

    grid on;
    xlabel('\it n miles', 'Fontname', 'Times New Roman');
    ylabel('\it n miles', 'Fontname', 'Times New Roman');
    title(['t=',num2str(k),'s'], 'Fontname', 'Times New Roman');
    box on;
end
% figure
% k=1073;
% 
% ship_icon(pos1(1,:),300,100,c1(1),1);
% ship_icon(pos2(1,:),300,100,c2(1),2);
% ship_icon(pos3(1,:),300,100,c3(1),3);
% ship_icon(pos4(1,:),300,100,c4(1),4);
% 
% %WTF:画出船舶的结束位置
% ship_icon2(pos1(k,:),300,100,c1(k),1);
% ship_icon2(pos2(k,:),300,100,c2(k),2);
% ship_icon2(pos3(k,:),300,100,c3(k),3);
% ship_icon2(pos4(k,:),300,100,c4(k),4);
% 
% 
% %WTF:画出过往的航迹图
% plot(pos1(1:k,1),pos1(1:k,2),'r-');
% plot(pos2(1:k,1),pos2(1:k,2),'g-');
% plot(pos3(1:k,1),pos3(1:k,2),'b-');
% plot(pos4(1:k,1),pos4(1:k,2),'k-');
% 
% %WTF:画出船头的圆用于表示安全范围
% circle(pos1(k,:),900/1852,1);
% circle(pos2(k,:),900/1852,2);
% circle(pos3(k,:),900/1852,3);
% circle(pos4(k,:),900/1852,4);
% 
% grid on;
% xlabel('\it n miles', 'Fontname', 'Times New Roman');
% ylabel('\it n miles', 'Fontname', 'Times New Roman');
% title(['t=',num2str(k),'s'], 'Fontname', 'Times New Roman');
