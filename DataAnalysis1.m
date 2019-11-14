%���scenario1��3 ������������ͼ
%���ݶ�Ӧ��ϵ
%1111�����Ʋ�Ϊ1010������Ӧscenario1,fig.7--���д�����
%2011�����Ʋ�Ϊ2010������Ӧscenario2,fig.9--ship1��COLREGs
%0011�����Ʋ�Ϊ0010������Ӧscenario3,fig.11--ship1ʧ��ֱ��
close all
clear 
load record(01-01)
t=1:2500;

figure
ha = MarginEdit(2,2,[0.08  0.08],[0.05  0.05],[0.05  0.05],1);
for i=1:4
    axes(ha(i)); 
    j=1;
    for k=1:4
        if k==i
            
        else
            switch k
                case 1
                    color=[1 0 0];%1�Ŵ���ɫ
                case 2
                    color=[0 1 0];%2�Ŵ���ɫ
                case 3
                    color=[0 0 1];%3�Ŵ���ɫ
                case 4
                    color=[0 0 0];%4�Ŵ���ɫ
            end
%             y1=DCPA0011(i).record(:,2*j)/1852;  %��Ӧscenario3,fig.11--ship1ʧ��ֱ��
%             y1=DCPA0011(i).record(:,2*j)/1852;  %��Ӧscenario2,fig.9--ship1��COLREGs
            y1=DCPA2011(i).record(:,2*j)/1852;  %��Ӧscenario1,fig.7--���д�����
            P(j)=plot(t,y1,'-','Color',color,'LineWidth',1.5);
            axis([0 max(t) 0 max(y1)]);
            hold on
%             Scenario1-3�ĶԱ�ͼ���в��²������������߱�ʾ
            plot(t,DCPA2010(i).record(:,2*j)/1852,'-.','Color',color)
            hold on
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
                    color=[1 0 0];%1�Ŵ���ɫ
                case 2
                    color=[0 1 0];%2�Ŵ���ɫ
                case 3
                    color=[0 0 1];%3�Ŵ���ɫ
                case 4
                    color=[0 0 0];%4�Ŵ���ɫ
            end
            
            y2=Dis2011(i).record(:,2*j); %��Ӧfig.11--ship1ʧ��ֱ��
            plot(t,y2,'-','Color',color,'LineWidth',1.5);
            axis([0 max(t) 0 20000]);
            hold on
%             Scenario1-3�ĶԱ�ͼ���в��²������������߱�ʾ
            plot(t,Dis2010(i).record(:,2*j),'-.','Color',color)
            hold on
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

