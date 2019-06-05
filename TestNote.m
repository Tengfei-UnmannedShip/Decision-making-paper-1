%% 本程序用于代码片段测试，记录实验历史和实验数据说明
% 1.case1-11-30是第一次试验成功，用的main4的程序，所有船舶都是遵守规则的
% 2.case1-12-03实验效果更好一些，用的CaseStudy1程序，判断DCPA时，基本值设置为1500


shipDismin = [];
for k=1:1:ShipNum
    ship(k).Dismin(1)=min(ship(k).Dismin_Record(:,2)); %最短距离
    A = find((ship(k).Dismin_Record(:,2)) < ship(k).Dismin(1)+0.5); 
    ship(k).Dismin(2)= A(1);    %到达最短距离的时间
    ship(k).Dismin(3)=ship(k).Dismin_Record(ship(k).Dismin(2),1); %产生最短距离的目标船
    shipDismin = [shipDismin; ship(k).Dismin];
end
shipDismin_inall=min(shipDismin(:,1));
shipDismin_Num=find((shipDismin(:,1))<=shipDismin_inall);
disp(['最短距离：t=',num2str(shipDismin(shipDismin_Num(1),2)),'Dis=',num2str(shipDismin_inall)]);