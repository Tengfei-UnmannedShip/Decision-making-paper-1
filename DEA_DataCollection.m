%% �����������ռ�DEA�������������
%DEA������������
%%%%%%%%%%%% �������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DCPA:��ÿ�Ҵ��ĳ�ʼDCPA�е���Сֵ
% TCPA:��ÿ�Ҵ��ĳ�ʼTCPA�е���Сֵ
% Ctg:�������,category of encounter scenario.��������-1����������-2���Ĵ�����-3������-׷Խ��ϱ���-����������+2
% Compl: ���������,Compliance of COLREGs���Ƿ��д��������ر����������Ϊ������-1��������-3
%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dismin:��̾���,Closest Distance����ÿ�Ҵ�����̾���
% DecNum:�޸Ĵ���,Number of Decision Changes�����������޸ĵĴ���
% ExtraDis: ���⺽�о���,Extra Navigation Distance��һ����������ǰ�ĺ��о���-ԭ�ƻ����о��룩��ԭ�ƻ����о���
%           ����:ԭ�ƻ����о���=���վ���-������룬��ǰ�ĺ��о���=ÿһ�ε�ʱ��*�ٶ�ϵ��*���ٶ�
%
clear
clc
%% Scenario 1 ��DEA���ݼ�¼
load final(11 11 11 11,0531)

for i=1:ShipNum
    Scenario1(i).input = [];
    Scenario1(i).output = [];
    DCPA = ship(i).DCPAmin_Record(1,2);
    TCPA = ship(i).TCPAmin_Record(1,2);
    Ctg = 3; 
    Compl = 1;
    Scenario1(i).input = [DCPA,TCPA,Ctg,Compl];
    Dismin = min(ship(i).Dismin_Record(:,2));
    RealDecision = unique(ship(i).data,'rows','stable');
    [m,n] = size(RealDecision);
    DecNum = m;
    ExtraDis0=[];
    ExtraDis1=[];
    ExtraDis00 = 0;
    ExtraDis11 = 0;
    ExtraDis_Pro = 0;
    for j=1:m
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %��ǰ���ߵ�·=�ٶ�ϵ��*ԭ�ٶ�*ʱ��
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %ԭ��Ӧ�ߵ�·����ֱ�Ǳߣ������Ǻ�������
        ExtraDis00 = ExtraDis00+ExtraDis0(j);
        ExtraDis11 = ExtraDis11+ExtraDis1(j);
    end
    ExtraDis_Pro = (ExtraDis00-ExtraDis11)/ExtraDis11;
    
    Scenario1(i).output = [Dismin,DecNum,ExtraDis00,ExtraDis_Pro];    
end
save ('DEArecord','Scenario1')

%% Scenario 2 ��DEA���ݼ�¼
load final(20 11 11 11,0531)

for i=1:ShipNum
    Scenario2(i).input = [];
    Scenario2(i).output = [];
    DCPA = ship(i).DCPAmin_Record(1,2);
    TCPA = ship(i).TCPAmin_Record(1,2);
    Ctg = 3; 
    if i==1
        Compl = 3; %No.1�����ر�������
    else
        Compl = 1;
    end
    Scenario2(i).input = [DCPA,TCPA,Ctg,Compl];
    
    Dismin = min(ship(i).Dismin_Record(:,2));
    RealDecision = unique(ship(i).data,'rows','stable');
    [m,n] = size(RealDecision);
    DecNum = m;
    ExtraDis0=[];
    ExtraDis1=[];
    ExtraDis00 = 0;
    ExtraDis11 = 0;
    ExtraDis_Pro = 0;
    for j=1:m
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %��ǰ���ߵ�·=�ٶ�ϵ��*ԭ�ٶ�*ʱ��
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %ԭ��Ӧ�ߵ�·����ֱ�Ǳߣ������Ǻ�������
        ExtraDis00 = ExtraDis00+ExtraDis0(j);
        ExtraDis11 = ExtraDis11+ExtraDis1(j);
    end
    ExtraDis_Pro = (ExtraDis00-ExtraDis11)/ExtraDis11;
    
    Scenario2(i).output = [Dismin,DecNum,ExtraDis00,ExtraDis_Pro];    
end
save ('DEArecord','Scenario2','-append')

%% Scenario 3 ��DEA���ݼ�¼
load final(00 11 11 11,0531)

for i=1:ShipNum
    Scenario3(i).input = [];
    Scenario3(i).output = [];
    DCPA = ship(i).DCPAmin_Record(1,2);
    TCPA = ship(i).TCPAmin_Record(1,2);
    Ctg = 3; 
    if i==1
        Compl = 3; %No.1�����ر�������
    else
        Compl = 1;
    end
    Scenario3(i).input = [DCPA,TCPA,Ctg,Compl];
    
    Dismin = min(ship(i).Dismin_Record(:,2));
    RealDecision = unique(ship(i).data,'rows','stable');
    [m,n] = size(RealDecision);
    DecNum = m;
    ExtraDis0=[];
    ExtraDis1=[];
    ExtraDis00 = 0;
    ExtraDis11 = 0;
    
    ExtraDis_Pro = 0;
    for j=1:m
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %��ǰ���ߵ�·=�ٶ�ϵ��*ԭ�ٶ�*ʱ��
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %ԭ��Ӧ�ߵ�·����ֱ�Ǳߣ������Ǻ�������
        ExtraDis00 = ExtraDis00+ExtraDis0(j);
        ExtraDis11 = ExtraDis11+ExtraDis1(j);
    end
    ExtraDis_Pro = (ExtraDis00-ExtraDis11)/ExtraDis11;
    if i==1
      ExtraDis_Pro=0;  
    end
    Scenario3(i).output = [Dismin,DecNum,ExtraDis00,ExtraDis_Pro];    
end
save ('DEArecord','Scenario3','-append')

%% Scenario 4 ��DEA���ݼ�¼
load Draft2-1-0502

for i=1:ShipNum
    Scenario4(i).input = [];
    Scenario4(i).output = [];
    DCPA = ship(i).DCPAmin_Record(1,2);
    TCPA = ship(i).TCPAmin_Record(1,2);
    if i==1
        Ctg = 5; %�Ĵ�����+����-׷Խ��ϱ���-3+2=5
    elseif i==2
        Ctg = 5;
    else
        Ctg = 3; 
    end
    
    Compl = 1;
    Scenario4(i).input = [DCPA,TCPA,Ctg,Compl];
    
    Dismin = min(ship(i).Dismin_Record(:,2));
    RealDecision = unique(ship(i).data,'rows','stable');
    [m,n] = size(RealDecision);
    DecNum = m;
    ExtraDis0=[];
    ExtraDis1=[];
    ExtraDis00 = 0;
    ExtraDis11 = 0;
    ExtraDis_Pro = 0;
    for j=1:m
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %��ǰ���ߵ�·=�ٶ�ϵ��*ԭ�ٶ�*ʱ��
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %ԭ��Ӧ�ߵ�·����ֱ�Ǳߣ������Ǻ�������
        ExtraDis00 = ExtraDis00+ExtraDis0(j);
        ExtraDis11 = ExtraDis11+ExtraDis1(j);
    end
    ExtraDis_Pro = (ExtraDis00-ExtraDis11)/ExtraDis11;
    
    Scenario4(i).output = [Dismin,DecNum,ExtraDis00,ExtraDis_Pro];    
end
save ('DEArecord','Scenario4','-append')