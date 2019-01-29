clear;
clc;
close all;

period_own=3;
period_target=3;
%% 读取AIS数据，存入航行历史数据矩阵，分别是位置、航速和航向
a=textread('Simulation1.txt');%Simulation1-保留2(目标船让路).txt

pos_own=[];
pos_target=[];
course_own=[];
course_target=[];
v_own1=[];
v_target1=[];

% txt文件中的信息排布：每行四个数，前两个为位置信息，第三个是速度，第四个为航向。每行一艘船，每两行是同一组数据
for i=1:size(a,1)
    if mod(i,2)==0 %将偶数行的船设置为目标船
        pos_target=[pos_target;a(i,1) a(i,2)];
        course_target=[course_target;(pi/2-a(i,4))*180/pi];
        v_target1=[v_target1;a(i,3)];
    else           %将奇数行的船设置为目标船
        pos_own=[pos_own;a(i,1) a(i,2)];
        course_own=[course_own;(pi/2-a(i,4))*180/pi];
        v_own1=[v_own1;a(i,3)];
    end
end

%将txt中提取的信息按照决策周期period_own做筛选，只在决策周期中才接收信息。
pos_own_rcv=[];
pos_target_rcv=[];
course_own_rcv=[];
course_target_rcv=[];
v_own=[];
v_target=[];
for i=1:size(pos_target,1)
    if mod(i,period_own)==0
        pos_own_rcv=[pos_own_rcv;pos_own(i,:)];
        pos_target_rcv=[pos_target_rcv;pos_target(i,:)];
        course_own_rcv=[course_own_rcv;course_own(i)];
        course_target_rcv=[course_target_rcv;course_target(i)];
        v_own=[v_own;v_own1(i)];
        v_target=[v_target;v_target1(i)];
    end
end


minimum = min(size(pos_own_rcv,1),size(pos_target_rcv,1));
hold on;
for i=1:minimum
    plot(pos_own_rcv(i,1),pos_own_rcv(i,2),'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',[(minimum-i)/minimum,i/minimum,i/minimum]);
    plot(pos_target_rcv(i,1),pos_target_rcv(i,2),'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',[(minimum-i)/minimum,i/minimum,i/minimum]);
end
axis equal;
%% 计算信息距离
pri_Gain_S=[];
pri_Gain_T=[];

m_S_P=[];
m_S_NP=[];
m_S_P_NP=[];

m_T_P=[];
m_T_NP=[];
m_T_P_NP=[];

pst_Gain_S=[];
pst_Gain_T=[];

pst_m_S_P=[];
pst_m_S_NP=[];
pst_m_S_P_NP=[];

pst_m_T_P=[];
pst_m_T_NP=[];
pst_m_T_P_NP=[];

data=[]; %用于存储每时刻所有数据

status=[];%存储目标船是直行船还是让路船。0表示直行，1表示让路
rou=1.5;
rou2=1.15;

pri_TCPA=[];
pst_TCPA=[];

for i=1:(size(pos_own_rcv,1)-1)
    pos_target_predct=[pos_target_rcv(i,1)+v_target(i)*period_target*sind(course_target_rcv(i,1)) pos_target_rcv(i,2)+v_target(i)*period_target*cosd(course_target_rcv(i,1))]; %假设船舶保向保速时的预测位置
    
    Cl1=computeCI([pos_own_rcv(i+1,1) pos_own_rcv(i+1,2)],pos_target_predct,v_own(i+1),v_target(i+1),course_own_rcv(i+1,1),course_target_rcv(i+1,1));
    Cl2=computeCI([pos_own_rcv(i,1) pos_own_rcv(i,2)],[pos_target_rcv(i,1) pos_target_rcv(i,2)],v_own(i),v_target(i),course_own_rcv(i,1),course_target_rcv(i,1));
    
    %CPA1=computeCPA(v_own(i+1),course_own_rcv(i+1,1),[pos_own_rcv(i+1,1) pos_own_rcv(i+1,2)],v_target(i+1),course_target_rcv(i+1,1),pos_target_predct)
    %CPA2=computeCPA(v_own(i),course_own_rcv(i,1),[pos_own_rcv(i,1) pos_own_rcv(i,2)],v_target(i),course_target_rcv(i,1),[pos_target_rcv(i,1) pos_target_rcv(i,2)])
    
    pri_Gain_S = [pri_Gain_S;Cl1/Cl2];
    
    TCPA1=computeTCPA(v_own(i+1),course_own_rcv(i+1,1),[pos_own_rcv(i+1,1) pos_own_rcv(i+1,2)],v_target(i+1),course_target_rcv(i+1,1),pos_target_predct);
    TCPA2=computeTCPA(v_own(i),course_own_rcv(i,1),[pos_own_rcv(i,1) pos_own_rcv(i,2)],v_target(i),course_target_rcv(i,1),[pos_target_rcv(i,1) pos_target_rcv(i,2)]);
    pri_TCPA=[pri_TCPA;TCPA1 TCPA2];
    pri_Gain_T = [pri_Gain_T;TCPA1/TCPA2];
    
    status1=defacto([pos_own_rcv(i,1) pos_own_rcv(i,2)],course_own_rcv(i,1),v_own(i),[pos_target_rcv(i,1) pos_target_rcv(i,2)],course_target_rcv(i,1),v_target(i));
    %status2=COLREG([pos_own_rcv(i+1,1) pos_own_rcv(i+1,2)],course_own_rcv(i+1,1),v_own(i),[pos_target_rcv(i+1,1) pos_target_rcv(i+1,2)],course_target_rcv(i+1,1),v_target(i));
    status=[status;status1(2) status1(3) status1(4) status1(5) status1(6) status1(7) status1(8) status1(9) status1(10)];
    
    Cl1 = computeCI([pos_own_rcv(i+1,1) pos_own_rcv(i+1,2)],pos_target_rcv(i+1,:),v_own(i+1),v_target(i+1),course_own_rcv(i+1,1),course_target_rcv(i+1,1));
    Cl2 = computeCI([pos_own_rcv(i,1) pos_own_rcv(i,2)],[pos_target_rcv(i,1) pos_target_rcv(i,2)],v_own(i),v_target(i),course_own_rcv(i,1),course_target_rcv(i,1));
    pst_Gain_S = [pst_Gain_S;Cl1/Cl2];
    
    TCPA1=computeTCPA(v_own(i+1),course_own_rcv(i+1,1),[pos_own_rcv(i+1,1) pos_own_rcv(i+1,2)],v_target(i+1),course_target_rcv(i+1,1),pos_target_rcv(i+1,:));
    TCPA2=computeTCPA(v_own(i),course_own_rcv(i,1),[pos_own_rcv(i,1) pos_own_rcv(i,2)],v_target(i),course_target_rcv(i,1),[pos_target_rcv(i,1) pos_target_rcv(i,2)]);
    pst_TCPA=[pst_TCPA;TCPA1 TCPA2];
    pst_Gain_T = [pst_Gain_T;TCPA1/TCPA2];
    %设置阶跃函数，并带入当前的自变量值
    if status1(2)==0  %判断目标船是否遵循避碰规则,0表示遵循
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % status1(2)
        %先验概率
        m_S_P=[m_S_P;NaiveCurve(pri_Gain_S(i),0.4,0.05,1.1,0.7) 1];  %CauchyCirve(pri_Gain_S(i)*rou,0.6,0.7)
        m_S_NP=[m_S_NP;NaiveCurve(pri_Gain_S(i),0.5,0.8,1.0,0.2) 1];
        m_S_P_NP=[m_S_P_NP;1-m_S_P(i,1)-m_S_NP(i,1) 1];
        
        m_T_P=[m_T_P;NaiveCurve(pri_Gain_T(i),0.4,0.05,1.1,0.7) 1];  %CauchyCirve(pri_Gain_T(i)*rou,0.6,0.7)
        m_T_NP=[m_T_NP;NaiveCurve(pri_Gain_T(i),0.5,0.8,1.0,0.2) 1];
        m_T_P_NP=[m_T_P_NP;1-m_T_P(i,1)-m_T_NP(i,1) 1];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %后验概率
        pst_m_S_P=[pst_m_S_P;NaiveCurve(pst_Gain_S(i),0.4,0.05,1.1,0.7) 1];  %CauchyCirve(pst_Gain_S(i)*rou,0.6,0.7)
        pst_m_S_NP=[pst_m_S_NP;NaiveCurve(pst_Gain_S(i),0.5,0.8,1.0,0.2) 1];
        pst_m_S_P_NP=[pst_m_S_P_NP;1-pst_m_S_P(i,1)-pst_m_S_NP(i,1) 1];

        pst_m_T_P=[pst_m_T_P;NaiveCurve(pst_Gain_T(i),0.4,0.05,1.1,0.7) 1];   %CauchyCirve(pst_Gain_T(i)*rou,0.6,0.7)
        pst_m_T_NP=[pst_m_T_NP;NaiveCurve(pst_Gain_T(i),0.5,0.8,1.0,0.2) 1];
        pst_m_T_P_NP=[pst_m_T_P_NP;1-pst_m_T_P(i,1)-pst_m_T_NP(i,1) 1];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %先验概率
        m_S_P=[m_S_P;NaiveCurve(pri_Gain_S(i),0.6,0.05,1.3,0.7) 0];   %CauchyCirve(pri_Gain_S(i)*rou,0.6,2)
        m_S_NP=[m_S_NP;NaiveCurve(pri_Gain_S(i),0.7,0.8,1.2,0.2) 0];
        m_S_P_NP=[m_S_P_NP;1-m_S_P(i,1)-m_S_NP(i,1) 0];
        
        m_T_P=[m_T_P;NaiveCurve(pri_Gain_T(i),0.6,0.05,1.3,0.7) 0];   %CauchyCirve(pri_Gain_T(i)*rou,0.6,2)
        m_T_NP=[m_T_NP;NaiveCurve(pri_Gain_T(i),0.7,0.8,1.2,0.2) 0];
        m_T_P_NP=[m_T_P_NP;1-m_T_P(i,1)-m_T_NP(i,1) 0];
        
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %后验概率
        pst_m_S_P=[pst_m_S_P;NaiveCurve(pst_Gain_S(i),0.6,0.05,1.3,0.7) 0];   %CauchyCirve(pst_Gain_S(i)*rou,0.6,2)
        pst_m_S_NP=[pst_m_S_NP;NaiveCurve(pst_Gain_S(i),0.7,0.8,1.2,0.2) 0];
        pst_m_S_P_NP=[pst_m_S_P_NP;1-pst_m_S_P(i,1)-pst_m_S_NP(i,1) 0];

        pst_m_T_P=[pst_m_T_P;NaiveCurve(pst_Gain_T(i),0.6,0.05,1.3,0.7) 0];   %CauchyCirve(pst_Gain_T(i)*rou,0.6,2)
        pst_m_T_NP=[pst_m_T_NP;NaiveCurve(pst_Gain_T(i),0.7,0.8,1.2,0.2) 0];
        pst_m_T_P_NP=[pst_m_T_P_NP;1-pst_m_T_P(i,1)-pst_m_T_NP(i,1) 0];
    end
    data=[data;Cl1 Cl2 pri_Gain_S(i) TCPA1 TCPA2 pri_Gain_T(i) m_S_P(i) m_S_NP(i) m_S_P_NP(i) m_T_P(i) m_T_NP(i) m_T_P_NP(i)];
end

figure
hold on;

len=0;
for i=1:size(data,1)
    if data(i,4) ~= 1048576
        len=len+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(2:len,m_S_P(2:len,1),'gs');
plot(2:len,m_S_NP(2:len,1),'r^');
plot(2:len,m_S_P_NP(2:len,1),'bd');
legend('m({P})','m({NP})','m({P,NP})');
title('Prior Spatial Gain');
xlabel('Time(sec)');
ylabel('BPA');
set(gca,'FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
hold on;
plot(2:len,m_T_P(2:len,1),'gs');
plot(2:len,m_T_NP(2:len,1),'r^');
plot(2:len,m_T_P_NP(2:len,1),'bd');
legend('m({P})','m({NP})','m({P,NP})');
title('Prior Temporal Gain');
xlabel('Time(sec)');
ylabel('BPA');
set(gca,'FontSize',12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
hold on;
plot(2:len,pst_m_S_P(2:len,1),'gs');
plot(2:len,pst_m_S_NP(2:len,1),'r^');
plot(2:len,pst_m_S_P_NP(2:len,1),'bd');
legend('m({P})','m({NP})','m({P,NP})');
xlabel('Time(sec)');
ylabel('BPA');
title('Post Spatial Gain');
set(gca,'FontSize',12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
hold on;
plot(2:len,pst_m_T_P(2:len,1),'gs');
plot(2:len,pst_m_T_NP(2:len,1),'r^');
plot(2:len,pst_m_T_P_NP(2:len,1),'bd');
legend('m({P})','m({NP})','m({P,NP})');
xlabel('Time(sec)');
ylabel('BPA');
title('Post Temporal Gain');
set(gca,'FontSize',12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_out=[];
for i=2:size(pos_own_rcv,1)-1
    data_out=[data_out;status(i) pos_own_rcv(i,:) v_own(i) course_own_rcv(i) status(i,2) status(i,3) status(i,4) status(i,5) status(i,6) status(i,7) status(i,8) status(i,9)];
    data_out=[data_out;1-status(i) pos_target_rcv(i,:) v_target(i) course_target_rcv(i) status(i,2) status(i,3) status(i,4) status(i,5) status(i,6) status(i,7) status(i,8) status(i,9)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 时间和空间合成
m_s=[pst_m_S_P(:,1) pst_m_S_NP(:,1) pst_m_S_P_NP(:,1)];
m_t=[pst_m_T_P(:,1) pst_m_T_NP(:,1) pst_m_T_P_NP(:,1)];
m_combine=[];

for i=1:size(m_s,1)
    m_combine(i,1)=evidence(m_s(i,:),m_t(i,:),1);
    m_combine(i,2)=evidence(m_s(i,:),m_t(i,:),2);
    m_combine(i,3)=evidence(m_s(i,:),m_t(i,:),3);
    %sum(m_combine(i,:))
end

figure;
l=size(m_combine,1);
hold on;

plot(1:l,m_combine(:,1),'gs');
plot(1:l,m_combine(:,2),'r^');
plot(1:l,m_combine(:,3),'bd');
legend('m({P})','m({NP})','m({P,NP})');
xlabel('Time(sec)');
ylabel('BPA');
title('Combined spatial and temporal Gain');
set(gca,'FontSize',12);

%% 
AM_S=[];
AM_T=[];
AM_C=[];
for i=1:35
    BetP_P = m_s(i,1)+0.5*m_s(i,3);
    BetP_NP = m_s(i,2)+0.5*m_s(i,3);
    AM_S=[AM_S -BetP_P*log2(BetP_P)-BetP_NP*log2(BetP_NP)];
    
    BetP_P = m_t(i,1)+0.5*m_t(i,3);
    BetP_NP = m_t(i,2)+0.5*m_t(i,3);
    AM_T=[AM_T -BetP_P*log2(BetP_P)-BetP_NP*log2(BetP_NP)];
    
    BetP_P = m_combine(i,1)+0.5*m_combine(i,3);
    BetP_NP = m_combine(i,2)+0.5*m_combine(i,3);
    AM_C=[AM_C -BetP_P*log2(BetP_P)-BetP_NP*log2(BetP_NP)];
end
figure;
plot(1:35,AM_S,1:35,AM_T,1:35,AM_C);
legend('Spatial ambiguity','Temporal ambiguity','Combined ambiguity');
xlabel('Time(sec)');
ylabel('Ambiguity');