%% ���������ڴ���Ƭ�β��ԣ���¼ʵ����ʷ��ʵ������˵��
% 1.case1-11-30�ǵ�һ������ɹ����õ�main4�ĳ������д����������ع����
% 2.case1-12-03ʵ��Ч������һЩ���õ�CaseStudy1�����ж�DCPAʱ������ֵ����Ϊ1500


shipDismin = [];
for k=1:1:ShipNum
    ship(k).Dismin(1)=min(ship(k).Dismin_Record(:,2)); %��̾���
    A = find((ship(k).Dismin_Record(:,2)) < ship(k).Dismin(1)+0.5); 
    ship(k).Dismin(2)= A(1);    %������̾����ʱ��
    ship(k).Dismin(3)=ship(k).Dismin_Record(ship(k).Dismin(2),1); %������̾����Ŀ�괬
    shipDismin = [shipDismin; ship(k).Dismin];
end
shipDismin_inall=min(shipDismin(:,1));
shipDismin_Num=find((shipDismin(:,1))<=shipDismin_inall);
disp(['��̾��룺t=',num2str(shipDismin(shipDismin_Num(1),2)),'Dis=',num2str(shipDismin_inall)]);