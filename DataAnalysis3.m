%针对scenario4 追越场景专门画的图
close all
t=1:2500;

figure
ha = MarginEdit(2,2,[0.08  0.08],[0.05  0.05],[0.05  0.05],1);
for i=1:4
    %     figure
%     subplot(2,2,i);
    axes(ha(i)); 
    j=1;
    for k=1:4
        if k==i
            
        else
            switch k
                case 1
                    color=[1 0 0];%1号船红色
                case 2
                    color=[0 1 0];%2号船绿色
                case 3
                    color=[0 0 1];%3号船蓝色
                case 4
                    color=[0 0 0];%4号船黑色
            end
            y1=DCPA_D2_1(i).record(:,2*j)/1852;
            P(j)=plot(t,y1,'-','Color',color,'LineWidth',1.5);
            axis([0 max(t) 0 max(y1)]);
            hold on
%             Scenario1-3的对比图，有不猜测的情况，用虚线表示
%             plot(t,DCPA0010(i).record(:,2*j)/1852,'-.','Color',color)
%             hold on
            j=j+1;
        end
    end

    xlabel('time','Fontname', 'Times New Roman','FontSize',15);
    ylabel('DCPA between OS and TS (\itmile)', 'Fontname', 'Times New Roman','FontSize',15);
    title(['Own ship is ship',num2str(i)], 'Fontname', 'Times New Roman','FontSize',15);
    
    yyaxis right
    
    j=1;
    for k=1:4
        if k==i
            
        else
            switch k
                case 1
                    color=[1 0 0];%1号船红色
                case 2
                    color=[0 1 0];%2号船绿色
                case 3
                    color=[0 0 1];%3号船蓝色
                case 4
                    color=[0 0 0];%4号船黑色
            end
            
            y2=Dis_D2_1(i).record(:,2*j);
            plot(t,y2,'-','Color',color,'LineWidth',1.5);
            axis([0 max(t) 0 20000]);
            hold on
%             Scenario1-3的对比图，有不猜测的情况，用虚线表示
%             plot(t,Dis0010(i).record(:,2*j),'-.','Color',color)
%             hold on
            j=j+1;
            
        end
    end
    ylabel('Distance between OS and TS (\itm)', 'Fontname', 'Times New Roman','FontSize',15);
        grid on
    switch i
        case 1
            legend([P(1),P(2),P(3)],'Ship 2','Ship 3','Ship 4','Location','northwest')
            legend('boxoff')
        case 2
            legend([P(1),P(2),P(3)],'Ship 1','Ship 3','Ship 4','Location','northwest')
            legend('boxoff')
        case 3
            legend([P(1),P(2),P(3)],'Ship 1','Ship 2','Ship 4','Location','northwest')
            legend('boxoff')
        case 4
            legend([P(1),P(2),P(3)],'Ship 1','Ship 2','Ship 3','Location','northwest')
            legend('boxoff')
    end
end

