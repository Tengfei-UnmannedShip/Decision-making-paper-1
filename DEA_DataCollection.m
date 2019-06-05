%% 本程序用于收集DEA分析所需的数据
%DEA分析所需数据
%%%%%%%%%%%% 输入数据 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DCPA:与每艘船的初始DCPA中的最小值
% TCPA:与每艘船的初始TCPA中的最小值
% Ctg:场景类别,category of encounter scenario.两船避碰-1／三船避碰-2／四船避碰-3／避碰-追越混合避碰-上述基础上+2
% Compl: 规则服从性,Compliance of COLREGs。是否有船舶不遵守避碰规则的行为，遵守-1／不遵守-3
%%%%%%%%%% 输出数据 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dismin:最短距离,Closest Distance。与每艘船的最短距离
% DecNum:修改次数,Number of Decision Changes。决策真正修改的次数
% ExtraDis: 额外航行距离,Extra Navigation Distance。一个比例（当前的航行距离-原计划航行距离）／原计划航行距离
%           其中:原计划航行距离=最终距离-最初距离，当前的航行距离=每一段的时间*速度系数*初速度
%
clear
clc
%% Scenario 1 的DEA数据记录
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
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %当前多走的路=速度系数*原速度*时间
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %原本应走的路，即直角边，用三角函数计算
        ExtraDis00 = ExtraDis00+ExtraDis0(j);
        ExtraDis11 = ExtraDis11+ExtraDis1(j);
    end
    ExtraDis_Pro = (ExtraDis00-ExtraDis11)/ExtraDis11;
    
    Scenario1(i).output = [Dismin,DecNum,ExtraDis00,ExtraDis_Pro];    
end
save ('DEArecord','Scenario1')

%% Scenario 2 的DEA数据记录
load final(20 11 11 11,0531)

for i=1:ShipNum
    Scenario2(i).input = [];
    Scenario2(i).output = [];
    DCPA = ship(i).DCPAmin_Record(1,2);
    TCPA = ship(i).TCPAmin_Record(1,2);
    Ctg = 3; 
    if i==1
        Compl = 3; %No.1不遵守避碰规则
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
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %当前多走的路=速度系数*原速度*时间
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %原本应走的路，即直角边，用三角函数计算
        ExtraDis00 = ExtraDis00+ExtraDis0(j);
        ExtraDis11 = ExtraDis11+ExtraDis1(j);
    end
    ExtraDis_Pro = (ExtraDis00-ExtraDis11)/ExtraDis11;
    
    Scenario2(i).output = [Dismin,DecNum,ExtraDis00,ExtraDis_Pro];    
end
save ('DEArecord','Scenario2','-append')

%% Scenario 3 的DEA数据记录
load final(00 11 11 11,0531)

for i=1:ShipNum
    Scenario3(i).input = [];
    Scenario3(i).output = [];
    DCPA = ship(i).DCPAmin_Record(1,2);
    TCPA = ship(i).TCPAmin_Record(1,2);
    Ctg = 3; 
    if i==1
        Compl = 3; %No.1不遵守避碰规则
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
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %当前多走的路=速度系数*原速度*时间
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %原本应走的路，即直角边，用三角函数计算
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

%% Scenario 4 的DEA数据记录
load Draft2-1-0502

for i=1:ShipNum
    Scenario4(i).input = [];
    Scenario4(i).output = [];
    DCPA = ship(i).DCPAmin_Record(1,2);
    TCPA = ship(i).TCPAmin_Record(1,2);
    if i==1
        Ctg = 5; %四船避碰+避碰-追越混合避碰-3+2=5
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
        ExtraDis0(j) = RealDecision(j,2)*ship(i).speed*RealDecision(j,4); %当前多走的路=速度系数*原速度*时间
        ExtraDis1(j) = ExtraDis0(j)*cosd(RealDecision(j,3)); %原本应走的路，即直角边，用三角函数计算
        ExtraDis00 = ExtraDis00+ExtraDis0(j);
        ExtraDis11 = ExtraDis11+ExtraDis1(j);
    end
    ExtraDis_Pro = (ExtraDis00-ExtraDis11)/ExtraDis11;
    
    Scenario4(i).output = [Dismin,DecNum,ExtraDis00,ExtraDis_Pro];    
end
save ('DEArecord','Scenario4','-append')