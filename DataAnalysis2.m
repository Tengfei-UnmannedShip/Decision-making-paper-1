close all
t=1:2000;

figure

for i=1:4
    %     figure
%     i=1;
    subplot(2,2,i);
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
            
            P(j)=plot(t,ship(i).DCPA_Record(:,2*j)/1852,'-','Color',color);
            hold on
            j=j+1;
        end
    end
    
    
    xlabel('time','Fontname', 'Times New Roman')
    ylabel('DCPA between OS and TS (\itmiles)', 'Fontname', 'Times New Roman')
    title(['Own ship is ship',num2str(i)], 'Fontname', 'Times New Roman')
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
            
            
            plot(t,ship(i).Dis_Record(:,2*j),'-','Color',color)
            hold on
            j=j+1;
            
        end
    end
    ylabel('Distance between OS and TS (\itm)', 'Fontname', 'Times New Roman')
    
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

