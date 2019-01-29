function [ Inference ] = Pre_infer( pristate,prestate,poststate )
%% 采用论文中的BPA程序，计算t(i+1)时隙观察到的实际船舶状态与上一时隙t预测的状态的距离；
% 结果是一个多维数组，然后第一个元素是Eij的值，后面的是返回的各种状态值
%% 状态信息预处理
pos_own      = pristate(1,1:2);
course_own   = pristate(1,3);
v_own        = pristate(1,4);
pos_target   = pristate(2,1:2);
course_target= pristate(2,3);
v_target     = pristate(2,4);

pos_own_predic       = prestate(1,1:2);
course_own_predic    = prestate(1,3);
v_own_predic         = prestate(1,4);
pos_target_predic    = prestate(2,1:2);
course_target_predic = prestate(2,3);
v_target_predic      = prestate(2,4);

pos_own_post      = poststate(1,1:2);
course_own_post   = poststate(1,3);
v_own_post        = poststate(1,4);
pos_target_post   = poststate(2,1:2);
course_target_post= poststate(2,3);
v_target_post     = poststate(2,4);

%% 计算信息距离
%先验信息计算
Cl1=computeCI(pos_own_predic,pos_target_predic,v_own_predic,v_target_predic,course_own_predic,course_target_predic);
Cl2=computeCI(pos_own,pos_target,v_own,v_target,course_own,course_target);
pre_Gain_S = Cl1/Cl2;

TCPA1=computeTCPA(v_own_predic,course_own_predic,pos_own_predic,v_target_predic,course_target_predic,pos_target_predic);
TCPA2=computeTCPA(v_own,course_own,pos_own,v_target,course_target,pos_target);
pre_Gain_T = TCPA1/TCPA2;

%后验信息计算
Cl3 = computeCI(pos_own_post,pos_target_post,v_own_post,v_target_post,course_own_post,course_target_post);
post_Gain_S = Cl3/Cl2;

TCPA3=computeTCPA(v_own_post,course_own_post,pos_own_post,v_target_post,course_target_post,pos_target_post);
post_Gain_T = TCPA3/TCPA2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参考jinfen论文中遵守规则的BPA赋值函数设定，设置函数，并带入当前的自变量值
%先验概率
pre_m_S_P=NaiveCurve(pre_Gain_S,0.4,0.05,1.1,0.7);  %CauchyCirve(pri_Gain_S*rou,0.6,0.7)
pre_m_S_NP=NaiveCurve(pre_Gain_S,0.5,0.8,1.0,0.2);
pre_m_S_P_NP=1-pre_m_S_P-pre_m_S_NP;

pre_m_T_P=NaiveCurve(pre_Gain_T,0.4,0.05,1.1,0.7);  %CauchyCirve(pri_Gain_T*rou,0.6,0.7)
pre_m_T_NP=NaiveCurve(pre_Gain_T,0.5,0.8,1.0,0.2);
pre_m_T_P_NP=1-pre_m_T_P-pre_m_T_NP;

%后验概率
post_m_S_P=NaiveCurve(post_Gain_S,0.4,0.05,1.1,0.7);  %CauchyCirve(post_Gain_S*rou,0.6,0.7)
post_m_S_NP=NaiveCurve(post_Gain_S,0.5,0.8,1.0,0.2);
post_m_S_P_NP=1-post_m_S_P-post_m_S_NP;

post_m_T_P=NaiveCurve(post_Gain_T,0.4,0.05,1.1,0.7);   %CauchyCirve(post_Gain_T*rou,0.6,0.7)
post_m_T_NP=NaiveCurve(post_Gain_T,0.5,0.8,1.0,0.2);
post_m_T_P_NP=1-post_m_T_P-post_m_T_NP;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data1=[Cl1 Cl2 Cl3 pre_Gain_S post_Gain_S TCPA1 TCPA2 TCPA3 pre_Gain_T post_Gain_T];
data2=[pre_Gain_S post_Gain_S pre_Gain_T post_Gain_T];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 时间和空间合成
%先验证据
pre_m_s=[pre_m_S_P pre_m_S_NP pre_m_S_P_NP];
pre_m_t=[pre_m_T_P pre_m_T_NP pre_m_T_P_NP];
pre_m_combine=[];

pre_m_combine(1)=evidence(pre_m_s,pre_m_t,1);
pre_m_combine(2)=evidence(pre_m_s,pre_m_t,2);
pre_m_combine(3)=evidence(pre_m_s,pre_m_t,3);

%后验证据
post_m_s=[post_m_S_P post_m_S_NP post_m_S_P_NP];
post_m_t=[post_m_T_P post_m_T_NP post_m_T_P_NP];
post_m_combine=[];

post_m_combine(1)=evidence(post_m_s,post_m_t,1);
post_m_combine(2)=evidence(post_m_s,post_m_t,2);
post_m_combine(3)=evidence(post_m_s,post_m_t,3);

D0=[1 0 0.5;0 1  0.5;0.5 0.5 1];
D=(0.5*(pre_m_combine-post_m_combine)*D0*(pre_m_combine-post_m_combine).')^0.5;

Inference=[D,data1];

end

