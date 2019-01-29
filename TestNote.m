%% 本程序用于记录实验历史和实验数据说明
% 1.case1-11-30是第一次试验成功，用的main4的程序，所有船舶都是遵守规则的
% 2.case1-12-03实验效果更好一些，用的CaseStudy1程序，判断DCPA时，基本值设置为1500
shipLabel=[
    0 0
    1 1
    1 1
    1 1];

% shipLabel=zeros(4,2);%检测是否在中间交汇
boat=[
    0.0, 2.5,  18,   0,  1,  3,  6,  0.7896, 1
    0.2,-0.2,  18, 230,  1,  4,  6,  0.7896, 1
    0.4, 0.3,  16, 300,  1,  5,  6,  0.7896, 1
    0.5, 0.5,  13, 135,  1,  5,  6,  0.7896, 1
    ];
boat(:,5)=shipLabel(:,1);
boat(:,9)=shipLabel(:,2);
if shipLabel(1,1)==0
    boat(:,8)=0.7895;
end