close all
t=1:2500;

figure
ha = MarginEdit(2,2,[.05  0.05],[.05  0.05],[0.03  0.03],1);
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
            
            P(j)=plot(t,DCPA_D2_1(i).record(:,2*j)/1852,'-','Color',color);
            hold on
%             Scenario1-3的对比图，有不猜测的情况，用虚线表示
%             plot(t,DCPA0010(i).record(:,2*j)/1852,'-.','Color',color)
%             hold on
            j=j+1;
        end
    end

    xlabel('time','Fontname', 'Times New Roman','FontSize',15);
    ylabel('DCPA between OS and TS (\itmiles)', 'Fontname', 'Times New Roman','FontSize',15);
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
            
            
            plot(t,Dis_D2_1(i).record(:,2*j),'-','Color',color)
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

